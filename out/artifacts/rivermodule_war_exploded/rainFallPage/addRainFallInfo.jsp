<%--
  Created by Yingyong Lao.
  User: laoyingyong
  Date: 2019-12-12
  Time: 12:04
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>添加降雨量数据</title>
    <!-- 2. jQuery导入，建议使用1.9以上的版本 -->
    <script src="../js/jquery-3.2.1.min.js"></script>
    <!-- 1. 导入CSS的全局样式 -->
    <link href="../css/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="../js/bootstrap.min.js"></script>
    <script>
        $(function ()//入口函数
        {
            //请求参数的值
            var area;
            var month;
            $("#area_select").change(function ()
            {
                area = $("#area_select").val();

            });
            $("#month_select").change(function ()
            {
                month=$("#month_select").val();

            });


            $("#rain_Form").submit(
                function ()
                {
                    var precipitation=$("#precipitation").val();
                    var releaseDate=$("#releaseDate").val();

                    $.post("../AddRainFallInfoServlet",{area:area,precipitation:precipitation,month:month,releaseDate:releaseDate},function (data)
                    {
                        var msg = data.msg;
                        var str='<div class="alert alert-warning alert-dismissible" role="alert">\n' +
                            '  <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>\n' +
                            '  <strong>提示：</strong>'+msg+'\n' +
                            '</div>';

                        $("#msg_div").html(str);


                    });


                    return false;//不让页面发生跳转

                }
            );


        });
    </script>
</head>
<body style="background: url('../img/img01.jpg') repeat-x;height: 100%">

<div class="container" >

    <div class="row" style="height: 700px;width: 100%; position: absolute;left: 0px;top: 0px; "id="particles-js">
        <div class="col-sm-8 col-sm-offset-2" >
            <form id="rain_Form" action="AddRainFallInfoServlet" method="post">
                <table class="table table-bordered"style="z-index: -1000;">
                    <caption style="text-align: center;font-size: 24px">添加降雨信息数据</caption>
                    <tr class="success">
                        <th  style="text-align: center">地区</th>
                        <th  style="text-align: center">降雨量（mm）</th>
                        <th  style="text-align: center">月份</th>
                        <th  style="text-align: center">发布日期</th>
                    </tr>
                    <tr class="info">
                        <td><select id="area_select"><option name="area">--请选择--</option><option value="淮河流域">淮河流域</option><option value="淮河水系">淮河水系</option><option value="沂沭泗水系">沂沭泗水系</option></select></td>
                        <td><input type="number" step="0.01" min="0" id="precipitation" name="precipitation" placeholder="48.70"></td>
                        <td>
                        <select id="month_select">
                            <option value="1">1月</option>
                            <option value="2">2月</option>
                            <option value="3">3月</option>
                            <option value="4">4月</option>
                            <option value="5">5月</option>
                            <option value="6">6月</option>
                            <option value="7">7月</option>
                            <option value="8">8月</option>
                            <option value="9">9月</option>
                            <option value="10">10月</option>
                            <option value="11">11月</option>
                            <option value="12">12月</option>

                        </select></td>
                        <td><input id="releaseDate" type="date" name="releaseDate"></td>

                    </tr>
                    <tr class="info">
                        <td colspan="2" style="text-align: center"><input id="addStation_Btn" type="submit" value="添加" class="btn btn-info"></td>
                        <td colspan="2"> <div id="msg_div"></div></td>
                    </tr>

                </table>

            </form>


        </div><%--单元格的结尾--%>
        </div><%--row的结尾--%>

</div><%--container的结尾--%>


<script src="../js/animation/particles.js"></script>
<script src="../js/animation/app.js"></script>
</body>
</html>
