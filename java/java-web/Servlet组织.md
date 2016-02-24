##Servlet tomcat部署
网上搜到的很多利用eclipse结合tomcat开发servlet的教程都要修改server.xml

感觉这种方式太粗暴了，server.xml最好是与应用无关的，

这里比较推荐export war的方式进行部署

先记录一下环境配置过程

我的系统是ubuntu 14.04；

* 下载eclipse for javaee，解压

* 下载tomcat插件：

* 在http://www.eclipsetotale.com/tomcatPlugin.html上下载tomcatPluginV33.zip ，将里面的jar放到eclipse的plugin目录下，

> 我并没有将jar放到了plugin目录下，而是建立了一个软链接，这样就可以防止冗余，节省一点磁盘空间

* 重启eclipse，会发现多了菜单栏多了tomcat，新建项目的时候，新建project-java-tomcat project，就可以建一个简单的服务器程序了

* 在WEB-INF/src下建自己的包，建servlet的类，在WEB-INF下建立web.xml，配置servlet及映射关系，注意class里要带包名；

* 挺重要的一点，在项目的properties-tomcat里，设置export war file路径（以.war结尾）

* 然后右击项目，tomcat project-export to war file……

* 导出到tomcat的webapp目录下，启动tomcat，就可以通过url之类的途径访问了

> 本文主要推荐war方式部署，具体servlet编写和站点访问请参考其他资料）

> 如果需要使用第三方库，记得设置build path后，手动复制jar文件到lib目录下，再导出war