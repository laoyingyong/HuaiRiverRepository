<%--
  Created by Yingyong Lao.
  User: laoyingyong
  Date: 2019-12-12
  Time: 21:48
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>查看水质信息</title>
    <!-- 2. jQuery导入，建议使用1.9以上的版本 -->
    <script src="../js/jquery-3.2.1.min.js"></script>
    <!-- 1. 导入CSS的全局样式 -->
    <link href="../css/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
     <link href="../css/costomizeAlertDialog/customizeAlert.css" rel="stylesheet">
    <script src="../js/bootstrap.min.js"></script>
    <script>
        $(function () //入口函数
        {
            $.post("../FindByPageServlet",{currentPage:1,pageSize:5},function (data)
            {
                var totalCount = data.totalCount;
                var totalPage = data.totalPage;
                var currentPage = data.currentPage;
                var array = data.list;

                if(currentPage==1)
                {
                    var str=' <ul class="pagination">\n' +
                        '                    <li class="disabled" onclick="findByPage('+(currentPage-1)+',5)">\n' +
                        '                        <a href="#" aria-label="Previous">\n' +
                        '                            <span aria-hidden="true">&laquo;</span>\n' +
                        '                        </a>\n' +
                        '                    </li>';

                }
                else
                {
                    var str=' <ul class="pagination">\n' +
                        '                    <li onclick="findByPage('+(currentPage-1)+',5)">\n' +
                        '                        <a href="#" aria-label="Previous">\n' +
                        '                            <span aria-hidden="true">&laquo;</span>\n' +
                        '                        </a>\n' +
                        '                    </li>';

                }

                for(var i=1;i<=totalPage;i++)
                {
                    if(currentPage==i)
                    {
                        var item='  <li class="active" onclick="findByPage('+i+',5)"><a href="#">'+i+'</a></li>';

                    }
                    else
                    {
                        var item='  <li onclick="findByPage('+i+',5)"><a href="#">'+i+'</a></li>';

                    }

                    str+=item;
                }

                    var end=' <li onclick="findByPage('+(currentPage+1)+',5)">\n' +
                        '                        <a href="#" aria-label="Next">\n' +
                        '                            <span aria-hidden="true">&raquo;</span>\n' +
                        '                        </a>\n' +
                        '                    </li>\n' +
                        '                </ul>\n' +
                        '                <div>\n' +
                        '                    <span style="font-size: 24px" id="total_sp">共'+totalCount+'条记录，共'+totalPage+'页</span>\n' +
                        '                </div>';
                str+=end;
                $("#fenyetiao").html(str);//分页条的初始化


                var tableStr=' <caption style="text-align: center;font-size: 24px">测站一览</caption>\n' +
                    '                <tr class="success">\n' +
                    '                    <th style="text-align: center">id</th>\n' +
                    '                    <th style="text-align: center">监测站名称</th>\n' +
                    '                    <th style="text-align: center">操作</th>\n' +
                    '                </tr>';
                for (var i=0;i<array.length;i++)
                {
                    var obj = array[i];
                    var id = obj.id;
                    var stationName = obj.stationName;

                    var oneRecord='<tr class="info">\n' +
                        '                    <td style="text-align: center">'+id+'</td>\n' +
                        '                    <td style="text-align: center">'+stationName+'</td>\n' +
                        '                    <td style="text-align: center"><input type="button" class="btn btn-info" value="查看监测数据" onclick="viewWaterQualityInfo(\''+stationName+'\');">&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn btn-info" value="查看简介" onclick="intro('+id+')"></td>\n' +
                        '                </tr>';

                    tableStr+=oneRecord;

                }
                $("#waterQuality_table").html(tableStr);


            });

        });//入口函数的结尾

        function findByPage(currentPage,pageSize)
        {
            $.post("../FindByPageServlet",{currentPage:currentPage,pageSize:pageSize},function (data)
            {
                var totalCount = data.totalCount;
                var totalPage = data.totalPage;
                var currentPage = data.currentPage;
                var array = data.list;


                if(currentPage==1)
                {
                    var str=' <ul class="pagination">\n' +
                        '                    <li class="disabled" onclick="findByPage('+(currentPage-1)+',5)">\n' +
                        '                        <a href="#" aria-label="Previous">\n' +
                        '                            <span aria-hidden="true">&laquo;</span>\n' +
                        '                        </a>\n' +
                        '                    </li>';

                }
                else
                {
                    var str=' <ul class="pagination">\n' +
                        '                    <li onclick="findByPage('+(currentPage-1)+',5)">\n' +
                        '                        <a href="#" aria-label="Previous">\n' +
                        '                            <span aria-hidden="true">&laquo;</span>\n' +
                        '                        </a>\n' +
                        '                    </li>';

                }

                for(var i=1;i<=totalPage;i++)
                {
                    if(currentPage==i)
                    {
                        var item='  <li class="active" onclick="findByPage('+i+',5)"><a href="#">'+i+'</a></li>';

                    }
                    else
                    {
                        var item='  <li onclick="findByPage('+i+',5)"><a href="#">'+i+'</a></li>';

                    }

                    str+=item;
                }
                if(currentPage==totalPage)
                {
                    var end=' <li class="disabled" onclick="findByPage('+(currentPage+1)+',5)">\n' +
                        '                        <a href="#" aria-label="Next">\n' +
                        '                            <span aria-hidden="true">&raquo;</span>\n' +
                        '                        </a>\n' +
                        '                    </li>\n' +
                        '                </ul>\n' +
                        '                <div>\n' +
                        '                    <span style="font-size: 24px" id="total_sp">共'+totalCount+'条记录，共'+totalPage+'页</span>\n' +
                        '                </div>';

                }
                else
                {
                    var end=' <li onclick="findByPage('+(currentPage+1)+',5)">\n' +
                        '                        <a href="#" aria-label="Next">\n' +
                        '                            <span aria-hidden="true">&raquo;</span>\n' +
                        '                        </a>\n' +
                        '                    </li>\n' +
                        '                </ul>\n' +
                        '                <div>\n' +
                        '                    <span style="font-size: 24px" id="total_sp">共'+totalCount+'条记录，共'+totalPage+'页</span>\n' +
                        '                </div>';

                }

                str+=end;
                $("#fenyetiao").html(str);//分页条的初始化


                var tableStr=' <caption style="text-align: center;font-size: 24px">测站一览</caption>\n' +
                    '                <tr class="success">\n' +
                    '                    <th style="text-align: center">id</th>\n' +
                    '                    <th style="text-align: center">监测站名称</th>\n' +
                    '                    <th style="text-align: center">操作</th>\n' +
                    '                </tr>';
                for (var i=0;i<array.length;i++)
                {
                    var obj = array[i];
                    var id = obj.id;
                    var stationName = obj.stationName;

                    var oneRecord=' <tr class="info">\n' +
                        '                    <td style="text-align: center">'+id+'</td>\n' +
                        '                    <td style="text-align: center">'+stationName+'</td>\n' +
                        '                    <td style="text-align: center"><input type="button" class="btn btn-info" value="查看监测数据" onclick="viewWaterQualityInfo(\''+stationName+'\');">&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn btn-info" value="查看简介" onclick="intro('+id+');"></td>\n' +
                        '                </tr>';

                    tableStr+=oneRecord;

                }
                $("#waterQuality_table").html(tableStr);


            });

        }

        //查看简介的回调函数
        function intro(id)
        {
            $.post("../FindIntroServlet",{id:id},function (data)
            {
                var introduction = data.introduction;
                alertMsg(introduction);
            });

        }


        //查看对应的水质信息的回调函数
        function viewWaterQualityInfo(stationName)
        {
            var divStr='<table class="table table-bordered table-hover" id="waterQualityInfo_table">\n' +
                '                <caption style="text-align: center;font-size: 24px">测站对应的水质信息</caption>\n' +
                '                <tr class="success">\n' +
                '                    <th style="text-align: center">所属测站</th>\n' +
                '                    <th style="text-align: center">ph</th>\n' +
                '                    <th style="text-align: center">溶解氧</th>\n' +
                '                    <th style="text-align: center">氨氮</th>\n' +
                '                    <th style="text-align: center">高猛酸钾指数</th>\n' +
                '                    <th style="text-align: center">总有机碳</th>\n' +
                '                    <th style="text-align: center">水质类别</th>\n' +
                '                    <th style="text-align: center">日期</th>\n' +
                '                    <th style="text-align: center">更新时间</th>\n' +
                '                </tr>';
            $.post("../ViewWaterQulityInfoServlet",{stationName:stationName},function (data)
            {
                for(var i=0;i<data.length;i++)
                {
                    var obj = data[i];
                    var belongStation = obj.belongStation;
                    var ph = obj.ph;
                    var oxygen=obj.oxygen;
                    var nitrogen=obj.nitrogen;
                    var permangan=obj.permangan;
                    var orgacarbon=obj.orgacarbon;
                    var phquality=obj.phquality;
                    var date=obj.date;
                    var time=obj.time;

                    var item='  <tr class="info">\n' +
                        '                    <td style="text-align: center">'+belongStation+'</td>\n' +
                        '                    <td style="text-align: center">'+ph+'</td>\n' +
                        '                    <td style="text-align: center">'+oxygen+'</td>\n' +
                        '                    <td style="text-align: center">'+nitrogen+'</td>\n' +
                        '                    <td style="text-align: center">'+permangan+'</td>\n' +
                        '                    <td style="text-align: center">'+orgacarbon+'</td>\n' +
                        '                    <td style="text-align: center">'+phquality+'</td>\n' +
                        '                    <td style="text-align: center">'+date+'</td>\n' +
                        '                    <td style="text-align: center">'+time+'</td>\n' +
                        '\n' +
                        '\n' +
                        '                </tr>';

                    divStr+=item;
                }

                var endStr=' </table>';
                $("#details_div").html(divStr);





            });

        }


        //搜索按钮的回调函数
        function searchByCondition()
        {
            var stationName = $("#stationName").val();
            $.post("../ConditionalQueryStationByPageServlet",{stationName:stationName,currentPage:1,pageSize:30},function (data)
            {
                var totalCount=data.totalCount;
                if(totalCount==0)
                {
                    alert("数据库中没有相关记录！")
                }
                var totalPage=data.totalPage;
                var currentPage = data.currentPage;
                var array = data.list;

                var waterQuality_table_str='<caption style="text-align: center;font-size: 24px">查询结果</caption>\n' +
                    '                <tr class="success">\n' +
                    '                    <th style="text-align: center">id</th>\n' +
                    '                    <th style="text-align: center">监测站名称</th>\n' +
                    '                    <th style="text-align: center">操作</th>\n' +
                    '                </tr>';

                for(var i=0;i<array.length;i++)
                {
                    var obj = array[i];
                    var id = obj.id;
                    var stationName= obj.stationName;


                    var itemStr='<tr class="info">\n' +
                        '                    <td style="text-align: center">'+id+'</td>\n' +
                        '                    <td style="text-align: center">'+stationName+'</td>\n' +
                        '                    <td style="text-align: center"><input type="button" class="btn btn-info" value="查看监测数据" onclick="viewWaterQualityInfo(\''+stationName+'\');">&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn btn-info" value="查看简介" onclick="intro('+id+');"></td>\n' +
                        '                </tr>';
                    waterQuality_table_str+=itemStr;
                }
                var endStr='  </table>';
                waterQuality_table_str+=endStr;
                $("#waterQuality_table").html(waterQuality_table_str);

                var fenyelanStr=' <span style="font-size: 24px" id="total_sp">共'+totalCount+'条记录</span>&nbsp;&nbsp;<input class="btn btn-info" value="返回一览表" type="button" onclick="fuwei();">';
                $("#fenyetiao").html(fenyelanStr);



            });
        }

        //返回一览表的回调函数
        function fuwei()
        {
            window.location.href='viewWaterQualityData.jsp';

        }


    </script>
</head>
<body style="background: url('../img/img01.jpg') repeat-x;padding-top: 50px">
<div class="container">

    <div class="row">
        <div class="col-sm-6">

            <form class="form-inline">
                <div class="form-group">
                    <label class="sr-only" for="stationName">Email address</label>
                    <input type="text" class="form-control" id="stationName" name="stationName" placeholder="请输入测站名称,支持模糊查询" style="width: 230px">
                </div>
                <button type="button" onclick="searchByCondition();" class="btn btn-warning">搜索</button>
            </form>

        </div>
    </div>
    <div class="row">
        <div class="col-sm-6">
            <table class="table table-bordered table-hover" id="waterQuality_table">
                <caption style="text-align: center;font-size: 24px">测站一览</caption>
                <tr class="success">
                    <th style="text-align: center">id</th>
                    <th style="text-align: center">监测站名称</th>
                    <th style="text-align: center">操作</th>
                </tr>
                <tr class="info">
                    <td style="text-align: center">id</td>
                    <td style="text-align: center">监测站名称</td>
                    <td style="text-align: center"><input type="button" class="btn btn-info" value="查看监测数据">&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="btn btn-info" value="查看简介"></td>
                </tr>

            </table>

            <nav aria-label="Page navigation" id="fenyetiao">
                <ul class="pagination">
                    <li>
                        <a href="#" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <li><a href="#">1</a></li>
                    <li>
                        <a href="#" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
                <div>
                    <span style="font-size: 24px" id="total_sp">共2条记录，共1页</span>
                </div>

            </nav>

        </div><%--单元格end--%>

        <div class="col-sm-6" id="details_div"><%--对应的水质信息--%>
        </div>

    </div><%--row end--%>

</div>
<script src="../js/customizeAlertDialog/customizeAlert.js"></script>
</body>
</html>
