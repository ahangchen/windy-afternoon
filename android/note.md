## 一些小的点就记在这里吧

### MultiDex打包时zip错误

我遇到的是

Execution failed for task ':excelSior:packageAllDebugClassesForMultiDex'.java.util.zip.ZipException: duplicate entry: android\/support\/v4\/util\/TimeUtils.class

在gradle里，把v4的依赖换成这样子就好了：

```gradle
dependencies {
    compile fileTree(include: '*.jar', dir: 'libs')
    compile 'com.android.support:multidex:1.0.1@aar'
}
```

### 多语言
默认的values文件夹里的strings.xml作为英语的字符串资源文件，新建一个values-zh文件夹，里面放一个strings.xml文件，只不过value都是中文，这样就会自动根据系统语言调用字符串了。

### Preference
android.support.v7.preference可以实现material design效果的设置页面，但我们要如何用getSharedPreference那套方法来操作其中的数据呢？关键在于配置xml文件的名称，查询android.support.v7.preference.PreferenceManager的构造方法，看到：

```java
public PreferenceManager(Context context) {
        this.mContext = context;
        this.setSharedPreferencesName(getDefaultSharedPreferencesName(context));
    }
```

所以可以用getDefaultSharedPreferencesName来获得xml文件的名字，另一种方法：

```java
SharedPreferences sps = PreferenceManager.getDefaultSharedPreferences(getBaseContext());
String userName = sps.getString(getString(R.string.pref_user_name_key), getString(R.string.pref_default_user_name));
```

用getDefaultSharedPreferences来获取。
