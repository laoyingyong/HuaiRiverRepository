<%--
  Created by Yingyong Lao.
  User: laoyingyong
  Date: 2019-12-10
  Time: 19:28
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>查看降雨信息</title>
    <!-- 1. 导入CSS的全局样式 -->
    <link href="../css/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- 2. jQuery导入，建议使用1.9以上的版本 -->
    <script src="../js/jquery-2.1.0.min.js"></script>
    <!-- 3. 导入bootstrap的js文件 -->
    <script src="../js/bootstrap.min.js"></script>
    <script>
        $(function () //入口函数
        {
            $.post("../ViewRainByPageServlet",{currentPage:1,pageSize:5},function (data)//页面加载完成之后发送ajax请求，请求前5条记录,完成界面的初始化
            {
               var totalCount=data.totalCount;//总记录数
               var totalPage=data.totalPage;//总页数
               var currentPage=data.currentPage;//当前页码

                if(currentPage==1)//如果当前页码为1，用户还点击上一页的话，设置class="disabled" ，即出现一个“禁用”图标
                {
                    var str=' <li class="disabled" onclick="findByPage('+(currentPage-1)+',5)">\n' +
                        '                    <a href="#" aria-label="Previous">\n' +
                        '                        <span aria-hidden="true">&laquo;</span>\n' +
                        '                    </a>\n' +
                        '                </li>';

                }
                else//否则上一页的按钮就是正常的样式
                {
                    var str=' <li onclick="findByPage('+(currentPage-1)+',5)">\n' +
                        '                    <a href="#" aria-label="Previous">\n' +
                        '                        <span aria-hidden="true">&laquo;</span>\n' +
                        '                    </a>\n' +
                        '                </li>';

                }

                for(var i=1;i<=totalPage;i++)//遍历页码，这是两个图标（上一页和下一页）之间的数字
                {
                    if(i==currentPage)//如果当前的这个数字等于当前页码currentPage，就设置class="active"，即页码呈高亮样式
                    {
                        var item='<li onclick="findByPage('+i+',5);" class="active"><a href="#">'+i+'</a></li>';
                    }
                    else
                    {
                        var item='<li onclick="findByPage('+i+',5);"><a href="#">'+i+'</a></li>';
                    }
                    str=str+item;

                }
                if(currentPage==totalPage)//如果当前页码为最后一页，用户还点击下一页的话，设置class="disabled" ，即出现一个“禁用”图标
                {
                    var strend='<li class="disabled" onclick="findByPage('+(currentPage+1)+',5)">\n' +
                        '                    <a href="#" aria-label="Next">\n' +
                        '                        <span aria-hidden="true">&raquo;</span>\n' +
                        '                    </a>\n' +
                        '                </li>\n' +
                        '                <span style="font-size: 24px" id="total_sp">共'+totalCount+'条记录，共'+totalPage+'页</span>';

                }
                else //不是最后一页，就是正常的样式
                {
                    var strend='<li onclick="findByPage('+(currentPage+1)+',5)">\n' +
                        '                    <a href="#" aria-label="Next">\n' +
                        '                        <span aria-hidden="true">&raquo;</span>\n' +
                        '                    </a>\n' +
                        '                </li>\n' +
                        '                <span style="font-size: 24px" id="total_sp">共'+totalCount+'条记录，共'+totalPage+'页</span>';

                }

                str=str+strend;
                $("#fenyelan").html(str);//分页条初始化

                var array=data.list;
                for(var i=0;i<array.length;i++)
                {
                    var obj=array[i];
                    var id=obj.id;
                    var area=obj.area;
                    var precipitation=obj.precipitation;
                    var month=obj.month;
                    var releaseDate=obj.releaseDate;
                    //表格的初始化
                    $("#rain_table").append('<tr class="info">\n' +
                        '                <td style="text-align: center">'+id+'</td>\n' +
                        '                <td style="text-align: center">'+area+'</td>\n' +
                        '                <td style="text-align: center">'+precipitation+'</td>\n' +
                        '                <td style="text-align: center">'+month+'</td>\n' +
                        '                <td style="text-align: center">'+releaseDate+'</td>\n' +
                        '                <td style="text-align: center"><input type="button" onclick="update('+id+',\''+area+'\','+precipitation+','+month+',\''+releaseDate+'\');" value="修改" class="btn btn-info">&nbsp;&nbsp;&nbsp;&nbsp;<input onclick="dele('+id+');" type="button" value="删除" class="btn btn-info"></td>\n' +
                        '            </tr>');
                }

            });//页面加载完成之后发送ajax请求end

        });//入口函数end



        //页面按钮的点击回调函数，不需要写在入口函数里面，因为只有页面按钮被点击时，这个函数才会被调用
        function findByPage(curPage,paSize) //被调用的时候，需要传递两个参数：当前页码和页码的大小（一页有几条记录）
        {
            $.post("../ViewRainByPageServlet",{currentPage:curPage,pageSize:paSize},function (data) //发送ajax请求
            {
                var totalCount=data.totalCount;//总记录数
                var totalPage=data.totalPage;//总页数
                var currentPage=data.currentPage;//当前页码


                if(currentPage==1)//如果当前页码为1，用户还点击上一页的话，设置class="disabled" ，即出现一个“禁用”图标
                {
                    var str=' <li class="disabled" onclick="findByPage('+(currentPage-1)+',5)">\n' +
                        '                    <a href="#" aria-label="Previous">\n' +
                        '                        <span aria-hidden="true">&laquo;</span>\n' +
                        '                    </a>\n' +
                        '                </li>';

                }
                else//不为第一页，上一页按钮就是正常的样式
                {
                    var str=' <li onclick="findByPage('+(currentPage-1)+',5)">\n' +
                        '                    <a href="#" aria-label="Previous">\n' +
                        '                        <span aria-hidden="true">&laquo;</span>\n' +
                        '                    </a>\n' +
                        '                </li>';

                }


                //分页条中间数字部分
                for(var i=1;i<=totalPage;i++)
                {
                    if(i==currentPage)//如果当前的这个数字等于当前页码currentPage，就设置class="active"，即页码呈高亮样式
                    {

                        var item='<li onclick="findByPage('+i+',5);" class="active"><a href="#">'+i+'</a></li>';
                    }
                    else
                    {
                        var item='<li onclick="findByPage('+i+',5);"><a href="#">'+i+'</a></li>';
                    }


                    str=str+item;

                }
                if(currentPage==totalPage)//如果当前页码为最后一页，用户还点击下一页的话，设置class="disabled" ，即出现一个“禁用”图标
                {
                    var strend='<li class="disabled" onclick="findByPage('+(currentPage+1)+',5)">\n' +
                        '                    <a href="#" aria-label="Next">\n' +
                        '                        <span aria-hidden="true">&raquo;</span>\n' +
                        '                    </a>\n' +
                        '                </li>\n' +
                        '                <span style="font-size: 24px" id="total_sp">共'+totalCount+'条记录，共'+totalPage+'页</span>';

                }
                else //不是最后一页，就是正常的样式
                {
                    var strend='<li onclick="findByPage('+(currentPage+1)+',5)">\n' +
                        '                    <a href="#" aria-label="Next">\n' +
                        '                        <span aria-hidden="true">&raquo;</span>\n' +
                        '                    </a>\n' +
                        '                </li>\n' +
                        '                <span style="font-size: 24px" id="total_sp">共'+totalCount+'条记录，共'+totalPage+'页</span>';

                }
                str=str+strend;
                $("#fenyelan").html(str);//改变分页条的内容

                //表格的字符串
                var tableStr='<caption style="text-align: center;font-size: 24px">降雨信息一览</caption>\n' +
                    '            <tr class="success">\n' +
                    '                <th style="text-align: center">id</th>\n' +
                    '                <th style="text-align: center">地区</th>\n' +
                    '                <th style="text-align: center">降雨量（mm）</th>\n' +
                    '                <th style="text-align: center">月份</th>\n' +
                    '                <th style="text-align: center">发布日期</th>\n' +
                    '                <th style="text-align: center">操作</th>\n' +
                    '            </tr>';
                var array=data.list;//具体内容的对象数组
                for(var i=0;i<array.length;i++)//遍历数对象组
                {
                    var obj=array[i];//数组的一个元素就是一个对象
                    var id=obj.id;
                    var area=obj.area;
                    var precipitation=obj.precipitation;
                    var month=obj.month;
                    var releaseDate=obj.releaseDate;
                    //一行记录的字符串
                    var oneRecord='<tr class="info">\n' +
                        '                <td style="text-align: center">'+id+'</td>\n' +
                        '                <td style="text-align: center">'+area+'</td>\n' +
                        '                <td style="text-align: center">'+precipitation+'</td>\n' +
                        '                <td style="text-align: center">'+month+'</td>\n' +
                        '                <td style="text-align: center">'+releaseDate+'</td>\n' +
                        '                <td style="text-align: center"><input type="button" onclick="update('+id+',\''+area+'\','+precipitation+','+month+',\''+releaseDate+'\');" value="修改" class="btn btn-info">&nbsp;&nbsp;&nbsp;&nbsp;<input onclick="dele('+id+');" type="button" value="删除" class="btn btn-info"></td>\n' +
                        '            </tr>';

                    tableStr=tableStr+oneRecord;//表格字符串的追加，每遍历一条记录，就会追加一行
                }
                $("#rain_table").html(tableStr);//改变表格里面的内容

            });//ajax请求end

        }//页面按钮的点击函数end


        var diqu;
        var yuefen;
        $(function ()
        {
            $("#area_select").change(function ()
            {
                diqu = $("#area_select").val();
            });
            $("#month_select").change(function ()
            {
                yuefen=$("#month_select").val();
            });

        });

        //筛选按钮的回调函数
        function searchByCondition()
        {
            $.post("../ConditionalQueryRainByPageServlet",{area:diqu,month:yuefen,currentPage:1,pageSize:50},function (data)
            {
                var totalCount = data.totalCount;
                if(totalCount==0)
                {
                    alert("数据库中没有记录！");
                }
                var currentPage = data.currentPage;
                var totalPage = data.totalPage;
                var array = data.list;



                var rain_table_Str=' <caption style="text-align: center;font-size: 24px">查询结果</caption>\n' +
                    '            <tr class="success">\n' +
                    '                <th style="text-align: center">id</th>\n' +
                    '                <th style="text-align: center">地区</th>\n' +
                    '                <th style="text-align: center">降雨量（mm）</th>\n' +
                    '                <th style="text-align: center">月份</th>\n' +
                    '                <th style="text-align: center">发布日期</th>\n' +
                    '                 <th style="text-align: center">操作</th>\n' +
                    '            </tr>';
                for(var i=0;i<array.length;i++)//遍历数组，从0开始
                {
                    var obj = array[i];
                    var id = obj.id;
                    var area = obj.area;
                    var precipitation = obj.precipitation;
                    var month = obj.month;
                    var releaseDate = obj.releaseDate;

                    var itemStr=' <tr class="info">\n' +
                        '                <td style="text-align: center">'+id+'</td>\n' +
                        '                <td style="text-align: center">'+area+'</td>\n' +
                        '                <td style="text-align: center">'+precipitation+'</td>\n' +
                        '                <td style="text-align: center">'+month+'</td>\n' +
                        '                <td style="text-align: center">'+releaseDate+'</td>\n' +
                        '                <td style="text-align: center"><input type="button" onclick="update('+id+',\''+area+'\','+precipitation+','+month+',\''+releaseDate+'\');" value="修改" class="btn btn-info">&nbsp;&nbsp;&nbsp;&nbsp;<input onclick="dele('+id+');" type="button" value="删除" class="btn btn-info"></td>\n' +
                        '            </tr>';
                    rain_table_Str+=itemStr;

                }

                var endStr=' </table>';
                rain_table_Str+=endStr;
                $("#rain_table").html(rain_table_Str);


                var fenyelanStr=' <span style="font-size: 24px" id="total_sp">共'+totalCount+'条记录</span>&nbsp;&nbsp;<input class="btn btn-info" value="返回一览表" type="button" onclick="fuwei();">';
                $("#fenyelan").html(fenyelanStr);

            });
        }

        //返回一览表的回调函数
        function fuwei()
        {
            window.location.href='viewRainInfo.jsp';

        }

        //更新按钮的回调函数
        function update(id,area,precipitation,month,releaseDate)
        {
            if(area==="淮河流域")
            {
                var divStr='<table class="table table-bordered table-hover" id="xiugai_table">\n' +
                    '            <caption style="text-align: center;font-size: 24px">修改信息</caption>\n' +
                    '                <tr class="success">\n' +
                    '                    <th style="text-align: center">id</th>\n' +
                    '                    <th style="text-align: center">地区</th>\n' +
                    '                    <th style="text-align: center">降雨量</th>\n' +
                    '                    <th style="text-align: center">月份</th>\n' +
                    '                    <th style="text-align: center">发布日期</th>\n' +
                    '                    <th style="text-align: center">操作</th>\n' +
                    '                </tr>\n' +
                    '                <tr class="info">\n' +
                    '                    <td style="text-align: center"><input type="text" readonly style="width: 120px" value="'+id+'"></td>\n' +
                    '                    <td style="text-align: center"><select id="diqu2" onchange="getValue();"><option>--请选择--</option><option value="淮河流域" selected>淮河流域</option><option value="淮河水系">淮河水系</option><option value="沂沭泗水系">沂沭泗水系</option></select></td>\n' +
                    '                    <td style="text-align: center"><input value="'+precipitation+'" type="number" step="0.01" min="0" id="precipitation2" name="precipitation" placeholder="48.70" style="width: 120px"></td>\n' +
                    '                    <td style="text-align: center"><input value="'+month+'" type="number" step="1" min="1" max="12" id="MyMonth" placeholder="1~12" style="width: 120px"></td>\n' +
                    '                    <td style="text-align: center"><input value="'+releaseDate+'" id="releaseDate2" type="date" name="releaseDate" style="width: 145px"></td>\n' +
                    '                    <td style="text-align: center"><input type="button" onclick="confirmUpdate('+id+');" value="确认修改" class="btn btn-info"></td>\n' +
                    '                </tr>\n' +
                    '            </table>';

            }
            else if(area==="淮河水系")
            {
                var divStr='<table class="table table-bordered table-hover" id="xiugai_table">\n' +
                    '            <caption style="text-align: center;font-size: 24px">修改信息</caption>\n' +
                    '                <tr class="success">\n' +
                    '                    <th style="text-align: center">id</th>\n' +
                    '                    <th style="text-align: center">地区</th>\n' +
                    '                    <th style="text-align: center">降雨量</th>\n' +
                    '                    <th style="text-align: center">月份</th>\n' +
                    '                    <th style="text-align: center">发布日期</th>\n' +
                    '                    <th style="text-align: center">操作</th>\n' +
                    '                </tr>\n' +
                    '                <tr class="info">\n' +
                    '                    <td style="text-align: center"><input type="text" readonly style="width: 120px" value="'+id+'"></td>\n' +
                    '                    <td style="text-align: center"><select id="diqu2" onchange="getValue();"><option>--请选择--</option><option value="淮河流域">淮河流域</option><option value="淮河水系" selected>淮河水系</option><option value="沂沭泗水系">沂沭泗水系</option></select></td>\n' +
                    '                    <td style="text-align: center"><input value="'+precipitation+'" type="number" step="0.01" min="0" id="precipitation2" name="precipitation" placeholder="48.70" style="width: 120px"></td>\n' +
                    '                    <td style="text-align: center"><input value="'+month+'" type="number" step="1" min="1" max="12" id="MyMonth" placeholder="1~12" style="width: 120px"></td>\n' +
                    '                    <td style="text-align: center"><input value="'+releaseDate+'" id="releaseDate2" type="date" name="releaseDate" style="width: 145px"></td>\n' +
                    '                    <td style="text-align: center"><input type="button" onclick="confirmUpdate('+id+');" value="确认修改" class="btn btn-info"></td>\n' +
                    '                </tr>\n' +
                    '            </table>';

            }
            else if(area==="沂沭泗水系")
            {
                var divStr='<table class="table table-bordered table-hover" id="xiugai_table">\n' +
                    '            <caption style="text-align: center;font-size: 24px">修改信息</caption>\n' +
                    '                <tr class="success">\n' +
                    '                    <th style="text-align: center">id</th>\n' +
                    '                    <th style="text-align: center">地区</th>\n' +
                    '                    <th style="text-align: center">降雨量</th>\n' +
                    '                    <th style="text-align: center">月份</th>\n' +
                    '                    <th style="text-align: center">发布日期</th>\n' +
                    '                    <th style="text-align: center">操作</th>\n' +
                    '                </tr>\n' +
                    '                <tr class="info">\n' +
                    '                    <td style="text-align: center"><input type="text" readonly style="width: 120px" value="'+id+'"></td>\n' +
                    '                    <td style="text-align: center"><select id="diqu2" onchange="getValue();"><option>--请选择--</option><option value="淮河流域">淮河流域</option><option value="淮河水系">淮河水系</option><option value="沂沭泗水系" selected>沂沭泗水系</option></select></td>\n' +
                    '                    <td style="text-align: center"><input value="'+precipitation+'" type="number" step="0.01" min="0" id="precipitation2" name="precipitation" placeholder="48.70" style="width: 120px"></td>\n' +
                    '                    <td style="text-align: center"><input value="'+month+'" type="number" step="1" min="1" max="12" id="MyMonth" placeholder="1~12" style="width: 120px"></td>\n' +
                    '                    <td style="text-align: center"><input value="'+releaseDate+'" id="releaseDate2" type="date" name="releaseDate" style="width: 145px"></td>\n' +
                    '                    <td style="text-align: center"><input type="button" onclick="confirmUpdate('+id+');" value="确认修改" class="btn btn-info"></td>\n' +
                    '                </tr>\n' +
                    '            </table>';

            }

            else
            {
                var divStr='<table class="table table-bordered table-hover" id="xiugai_table">\n' +
                    '            <caption style="text-align: center;font-size: 24px">修改信息</caption>\n' +
                    '                <tr class="success">\n' +
                    '                    <th style="text-align: center">id</th>\n' +
                    '                    <th style="text-align: center">地区</th>\n' +
                    '                    <th style="text-align: center">降雨量</th>\n' +
                    '                    <th style="text-align: center">月份</th>\n' +
                    '                    <th style="text-align: center">发布日期</th>\n' +
                    '                    <th style="text-align: center">操作</th>\n' +
                    '                </tr>\n' +
                    '                <tr class="info">\n' +
                    '                    <td style="text-align: center"><input type="text" readonly style="width: 120px" value="'+id+'"></td>\n' +
                    '                    <td style="text-align: center"><select id="diqu2" onchange="getValue();"><option>--请选择--</option><option value="淮河流域">淮河流域</option><option value="淮河水系">淮河水系</option><option value="沂沭泗水系">沂沭泗水系</option></select></td>\n' +
                    '                    <td style="text-align: center"><input value="'+precipitation+'" type="number" step="0.01" min="0" id="precipitation2" name="precipitation" placeholder="48.70" style="width: 120px"></td>\n' +
                    '                    <td style="text-align: center"><input value="'+month+'" type="number" step="1" min="1" max="12" id="MyMonth" placeholder="1~12" style="width: 120px"></td>\n' +
                    '                    <td style="text-align: center"><input value="'+releaseDate+'" id="releaseDate2" type="date" name="releaseDate" style="width: 145px"></td>\n' +
                    '                    <td style="text-align: center"><input type="button" onclick="confirmUpdate('+id+');" value="确认修改" class="btn btn-info"></td>\n' +
                    '                </tr>\n' +
                    '            </table>';

            }


            $("#xiugai_div").html(divStr);

        }



        function getValue()
        {
            var area=$("#diqu2").val();
            return area;
        }

        //确认修改的回调函数
        function confirmUpdate(id)
        {
            var area=getValue();
            var month=$("#MyMonth").val();
            var precipitation=$("#precipitation2").val();
            var releaseDate=$("#releaseDate2").val();
            $.post("../UpdateRainFallInfoServlet",{id:id,area:area,precipitation:precipitation,month:month,releaseDate:releaseDate},function (data)
            {
                alert(data.msg);
                window.location.href='viewRainInfo.jsp';

            });

        }


        //删除按钮的回调函数
        function dele(id)
        {
            $.post("../DeleteRainFallInfoServlet",{id:id},function (data)
            {
                alert(data.msg);
                window.location.href="viewRainInfo.jsp";

            });

        }
    </script>
</head>
<body style="background: url('../img/img01.jpg') repeat-x">
<div class="container">
    <div class="row">
        <div class="col-sm-6 col-sm-offset-8" style="margin-top: 20px">

            <form class="form-inline">
                <div class="form-group">地区：</div>
                <div class="form-group">
                    <select id="area_select"><option>--请选择--</option><option value="淮河流域">淮河流域</option><option value="淮河水系">淮河水系</option><option value="沂沭泗水系">沂沭泗水系</option></select>

                </div>
                <div class="form-group">月份：</div>
                <div class="form-group">
                    <select id="month_select">
                        <option>--请选择--</option>
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
                    </select>

                </div>
                <button type="button" onclick="searchByCondition();" class="btn btn-warning">开始筛选</button>
            </form>

        </div>
    </div>
    <div class="row">

        <table class="table table-bordered table-hover" id="rain_table">
            <caption style="text-align: center;font-size: 24px">降雨信息一览</caption>
            <tr class="success">
                <th style="text-align: center">id</th>
                <th style="text-align: center">地区</th>
                <th style="text-align: center">降雨量（mm）</th>
                <th style="text-align: center">月份</th>
                <th style="text-align: center">发布日期</th>
                <th style="text-align: center">操作</th>
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


    </div><%-->row的结尾--%>
    <div class="row">
        <hr style="border: none;height: 2px;background-color: silver"/>

    </div>
    <div class="row">
        <div class="col-sm-12" id="xiugai_div">
        </div>

    </div>

</div>
</body>
</html>
