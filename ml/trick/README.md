# 技巧

## 反卷积的棋盘格效应
使用反卷积时，由于卷积区域的overlap，会形成棋盘格效应，在kernel size不能被stride整除时尤为明显，比较好的替代方案是upsample+conv
