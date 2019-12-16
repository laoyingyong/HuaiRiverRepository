<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- HTML5文档-->
<!DOCTYPE html>
<!-- 网页使用的语言 -->
<html lang="zh-CN">
<head>
    <!-- 指定字符集 -->
    <meta charset="utf-8">
    <!-- 使用Edge最新的浏览器的渲染方式 -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- viewport视口：网页可以根据设置的宽度自动进行适配，在浏览器的内部虚拟一个容器，容器的宽度与设备的宽度相同。
    width: 默认宽度与设备的宽度相同
    initial-scale: 初始的缩放比，为1:1 -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>添加用户</title>

    <!-- 1. 导入CSS的全局样式 -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <!-- 2. jQuery导入，建议使用1.9以上的版本 -->
    <script src="js/jquery-2.1.0.min.js"></script>
    <!-- 3. 导入bootstrap的js文件 -->
    <script src="js/bootstrap.min.js"></script>
    <style>
        #name_sp,#age_sp,#qq_sp,#email_sp{
            color: red;

        }
    </style>
</head>
<body style="background: url('img/img01.jpg') repeat-x;padding-top: 100px">
<div class="container">
    <center><h3>添加联系人页面</h3></center>
    <form action="${pageContext.request.contextPath}/addUserServlet" method="post" id="form" class="form-horizontal">
        <div class="form-group">
            <label for="name" class="col-sm-2 control-label">姓名：</label>
            <div class="col-sm-7">
            <input type="text" class="form-control" id="name" name="name" placeholder="请输入姓名">
            </div>
            <div class="col-sm-3">
                <span id="name_sp"></span>
            </div>
        </div>

        <div class="form-group">
            <label class="col-sm-2 control-label">性别：</label>
            <div class="col-sm-10">
            <input type="radio" name="gender" value="男" id="nan" checked="checked"/>男
            <input type="radio" name="gender" value="女" id="nv"/>女
            </div>
        </div>

        <div class="form-group">
            <label for="age" class="col-sm-2 control-label">年龄：</label>
            <div class="col-sm-7">
            <input type="text" class="form-control" id="age" name="age" placeholder="请输入年龄">
            </div>
            <div class="col-sm-3">
                <span id="age_sp"></span>
            </div>
        </div>

        <div class="form-group">
            <label for="address" class="col-sm-2 control-label">籍贯：</label>
            <div class="col-sm-7">
            <select name="address" class="form-control" id="address">
                <option>--请选择--</option>
                <option value="陕西">陕西</option>
                <option value="北京">北京</option>
                <option value="上海">上海</option>
            </select>
            </div>
        </div>

        <div class="form-group">
            <label for="qq" class="col-sm-2 control-label">QQ：</label>
            <div class="col-sm-7">
            <input type="text" class="form-control" id="qq" name="qq" placeholder="请输入QQ号码"/>
            </div>
            <div>
                <span id="qq_sp" class="col-sm-3"></span>
            </div>
        </div>

        <div class="form-group">
            <label for="email" class="col-sm-2 control-label">Email：</label>
            <div class="col-sm-7">
            <input type="email" class="form-control" id="email" name="email" placeholder="请输入邮箱地址"/>
            </div>
            <div class="col-sm-3">
                <span id="email_sp"></span>
            </div>
        </div>

        <div class="form-group" style="text-align: center">
            <input class="btn btn-primary" type="submit" value="提交" />
            <input class="btn btn-default" type="reset" value="重置" />
            <input class="btn btn-default" type="button" value="返回" />
        </div>
    </form>
</div>
<script>

    function checkName()
    {
        var name = document.getElementById("name").value;
        var zhengze=/^([a-zA-Z0-9\u4e00-\u9fa5\·]{1,10})$/;
        var b = zhengze.test(name);
        if(b==true)
            document.getElementById("name_sp").innerHTML="<img src='img/gou.png' width='50' height='30'>";
        else
            document.getElementById("name_sp").innerHTML="用户名格式错误";
        return b;
    }
    function checkAge()
    {
        var age = document.getElementById("age").value;
        var zhengze=/^(?:[1-9][0-9]?|1[01][0-9]|120)$/;
        var b = zhengze.test(age);
        if(b==true)
            document.getElementById("age_sp").innerHTML="<img src='img/gou.png' width='50' height='30'>";
        else
            document.getElementById("age_sp").innerHTML="年龄输入错误";
        return b;

    }

    function cheskQq()
    {

        var qq = document.getElementById("qq").value;
        var zhengze=/^[1-9][0-9]{4,9}$/;
        var b = zhengze.test(qq);
        if(b==true)
            document.getElementById("qq_sp").innerHTML="<img src='img/gou.png' width='50' height='30'>";
        else
            document.getElementById("qq_sp").innerHTML="qq号格式错误";
        return b;

    }

    function checkEmail()
    {
        var email = document.getElementById("email").value;
        var zhengze=/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/;
        var b = zhengze.test(email);
        if(b==true)
            document.getElementById("email_sp").innerHTML="<img src='img/gou.png' width='50' height='30'>";
        else
            document.getElementById("email_sp").innerHTML="邮箱格式错误";
        return b;

    }


    var form = document.getElementById("form");
    form.onsubmit=function ()
    {
        checkName();
        checkAge();
        cheskQq();
        checkEmail();
        return checkName()&&checkAge()&&cheskQq()&&checkEmail();
    }

    $("#name").blur(function ()//姓名输入框离焦事件，采用jquery的写法
    {
        var name = $("name").val();
        var zhengze=/^([a-zA-Z0-9\u4e00-\u9fa5\·]{1,10})$/;
        var b = zhengze.test(name);
        if(b==true)
        $("name_sp").html("<img src='img/gou.png' width='50' height='30'>");
    else
       $("name_sp").html("用户名格式错误");

    });

    $("#age").blur(function ()//年龄输入框离焦事件，采用jquery的写法
    {
        var age = $("age").val();
        var zhengze=/^(?:[1-9][0-9]?|1[01][0-9]|120)$/;
        var b = zhengze.test(age);
        if(b==true)
        $("age_sp").html("<img src='img/gou.png' width='50' height='30'>");
    else
        $("age_sp").html("年龄格式错误");
    });

    $("#qq").blur(function ()//qq输入框离焦事件，采用jquery的写法
    {
        var qq = $("qq").val();
        var zhengze=/^[1-9][0-9]{4,9}$/;
        var b = zhengze.test(qq);
        if(b==true)
            $("qq_sp").html("<img src='img/gou.png' width='50' height='30'>");
        else
            $("qq_sp").html("qq号格式错误");
    });

    $("#email").blur(function ()//email输入框离焦事件，采用jquery的写法
    {
        var email = $("email").val();
        var zhengze=/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/;
        var b = zhengze.test(email);
        if(b==true)
            $("email_sp").html("<img src='img/gou.png' width='50' height='30'>");
        else
            $("email_sp").html("邮箱格式错误");
    });

    $("#nan").click(
        function ()
        {
            $("#nan").prop("checked","checked");

        }
    );

    $("#nv").click(
        function ()
        {
            $("#nv").prop("checked","checked");

        }
    );

    $("input[value='返回']").click(function ()
    {
        window.location.href="${pageContext.request.contextPath}/list.jsp";
    });



</script>
</body>
</html>