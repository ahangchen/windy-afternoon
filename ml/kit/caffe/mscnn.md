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

- 编译
```shell
make all
make pycaffe
make matcaffe
make test
make runtest
```
