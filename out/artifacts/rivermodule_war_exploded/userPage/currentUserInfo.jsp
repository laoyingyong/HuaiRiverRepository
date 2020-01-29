<%--
  Created by Yingyong Lao.
  User: laoyingyong
  Date: 2020-01-22
  Time: 17:21
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>用户资料</title>
    <script src="../js/jquery-3.2.1.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="../css/bootstrap-3.3.7-dist/css/bootstrap.min.css">
</head>
<body style="background: url('../img/img01.jpg') repeat-x;padding-top: 50px">
<div class="container-fluid">
    <div class="row">
        <div class="col-sm-8 col-sm-offset-2">
           <table class="table table-bordered" id="userInfoTable">
               <caption style="text-align: center;font-size: 24px">个人资料</caption>
               <tr>
                   <th>姓名：</th>
                   <td>${user.name}</td>
               </tr>
               <tr>
                   <th>性别：</th>
                   <td>${user.gender}</td>
               </tr>
               <tr>
                   <th>年龄：</th>
                   <td>${user.age}</td>
               </tr>
               <tr>
                   <th>贯籍：</th>
                   <td>${user.address}</td>
               </tr>
               <tr>
                   <th>QQ：</th>
                   <td>${user.qq}</td>
               </tr>
               <tr>
                   <th>邮箱：</th>
                   <td>${user.email}</td>
               </tr>
               <tr>
                   <th>操作：</th>
                   <td><button class="btn btn-info btn-primary" onclick="update();">修改个人资料</button></td>
               </tr>
           </table>

        </div>

    </div>

</div>

<script>
    function update()
    {
        var tableStr='<caption style="text-align: center;font-size: 24px">修改个人资料</caption>';
        var contentStr='<tr>\n' +
            '                   <th>姓名：</th>\n' +
            '                   <td><input type="text" id="name" value="${user.name}"/><input id="id" type="hidden" value="${user.id}"/></td>\n' +
            '               </tr>\n' +
            '               <tr>\n' +
            '                   <th>性别：</th>\n' +
            '                   <td><input id="gender" type="text" value="${user.gender}"/></td>\n' +
            '               </tr>\n' +
            '               <tr>\n' +
            '                   <th>年龄：</th>\n' +
            '                   <td><input id="age" type="text" value="${user.age}"/></td>\n' +
            '               </tr>\n' +
            '               <tr>\n' +
            '                   <th>贯籍：</th>\n' +
            '                   <td><input id="address" type="text" value="${user.address}"/></td>\n' +
            '               </tr>\n' +
            '               <tr>\n' +
            '                   <th>QQ：</th>\n' +
            '                   <td><input id="qq" type="text" value="${user.qq}"/></td>\n' +
            '               </tr>\n' +
            '               <tr>\n' +
            '                   <th>邮箱：</th>\n' +
            '                   <td><input id="email" type="text" value="${user.email}"/></td>\n' +
            '               </tr>\n' +
            '               <tr>\n' +
            '                   <th>操作：</th>\n' +
            '                   <td><button class="btn btn-info btn-primary" onclick="confirmUpdate();">修改</button></td>\n' +
            '               </tr>\n';

            tableStr+=contentStr;
        $("#userInfoTable").html(tableStr);
    }


    function confirmUpdate()
    {
        var id=$("#id").val();
        var name=$("#name").val();
        var gender=$("#gender").val();
        var age=$("#age").val();
        var address=$("#address").val();
        var qq=$("#qq").val();
        var email=$("#email").val();

        $.post("../UpdateUserInfoServlet",{id:id,name:name,gender:gender,age:age,address:address,qq:qq,email:email},function (data)
        {
            alert(data.msg);
        });

    }
</script>

</body>
</html>
