### Hadoop 配置中的一个坑
- start-dfs.sh执行时，提示JAVA_HOME not set，但是echo "$JAVA_HOME"是有正确的路径出来的，
- 说明hadoop分布式执行时不会读取系统环境变量，
- 所以我们要手动在/your/hadoop/path/etc/hadoop/hadoop-env.sh里设置
- export JAVA_HOME="/your/java/home/path"
