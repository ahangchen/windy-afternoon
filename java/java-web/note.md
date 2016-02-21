2015-1-6：

IDEA servlet-api.jar

   idea从14升级到15后，发现

import javax.servlet.AsyncContext;

找不到，
右击工程，open module setting，找到图中的位置，在classPath里添加tomcat的servlet-api.jar即可。
