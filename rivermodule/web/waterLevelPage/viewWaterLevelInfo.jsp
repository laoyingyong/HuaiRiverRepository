<%--
  Created by Yingyong Lao.
  User: laoyingyong
  Date: 2019-12-12
  Time: 18:49
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>查看水位信息</title>
    <script src="../js/jquery-3.2.1.min.js"></script>
    <!-- 1. 导入CSS的全局样式 -->
    <link href="../css/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="../js/bootstrap.min.js"></script>
    <script>

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


        $(function () //入口函数
        {
            $.post("../FindAllByPageServlet",{currentPage:1,pageSize:5},function (data)//页面加载完成后初始化界面
            {
                var totalCount = data.totalCount;
                var totalPage=data.totalPage;
                var currentPage = data.currentPage;
                var array = data.list;

                //上一页的图标
                if(currentPage==1)
                {
                    var str='<li class="disabled" onclick="findByPage('+(currentPage-1)+',5);">\n' +
                        '                        <a href="#" aria-label="Previous">\n' +
                        '                            <span aria-hidden="true">&laquo;</span>\n' +
                        '                        </a>\n' +
                        '                    </li>';

                }
                else
                {
                    var str='<li onclick="findByPage('+(currentPage-1)+',5);">\n' +
                        '                        <a href="#" aria-label="Previous">\n' +
                        '                            <span aria-hidden="true">&laquo;</span>\n' +
                        '                        </a>\n' +
                        '                    </li>';

                }

                for(var i=1;i<=totalPage;i++)//中间分页栏的部分
                {
                    if(i==currentPage)
                    {
                        var item=' <li class="active" onclick="findByPage('+i+',5);"><a href="#">'+i+'</a></li>';

                    }
                    else
                    {
                        var item=' <li onclick="findByPage('+i+',5);"><a href="#">'+i+'</a></li>';

                    }
                    str=str+item;
                }
                if(currentPage==totalPage)
                {
                    var endStr='<li class="disabled" onclick="findByPage('+(currentPage+1)+',5);">\n' +
                        '                        <a href="#" aria-label="Next">\n' +
                        '                            <span aria-hidden="true">&raquo;</span>\n' +
                        '                        </a>\n' +
                        '                    </li>\n' +
                        '                    <span style="font-size: 24px" id="total_sp">共'+totalCount+'条记录，共'+totalPage+'页</span>';
                }
                else
                {
                    var endStr='<li onclick="findByPage('+(currentPage+1)+',5);">\n' +
                        '                        <a href="#" aria-label="Next">\n' +
                        '                            <span aria-hidden="true">&raquo;</span>\n' +
                        '                        </a>\n' +
                        '                    </li>\n' +
                        '                    <span style="font-size: 24px" id="total_sp">共'+totalCount+'条记录，共'+totalPage+'页</span>';
                }

                str=str+endStr;
                $("#fenyelan").html(str);//初始化分页栏


                var tableStr='<caption style="text-align: center;font-size: 24px">水位信息一览表</caption>\n' +
                    '                <tr class="success">\n' +
                    '                    <th style="text-align: center">id</th>\n' +
                    '                    <th style="text-align: center">河流</th>\n' +
                    '                    <th style="text-align: center">站名</th>\n' +
                    '                    <th style="text-align: center">水位（m）</th>\n' +
                    '                    <th style="text-align: center">超过警戒线（m）</th>\n' +
                    '                    <th style="text-align: center">流量</th>\n' +
                    '                    <th style="text-align: center">日期</th>\n' +
                    '                     <th style="text-align: center">操作</th>\n'+
                    '                </tr>';


                for(var i=0;i<array.length;i++)
                {
                    var obj = array[i];
                    var id = obj.id;
                    var riverName = obj.riverName;
                    var siteName = obj.siteName;
                    var waterLevel = obj.waterLevel;
                    var over = obj.over;
                    var flow = obj.flow;
                    var collectionDate = obj.collectionDate;
                    var dateTime=dateFormat("yyyy-MM-dd HH:mm",new Date(collectionDate));

                    var tableItem=' <tr class="info">\n' +
                        '                    <td style="text-align: center">'+id+'</td>\n' +
                        '                    <td style="text-align: center">'+riverName+'</td>\n' +
                        '                    <td style="text-align: center">'+siteName+'</td>\n' +
                        '                    <td style="text-align: center">'+waterLevel+'</td>\n' +
                        '                    <td style="text-align: center">'+over+'</td>\n' +
                        '                    <td style="text-align: center">'+flow+'</td>\n' +
                        '                    <td style="text-align: center">'+dateTime+'</td>\n' +
                        '<td style="text-align: center"><input type="button" onclick="update('+id+',\''+name+'\',\''+waterLevel+'\',\''+over+'\',\''+status+'\',\''+collectionDate+'\');" value="修改" class="btn btn-info">&nbsp;&nbsp;&nbsp;&nbsp;<input onclick="dele('+id+');" type="button" value="删除" class="btn btn-info"></td>\n'+
                        '                </tr>';

                    tableStr=tableStr+tableItem;

                }
                $("#waterLevelTable").html(tableStr);

            });

        });//入口函数end


        function findByPage(cuentPage,paSize)//页面按钮被点击时的回调函数
        {
            $.post("../FindAllByPageServlet",{currentPage:cuentPage,pageSize:paSize},function (data)//页面加载完成后初始化界面
            {
                var totalCount = data.totalCount;
                var totalPage=data.totalPage;
                var currentPage = data.currentPage;
                var array = data.list;

                //上一页的图标
                if(currentPage==1)
                {
                    var str='<li class="disabled" onclick="findByPage('+(currentPage-1)+',5);">\n' +
                        '                        <a href="#" aria-label="Previous">\n' +
                        '                            <span aria-hidden="true">&laquo;</span>\n' +
                        '                        </a>\n' +
                        '                    </li>';

                }
                else
                {
                    var str='<li onclick="findByPage('+(currentPage-1)+',5);">\n' +
                        '                        <a href="#" aria-label="Previous">\n' +
                        '                            <span aria-hidden="true">&laquo;</span>\n' +
                        '                        </a>\n' +
                        '                    </li>';

                }
                for(var i=1;i<=totalPage;i++)
                {
                    if(i==currentPage)
                    {
                        var item=' <li class="active" onclick="findByPage('+i+',5);"><a href="#">'+i+'</a></li>';

                    }
                    else
                    {
                        var item=' <li onclick="findByPage('+i+',5);"><a href="#">'+i+'</a></li>';

                    }

                    str=str+item;
                }
                if(currentPage==totalPage)
                {
                    var endStr='<li class="disabled" onclick="findByPage('+(currentPage+1)+',5);">\n' +
                        '                        <a href="#" aria-label="Next">\n' +
                        '                            <span aria-hidden="true">&raquo;</span>\n' +
                        '                        </a>\n' +
                        '                    </li>\n' +
                        '                    <span style="font-size: 24px" id="total_sp">共'+totalCount+'条记录，共'+totalPage+'页</span>';
                }
                else
                {
                    var endStr='<li onclick="findByPage('+(currentPage+1)+',5);">\n' +
                        '                        <a href="#" aria-label="Next">\n' +
                        '                            <span aria-hidden="true">&raquo;</span>\n' +
                        '                        </a>\n' +
                        '                    </li>\n' +
                        '                    <span style="font-size: 24px" id="total_sp">共'+totalCount+'条记录，共'+totalPage+'页</span>';
                }
                str=str+endStr;
                $("#fenyelan").html(str);//初始化分页栏


                var tableStr='<caption style="text-align: center;font-size: 24px">水位信息一览表</caption>\n' +
                    '                <tr class="success">\n' +
                    '                    <th style="text-align: center">id</th>\n' +
                    '                    <th style="text-align: center">河流</th>\n' +
                    '                    <th style="text-align: center">站名</th>\n' +
                    '                    <th style="text-align: center">水位（m）</th>\n' +
                    '                    <th style="text-align: center">超过警戒线（m）</th>\n' +
                    '                    <th style="text-align: center">流量</th>\n' +
                    '                    <th style="text-align: center">日期</th>\n' +
                    '                     <th style="text-align: center">操作</th>\n'+
                    '                </tr>';


                for(var i=0;i<array.length;i++)
                {
                    var obj = array[i];
                    var id = obj.id;
                    var riverName = obj.riverName;
                    var siteName=obj.siteName;
                    var waterLevel = obj.waterLevel;
                    var over = obj.over;
                    var flow = obj.flow;
                    var collectionDate = obj.collectionDate;
                    var dateTime=dateFormat("yyyy-MM-dd HH:mm",new Date(collectionDate));

                    var tableItem=' <tr class="info">\n' +
                        '                    <td style="text-align: center">'+id+'</td>\n' +
                        '                    <td style="text-align: center">'+riverName+'</td>\n' +
                        '                    <td style="text-align: center">'+siteName+'</td>\n' +
                        '                    <td style="text-align: center">'+waterLevel+'</td>\n' +
                        '                    <td style="text-align: center">'+over+'</td>\n' +
                        '                    <td style="text-align: center">'+flow+'</td>\n' +
                        '                    <td style="text-align: center">'+dateTime+'</td>\n' +
                        '<td style="text-align: center"><input type="button" onclick="update('+id+',\''+name+'\',\''+waterLevel+'\',\''+over+'\',\''+status+'\',\''+collectionDate+'\');" value="修改" class="btn btn-info">&nbsp;&nbsp;&nbsp;&nbsp;<input onclick="dele('+id+');" type="button" value="删除" class="btn btn-info"></td>\n'+
                        '                </tr>';

                    tableStr=tableStr+tableItem;

                }
                $("#waterLevelTable").html(tableStr);

            });

        }//回调函数的结尾

        //更新按钮的回调函数
        function update(id,name,waterLevel,over,status,collectionDate)
        {
            var str=' <form id="confirmUpdateForm">\n' +
                '            <table class="table table-bordered table-hover">\n' +
                '                <caption style="text-align: center;font-size: 24px">修改数据</caption>\n' +
                '                <tr class="success">\n' +
                '                    <th style="text-align: center">id</th>\n' +
                '                    <th style="text-align: center">地点名称</th>\n' +
                '                    <th style="text-align: center">水位（m）</th>\n' +
                '                    <th style="text-align: center">超过警戒线（m）</th>\n' +
                '                    <th style="text-align: center">状态（OK/NO）</th>\n' +
                '                    <th style="text-align: center">采集日期</th>\n' +
                '                    <th style="text-align: center">操作</th>\n' +
                '                </tr>\n' +
                '                <tr class="info">\n' +
                '                    <td style="text-align: center"><input id="id" name="id" style="width:120px" readonly value="'+id+'"></td>\n' +
                '                    <td style="text-align: center"><input value="'+name+'" id="name" name" placeholder="王家坝控制站" style="width:120px"></td>\n' +
                '                    <td style="text-align: center"><input value="'+waterLevel+'" id="shuiwei" type="number" step="0.01" name="shuiwei" placeholder="21.43" style="width:120px" ></td>\n' +
                '                    <td style="text-align: center"><input value="'+over+'" id="chaoguo" type="number" step="0.01" name="chaoguo" placeholder="0" style="width:120px"></td>\n' +
                '                    <td style="text-align: center"><input value="'+status+'" id="zhuangtai" name="zhuangtai" placeholder="OK" style="width:120px"></td>\n' +
                '                    <td style="text-align: center"><input value="'+collectionDate+'" id="caijiriqi" name="caijiriqi" type="date"></td>\n' +
                '                    <td style="text-align: center"><input type="button" onclick="updateInfo()" value="确认修改" class="btn btn-info"></td>\n' +
                '                </tr>\n' +
                '            </table>\n' +
                '            </form>';
           $("#confirmUpdate_div").html(str);

        } //更新按钮的回调函数end


        function updateInfo()//确认修改按钮的回调函数
        {
            var id=$("#id").val();
            var name=$("#name").val();
            var shuiwei=$("#shuiwei").val();
            var chaoguo=$("#chaoguo").val();
            var zhuangtai=$("#zhuangtai").val();
            var caijiriqi=$("#caijiriqi").val();
            $.get("../UpdateWaterLevelData",{id:id,name:name,shuiwei:shuiwei,chaoguo:chaoguo,zhuangtai:zhuangtai,caijiriqi:caijiriqi} ,function (data)
            {
                alert(data.msg);
                window.location.href="viewWaterLevelInfo.jsp";

            });
        }

        //删除按钮的回调函数
        function dele(id)
        {
            var b = confirm("您确定要删除吗？");
            if(b)
            {
                $.post("../DeleteInfoServlet",{id:id},function (data)
                {
                    alert(data.msg);

                });

            }

        }

        //条件查询按钮的回调函数
        function searchByCondition()
        {
            var name=$("#name2").val();
            var status=$("#status2").val();
            $.post("../ConditionQueryByPageServlet",{name:name,status:status,currentPage2:1,pageSize2:5},function (data)
            {
                //alert(data);
                var totalCount = data.totalCount;
                if(totalCount==0)
                {
                    alert("数据库中没有记录！");
                }
                var totalPage = data.totalPage;
                var currentPage = data.currentPage;
                var array = data.list;

                var tableStr=' <caption style="text-align: center;font-size: 24px">查询结果</caption>\n' +
                    '                <tr class="success">\n' +
                    '                    <th style="text-align: center">id</th>\n' +
                    '                    <th style="text-align: center">地点名称</th>\n' +
                    '                    <th style="text-align: center">水位（m）</th>\n' +
                    '                    <th style="text-align: center">超过警戒线（m）</th>\n' +
                    '                    <th style="text-align: center">状态（OK/NO）</th>\n' +
                    '                    <th style="text-align: center">采集日期</th>\n' +
                    '                    <th style="text-align: center">操作</th>\n' +
                    '                </tr>';

                for(var i=0;i<array.length;i++)
                {
                    var obj = array[i];
                    var id = obj.id;
                    var name = obj.name;
                    var waterLevel = obj.waterLevel;
                    var over = obj.over;
                    var status= obj.status;
                    var collectionDate = obj.collectionDate;obj

                    var item=' <tr class="info">\n' +
                        '                    <td style="text-align: center">'+id+'</td>\n' +
                        '                    <td style="text-align: center">'+name+'</td>\n' +
                        '                    <td style="text-align: center">'+waterLevel+'</td>\n' +
                        '                    <td style="text-align: center">'+over+'</td>\n' +
                        '                    <td style="text-align: center">'+status+'</td>\n' +
                        '                    <td style="text-align: center">'+collectionDate+'</td>\n' +
                        '<td style="text-align: center"><input type="button" onclick="update('+id+',\''+name+'\',\''+waterLevel+'\',\''+over+'\',\''+status+'\',\''+collectionDate+'\');" value="修改" class="btn btn-info">&nbsp;&nbsp;&nbsp;&nbsp;<input onclick="dele('+id+');" type="button" value="删除" class="btn btn-info"></td>\n'+
                        '                </tr>';

                    tableStr+=item;
                }

                var endStr='  </table>';
                tableStr+=endStr;
                $("#waterLevelTable").html(tableStr);


                var fenyelanStr=' <span style="font-size: 24px" id="total_sp">共'+totalCount+'条记录</span>&nbsp;&nbsp;<input class="btn btn-info" value="返回一览表" type="button" onclick="fuwei();">';
                $("#fenyelan").html(fenyelanStr);



            });//异步请求

        }

        function fuwei()
        {
            window.location.href='viewWaterLevelInfo.jsp';

        }
    </script>
</head>
<body style="background: url('../img/img01.jpg') repeat-x">
<div class="container">
    <div class="row">
        <div class="col-sm-8"  style="margin-top: 20px">

                <form class="form-inline">
                    <div class="form-group">
                        <label class="sr-only" for="name2">Email address</label>
                        <input type="text" class="form-control" id="name2" name="name2" placeholder="河流">
                    </div>
                    <div class="form-group">
                        <label class="sr-only" for="status2">Password</label>
                        <input type="text" class="form-control" id="status2" name="status2" placeholder="站名">
                    </div>
                    <div class="form-group">
                        <label class="sr-only" for="collectionDate">Password</label>
                        <input type="datetime-local" class="form-control" id="collectionDate" name="status2" placeholder="时间">
                    </div>
                    <button type="button" onclick="searchByCondition();" class="btn btn-warning">搜索</button>
                </form>
         </div>

    </div><%--row end--%>
    <div class="row">

        <div class="col-sm-10" id="waterLevelTableDiv">

            <table class="table table-bordered table-hover" id="waterLevelTable">
                <caption style="text-align: center;font-size: 24px">水位信息一览表</caption>
                <tr class="success">
                    <th style="text-align: center">id</th>
                    <th style="text-align: center">地点名称</th>
                    <th style="text-align: center">水位（m）</th>
                    <th style="text-align: center">超过警戒线（m）</th>
                    <th style="text-align: center">状态</th>
                    <th style="text-align: center">采集日期</th>
                    <th style="text-align: center">操作</th>
                </tr>
                <tr class="info">
                    <td style="text-align: center">id</td>
                    <td style="text-align: center">地点名称</td>
                    <td style="text-align: center">水位（m）</td>
                    <td style="text-align: center">超过警戒线（m）</td>
                    <td style="text-align: center">状态（OK/NO）</td>
                    <td style="text-align: center">采集日期</td>
                    <td style="text-align: center"><input type="button" onclick="update(1);" value="修改" class="btn btn-info">&nbsp;&nbsp;&nbsp;&nbsp;<input onclick="dele(1);" type="button" value="删除" class="btn btn-info"></td>
                </tr>
            </table>

            <nav aria-label="Page navigation">
                <ul class="pagination" id="fenyelan">
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
                    <span style="font-size: 24px" id="total_sp">共2条记录，共1页</span>
                </ul>
            </nav>

        </div>

    </div>

    <div class="row">
        <hr style="background-color: silver;border: none;height: 2px">

    </div>

    <div class="row">
        <div class="col-sm-10" id="confirmUpdate_div">
        </div>

    </div>

</div>

</body>
</html>
