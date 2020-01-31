<%--
  Created by Yingyong Lao.
  User: laoyingyong
  Date: 2019-12-11
  Time: 18:43
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>添加水质质量数据</title>
    <script src="../js/jquery-ui.js"></script>
    <!-- 2. jQuery导入，建议使用1.9以上的版本 -->
    <script src="../js/jquery-3.2.1.min.js"></script>
    <!-- 1. 导入CSS的全局样式 -->
    <link href="../css/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/jquery-ui.min.css">
    <script src="../js/bootstrap.min.js"></script>
    <script>
        $(function ()
        {

            $.post("../FindAlllStationServlet",function (data)
            {
                for (var i = 0; i <data.length ; i++)
                {
                    var obj=data[i];
                    var stationName=obj.stationName;
                    var optionStr='<option value="'+stationName+'">'+stationName+'</option>';
                    $("#belongStation").append(optionStr);
                }

            });

            $("#stationForm").submit(function ()
            {
                $.get("../AddWaterQualityDataServlet",$("#stationForm").serialize(),function (data)//serialize()千万别少写了括号哦
                {
                    var msg=data.msg;
                    var str='<div class="alert alert-warning alert-dismissible" role="alert">\n' +
                        '  <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>\n' +
                        '  <strong>提示：</strong>'+msg+'\n' +
                        '</div>';
                    $("#msg_div").html(str);
                });

                return false;//阻止页面跳转
            });



        });


        function addSomeWaterQuality()
        {
            $.post("../AddWaterQualityServlet",function (data)
            {
                var msg=data.msg;
                alert(msg);

            });

        }

        function getStation()
        {
            var belongStation = $("#belongStation").val();
            return belongStation;
        }
        
        function addOneWaterQuality() 
        {
            var belongStation = getStation();
            var waterQuality=getQualityLevel();
            var date = $("#date").val();
            var ph = $("#ph").val();
            var oxygen = $("#oxygen").val();
            var nitrogen=$("#nitrogen").val();
            var permangan = $("#permangan").val();
            var orgacarbon=$("#orgacarbon").val();


            $.post("../AddOneWaterQualityServlet",{belongStation:belongStation,date:date,ph:ph,oxygen:oxygen,nitrogen:nitrogen,permangan:permangan,orgacarbon:orgacarbon,waterQuality:waterQuality},function (data)
            {
                alert(data.msg);
                
            });
            
        }


        function getQualityLevel()
        {
            var a = $("#qualitySelect").val();

            return a;
        }




    </script>
</head>
<body style="background: url('../img/img01.jpg') repeat-x;">
<div class="container">
    <div class="row">
        <div class="col-sm-8">
            <form id="stationForm" action="AddWaterQualityDataServlet" method="post">
            <table class="table table-bordered">
                <caption style="text-align: center;font-size: 24px">添加水质监测站</caption>
                <tr class="success">
                    <th  style="text-align: center">监测站名称</th>
                    <th  style="text-align: center">经度</th>
                    <th  style="text-align: center">纬度</th>
                    <th  style="text-align: center">所属断面</th>
                    <th  style="text-align: center">简介</th>
                </tr>
                <tr class="info">
                    <td><input name="stationName" placeholder="安徽宿州杨庄"></td>
                    <td><input name="longitude" placeholder="经度"></td>
                    <td><input name="latitude" placeholder="纬度"></td>
                    <td><input name="section" placeholder="苏-皖省界"></td>
                    <td><textarea rows="5" cols="20" name="introduction" placeholder="安徽宿州杨庄水质自动监测站位于宿州市杨庄乡伊桥村。点位坐标北纬34度03分43秒，东经117度13分12秒。属淮河流域，奎河（苏-皖省界）。由安徽省宿州环境监测站管理。距水站77公里。建于2006年12月。"></textarea></td>
                </tr>
                <tr class="info">
                    <td colspan="2" style="text-align: center"><input id="addStation_Btn" type="submit" value="添加" class="btn btn-info"></td>
                    <td colspan="3"> <div id="msg_div"></div></td>
                </tr>

            </table>

            </form>

        </div><%--单元格的结尾--%>

    </div><%--row end--%>

    <div class="row" style="padding-top: 50px"><%--第二行--%>

        <div class="col-md-12">
                <table class="table table-bordered table-responsive table-condensed">
                    <caption style="text-align: center;font-size: 24px">手动添加水质监测数据</caption>
                    <tr class="success">
                        <th  style="text-align: center">所属测站名</th>
                        <th  style="text-align: center">PH</th>
                        <th  style="text-align: center">溶解氧</th>
                        <th  style="text-align: center">氨氮</th>
                        <th  style="text-align: center">高猛酸钾指数</th>
                        <th  style="text-align: center">总有机碳</th>
                        <th  style="text-align: center">水质类别</th>
                        <th  style="text-align: center">测量时间</th>
                    </tr>
                    <tr class="info">
                        <td>
                            <select id="belongStation" onchange="getStation();">
                                <option>--请选择--</option>
                            </select>
                        </td>
                        <td><input type="number" step="0.01" style="width: 120px" id="ph" name="ph" placeholder="8.02"></td>
                        <td><input type="number" step="0.01" style="width: 110px" id="oxygen" name="oxygen" placeholder="11.33"></td>
                        <td><input type="number" step="0.01" style="width: 120px" name="nitrogen" id="nitrogen" placeholder="1.39"></td>
                        <td><input type="number" step="0.01" style="width: 120px" name="permangan" id="permangan" placeholder="3.5"></td>
                        <td><input type="number" step="0.01" style="width: 120px" name="orgacarbon" id="orgacarbon" placeholder="0.8"></td>
                        <td>
                            <select id="qualitySelect" onchange="getQualityLevel();">
                                <option>--请选择--</option>
                                <option value="I">Ⅰ</option>
                                <option value="II">Ⅱ</option>
                                <option value="III">Ⅲ</option>
                                <option value="IV">Ⅳ</option>
                                <option value="V">Ⅴ</option>
                                <option value="劣V">劣Ⅴ</option>

                            </select>
                        </td>
                        <td><input type="datetime-local" style="width: 180px"  name="date" id="date" placeholder="2019-12-11 12:00"></td>
                    </tr>
                    <tr class="info">
                        <td colspan="4" style="text-align: center"><input  onclick="addOneWaterQuality();" type="button" value="添加" class="btn btn-info"></td>
                        <td colspan="5"></td>
                    </tr>

                </table>
        </div><%--单元格的结尾--%>


    </div><%--第二行end--%>


    <div class="row" style="padding-top:50px">
        <div class="col-sm-3 col-sm-offset-4">
            <table class="table table-bordered">
                <caption style="text-align: center;font-size: 24px">一键添加多条水质数据</caption>
                <tr class="info">
                    <td><button onclick="addSomeWaterQuality();" class="btn btn-info"><span class="glyphicon glyphicon-refresh" aria-hidden="true"></span>&nbsp;从“中国环境监测总站”同步数据到数据库</button></td>
                </tr>
            </table>

        </div>

    </div>

</div><%--container容器end--%>


</body>
</html>
