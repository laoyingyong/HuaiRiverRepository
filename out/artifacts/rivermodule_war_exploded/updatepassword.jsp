<%--
  Created by Yingyong Lao.
  User: laoyingyong
  Date: 2019-12-09
  Time: 22:44
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>修改密码</title>
    <!-- 2. jQuery导入，建议使用1.9以上的版本 -->
    <script src="js/jquery-3.2.1.min.js"></script>
    <!-- 1. 导入CSS的全局样式 -->
    <script src="js/bootstrap.min.js"></script>
    <link href="css/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script>
        $(function () //入口函数
        {
            $("#myform").submit(function ()
            {
                $.post("UpdatePasswordServlet",$("#myform").serialize(),function (data) //发送ajax请求
                {

                  alert(data.msg);

                });
               return false;//不让表单提交
            });


        });
    </script>
</head>
<body style="background: url('img/img01.jpg') repeat-x">
<div class="container">
    <div class="row" style="margin-top: 50px">
        <div class="col-sm-10 col-sm-offset-2"id="xiugai_div">
            <form id="myform" class="form-horizontal" method="post">
                <div class="form-group">
                    <label class="col-sm-2 col-sm-offset-4"><h2>修改密码</h2></label>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">用户名:</label>
                    <div class="col-sm-6">
                        <input type="text" readonly="readonly" class="form-control" id="username" name="username" value="${user.username}"/>
                    </div>
                    <div class="col-sm-2">
                        <span id="username_sp" style="color: red"></span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-2 control-label">新密码:</label>
                    <div class="col-sm-6">
                        <input type="password" placeholder="请输入新密码" class="form-control" id="password2" name="newPassword"/>
                    </div>
                    <div class="col-sm-2">
                        <span id="password2_sp" style="color: red"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-sm-2 col-sm-offset-2">
                        <input type="submit" value="修改" class="btn btn-primary form-control">
                    </div>
                </div>

            </form>

        </div>


    </div><%--row的结尾--%>

</div><%--container的结尾--%>

</body>
</html>
