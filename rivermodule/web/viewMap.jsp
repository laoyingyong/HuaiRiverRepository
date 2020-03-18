<%--
  Created by Yingyong Lao.
  User: laoyingyong
  Date: 2019-12-10
  Time: 14:04
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>地图浏览</title>
    <script src="js/jquery-1.11.2.min.js"></script>
    <!-- 1. 导入CSS的全局样式 -->
    <script src="js/bootstrap.min.js"></script>
    <script src="js/ol-debug.js"></script>
    <script src="js/GoogleMapSource.js"></script>
    <script src="js/GoogleMapLayer.js"></script>
    <script src="js/jquery-ui.js"></script>
    <script src="js/echarts.min.js"></script>
    <script type="text/javascript" src="js/bootstrap-select.js"></script>
    <link href="css/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/ol.css" rel="stylesheet">
    <link rel="stylesheet" href="css/jquery-ui.min.css"/>
    <link rel="stylesheet" href="css/bootstrap-select.css">
    <style>

        #reset{
            left: 10px;
            top: 150px;
            position: absolute;
            z-index: 2000;
        }

        .ol-popup {
            position: absolute;
            background-color: white;
            -webkit-filter: drop-shadow(0 1px 4px rgba(0,0,0,0.2));
            filter: drop-shadow(0 1px 4px rgba(0,0,0,0.2));
            padding: 15px;
            border-radius: 10px;
            border: 1px solid #cccccc;
            bottom: 12px;
            left: -50px;
        }
        .ol-popup:after, .ol-popup:before {
            top: 100%;
            border: solid transparent;
            content: " ";
            height: 0;
            width: 0;
            position: absolute;
            pointer-events: none;
        }
        .ol-popup:after {
            border-top-color: white;
            border-width: 10px;
            left: 48px;
            margin-left: -10px;
        }
        .ol-popup:before {
            border-top-color: #cccccc;
            border-width: 11px;
            left: 48px;
            margin-left: -11px;
        }
        .ol-popup-closer {
            text-decoration: none;
            position: absolute;
            top: 2px;
            right: 8px;
        }
        .ol-popup-closer:after {
            content: "✖";
        }
        #popup-content{
            font-size:14px;
            font-family:"微软雅黑";
        }
        #popup-content .markerInfo {
            font-weight:bold;
        }


        .ui-widget, .ui-widget input, .ui-widget select{font-size:14px;font-family:"微软雅黑";}
        .ui-widget .ui-widget{font-size:14px; font-family:"微软雅黑"; color: #222222;}



    </style>
    <script>

        //查看水位变化曲线图的回调函数
        function viewLevelChange(siteName)
        {
            $.post("./FindBySiteNameServlet",{siteName:siteName},function (data)
            {
                var timeArray=new Array();
                var levelArray=new Array();
                var flowArray=new Array();
                for(var i=0;i<data.length;i++)
                {
                    var obj=data[i];
                    //var zhanName=obj.siteName;
                    var waterLevel=obj.waterLevel;
                    var flow=obj.flow;
                    var collectionDate=obj.collectionDate;
                    var dateStr=dateFormat("YYYY-MM-dd HH:mm",new Date(collectionDate));

                    timeArray.push(dateStr);
                    levelArray.push(waterLevel);
                    flowArray.push(flow);

                }

                var myChart = echarts.init(document.getElementById('main'));
                var option = {
                    backgroundColor:'rgba(255, 255, 255, 0.7)',
                    title: {
                        text:siteName+ "监测站水位变化曲线图",
                        textStyle:{ fontSize:18},
                        top:20,
                        left:"center"
                    },
                    tooltip: {
                        trigger: 'axis'
                    },
                    legend: {
                        data: ['水位', '流量']
                    },
                    grid: {
                        left: '3%',
                        right: '4%',
                        bottom: '3%',
                        containLabel: true
                    },
                    toolbox: {
                        feature: {
                            saveAsImage: {}
                        }
                    },
                    xAxis: {
                        type: 'category',
                        boundaryGap: false,
                        data: timeArray

                    },
                    yAxis: {
                        type: 'value',
                        name:"水位单位(m)\n     流量单位m^3/s",
                        nameTextStyle:{ align:"right"}
                    },
                    series: [
                        {
                            name: '水位',
                            type: 'line',
                            stack: '总量',
                            data: levelArray
                        },
                        {
                            name: '流量',
                            type: 'line',
                            stack: '总量',
                            data: flowArray
                        },

                    ]
                };

                myChart.setOption(option,true);

            });

        }


        function closeResult()
        {
            $("#reslut").css("display","none");
        }

        $(function ()
        {
            $(".ol-zoom-in").attr("title","放大");
            $(".ol-zoom-out").attr("title","缩小");
            $(".ol-full-screen-false").attr("title","全屏显示");
            $("button[title='复位']").mouseover(function ()
            {
                $(this).css("background-color","#4873A6");

            });
            $("button[title='复位']").mouseout(function ()
            {
                $(this).css("background-color","#7897BC");

            });

        });

        //根据监测站名称查看最新的一条水质数据
        function viewNewest(stationName)
        {
            $.post("/FindNewestServlet",{stationName:stationName},function (data)
            {
                var belongStation=data.belongStation;
                var dateTime=data.dateTime;
                var dateStr=dateFormat("YYYY-MM-dd HH:mm",new Date(dateTime));
                var pH=data.pH;
                var dO=data.dO;
                var nH4=data.nH4;
                var cODMn=data.cODMn;
                var tOC=data.tOC;
                var level=data.level;



                // 基于准备好的dom，初始化echarts实例
                var myChart = echarts.init(document.getElementById('main'));

                // 指定图表的配置项和数据
                var option = {
                    backgroundColor: "rgba(255,255,255,0.7)",
                    title: {
                        x:'center',
                        text: belongStation+"最新水质数据",
                        subtext:dateStr+"\t"+"水质类别："+level,
                        subtextStyle:{

                            color: '#000000'
                        }
                    },
                    tooltip: {},
                    legend:
                        {
                            data:[]
                        },
                    xAxis: {

                        data: ["溶解氧","高猛酸钾","氨氮","总有机碳","PH"]
                    },
                    yAxis:[{
                        name:"数值单位:mg/L",
                        min:0,
                        max:20

                    },{
                        name:"PH",
                        min:0,
                        max:11,
                        maxInterval:1

                    }] ,
                    series: [{
                        name: '数值',
                        type: 'bar',
                        data: [dO, cODMn, nH4, tOC,pH],
                        //配置样式
                        itemStyle: {
                            //通常情况下：
                            normal:{
                                //每个柱子的颜色即为colorList数组里的每一项，如果柱子数目多于colorList的长度，则柱子颜色循环使用该数组
                                color: function (params){
                                    var colorList = ['rgb(164,205,238)','rgb(42,170,227)','rgb(25,46,94)','rgb(195,229,235)','rgb(195,0,235)'];
                                    return colorList[params.dataIndex];
                                }
                            },
                            //鼠标悬停时：
                            emphasis: {
                                shadowBlur: 10,
                                shadowOffsetX: 0,
                                shadowColor: 'rgba(0, 0, 0, 0.5)'
                            }
                        },
                    }]
                };

                // 使用刚指定的配置项和数据显示图表。
                myChart.setOption(option);


            });


        }


        function searchStation()
        {
            $("#reslut").css("display","block");
            var cezhanName=$("#cezhanName").val();
            var startTime=$("#startTime").val();
            var endTime=$("#endTime").val();
            var water_level=selectLevel();
            $.post("/FindByNameAndTimeServlet",{cezhanName:cezhanName,startTime:startTime,endTime:endTime,water_level:water_level},function (data)
            {
                var count=data.length;
                var mainStr='<table class="table table-bordered table-hover" id="shuiZhiTable">\n' +
                    ' <caption style="font-size: 24px;text-align: right;background-color: rgba(255,255,255,0.7)">查询结果(共'+count+'条记录)' +
                    '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
                    '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button onclick="closeResult();" class="btn btn-danger btn-sm">关闭</button></caption>\n'+
                    '                <tr class="success">\n' +
                    '                    <th>测站名</th>\n' +
                    '                    <th>测量时间</th>\n' +
                    '                    <th>pH</th>\n' +
                    '                    <th>溶解氧</th>\n' +
                    '                    <th>氨氮</th>\n' +
                    '                    <th>高猛酸钾盐指数</th>\n' +
                    '                    <th>总有机碳</th>\n' +
                    '                    <th>水质类别</th>\n' +
                    '                </tr>';
                for(var i=0;i<data.length;i++)
                {
                    var obj=data[i];
                    var belongStation=obj.belongStation;
                    var dateTime=obj.dateTime;
                    var dateStr=dateFormat("YYYY-MM-dd HH:mm",new Date(dateTime));
                    var pH=obj.pH;
                    var dO=obj.dO;
                    var nH4=obj.nH4;
                    var cODMn=obj.cODMn;
                    var tOC=obj.tOC;
                    var level=obj.level;

                    var tdStr;
                    if(level==="III")
                    {
                        tdStr=' <td style="background-color: #03ff03">'+level+'</td>';
                    }
                    else if(level==="II")
                    {
                        tdStr=' <td style="background-color: #34c3f6">'+level+'</td>';
                    }
                    else if(level==="IV")
                    {
                        tdStr=' <td style="background-color: #faff19">'+level+'</td>';
                    }
                    else if(level==="I")
                    {
                        tdStr=' <td style="background-color: #c5ffff">'+level+'</td>';
                    }
                    else if(level==="V")
                    {
                        tdStr=' <td style="background-color: #ff9000">'+level+'</td>';
                    }
                    else if(level==="劣V")
                    {
                        tdStr=' <td style="background-color: #ff0000">'+level+'</td>';
                    }
                    else
                    {
                        tdStr=' <td style="background-color: #ffffff">'+level+'</td>';
                    }


                    var itemStr=' <tr class="info">\n' +
                        '                    <td>'+belongStation+'</td>\n' +
                        '                    <td>'+dateStr+'</td>\n' +
                        '                    <td>'+pH+'</td>\n' +
                        '                    <td>'+dO+'</td>\n' +
                        '                    <td>'+nH4+'</td>\n' +
                        '                    <td>'+cODMn+'</td>\n' +
                        '                    <td>'+tOC+'</td>\n' +
                        tdStr +
                        '                </tr>';
                    mainStr+= itemStr;
                }
                var endStr=' </table>';
                mainStr+=endStr;
                $("#reslut").html(mainStr);


            });

        }


        function selectLevel()
        {
            var value=$("#water_level_select").val();
            return value;
        }

    </script>
</head>
<body>
<div class="container-fluid">
   <div class="row">
        <div class="col-sm-12">
            <ul class="nav nav-pills">
                <li role="presentation"><a href="javascript:shuiQing();">实时水情</a></li>
                <li role="presentation"><a href="javascript:findSite();">水质站点列表</a></li>
                <li role="presentation"><a href="javascript:viewCurrentWaterQuality();">实时水质数据</a></li>
                <li role="presentation" class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
                    警戒区 <span class="caret"></span>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a href="javascript:void(0)" id="showReg">显示警戒区</a></li>
                        <li><a href="javascript:void(0)" id="drawReg">绘制警戒区</a></li>
                        <li><a href="javascript:void(0)" id="deleteReg">删除警戒区</a></li>
                    </ul>
                </li>
                <li role="presentation">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
                        地图类型 <span class="caret"></span>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a href="javascript:terrain();">谷歌地形图</a></li>
                        <li><a href="javascript:vector();">谷歌矢量图</a></li>
                        <li><a href="javascript:raster();">谷歌遥感图</a></li>
                        <li><a href="javascript:road();">谷歌交通</a></li>
                        <li><a href="javascript:osm();">OSM地图</a></li>
                    </ul>

                </li>

                <li role="presentation">
                    <form class="form-inline">
                        <div class="form-group">
                            <label class="sr-only" for="cezhanName">Email address</label>
                            <input type="text" class="form-control" id="cezhanName" name="name2" placeholder="请输入监测站名称" STYLE="width: 140px;height: 28px">
                        </div>
                        <div class="form-group">
                           <input type="datetime-local" id="startTime">
                        </div>
                        <div class="form-group">
                            至
                        </div>
                        <div class="form-group">
                            <input type="datetime-local" id="endTime">
                        </div>
                        <div class="form-group">
                            <select style="height: 28px" id="water_level_select" onchange="selectLevel();">
                                <option>--水质类别--</option>
                                <option value="I">I</option>
                                <option value="II">II</option>
                                <option value="III">III</option>
                                <option value="IV">IV</option>
                                <option value="V">V</option>
                                <option value="劣V">劣V</option>
                            </select>
                        </div>
                        <button type="button"  onclick="searchStation();" class="btn btn-info btn-sm"><span class="glyphicon glyphicon-search" aria-hidden="true"></span>&nbsp;搜索</button>
                    </form>
                </li>
            </ul>

        </div>


    </div><%--row end--%>
    <div class="row">
        <div id="dd" title="实时水情">
            <div id="shuiqingDiv">
            <table class="table table-bordered" id="shuiQingTable">
                <tr class="success">
                    <th>河流</th>
                    <th>站名</th>
                    <th>日期</th>
                    <th>水位</th>
                    <th>流量</th>
                    <th>超警戒/汛限水位</th>
                </tr>
            </table>
            </div>
        </div>

        <div id="wQuality" title="淮河流域实时水质数据">
            <table class="table table-bordered" id="shuiZhiTable">
                <tr class="success">
                    <th>测站名</th>
                    <th>测量时间</th>
                    <th>pH</th>
                    <th>溶解氧</th>
                    <th>氨氮</th>
                    <th>高猛酸钾盐指数</th>
                    <th>总有机碳</th>
                    <th>水质类别</th>
                </tr>
                <tr class="info">
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
            </table>
        </div>



        <div id="site" title="水质站点">
            <table class="table table-bordered" id="siteTable">
                <tr class="success">
                    <th>水质站点名</th>
                    <th>操作</th>
                </tr>
                <tr class="info">
                    <td></td>
                    <td></td>
                </tr>
            </table>

        </div>


        <div id="dialog-confirm" title="图形属性信息设置">
            <label>信息类别:警戒区域</label><br />
            <label>热区名称:</label>
            <input type="text" value="" id="name" />
            <br />
            <label>所在城市:</label>
            <input type="text"  id="city" />
        </div>
        <div id="dialog-delete" title="删除热区要素确认">
            <label>是否删除该要素？</label><br />
        </div>

        <div id="map" style="height: 650px"><%--地图容器--%>

            <!-- 监测站Popup -->
            <div id="popup" class="ol-popup" >
                <a href="#" id="popup-closer" class="ol-popup-closer"></a>
                <div id="popup-content">
                </div>
            </div>


            <div id="mypopup"  ></div><%--热区的popup--%>



            <span id="reset"><button class="btn btn-info btn-xs" data-toggle="tooltip" data-placement="right" title="复位" style="background-color: #7897BC;height:23px;width:23px"><span class="glyphicon glyphicon-repeat" aria-hidden="true"></span></button></span>
            <!-- 为ECharts准备一个具备大小（宽高）的Dom -->
            <div id="main" style="width: 500px;height:250px;right: 0px;bottom: 0px;position: absolute;z-index: 2000;"></div>
            <div id="reslut" style="border-radius:10px;box-shadow:0px 0px 20px 5px gray;width: 700px;height:300px;right: 0px;top: 100px;position: absolute;z-index: 2000;overflow-y: scroll;display: none;background-color: rgba(255,255,255,0.7)"></div>

        </div><%--地图容器end--%>

   </div><%--row end--%>

</div><%--container end--%>



<script>

    function viewDetails(stationName) //查看水质站点详情的回调函数
    {
        $("#site").dialog("close");
        $.post("FindLocationByNameServlet",{stationName:stationName},function (data)
        {
            var longitude=data.longitude;//经度
            var latitude=data.latitude;//纬度
            var stationName=data.stationName;
            var introduction=data.introduction;


            var site = ol.proj.fromLonLat([longitude, latitude]);
            //标注点信息对象
            var featuerInfo =
            {
                geo: site,
                att:
                {
                    title: stationName, //标注信息的标题内容
                    titleURL: "https://blog.csdn.net/Deep_rooted", //标注详细信息链接
                    text:introduction, //标注内容简介
                    imgURL: "img/bangbu.png" //标注的图片
                }
            }



            /**
             * 创建标注样式函数,设置image为图标ol.style.Icon
             * @param {ol.Feature} feature 要素
             */
            var createLabelStyle = function (feature) {
                return new ol.style.Style({
                    image: new ol.style.Icon(/** @type {olx.style.IconOptions} */({
                        anchor: [0.5, 60],
                        anchorOrigin: 'top-right',
                        anchorXUnits: 'fraction',
                        anchorYUnits: 'pixels',
                        offsetOrigin: 'top-right',
                        // offset:[0,10],
                        // scale:0.5,  //图标缩放比例
                        opacity: 0.75,  //透明度
                        src: 'img/blueIcon3.png' //图标的url
                    })),
                    text: new ol.style.Text({
                        textAlign: 'center', //位置
                        textBaseline: 'middle', //基准线
                        font: 'normal 14px 微软雅黑',  //文字样式
                        text: feature.get('name'),  //文本内容
                        fill: new ol.style.Fill({ color: '#aa3300' }), //文本填充样式（即文字颜色）
                        stroke: new ol.style.Stroke({ color: '#ffcc33', width: 2 })
                    })
                });
            }

            //实例化Vector要素，通过矢量图层添加到地图容器中
            var iconFeature = new ol.Feature({
                geometry: new ol.geom.Point(site),
                name: stationName,  //名称属性
                population: 2115 //大概人口数（万）
            });
            iconFeature.setStyle(createLabelStyle(iconFeature));
            //矢量标注的数据源
            var vectorSource = new ol.source.Vector({
                features: [iconFeature]
            });
            //矢量标注图层
            var vectorLayer = new ol.layer.Vector({
                source: vectorSource
            });
            map.addLayer(vectorLayer);

            /**
             * 实现popup的html元素
             */
            var container = document.getElementById('popup');
            var content = document.getElementById('popup-content');
            var closer = document.getElementById('popup-closer');

            /**
             * 在地图容器中创建一个Overlay
             */
            var popup = new ol.Overlay(/** @type {olx.OverlayOptions} */({
                element: container,
                autoPan: true,
                positioning: 'bottom-center',
                stopEvent: false,
                autoPanAnimation: {
                    duration: 250
                }
            }));
            map.addOverlay(popup);

            /**
             * 添加关闭按钮的单击事件（隐藏popup）
             * @return {boolean} Don't follow the href.
             */
            closer.onclick = function () {
                popup.setPosition(undefined);  //未定义popup位置
                closer.blur(); //失去焦点
                return false;
            };

            /**
             * 动态创建popup的具体内容
             * @param {string} title
             */
            function addFeatrueInfo(info)
            {
                //新增a元素
                var elementA = document.createElement('a');
                elementA.className = "markerInfo";
                elementA.href = info.att.titleURL;
                //elementA.innerText = info.att.title;
                setInnerText(elementA, info.att.title);
                content.appendChild(elementA); // 新建的div元素添加a子节点
                //新增div元素
                var elementDiv = document.createElement('div');
                elementDiv.className = "markerText";
                //elementDiv.innerText = info.att.text;
                setInnerText(elementDiv, info.att.text);
                content.appendChild(elementDiv); // 为content添加div子节点
                //新增img元素
                var elementImg = document.createElement('img');
                elementImg.className = "markerImg";
                elementImg.src = info.att.imgURL;
                content.appendChild(elementImg); // 为content添加img子节点
            }
            /**
             * 动态设置元素文本内容（兼容）
             */
            function setInnerText(element, text)
            {
                if (typeof element.textContent == "string")
                {
                    element.textContent = text;
                } else
                {
                    element.innerText = text;
                }
            }

            /**
             * 为map添加点击事件监听，渲染弹出popup
             */
            map.on('click', function (evt)
            {
                var coordinate = evt.coordinate;
                //判断当前单击处是否有要素，捕获到要素时弹出popup
                var feature = map.forEachFeatureAtPixel(evt.pixel, function (feature, layer) { return feature; });
                if (feature)
                {
                    content.innerHTML = ''; //清空popup的内容容器
                    addFeatrueInfo(featuerInfo); //在popup中加载当前要素的具体信息

                    viewNewest(stationName);

                    /*if (popup.getPosition() == undefined)
                    {
                        popup.setPosition(coordinate); //设置popup的位置
                    }*/
                    popup.setPosition(coordinate); //设置popup的位置
                }
            });
            /**
             * 为map添加鼠标移动事件监听，当指向标注时改变鼠标光标状态
             */
            map.on('pointermove', function (e)
            {
                var pixel = map.getEventPixel(e.originalEvent);
                var hit = map.hasFeatureAtPixel(pixel);
                map.getTargetElement().style.cursor = hit ? 'pointer' : '';
            });


        });
    }

    function terrain()//地形图
    {
        map.removeLayer(googleLayer); //移除Google图层
        googleLayer = new ol.layer.GoogleMapLayer({
            layerType: ol.source.GoogleLayerType.TERRAIN
        });
        map.addLayer(googleLayer); //添加Google地图图层
    }
    function vector()//矢量图
    {
        map.removeLayer(googleLayer); //移除Google图层
        googleLayer = new ol.layer.GoogleMapLayer({
            layerType: ol.source.GoogleLayerType.VEC
        });
        map.addLayer(googleLayer); //添加Google地图图层
    }
    function raster()//遥感图
    {
        map.removeLayer(googleLayer); //移除Google图层
        googleLayer = new ol.layer.GoogleMapLayer({
            layerType: ol.source.GoogleLayerType.RASTER
        });
        map.addLayer(googleLayer); //添加Google地图图层
    }
    function road()//道路图
    {
        map.removeLayer(googleLayer); //移除Google图层
        googleLayer = new ol.layer.GoogleMapLayer({
            layerType: ol.source.GoogleLayerType.ROAD
        });
        map.addLayer(googleLayer); //添加Google地图图层
    }
    function osm()
    {
        map.removeLayer(googleLayer); //移除Google图层
        var osmLayer=new ol.layer.Tile({
            source: new ol.source.OSM() //图层数据源
        });
        map.addLayer(osmLayer); //添加瓦片图层

    }

    function viewCurrentWaterQuality()
    {
        $("#wQuality").dialog("open");
        $.post("/ViewCurrentWaterQualityServlet",function (data)
        {


            var tableStr='<table class="table table-bordered table-hover" id="shuiZhiTable">\n' +
                '                    <tr class="success">\n' +
                '                        <th>测站名</th>\n' +
                '                        <th>测量时间</th>\n' +
                '                        <th>pH</th>\n' +
                '                        <th>溶解氧</th>\n' +
                '                        <th>氨氮</th>\n' +
                '                        <th>高猛酸钾盐指数</th>\n' +
                '                        <th>总有机碳</th>\n' +
                '                        <th>水质类别</th>\n' +
                '                    </tr>';
            for (var i = 0; i <data.length ; i++)
            {
                var rowStr;
                var obj=data[i];
                var belongStation=obj.belongStation;
                var dateTime=obj.dateTime;
                var timeStr=dateFormat("YYYY-MM-dd HH:mm",new Date(dateTime));
                var pH=obj.pH;
                var dO=obj.dO;
                var nH4=obj.nH4;
                var cODMn=obj.cODMn;
                var tOC=obj.tOC;
                var level=obj.level;

                var tdStr;
                if(level==="III")
                {
                    tdStr=' <td style="background-color: #03ff03">'+level+'</td>';
                }
                else if(level==="II")
                {
                    tdStr=' <td style="background-color: #34c3f6">'+level+'</td>';
                }
                else if(level==="IV")
                {
                    tdStr=' <td style="background-color: #faff19">'+level+'</td>';
                }
                else if(level==="I")
                {
                    tdStr=' <td style="background-color: #c5ffff">'+level+'</td>';
                }
                else if(level==="V")
                {
                    tdStr=' <td style="background-color: #ff9000">'+level+'</td>';
                }
                else if(level==="劣V")
                {
                    tdStr=' <td style="background-color: #ff0000">'+level+'</td>';
                }
                else
                {
                    tdStr=' <td style="background-color: #ffffff">'+level+'</td>';
                }

                rowStr='<tr class="info">\n' +
                    '                        <td>'+belongStation+'</td>\n' +
                    '                        <td>'+timeStr+'</td>\n' +
                    '                        <td>'+pH+'</td>\n' +
                    '                        <td>'+dO+'</td>\n' +
                    '                        <td>'+nH4+'</td>\n' +
                    '                        <td>'+cODMn+'</td>\n' +
                    '                        <td>'+tOC+'</td>\n' +
                                                  tdStr+
                    '                    </tr>';


                tableStr+=rowStr;
            }

            var endStr=' </table>\n';
            tableStr+=endStr;
            $("#wQuality").html(tableStr);

        });

    }

    function viewPie(stationName)
    {

        $.post("./StatisticsWaterQualityServlet",{stationName:stationName},function (data)
        {
            var a=data.a;
            var b=data.b;
            var c=data.c;
            var d=data.d;
            var e=data.e;
            var f=data.f;
            var g=data.g;

            if(a==0&&b==0&&c==0&&d==0&&e==0&&f==0)
            {
                alert("数据库中尚未有该站点的数据！");
            }

            // 基于准备好的dom，初始化echarts实例
            var myChart = echarts.init(document.getElementById('main'));
            myChart.setOption({
                tooltip:{formatter:"{b}:{c}"+"，"+"占比{d}%"},
                backgroundColor:'rgba(255, 255, 255, 0.7)',
                legend:{orient:"vertical",left:"70%",y:"center",data:["I类水质","II类水质","III类水质","IV类水质","V类水质","劣V类水质"]},
                toolbox:{feature:{ saveAsImage:{ type:'png'}}},
                title: {
                    text: stationName,
                    left: 'center',//主副标题的水平位置
                    subtext:"历史水质统计图",
                    subtextStyle: {//副标题的属性
                        color: '#000000',
                        fontSize:15
                        // 同主标题
                    },

                },
                series : [
                    {

                        center:["30%","50%"],
                        label:{ formatter:"{b}:{c}({d}%)"},
                        color: ['#c5ffff','#34c3f6', '#03ff03', '#faff19', '#ff9000','#ff0000'],
                        name: '水质类别',
                        type: 'pie',    // 设置图表类型为饼图
                        radius: '30%',  // 饼图的半径，外半径为可视区尺寸（容器高宽中较小一项）的 55% 长度。
                        data:[          // 数据数组，name 为数据项名称，value 为数据项值
                            {value:a, name:'I类水质'},
                            {value:b, name:'II类水质'},
                            {value:c, name:'III类水质'},
                            {value:d, name:'IV类水质'},
                            {value:e, name:'V类水质'},
                            {value:f, name:'劣V类水质'}
                        ]
                    }
                ]
            },true)

        });

    }


    function viewLine(stationName)
    {
        $.post("/FindLineServlet",{stationName:stationName},function (data)
        {
            var count=data.length;
            if(count==0)
            {
                alert("数据库中尚未有该站点的监测数据！");
            }
            var phArray=new Array();
            var dOArray=new Array();
            var nH4Array=new Array();
            var cODMnArray=new Array();
            var tOCArray=new Array();
            var timeArray=new Array();
            var belongStation;
            for(var i=0;i<data.length;i++)
            {

                var obj=data[i];
                var pH=obj.pH;
                var dO=obj.dO;
                var nH4=obj.nH4;
                var cODMn=obj.cODMn;
                var tOC=obj.tOC;
                var dateTime=obj.dateTime;
                var dateStr=dateFormat("YYYY-MM-dd HH:mm",new Date(dateTime));
                belongStation=obj.belongStation;

                phArray.push(pH);
                dOArray.push(dO);
                nH4Array.push(nH4);
                cODMnArray.push(cODMn);
                tOCArray.push(tOC);
                timeArray.push(dateStr);
            }


            var myChart = echarts.init(document.getElementById('main'));
            var option = {
                backgroundColor:'rgba(255, 255, 255, 0.7)',
                title: {
                    text: belongStation+"水质变化曲线图",
                    textStyle:{ fontSize:18},
                    top:20,
                    left:"center"
                },
                tooltip: {
                    trigger: 'axis'
                },
                legend: {
                    data: ['PH', '溶解氧', '氨氮', '高猛酸钾', '总有机碳']
                },
                grid: {
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    containLabel: true
                },
                toolbox: {
                    feature: {
                        saveAsImage: {}
                    }
                },
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    data: timeArray

                },
                yAxis: {
                    type: 'value',
                    name:"单位mg/L"+"\n"+"(PH除外)"
                },
                series: [
                    {
                        name: 'PH',
                        type: 'line',
                        stack: '总量',
                        data: phArray
                    },
                    {
                        name: '溶解氧',
                        type: 'line',
                        stack: '总量',
                        data: dOArray
                    },
                    {
                        name: '氨氮',
                        type: 'line',
                        stack: '总量',
                        data: nH4Array
                    },
                    {
                        name: '高猛酸钾',
                        type: 'line',
                        stack: '总量',
                        data: cODMnArray
                    },
                    {
                        name: '总有机碳',
                        type: 'line',
                        stack: '总量',
                        data:tOCArray
                    }
                ]
            };

            myChart.setOption(option,true);


        });

    }

    //查看水质监测站按钮的回调函数
    function findSite()
    {
        $("#site").dialog("open");
        $.post("FindAlllStationServlet",function (data)
        {
            var tableStr='<table class="table table-bordered" id="siteTable">\n' +
                '                    <tr class="success">\n' +
                '                        <th>水质站点名</th>\n' +
                '                        <th>操作</th>\n' +
                '                    </tr>';

            for(var i=0;i<data.length;i++)
            {
               var obj= data[i];
               var stationName=obj.stationName;
               var hangStr='<tr class="info">\n' +
                   '                        <td>'+stationName+'</td>\n' +
                   '                        <td><button class="btn btn-info btn-xs" onclick="viewDetails(\''+stationName+'\');">查看位置</button>' +
                   '&nbsp;<button onclick="viewPie(\''+stationName+'\');" class="btn btn-info btn-xs">水质饼图</button>&nbsp;' +
                   '<button onclick="viewLine(\''+stationName+'\');" class="btn btn-info btn-xs">水质折线图</button></td>\n' +
                   '                    </tr>';
               tableStr+=hangStr;
            }
            var endStr=' </table>\n';
            tableStr+=endStr;
            $("#siteTable").html(tableStr);

        });

    }

    //实时水情按钮的回调函数
    function shuiQing()
    {
        $("#dd").dialog("open");
        $.post("CurrentWaterLevelServlet",function (data)
        {

            var tableStr=' <table class="table table-bordered table-hover" id="shuiQingTable">\n' +
                '                   <tr class="success">\n' +
                '                       <th>河流</th>\n' +
                '                       <th>站名</th>\n' +
                '                       <th>日期</th>\n' +
                '                       <th>水位</th>\n' +
                '                       <th>流量</th>\n' +
                '                       <th>超警戒/汛限水位</th>\n' +
                '                       <th>操作</th>\n' +
                '                   </tr>';

            for(var i=0;i<data.length;i++)
            {
                var obj = data[i];
                var riverName=obj.riverName;
                var stationName=obj.siteName;
                var date=obj.collectionDate;
                var dateTime=dateFormat("YYYY-MM-dd HH:mm",new Date(date));
                var waterLevel=obj.waterLevel;
                var flow=obj.flow;
                var over=obj.over;

                var hangStr=' <tr class="info">\n' +
                    '                       <td>'+riverName+'</td>\n' +
                    '                       <td>'+stationName+'</td>\n' +
                    '                       <td>'+dateTime+'</td>\n' +
                    '                       <td>'+waterLevel+'</td>\n' +
                    '                       <td>'+flow+'</td>\n' +
                    '                       <td>'+over+'</td>\n' +
                    '                       <td><button class="btn btn-sm btn-info" onclick="viewLevelChange(\''+stationName+'\');">水位变化曲线图</button></td>\n' +
                    '                   </tr>';
                tableStr+=hangStr;

            }
            var endStr=' </table>\n';
            tableStr+=endStr;
            $("#shuiqingDiv").html(tableStr);



        });


    }



    var flashFeature;  //热区要素
    var preFeature;  //前一个热区要素
    var flag = false; //是否是同一个要素的标识
    var feature; //当前鼠标选中要素
    var draw; //绘制对象
    var geoStr = null; // 当前绘制图形的坐标串
    var currentFeature = null; //当前绘制的几何要素

    //绘制热区的样式
    var flashStyle = new ol.style.Style({
        fill: new ol.style.Fill({
            color: 'rgba(255, 102, 0, 0.2)'
        }),
        stroke: new ol.style.Stroke({
            color: '#cc3300',
            width: 2
        }),
        image: new ol.style.Circle({
            radius: 7,
            fill: new ol.style.Fill({
                color: '#cc3300'
            })
        })
    });
    //矢量要素（区）的样式
    var vectStyle = new ol.style.Style({
        fill: new ol.style.Fill({
            color: 'rgba(255, 255, 255, 0.5)'
        }),
        stroke: new ol.style.Stroke({
            color: '#0099ff',
            width: 2
        }),
        image: new ol.style.Circle({
            radius: 7,
            fill: new ol.style.Fill({
                color: '#0099ff'
            })
        })
    });

    //矢量数据源
    var vectSource = new ol.source.Vector({
    });
    //矢量图层
    var vectLayer = new ol.layer.Vector({
        source: vectSource,
        style: vectStyle,
        opacity: 0.5
    });

    //矢量数据源（热区）
    var hotSpotsSource = new ol.source.Vector({
    });
    //矢量图层（热区）
    var hotSpotsLayer = new ol.layer.Vector({
        source: hotSpotsSource,
        style: flashStyle,
        opacity: 1
    });



    //实例化比例尺控件（ScaleLine）
    var scaleLineControl = new ol.control.ScaleLine({
        units: "metric" //设置比例尺单位，degrees、imperial、us、nautical、metric（度量单位）
    });





    var beijing = ol.proj.fromLonLat([117.2710932, 32.9527884]);
    //示例标注点北京市的信息对象
    var featuerInfo = {
        geo: beijing,
        att: {
            title: "北京市(中华人民共和国首都)", //标注信息的标题内容
            titleURL: "http://www.openlayers.org/", //标注详细信息链接
            text: "北京（Beijing），简称京，中华人民共和国首都、直辖市，中国的政治、文化和国际交往中心……", //标注内容简介
            imgURL: "../img/bangbu.png" //标注的图片
        }
    }



    var layer = new ol.layer.Vector({
        title: 'add Layer',
        source: new ol.source.Vector({
            projection: 'EPSG:3857',
            url: "huai.json",
            format: new ol.format.GeoJSON()
        })
    });


    //实例化地图对象加载地图
    var googleLayer = new ol.layer.GoogleMapLayer({layerType: ol.source.GoogleLayerType.TERRAIN});//Google图层
    var map = new ol.Map({
        logo: false,
        layers: [googleLayer,vectLayer,hotSpotsLayer,layer],
        target: 'map',
        view: new ol.View({
            center:ol.proj.fromLonLat([115.81, 32.89]),
            zoom: 6,
            minZoom:4,
            maxZoom:20
        }),
        //加载控件到地图容器中
        controls: ol.control.defaults().extend([scaleLineControl,new ol.control.FullScreen()])
    });

















    var initialView = map.getView();//初始视图
    var initialZoom = initialView.getZoom();
    var initialCenter = initialView.getCenter();
    var initialRotation = initialView.getRotation();

    $("#reset").click(function ()//地图复位
    {
        initialView.setZoom(initialZoom);
        initialView.setCenter(initialCenter);
        initialView.setRotation(initialRotation);
    });










    var haha={
        anchor: [0.5, 60],
        anchorOrigin: 'top-right',
        anchorXUnits: 'fraction',
        anchorYUnits: 'pixels',
        offsetOrigin: 'top-right',
        // offset:[0,10],
        // scale:0.5,  //图标缩放比例
        opacity: 0.75,  //透明度
        src: '../img/blueIcon.png' //图标的url
        //src: imgsrc //图标的url
    };

    /**
     * 创建标注样式函数,设置image为图标ol.style.Icon
     * @param {ol.Feature} feature 要素
     */
    var createLabelStyle = function createLabelStyle (feature)
    {
        return new ol.style.Style(
        {
            image: new ol.style.Icon(/** @type {olx.style.IconOptions} */(haha)),
            text: new ol.style.Text({
                textAlign: 'center', //位置
                textBaseline: 'middle', //基准线
                font: 'normal 14px 微软雅黑',  //文字样式
                text: feature.get('name'),  //文本内容
                fill: new ol.style.Fill({ color: '#aa3300' }), //文本填充样式（即文字颜色）
                stroke: new ol.style.Stroke({ color: '#ffcc33', width: 2 })
            })
        });
    }



    //实例化Vector要素，通过矢量图层添加到地图容器中
    var iconFeature = new ol.Feature({
        geometry: new ol.geom.Point(beijing),
        name: '北京市',  //名称属性
        population: 2115 //大概人口数（万）
    });
    iconFeature.setStyle(createLabelStyle(iconFeature));
    //矢量标注的数据源
    var vectorSource = new ol.source.Vector({
        features: [iconFeature]
    });



    $.post("../IndexingServlet",function (data)
    {
        for(var i=0;i<data.length;i++)
        {
            var obj=data[i];
            var station=obj.station;
            var quality=obj.quality;

            var longitude=station.longitude;
            var latitude=station.latitude;
            var stationName=station.stationName;

            var level=null;
            if(quality!=null)
            {level=quality.level;}


            //实例化Vector要素，通过矢量图层添加到地图容器中
            var iconFeature2 = new ol.Feature({
                geometry: new ol.geom.Point(ol.proj.fromLonLat([longitude,latitude])),
                name: stationName,  //名称属性
                population: 2115 //大概人口数（万）
            });

            if(level!=null&&level=="II")
            {haha.src="../img/blueIconTwo.png";}
            else if(level!=null&&level=="I")
            {haha.src="../img/blueIconOne.png";}
            else if(level!=null&&level=="III")
            {haha.src="../img/blueIconThree.png";}
            else if(level!=null&&level=="IV")
            {haha.src="../img/blueIconFour.png";}
            else if(level!=null&&level=="V")
            {haha.src="../img/blueIconWu.png";}
            else if(level!=null&&level=="劣V")
            {haha.src="../img/blueIconFive.png";}
            else
            {haha.src="../img/blueIconNull.png";}
            iconFeature2.setStyle(createLabelStyle(iconFeature2));
            //矢量标注的数据源
            vectorSource.addFeature(iconFeature2)

        }

    });



    //矢量标注图层
    var vectorLayer = new ol.layer.Vector({
        source: vectorSource
    });
    map.addLayer(vectorLayer);

    /**
     * 实现popup的html元素
     */
    var container = document.getElementById('popup');
    var content = document.getElementById('popup-content');
    var closer = document.getElementById('popup-closer');

    /**
     * 在地图容器中创建一个Overlay
     */
    var popup = new ol.Overlay(/** @type {olx.OverlayOptions} */({
        element: container,
        autoPan: true,
        positioning: 'bottom-center',
        stopEvent: false,
        autoPanAnimation: {
            duration: 250
        }
    }));
    map.addOverlay(popup);

    /**
     * 添加关闭按钮的单击事件（隐藏popup）
     * @return {boolean} Don't follow the href.
     */
    closer.onclick = function () {
        popup.setPosition(undefined);  //未定义popup位置
        closer.blur(); //失去焦点
        return false;
    };

    /**
     * 动态创建popup的具体内容
     * @param {string} title
     */
    function addFeatrueInfo(info) {
        //新增a元素
        var elementA = document.createElement('a');
        elementA.className = "markerInfo";
        elementA.href = info.att.titleURL;
        //elementA.innerText = info.att.title;
        setInnerText(elementA, info.att.title);
        content.appendChild(elementA); // 新建的div元素添加a子节点
        //新增div元素
        var elementDiv = document.createElement('div');
        elementDiv.className = "markerText";
        //elementDiv.innerText = info.att.text;
        setInnerText(elementDiv, info.att.text);
        content.appendChild(elementDiv); // 为content添加div子节点
        //新增img元素
        var elementImg = document.createElement('img');
        elementImg.className = "markerImg";
        elementImg.src = info.att.imgURL;
        content.appendChild(elementImg); // 为content添加img子节点
    }
    /**
     * 动态设置元素文本内容（兼容）
     */
    function setInnerText(element, text) {
        if (typeof element.textContent == "string") {
            element.textContent = text;
        } else {
            element.innerText = text;
        }
    }

    /**
     * 为map添加点击事件监听，渲染弹出popup
     */
    map.on('click', function (evt) {
        var coordinate = evt.coordinate;
        var zuobiao4326=ol.proj.transform(coordinate, 'EPSG:3857' ,'EPSG:4326');
        var jingdu=zuobiao4326[0];
        var weidu=zuobiao4326[1];

        //判断当前单击处是否有要素，捕获到要素时弹出popup
        var feature = map.forEachFeatureAtPixel(evt.pixel, function (feature, layer) { return feature; });
        if (feature)
        {



            $.post("../FindStationAndQualityServlet",{jingdu:jingdu,weidu:weidu},function (data)
            {
                var stationName=data.station.stationName;
                var introduction=data.station.introduction;


                if(data.quality==null)
                {
                    alert("尚未有该站点的监测数据！")
                }
                var belongStation;
                var dateTime;
                var dateStr;
                var dO;
                var nH4;
                var cODMn;
                var tOC;
                var level;
                var pH;

                if(data.quality!=null)
                {
                    belongStation=data.quality.belongStation;
                    dateTime=data.quality.dateTime;
                    dateStr=dateFormat("YYYY-MM-dd HH:mm",new Date(dateTime));
                    pH=data.quality.pH;
                    dO=data.quality.dO;
                    nH4=data.quality.nH4;
                    cODMn=data.quality.cODMn;
                    tOC=data.quality.tOC;
                    level=data.quality.level;


                }



                // 基于准备好的dom，初始化echarts实例
                var myChart = echarts.init(document.getElementById('main'));

                // 指定图表的配置项和数据
                var option = {
                    toolbox:{
                        show:true,
                        feature:
                            {
                                saveAsImage:{type:"png"}
                            }
                    },
                    backgroundColor: "rgba(255,255,255,0.7)",
                    title: {
                        x:'center',
                        text: belongStation+"最新水质数据",
                        subtext:dateStr+"\t"+"水质类别："+level,
                        subtextStyle:{

                            fontSize:20,
                            color: '#000000'
                        }
                    },
                    tooltip: {},
                    legend:
                        {
                            data:[]
                        },
                    xAxis: [{
                        data: ["溶解氧","高猛酸钾","氨氮","总有机碳","PH"]
                    }],
                    yAxis:[ {
                        name:"单位:mg/L"+"\n"+"（ph除外）",
                        min:0,
                        max:20

                    }],
                    series: [{
                        /*name: '数值',*/
                        type: 'bar',
                        yAxisIndex: '0',
                        data: [dO, cODMn, nH4, tOC,pH],
                        //配置样式
                        itemStyle: {
                            //通常情况下：
                            normal:{
                                //每个柱子的颜色即为colorList数组里的每一项，如果柱子数目多于colorList的长度，则柱子颜色循环使用该数组
                                color: function (params){
                                    var colorList = ['rgb(164,205,238)','rgb(42,170,227)','rgb(25,46,94)','rgb(195,229,235)','rgb(195,0,235)'];
                                    return colorList[params.dataIndex];
                                }
                            },
                            //鼠标悬停时：
                            emphasis: {
                                shadowBlur: 10,
                                shadowOffsetX: 0,
                                shadowColor: 'rgba(0, 0, 0, 0.5)'
                            }
                        },
                    }]
                };

                if(level==="I")
                {
                    option.title.subtextStyle.color="#c5ffff";
                }

                if(level==="II")
                {
                    option.title.subtextStyle.color="#34c3f6";
                }
                if(level==="III")
                {
                    option.title.subtextStyle.color="#03ff03";
                }
                if(level==="IV")
                {
                    option.title.subtextStyle.color="#faff19";
                }
                if(level==="V")
                {
                    option.title.subtextStyle.color="#ff9000";
                }
                if(level==="劣V")
                {
                    option.title.subtextStyle.color="#ff0000";
                }
                // 使用刚指定的配置项和数据显示图表。
                myChart.setOption(option,true);


                featuerInfo.att.text=introduction;//正文
                featuerInfo.att.title=stationName;//标题


                content.innerHTML = ''; //清空popup的内容容器
                addFeatrueInfo(featuerInfo); //在popup中加载当前要素的具体信息

                popup.setPosition(coordinate); //设置popup的位置




            });/*post end*/



        }
    });
    /**
     * 为map添加鼠标移动事件监听，当指向标注时改变鼠标光标状态
     */
    map.on('pointermove', function (e) {
        var pixel = map.getEventPixel(e.originalEvent);
        var hit = map.hasFeatureAtPixel(pixel);
        map.getTargetElement().style.cursor = hit ? 'pointer' : '';
    });






















    /**
     * 在地图容器中创建一个Overlay
     */
    var element = document.getElementById('mypopup');
    var mypopup = new ol.Overlay(/** @type {olx.OverlayOptions} */({
        element: element,
        positioning: 'bottom-center',
        stopEvent: false
    }));
    map.addOverlay(mypopup);


    /**
     * 通过后台查询热区要素
     */
    function selectRegData()
    {


        $.post("../FindAllGraphServlet",function (data)
        {
            if(data.length===0)
            {
                alert("数据库中没有数据！");
            }
            preFeature = null;
            flag = false;  //还原要素判断标识
            hotSpotsSource.clear(); //清空绘图层数据源
            hotSpotsLayer.setVisible(true); //显示绘图层
            vectSource.clear(); //清空矢量图层数据源

            for(var i=0;i<data.length;i++)
            {


                var obj = data[i];

                var name = obj.name;
                var id = obj.id;

                var geome=obj.geometry;//坐标的字符串


                var pointArray=geome.split(";")//先按分号进行切割
                var coordinates = new Array();
                coordinates[0] = new Array();
                for(var j=0;j<pointArray.length;j++)
                {
                    coordinates[0][j] = pointArray[j].split(",");

                }

                //创建一个新的要素，并添加到数据源中
                var feature = new ol.Feature({
                    geometry: new ol.geom.Polygon(coordinates),
                    name:name,
                    id:id
                });
                vectSource.addFeature(feature);

            }

            map.on('pointermove', pointermoveFun,this); //添加鼠标移动事件监听，捕获要素时添加热区功能

        });//ajax请求end

    }


    /**
     * 鼠标移动事件监听处理函数（添加热区功能）
     */
    function pointermoveFun(e)
    {
        var pixel = map.getEventPixel(e.originalEvent);
        var hit = map.hasFeatureAtPixel(pixel);
        map.getTargetElement().style.cursor = hit ? 'pointer' : '';//改变鼠标光标状态

        if (hit) {
            //当前鼠标位置选中要素
            var feature = map.forEachFeatureAtPixel(e.pixel,
                function (feature, layer) {
                    return feature;
                });
            //如果当前存在热区要素
            if (feature) {
                //显示热区图层
                hotSpotsLayer.setVisible(true);
                //控制添加热区要素的标识（默认为false）
                if (preFeature != null) {
                    if (preFeature === feature) {
                        flag = true; //当前鼠标选中要素与前一个选中要素相同
                    }
                    else {

                        flag = false; //当前鼠标选中要素不是前一个选中要素
                        hotSpotsSource.removeFeature(preFeature); //将前一个热区要素移除
                        preFeature = feature; //更新前一个热区要素对象
                    }
                }
                //如果当前选中要素与之前选中要素不同，在热区绘制层添加当前要素
                if (!flag) {
                    $(element).popover('destroy'); //销毁popup
                    flashFeature = feature; //当前热区要素
                    flashFeature.setStyle(flashStyle); //设置要素样式
                    hotSpotsSource.addFeature(flashFeature); //添加要素
                    hotSpotsLayer.setVisible(true); //显示热区图层
                    preFeature = flashFeature; //更新前一个热区要素对象
                }
                //弹出popup显示热区信息
                mypopup.setPosition(e.coordinate); //设置popup的位置
                $(element).popover({
                    placement: 'top',
                    html: true,
                    content: feature.get('name')
                });
                $(element).css("width", "120px");
                $(element).popover('show'); //显示popup

            }
            else {
                hotSpotsSource.clear(); //清空热区图层数据源
                flashFeature = null; //置空热区要素
                $(element).popover('destroy'); //销毁popup
                hotSpotsLayer.setVisible(false); //隐藏热区图层
            }
        }
        else {
            $(element).popover('destroy'); //销毁popup
            hotSpotsLayer.setVisible(false); //隐藏热区图层
        }
    }


    /**
     * 绘制结束事件的回调函数，
     * @param {ol.interaction.DrawEvent} evt 绘制结束事件
     */
    function drawEndCallBack(evt)
    {
        map.removeInteraction(draw); //移除绘制控件

        var geoType = "Polygon"; //绘制图形类型
        $("#dialog-confirm").dialog("open"); //打开属性信息设置对话框
        currentFeature = evt.feature; //当前绘制的要素
        var geo = currentFeature.getGeometry(); //获取要素的几何信息
        var coordinates = geo.getCoordinates(); //获取几何坐标
        //将几何坐标拼接为字符串
        if (geoType == "Polygon")
        {
            geoStr = coordinates[0].join(";");
        }
        else
        {
            geoStr = coordinates.join(";");
        }
    }

    /**
     * 提交数据到后台保存
     * @param {string} geoData 区几何数据
     * @param {string} attData 区属性数据
     */
    function saveData( geoData, attData)
    {
        //通过ajax请求将数据传到后台文件进行保存处理
        $.post("../AddGraphInfoServlet",{geo: geoData, att: attData},function (data)
        {
            alert(data.msg);

        });

    }

    /**
     * 将绘制的几何数据与对话框设置的属性数据提交到后台处理
     */
    function submitData()
    {
        var name = $("#name").val(); //名称
        var city = $("#city").val(); //所属城市
        var attData = name + "," + city;

        if (geoStr != null)
        {
            saveData(geoStr, attData); //将数据提交到后台处理（保存到数据库中）
            currentFeature = null;  //置空当前绘制的几何要素
            geoStr = null; //置空当前绘制图形的geoStr
        }
        else
        {
            alert("未得到绘制图形几何信息！");
            vector.getSource().removeFeature(currentFeature); //删除当前绘制图形
        }
    }

    // 初始化绘制热区要素信息设置对话框
    $("#dialog-confirm").dialog(
        {
            modal: true,  // 创建模式对话框
            autoOpen: false, //默认隐藏对话框
            //对话框打开时默认设置
            open: function (event, ui) {
                $(".ui-dialog-titlebar-close", $(this).parent()).hide(); //隐藏默认的关闭按钮
            },
            //对话框功能按钮
            buttons:
             {
                "提交": function ()
                {
                    submitData(); //提交几何与属性信息到后台处理
                    $(this).dialog('close'); //关闭对话框
                },
                "取消": function ()
                {
                    $(this).dialog('close'); //关闭对话框
                    vectLayer.getSource().removeFeature(currentFeature); //删除当前绘制图形
                }
            }
        });


    /**
     * 鼠标单击事件监听处理函数
     */
    function singleclickFun(e)
    {
        var pixel = map.getEventPixel(e.originalEvent);
        var hit = map.hasFeatureAtPixel(pixel);
        map.getTargetElement().style.cursor = hit ? 'pointer' : '';
        //当前鼠标位置选中要素
        var feature = map.forEachFeatureAtPixel(e.pixel,
            function (feature, layer) {
                return feature;
            });
        //如果当前存在热区要素
        if (feature)
        {
            $("#dialog-delete").dialog("open"); //打开删除要素设置对话框
            currentFeature = feature; //当前绘制的要素
        }
    }
    /**
     * 通过后台删除热区要素
     */
    function deleteData(feature)
    {
        var regID = feature.get('id'); //要素的ID

        //通过ajax请求将数据传到后台文件进行删除处理
        $.post("../DeleGraphServlet",{fID: regID},function (data)
        {
            alert(data.msg);
            vectLayer.getSource().removeFeature(currentFeature); //删除当前选中热区要素

        });

    }

    // 初始化删除要素信息设置对话框
    $("#dialog-delete").dialog(
        {
            modal: true,  // 创建模式对话框
            autoOpen: false, //默认隐藏对话框
            //对话框打开时默认设置
            open: function (event, ui) {
                $(".ui-dialog-titlebar-close", $(this).parent()).hide(); //隐藏默认的关闭按钮
            },
            //对话框功能按钮
            buttons: {
                "删除": function () {
                    deleteData(currentFeature);  //通过后台删除数据库中的热区要素数据并同时删除前端绘图
                    $(this).dialog('close'); //关闭对话框
                },
                "取消": function () {
                    $(this).dialog('close'); //关闭对话框

                }
            }
        });


    /**
     * 【显示热区】功能按钮处理函数
     */
    document.getElementById('showReg').onclick = function () {
        map.un('pointermove', pointermoveFun, this); //移除鼠标移动事件监听
        selectRegData(); //通过后台查询热区要素显示并实现热区功能
    };

    /**
     * 【绘制热区】功能按钮处理函数
     */
    document.getElementById('drawReg').onclick = function () {
        map.removeInteraction(draw); //移除绘制控件
        map.un('singleclick', singleclickFun, this); //移除鼠标单击事件监听

        //实例化交互绘制类对象并添加到地图容器中
        draw = new ol.interaction.Draw({
            source: vectLayer.getSource(), //绘制层数据源
            type: /** @type {ol.geom.GeometryType} */"Polygon"  //几何图形类型
        });
        map.addInteraction(draw);
        //添加绘制结束事件监听，在绘制结束后保存信息到数据库
        draw.on('drawend', drawEndCallBack, this);
    };

    /**
     * 【删除热区】功能按钮处理函数
     */
    document.getElementById('deleteReg').onclick = function () {
        map.un('pointermove', pointermoveFun, this); //移除鼠标移动事件监听

        map.un('singleclick', singleclickFun, this); //移除鼠标单击事件监听
        map.on('singleclick', singleclickFun, this); //添加鼠标单击事件监听
    };







    $("#site").dialog
    (
        {
            closeText:"关闭",
            height:500,
            width:500,
            modal: true,
            autoOpen:false,//默认隐藏对话框
            show:
                {
                    effect: "blind",
                    duration: 1000
                },
            hide:
                {
                    effect: "explode",
                    duration: 1000
                }


        }


    );


    $("#wQuality").dialog
    (
        {
            closeText:"关闭",
            height:500,
            width:900,
            modal: true,
            autoOpen:false,//默认隐藏对话框
            show:
                {
                    effect: "blind",
                    duration: 1000
                },
            hide:
                {
                    effect: "explode",
                    duration: 1000
                }


        }


    );



    $("#dd").dialog
    (
        {
            closeText:"关闭",
            height:500,
            width:700,
            modal: true,
            autoOpen:false,//默认隐藏对话框
            show:
                {
                    effect: "blind",
                    duration: 1000
                },
            hide:
                {
                    effect: "explode",
                    duration: 1000
                }


        }


    );


    function dateFormat(fmt, date) //时间格式化
    {
        var ret;
        var opt =
            {
                "Y+": date.getFullYear().toString(),        // 年
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
