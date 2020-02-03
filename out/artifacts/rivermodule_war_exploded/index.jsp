<%@ page import="java.util.List" %>
<%@ page import="domain.WaterQualityStation" %><%--
  Created by Yingyong Lao.
  User: laoyingyong
  Date: 2019-11-18
  Time: 18:47
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>首页</title>

  <!-- 2. jQuery导入，建议使用1.9以上的版本 -->
  <script src="js/jquery-3.2.1.min.js"></script>
  <!-- 1. 导入CSS的全局样式 -->
  <link href="css/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="css/shouye.css">
  <!-- 3. 导入bootstrap的js文件 -->
  <script src="js/bootstrap.min.js"></script>
  <script type="text/javascript" src="js/init.js">
  </script>


</head>
<body style="background: url('img/img01.jpg') repeat-x;padding-top: 52px">


    <!--导航条-->
    <nav class="navbar navbar-default  navbar-fixed-top">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
            </div>

            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    <li> <img src="img/huaiRiver.png" style="width: 350px;height: 51px"/></li>
                </ul>



                <ul class="nav navbar-nav navbar-right">
                    <li><p class="navbar-text"><span class="glyphicon glyphicon-time" aria-hidden="true"></span>&nbsp;时间：<span id="time_sp" style="color:dodgerblue"></span></p></li>
                    <c:if test="${user!=null}">
                        <li><p class="navbar-text"><span class="glyphicon glyphicon-user" aria-hidden="true"></span>&nbsp;<span>用户：</span><a target="myframe" href="../userPage/currentUserInfo.jsp">${user.name}</a></p></li>
                    </c:if>
                    <c:if test="${user==null}">
                        <li><p class="navbar-text"><span class="glyphicon glyphicon-user" aria-hidden="true"></span>&nbsp;<span>用户：</span>未登录</p></li>
                    </c:if>
                    <c:if test="${user!=null}">
                        <li><p class="navbar-text"><span class="glyphicon glyphicon-log-out" aria-hidden="true"></span>&nbsp;<a href="${pageContext.request.contextPath}/LogoutServlet">注销</a></p></li>
                    </c:if>
                    <c:if test="${user==null}">
                        <li><p class="navbar-text"><a href="${pageContext.request.contextPath}/login.jsp" style="color: yellow">点击登录</a></p></li>

                    </c:if>

                </ul>


            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>



<div class="container-fluid">
        <div class="row">

            <div class="col-sm-2" style="height: 700px;">

                <div class="leftsidebar_box"><%--侧边菜单栏--%>
                    <dl>
                        <dt class="first_dt" ><span class="glyphicon glyphicon-plus"></span>&nbsp;数据采集与录入<img  src="img/select_xl01.png"/></dt>
                        <dd><a href="rainFallPage/addRainFallInfo.jsp" target="myframe" style="color: white">降雨量数据</a></dd>
                        <dd><a href="waterLevelPage/addWaterLevelData.jsp" target="myframe" style="color: white">水位监测数据</a></dd>
                        <dd><a href="waterQualityPage/addWaterQualityData.jsp" target="myframe" style="color: white">水质监测数据</a></dd>
                    </dl>
                    <dl>
                        <dt><span class="glyphicon glyphicon-blackboard"></span>&nbsp;地理信息展示<img  src="img/select_xl01.png"/></dt>
                        <dd>监测可视化</dd>
                        <dd><a target="myframe" href="viewMap.jsp" style="color: white">地图浏览</a></dd>
                        <dd>水质空间数据分析</dd>
                        <dd>空间属性查询</dd>
                        <dd>多尺度表达</dd>
                    </dl>
                    <dl>
                        <dt><span class="glyphicon glyphicon-equalizer"></span>&nbsp;数据查询与分析<img src="img/select_xl01.png"/></dt>
                        <dd ><a href="waterQualityStationPage/viewWaterQualityData.jsp" target="myframe" style="color: white">水质信息查询</a></dd>
                        <dd> <a href="waterLevelPage/viewWaterLevelInfo.jsp" target="myframe" style="color: white">水位信息查询</a></dd>
                        <dd id="rain_fall"><a href="rainFallPage/viewRainInfo.jsp" target="myframe" style="color: white">降雨信息查询</a></dd>
                        <dd>数据获取</dd>
                        <dd>分析评价</dd>
                        <dd>生成报告</dd>
                    </dl>
                    <dl>
                        <dt><span class="glyphicon glyphicon-exclamation-sign"></span>&nbsp;应急决策处理<img src="img/select_xl01.png"/></dt>
                        <dd> <a href="emergencyPage/emergencyDecision.jsp" target="myframe" style="color: white">应急决策分析</a></dd>
                        <dd>应急处理流程</dd>
                        <dd>应急方案生成</dd>
                        <dd>应急决策总结</dd>
                    </dl>

                    <dl>
                        <dt><span class="glyphicon glyphicon-user"></span>&nbsp;用户管理<img src="img/select_xl01.png"/></dt>
                        <dd><a href="updatepassword.jsp" target="myframe" style="color: white">修改当前用户密码</a></dd>
                        <dd ><a href="findUserByPageServlet" style="color: white">管理所有用户信息</a></dd>
                    </dl>

            </div><%--侧边栏的结尾--%>

            </div>

            <div class="col-sm-10" style="padding-left: 0px;padding-right: 0px">
                <iframe style="width: 100%;height: 700px;border: 0px" name="myframe" src="welcom.jsp"></iframe>

            </div>






        </div> <%--<div class="row">的结尾--%>




</div><%--container的结尾--%>



<script>

    //顶部导航栏的时间
    function getCurrentTime()
    {
        var time=new Date();
        var s=dateFormat("yyyy年MM月dd日 HH时mm分ss秒",time);
        return s;
    }
    function f()
    {
        $("#time_sp").html(getCurrentTime());
    }
    window.setInterval(f,1000);


    function dateFormat(fmt, date) //时间格式化
    {
        var ret;
        var opt =
         {
            "y+": date.getFullYear().toString(),        // 年
            "M+": (date.getMonth() + 1).toString(),     // 月
            "d+": date.getDate().toString(),            // 日
            "H+": date.getHours().toString(),           // 时
            "m+": date.getMinutes().toString(),         // 分
            "s+": date.getSeconds().toString()       // 秒
            // 有其他格式化字符需求可以继续添加，必须转化成字符串
        };
        for (var k in opt)
        {
            ret = new RegExp("(" + k + ")").exec(fmt);
            if (ret)
            {
                fmt = fmt.replace(ret[1], (ret[1].length == 1) ? (opt[k]) : (opt[k].padStart(ret[1].length, "0")))
            };
        };
        return fmt;
    }

</script>

</body>
</html>