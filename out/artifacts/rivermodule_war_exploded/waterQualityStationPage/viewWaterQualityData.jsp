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
                    var longitude= obj.longitude;
                    var latitude= obj.latitude;
                    var section = obj.section;
                    var introduction = obj.introduction;
                    

                    var oneRecord='<tr class="info">\n' +
                        '                    <td style="text-align: center">'+id+'</td>\n' +
                        '                    <td style="text-align: center">'+stationName+'</td>\n' +
                        '                    <td style="text-align: center">\n' +
                        '                        <input onclick="viewWaterQualityInfo(\''+stationName+'\');" type="button" class="btn btn-info btn-xs" value="查看监测数据">&nbsp;&nbsp;&nbsp;&nbsp;\n' +
                        '                        <input onclick="intro('+id+');" type="button" class="btn btn-info btn-xs" value="查看简介">&nbsp;&nbsp;&nbsp;&nbsp;\n' +
                        '                        <input onclick="update('+id+',\''+stationName+'\','+longitude+','+latitude+',\''+section+'\',\''+introduction+'\')" type="button" class="btn btn-info btn-xs" value="修改">&nbsp;&nbsp;&nbsp;&nbsp;\n' +
                        '                        <input onclick="dele('+id+');" type="button" class="btn btn-info btn-xs" value="删除">\n' +
                        '                    </td>\n' +
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
                    var longitude = obj.longitude;
                    var latitude = obj.latitude;

                    var section = obj.section;
                    var introduction = obj.introduction;

                    var oneRecord='<tr class="info">\n' +
                        '                    <td style="text-align: center">'+id+'</td>\n' +
                        '                    <td style="text-align: center">'+stationName+'</td>\n' +
                        '                    <td style="text-align: center">\n' +
                        '                        <input onclick="viewWaterQualityInfo(\''+stationName+'\');" type="button" class="btn btn-info btn-xs" value="查看监测数据">&nbsp;&nbsp;&nbsp;&nbsp;\n' +
                        '                        <input onclick="intro('+id+');" type="button" class="btn btn-info btn-xs" value="查看简介">&nbsp;&nbsp;&nbsp;&nbsp;\n' +
                        '                        <input onclick="update('+id+',\''+stationName+'\','+longitude+','+latitude+',\''+section+'\',\''+introduction+'\')" type="button" class="btn btn-info btn-xs" value="修改">&nbsp;&nbsp;&nbsp;&nbsp;\n' +
                        '                        <input onclick="dele('+id+');" type="button" class="btn btn-info btn-xs" value="删除">\n' +
                        '                    </td>\n' +
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
                '                    <th style="text-align: center">操作</th>\n' +
                '                </tr>';
            $.post("../ViewWaterQulityInfoServlet",{stationName:stationName},function (data)
            {
                for(var i=0;i<data.length;i++)
                {
                    var obj = data[i];
                    var id=obj.id;
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
                        '                    <td style="text-align: center">' +
                        '<input type="button" onclick="updateQuality('+id+',\''+belongStation+'\','+ph+','+oxygen+','+nitrogen+','+permangan+','+orgacarbon+',\''+phquality+'\',\''+date+'\',\''+time+'\');" class="btn btn-info btn-xs" value="修改">&nbsp;' +
                        '<input type="button" class="btn btn-info btn-xs" value="删除" onclick="deleQuality('+id+');"></td>\n' +
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
                    var longitude = obj.longitude;
                    var latitude = obj.latitude;
                    var section = obj.section;
                    var introduction = obj.introduction;

                    var itemStr='<tr class="info">\n' +
                        '                    <td style="text-align: center">'+id+'</td>\n' +
                        '                    <td style="text-align: center">'+stationName+'</td>\n' +
                        '                    <td style="text-align: center">\n' +
                        '                        <input onclick="viewWaterQualityInfo(\''+stationName+'\');" type="button" class="btn btn-info btn-xs" value="查看监测数据">&nbsp;&nbsp;&nbsp;&nbsp;\n' +
                        '                        <input onclick="intro('+id+');" type="button" class="btn btn-info btn-xs" value="查看简介">&nbsp;&nbsp;&nbsp;&nbsp;\n' +
                        '                        <input onclick="update('+id+',\''+stationName+'\','+longitude+','+latitude+',\''+section+'\',\''+introduction+'\')" type="button" class="btn btn-info btn-xs" value="修改">&nbsp;&nbsp;&nbsp;&nbsp;\n' +
                        '                        <input onclick="dele('+id+');" type="button" class="btn btn-info btn-xs" value="删除">\n' +
                        '                    </td>\n' +
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

        //更新按钮的回调函数
        function update(id,stationName,longitude,latitude,section,introduction)
        {
            var tableStr='<table class="table table-bordered table-hover" id="update_table">\n' +
                '                <caption style="text-align: center;font-size: 24px">修改测站信息</caption>\n' +
                '                <tr class="success">\n' +
                '                    <th style="text-align: center">id</th>\n' +
                '                    <th style="text-align: center">监测站名称</th>\n' +
                '                    <th style="text-align: center">经度</th>\n' +
                '                    <th style="text-align: center">纬度</th>\n' +
                '                    <th style="text-align: center">所属断面</th>\n' +
                '                    <th style="text-align: center">简介</th>\n' +
                '                    <th style="text-align: center">操作</th>\n' +
                '                </tr>\n' +
                '                <tr class="info">\n' +
                '                    <td style="text-align: center"><input id="stationId" type="text" readonly="readonly" value="'+id+'" style="width: 120px"></td>\n' +
                '                    <td style="text-align: center"><input id="StationName" type="text" value="'+stationName+'" placeholder="请输入测站名称" style="width: 120px"></td>\n' +
                '                    <td style="text-align: center"><input id="longitude" type="text" value="'+longitude+'" placeholder="请输入经度" style="width: 120px"></td>\n' +
                '                    <td style="text-align: center"><input id="latitude" type="text" value="'+latitude+'" placeholder="请输入纬度" style="width: 120px"></td>\n' +
                '                    <td style="text-align: center"><input id="Section" type="text" value="'+section+'" style="width: 120px" placeholder="请输入断面名称"></td>\n' +
                '                    <td style="text-align: center"><textarea id="jianjie" cols="20"  rows="5" placeholder="请输入简介">'+introduction+'</textarea></td>\n' +
                '                    <td style="text-align: center">\n' +
                '                        <input onclick="confirmUpdate('+id+');" type="button" class="btn btn-info btn-xs" value="确认修改">\n' +
                '                    </td>\n' +
                '                </tr>\n' +
                '            </table>';
            $("#update_div").html(tableStr);

        }

        function confirmUpdate(id) //确认更新按钮的回调函数
        {
            var id=$("#stationId").val();
            var stationName=$("#StationName").val();
            var longitude=$("#longitude").val();
            var latitude=$("#latitude").val();
            var section=$("#Section").val();
            var introduction=$("#jianjie").val();

            $.post("../UpdateStationInfoServlet",{id:id,stationName:stationName,longitude:longitude,latitude:latitude,section:section,introduction:introduction},function (data)
            {
                alert(data.msg);
                window.location.href="viewWaterQualityData.jsp";

            });

        }


        //删除按钮的回调函数
        function dele(id)
        {
            var b = window.confirm("您确定要删除吗？");
            if(b)
            {
                $.post("../DeleteStationServlet",{id:id},function (data)
                {
                    alert(data.msg);
                    window.location.href="viewWaterQualityData.jsp";

                });

            }
        }

        //更新水质信息按钮的回调函数
        function updateQuality(id,belongStation,ph,oxygen,nitrogen,permangan,orgacarbon,phquality,date,time)
        {
            var tableStr=' <table class="table table-bordered">\n' +
                '                <caption style="text-align: center;font-size: 24px">修改水质信息</caption>\n' +
                '                <tr class="success">\n' +
                '                    <th>所属测站</th>\n' +
                '                    <th>ph</th>\n' +
                '                    <th>溶解氧</th>\n' +
                '                    <th>氨氮</th>\n' +
                '                    <th>高锰酸钾指数</th>\n' +
                '                    <th>总有机碳</th>\n' +
                '                    <th>水质类别</th>\n' +
                '                    <th>日期</th>\n' +
                '                    <th>更新时间</th>\n' +
                '                    <th>操作</th>\n' +
                '                </tr>\n' +
                '                <tr class="info">\n' +
                '                    <td><input id="BelongStation" readonly="readonly" type="text" style="width: 150px" value="'+belongStation+'"></td>\n' +
                '                    <td><input id="PH" type="number" step="0.01" min="0" style="width: 50px" value="'+ph+'"></td>\n' +
                '                    <td><input id="Oxygen" type="number" step="0.01" min="0" style="width: 50px" value="'+oxygen+'"></td>\n' +
                '                    <td><input id="Nitrogen" type="number" step="0.01" min="0" style="width: 50px" value="'+nitrogen+'"></td>\n' +
                '                    <td><input id="Permangan" type="number" step="0.01" min="0" style="width: 50px" value="'+permangan+'"></td>\n' +
                '                    <td><input id="Orgacarbon" type="number" step="0.01" min="0" style="width: 50px" value="'+orgacarbon+'"></td>\n' +
                '                    <td><input id="PhQuality" type="text" style="width: 50px" value="'+phquality+'"></td>\n' +
                '                    <td><input id="Date" type="date" style="width: 145px" value="'+date+'"></td>\n' +
                '                    <td><input id="Time" type="time" style="width: 100px;width: 120px" step="1" value="'+time+'"></td>\n' +
                '                    <td><input type="button" class="btn btn-xs btn-info" value="确认修改" onclick="confirmUpdateQuality('+id+')"></td>\n' +
                '                </tr>\n' +
                '            </table>';
            $("#update_div").html(tableStr);

        }

        //确认更新水质信息的回调函数
        function confirmUpdateQuality(id)
        {
            var belongStation=$("#BelongStation").val();
            var ph=$("#PH").val();
            var oxygen=$("#Oxygen").val();
            var nitrogen=$("#Nitrogen").val();
            var permangan=$("#Permangan").val();
            var orgacarbon=$("#Orgacarbon").val();
            var phquality=$("#PhQuality").val();
            var date=$("#Date").val();
            var time=$("#Time").val();

            $.post("../UpdateWaterQualityInfoServlet",
                {id:id,belongStation:belongStation,ph:ph,oxygen:oxygen,nitrogen:nitrogen,
                    permangan:permangan,orgacarbon:orgacarbon,phquality:phquality,date:date,time:time},function (data)
                {
                    alert(data.msg);
                    window.location.href="viewWaterQualityData.jsp";

                });
        }

        function deleQuality(id) //删除水质信息按钮的回调函数
        {
            var b = window.confirm("您确定要删除吗？");
            if(b)
            {
                $.post("../DeleteWaterQualityInfoServlet",{id:id},function (data)
                {
                    alert(data.msg);
                    window.location.href="viewWaterQualityData.jsp";

                });

            }
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
                    <td style="text-align: center">
                        <input onclick="viewWaterQualityInfo(stationName);" type="button" class="btn btn-info btn-xs" value="查看监测数据">&nbsp;&nbsp;&nbsp;&nbsp;
                        <input onclick="intro(id);" type="button" class="btn btn-info btn-xs" value="查看简介">&nbsp;&nbsp;&nbsp;&nbsp;
                        <input onclick="update(id)" type="button" class="btn btn-info btn-xs" value="修改">&nbsp;&nbsp;&nbsp;&nbsp;
                        <input onclick="dele(id);" type="button" class="btn btn-info btn-xs" value="删除">
                    </td>
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
    <div class="row">
        <hr style="background-color: silver;border: none;height: 2px">

    </div>

    <div class="row">
        <div class="col-sm-8" id="update_div">
        </div>

    </div>

</div>
<script src="../js/customizeAlertDialog/customizeAlert.js"></script>
</body>
</html>
