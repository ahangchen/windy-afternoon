##Java Note
###java执行系统调用

```java

package scut.cs.cwh;

import java.io.InputStreamReader;
import java.io.LineNumberReader;

public class ExecLinuxCMD {

    public static Object exec(String cmd) {
        try {
            String[] cmdA = { "/bin/sh", "-c", cmd };
            Process process = Runtime.getRuntime().exec(cmdA);
            LineNumberReader br = new LineNumberReader(
                    new InputStreamReader(process
                            .getInputStream()));
            StringBuffer sb = new StringBuffer();
            String line;
            while ((line = br.readLine()) != null) {
                System.out.println(line);
                sb.append(line).append("\n");
            }
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static void main(String[] args) {
        // TODO Auto-generated method stub
        String rst = exec("ls").toString();
        
        System.out.println(rst);
    }

}
```