<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>登录</title>

    <!-- 1. 导入CSS的全局样式 -->
    <link href="css/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- 2. jQuery导入，建议使用1.9以上的版本 -->
    <script src="js/jquery-2.1.0.min.js"></script>
    <!-- 3. 导入bootstrap的js文件 -->
    <script src="js/bootstrap.min.js"></script>
    <script type="text/javascript">
        //切换验证码
        function refreshCode(){
            //1.获取验证码图片对象
            var vcode = document.getElementById("vcode");

            //2.设置其src属性，加时间戳
            vcode.src = "${pageContext.request.contextPath}/checkCodeServlet?time="+new Date().getTime();
        }

    </script>
    <style>
        html {
            position: relative;
            min-height: 100%;
        }

        body {
            /* Margin bottom by footer height */
            margin-bottom: 60px;
        }

        .footer {
            position: absolute;
            bottom: 0;
            width: 100%;
            /* Set the fixed height of the footer here */
            height: 50px;
            background-color: #f5f5f5;
        }
    </style>


</head>
<body style="background: url('img/img01.jpg') repeat-x;padding-top: 100px;">
<div class="container">
    <div class="row">
    <div class="col-sm-6 col-sm-offset-5">
    <h2>欢迎登录</h2>
    </div>
    </div>
    <div class="row col-sm-offset-2">
        <form action="${pageContext.request.contextPath}/loginServlet" method="post" class="form-horizontal">
            <div class="form-group">
                <label for="user" class="col-sm-2 control-label">用户名：</label>
                <div class="col-sm-6">
                    <input type="text" name="username" class="form-control" id="user" placeholder="请输入用户名"/>
                </div>
                <div class="col-sm-2">
                    <span id="username_sp" style="color: red"></span>
                </div>

            </div>

            <div class="form-group">
                <label for="password" class="col-sm-2 control-label">密码：</label>
                <div class="col-sm-6">
                    <input type="password" name="password" class="form-control" id="password" placeholder="请输入密码"/>
                </div>
                <div class="col-sm-2">
                    <span id="password_sp" style="color: red"></span>
                </div>
            </div>

            <div class="form-group">
                <label for="verifycode" class="col-sm-2 control-label">验证码：</label>
                <div class="col-sm-4">
                    <input type="text" name="verifycode" class="form-control" id="verifycode" placeholder="请输入验证码"/>
                </div>
                <div class="col-sm-4">
                    <a href="javascript:refreshCode();">
                        <img src="${pageContext.request.contextPath}/checkCodeServlet" id="vcode"/>
                    </a>
                    <a href="javascript:void(0)" id="kan">看不清？点我</a>
                </div>
                <div class="col-sm-2">
                    <span id="code_sp"></span>
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-2 col-sm-offset-2">
                    <input class="btn btn btn-primary form-control" type="submit" value="登录">
                </div>
                <div class="col-sm-3 col-sm-offset-2">
                    还没有账号？<span class="glyphicon glyphicon-hand-right" aria-hidden="true"></span> <a href="${pageContext.request.contextPath}/register.jsp">注册一个</a>
                </div>
            </div>
        </form>


        <c:if test="${requestScope.login_msg!=null}"><%--如果提示信息不为空的话，才会显示提示框--%>
            <!-- 出错显示的信息框 -->
            <div class="alert alert-warning alert-dismissible col-sm-6 col-sm-offset-2" role="alert">
                <button type="button" class="close" data-dismiss="alert" >
                    <span>&times;</span>
                </button>
                <strong>${requestScope.login_msg}</strong>
            </div>
        </c:if>
    </div><%--row end--%>
</div><%--container结尾--%>
<footer class="footer">
    <div class="container">
        <div class="row">
            <div class="col-sm-5 col-sm-offset-4">
                <strong>Copyright &copy; 2019-2020 <a href="https://blog.csdn.net/Deep_rooted">Yingyong Lao</a>.</strong> All rights reserved.
            </div>
        </div>
    </div>
</footer>

<script>
    //点击图片右侧文字刷新验证码
    var kan = document.getElementById("kan");
    kan.onclick=function ()
    {
        var vcode = document.getElementById("vcode");
        vcode.src="${pageContext.request.contextPath}/checkCodeServlet?time="+new Date().getTime();
    }

    /***************以下为表单校验********************/
    function checkUserName()//校验用户名
    {
        var username = $("#user").val();
        var zhengze=/^[a-zA-Z0-9_]{4,16}$/;//用户名正则，4到16位（字母，数字，下划线）
        var b = zhengze.test(username);
        return b;
    }
    function checkPassword()
    {
        var password=$("#password").val();
        var zhengze=/^[a-zA-Z0-9_]{4,16}$/;//密码正则，4到16位（字母，数字，下划线）
        var b = zhengze.test(password);
        return b;
    }

    $("form").submit(function ()//用户名或者密码格式错误的话，点击登录按钮是不会提交表单的，减轻了服务器的压力
    {
        checkUserName();
        checkPassword();
        return checkUserName()&&checkPassword();//只有同时为true，才会提交表单
    });

    $("#user").blur(function ()
    {
        var username = $("#user").val();
        var zhengze=/^[a-zA-Z0-9_]{4,16}$/;//用户名正则，4到16位（字母，数字，下划线）
        var b = zhengze.test(username);
        if(b!=true)
        {
            $("#username_sp").html("用户名格式错误");
        }
        else
        {
            $("#username_sp").html("格式正确");
            $("#username_sp").css("color","green");

        }

    });

    $("#password").blur(function ()
    {
        var password=$("#password").val();
        var zhengze=/^[a-zA-Z0-9_]{4,16}$/;//密码正则，4到16位（字母，数字，下划线）
        var b = zhengze.test(password);
        if(b!=true)
        {
            $("#password_sp").html("密码格式错误");
        }
        else
        {
            $("#password_sp").html("格式正确");
            $("#password_sp").css("color","green");

        }


    });


</script>
</body>
</html>