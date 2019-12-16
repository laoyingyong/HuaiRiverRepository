<%--
  Created by Yingyong Lao.
  User: laoyingyong
  Date: 2019-12-02
  Time: 14:42
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>注册</title>
    <!-- 1. 导入CSS的全局样式 -->
    <link href="css/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- 2. jQuery导入，建议使用1.9以上的版本 -->
    <script src="js/jquery-2.1.0.min.js"></script>
    <!-- 3. 导入bootstrap的js文件 -->
    <script src="js/bootstrap.min.js"></script>
</head>
<body style="background: url('img/img01.jpg') repeat-x;padding-top: 100px;">

<div class="container">
    <form id="form" class="form-horizontal" method="post" action="${pageContext.request.contextPath}/RegisterServlet">
        <div class="form-group">
            <label class="col-sm-2 col-sm-offset-4"><h2>欢迎注册</h2></label>
        </div>
       <div class="form-group">
           <label class="col-sm-2 control-label">用户名:</label>
           <div class="col-sm-6">
           <input type="text" placeholder="请输入用户名" class="form-control" id="username" name="username"/>
           </div>
           <div class="col-sm-2">
               <span id="username_sp" style="color: red"></span>
           </div>
       </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">密码:</label>
            <div class="col-sm-6">
                <input type="password" placeholder="请输入密码" class="form-control" id="password1" name="password"/>
            </div>
            <div class="col-sm-2">
                <span id="password1_sp" style="color: red"></span>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">密码:</label>
            <div class="col-sm-6">
                <input type="password" placeholder="请再次输入密码" class="form-control" id="password2"/>
            </div>
            <div class="col-sm-2">
                <span id="password2_sp" style="color: red"></span>
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-2 col-sm-offset-2">
                <input type="submit" value="注册" class="btn btn-primary form-control">
            </div>
            <div class="col-sm-2 col-sm-offset-2">
                已有账号？<span class="glyphicon glyphicon-hand-right" aria-hidden="true"></span>&nbsp;<a href="${pageContext.request.contextPath}/login.jsp">登录</a>
            </div>
        </div>

    </form>

    <c:if test="${requestScope.register_msg!=null}"><%--如果提示信息不为空的话，才会显示提示框--%>
        <!-- 出错显示的信息框 -->
        <div class="alert alert-warning alert-dismissible col-sm-6 col-sm-offset-2" role="alert">
            <button type="button" class="close" data-dismiss="alert" >
                <span>&times;</span>
            </button>
            <strong>${requestScope.register_msg}</strong>
        </div>
    </c:if>
</div>
<script>
    /***************以下为表单校验*****************/
    function checkUserName()//校验用户名
    {
        var username = $("#username").val();
        var zhengze=/^[a-zA-Z0-9_]{4,16}$/;//用户名正则，4到16位（字母，数字，下划线）
        var b = zhengze.test(username);
        return b;
    }
    function checkPassword1()
    {
        var password=$("#password1").val();
        var zhengze=/^[a-zA-Z0-9_]{4,16}$/;//密码正则，4到16位（字母，数字，下划线）
        var b = zhengze.test(password);
        return b;
    }
    function checkPassword2()
    {
        var password=$("#password2").val();
        var zhengze=/^[a-zA-Z0-9_]{4,16}$/;//密码正则，4到16位（字母，数字，下划线）
        var b = zhengze.test(password);
        return b;
    }

    function isPasswordSame()//判断输入框的密码是否相等
    {
        var password1 = $("#password1").val();
        var password2 = $("#password2").val();
        if(password1===password2)
        {
            return true
        }
        else
        {
            return false;
        }
    }


    document.getElementById("form").onsubmit=function()//用户名或者密码格式错误的话，点击注册按钮是不会提交表单的，减轻了服务器的压力
    {

        if(isPasswordSame()===false)
        {
            $("#password2_sp").html("两次输入的密码不一致");
        }
        if(checkUserName()==true&&checkPassword1()==true&&checkPassword2()==true&&isPasswordSame()==true)
        {
            return true;
        }
        else
        {
            return false;
        }

    }

    $("#username").blur(function ()
    {
        var username = $("#username").val();
        var zhengze=/^[a-zA-Z0-9_]{4,16}$/;//用户名正则，4到16位（字母，数字，下划线）
        var b = zhengze.test(username);
        if(b!==true)
        {
            $("#username_sp").html("用户名格式错误");
        }
        else
        {
            $("#username_sp").html("<img src='img/gou.png' width='50' height='30'>");

        }

    });

    $("#password1").blur(function ()
    {
        var password=$("#password1").val();
        var zhengze=/^[a-zA-Z0-9_]{4,16}$/;//密码正则，4到16位（字母，数字，下划线）
        var b = zhengze.test(password);
        if(b!==true)
        {
            $("#password1_sp").html("密码格式错误");
        }
        else
        {
            $("#password1_sp").html("<img src='img/gou.png' width='50' height='30'>");

        }
    });

    $("#password2").blur(function ()
    {
        var password=$("#password2").val();
        var zhengze=/^[a-zA-Z0-9_]{4,16}$/;//密码正则，4到16位（字母，数字，下划线）
        var b = zhengze.test(password);
        if(!isPasswordSame())
        {
            $("#password2_sp").html("两次输入的密码不一致");

        }
        if(b!==true)
        {
            $("#password2_sp").html("密码格式错误");
        }
        if(b===true&&isPasswordSame())
        {
            $("#password2_sp").html("<img src='img/gou.png' width='50' height='30'>");

        }
    });

</script>

</body>
</html>
