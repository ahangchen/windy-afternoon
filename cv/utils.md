# 机器视觉常用工具知识点

## Eigen
- [将Eigen中的vector4f变成vector3f](https://stackoverflow.com/questions/25104665/best-way-to-convert-an-eigen-vector4-type-to-vector3)

## OpenCV
- [OpenCV逐元素访问时使用的类型](https://stackoverflow.com/questions/30596158/how-to-find-out-what-type-to-use-for-opencv-at-function-in-c)

```
        C1      C2     C3     C4     C6
CV_8U   uchar   Vec2b  Vec3b  Vec4b
CV_8S   char    -       
CV_16U  ushort  -
CV_16S  short   Vec2s  Vec3s  Vec4s
CV_32S  int     Vec2i  Vec3i  Vec4i
CV_32F  float   Vec2f  Vec3f  Vec4f  Vec6f
CV_64F  double  Vec2d  Vec3d  Vec4d  Vec6d
```
