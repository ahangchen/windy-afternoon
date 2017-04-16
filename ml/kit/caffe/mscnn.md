# mscnn
- [Source Code](https://github.com/zhaoweicai/mscnn)
- 别人写的[教程](https://gist.github.com/arundasan91/b432cb011d1c45b65222d0fac5f9232c)

## Install
- 从github下载mscnn工程
- 如果git clone出现

    ```log
    正克隆到 'mscnn'...
    remote: Counting objects: 1120, done.
    error: RPC failed; curl 56 GnuTLS recv error (-110): The TLS connection was non-properly terminated.
    fatal: The remote end hung up unexpectedly
    fatal: 过早的文件结束符（EOF）
    fatal: index-pack failed

    ```
- 用这种方法避开：

    ```shell
    mkdir mscnn
    cd mscnn
    git init
    git remote add origin https://github.com/zhaoweicai/mscnn.git
    git pull
    ```

- 我只在ubuntu上安装，所以只讲ubuntu上的依赖:
  - [CUDA和CUDNN](https://www.youtube.com/watch?v=cVWVRA8XXxs)
  - 其他依赖
```shell
sudo apt-get install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
sudo apt-get install --no-install-recommends libboost-all-dev
sudo apt-get install libatlas-base-dev
sudo apt-get install libgflags-dev libgoogle-glog-dev liblmdb-dev
```

  - Caffe在debian系列系统上对hdf5的支持导致的[一个坑>>](https://github.com/BVLC/caffe/issues/2347#issuecomment-118508564)

## 编译
```shell
make all
make pycaffe
make matcaffe
make test
make runtest
```

## 测试（Python版）
- [源代码](https://github.com/GBJim/mscnn/blob/master/examples/caltech/run_mscnn_detection.py)
- 前面是用apt安装的opencv和protobuf，没有安装Python包，所以直接运行会报cv2和protobuf找不到
- 安装opencv python包：

```shell
sudo apt-get install python-opencv
```

- 这样会安装到系统默认的python解释器中，即`/usr/lib/python2.7/dist-packages`，我们把这里面跟opencv有关的复制到前面编译caffe指定的python解释器目录中，比如`~/anaconda2/lib/python2.7/site-packages`，同时注意改cv2的名字

```shell
sudo ln -s cv2.x86_64-linux-gnu.so cv2.so
```

搞定opencv的依赖

- 安装protobuf python包: `pip install protobuf`（注意pip要和caffe对应的python解释器绑定）
- 由于前面的那份python代码用了nms来做GPU调用，这个东西是来自py-faster-rcnn的，也是caffe的一个变种，复制[这个目录](https://github.com/rbgirshick/py-faster-rcnn/tree/master/lib/)，然后make，按上面的复制opencv的方法把nms目录复制到caffe对应的python解释器就好了
