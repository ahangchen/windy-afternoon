# Pytorch剪枝

pytorch官方的剪枝工具分为非结构化和结构化剪枝两种，非结构化剪枝会随机地把一些权重参数变为0，结构化剪枝则将某个维度某些通道随机变成0，但这套工具不会真正输出剪枝后的模型，只是将模型变稀疏了，只有用某些特殊前向库，才能加快模型运行速度。最近找到一个库，能根据一定策略找到权重中作用较小的部分，用index表示，并保留对应的模型。

## 原理
首先构造输入，前向运行一次模型，得到模型对应的计算图

```python
DG = tp.DependencyGraph()
DG.build_dependency(model, example_inputs=torch.randn(1,3,224,224))
```

对于计算图中的各种带权重的层，根据指定策略（目前支持ln,l1,l2等）比较权重中各个数值，找到第k小的数对应的index，记为将要删除的部分，

```python
strategy = tp.strategy.L1Strategy() 
# 3. get a pruning plan from the dependency graph.
pruning_idxs = strategy(model.conv1.weight, amount=0.4) # or manually selected pruning_idxs=[2, 6, 9, ...]
```

得到index后，对依赖该层的其他层，递归使用对应的prune函数进行剪枝，得到每一层的剪枝计划。

```python
pruning_plan = DG.get_pruning_plan( model.conv1, tp.prune_conv, idxs=pruning_idxs )
```

在剪枝计划执行时，根据index改变model中对应层的定义，使得model中的channel数变少。

```python
# plune plane exec source code
def exec(self, dry_run=False):
    num_pruned = 0
    for dep, idxs in self._plans: # idxs were computed by specified strategy
        _, n = dep(idxs, dry_run=dry_run)
        num_pruned += n
    return num_pruned
```

以卷积层为例，执行剪枝计划时，根据strategy提供的idx，对weight和bias进行修剪：

```python
class ConvPruning(BasePruningFunction):
    @staticmethod
    def prune_params(layer: nn.Module, idxs: Sequence[int]) -> nn.Module: 
        keep_idxs = list(set(range(layer.out_channels)) - set(idxs))
        layer.out_channels = layer.out_channels-len(idxs)
        if not layer.transposed:
            layer.weight = torch.nn.Parameter(layer.weight.data.clone()[keep_idxs])
        else:
            layer.weight = torch.nn.Parameter(layer.weight.data.clone()[:, keep_idxs])
        if layer.bias is not None:
            layer.bias = torch.nn.Parameter(layer.bias.data.clone()[keep_idxs])
        return layer
    
    @staticmethod
    def calc_nparams_to_prune(layer: nn.Module, idxs: Sequence[int]) -> int: 
        nparams_to_prune = len(idxs) * reduce(mul, layer.weight.shape[1:]) + (len(idxs) if layer.bias is not None else 0)
        return nparams_to_prune
```

如此，剪枝后model.forward时，运行的卷积层就是剪枝过的版本啦。

## 样例
- [CIFAR10上ResNet18剪枝](https://github.com/VainF/Torch-Pruning/blob/master/examples/prune_resnet18_cifar10.py)
- 注意事项：
  - 剪枝是对遍历网络的每一个单独的层进行剪枝
  - 剪枝时虽然有一定的策略，但不能保证每个剪掉这些层之后损失就是最小的
  - 每层剪枝的比例可以不同，可以考虑人工将网络划分为几个部分，每个部分可以设置不同的剪枝比例，但具体应该设置多少，可以从剪枝后模型的执行结果进行评估，可以考虑写一个遍历算法，或者写个启发式搜索来找到最佳比例；
  - 剪枝后应当在新的模型上继续fine tune一定epoch，以得到最适合此网络结构的权重