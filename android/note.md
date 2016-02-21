##一些小的点就记在这里吧

**MultiDex打包时zip错误**

我遇到的是

Execution failed for task ':excelSior:packageAllDebugClassesForMultiDex'.java.util.zip.ZipException: duplicate entry: android/support/v4/util/TimeUtils.class

在gradle里，把v4的依赖换成这样子就好了：

```gradle
dependencies {
    compile fileTree(include: '*.jar', dir: 'libs')
    compile 'com.android.support:multidex:1.0.1@aar'
}```

