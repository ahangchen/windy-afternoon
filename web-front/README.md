##web前端
- [header div固定，content div填充父容器](head_content.md)
- [json接口资源](json_res.md)
- jQuery iframe高度自适应内容
```js
    $("#content-frame").load(function(){
        var content_height = $(this).contents().find("body").height();
        $(this).height(content_height);
    });
```

- ajax跨域cookie问题
  - "Access-Control-Allow-Origin":"*"
  - 解决浏览器对前端的拦截
  - xhrFields: {withCredentials: true},
  - 允许使用cookie
  example
```javascript
function loadValidCode(id) {
    $.ajax({
            url: "http://110.64.69.66:8081/team/valid_code",
            processData: false,
            xhrFields: {withCredentials: true}
        }).always(function (data) {
                console.log('test');
                $(id).attr('src', "data:image/gif;base64," + data);
            }
        );

}
$('#reg_btn').click(function () {
        $.ajax({
            type: "post",
            url: "http://110.64.69.66:8081/team/register/",
            dataType: "json",
            data: {
                "mail": $('#r_mail').val(),
                "pwd": $('#r_pwd').val(),
                "inv": $('#r_inv').val(),
                "code": $('#r_code').val()
            },
            xhrFields: {withCredentials: true},
            headers: {
                "Access-Control-Allow-Origin":"*"
            }

        }).always(function (data) {
            console.log(data);
        });
```
  - 另一方面还需要后端配合，具体查看各种后端的相关配置
