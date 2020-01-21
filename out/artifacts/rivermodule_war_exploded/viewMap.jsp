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
            position: fixed;
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



    </style>
    <script>
        $(function ()
        {
            $.post("FindAlllStationServlet",function (data)
            {
                for(var i=0;i<data.length;i++)
                {
                    var obj = data[i];
                    var stationName=obj.stationName;
                    $("#waterQualitySelect").append('<option value="'+stationName+'">'+stationName+'</option>');

                }

            });

        });




    </script>
</head>
<body>
<div class="container-fluid">
   <div class="row">
        <div class="col-sm-12">
            <ul class="nav nav-pills">
                <li role="presentation"><a href="javascript:shuiQing();">实时水情</a></li>
                <li role="presentation"><a href="javascript:findSite();">水质站点查询</a></li>
                <li role="presentation"><a href="javascript:viewCurrentWaterQuality();">实时水质数据</a></li>
                <li role="presentation" class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
                    热区功能 <span class="caret"></span>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a href="javascript:void(0)" id="showReg">显示热区</a></li>
                        <li><a href="javascript:void(0)" id="drawReg">绘制热区</a></li>
                        <li><a href="javascript:void(0)" id="deleteReg">删除热区</a></li>
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
            </ul>

        </div>


    </div><%--row end--%>
    <div class="row">
        <div id="dd" title="实时水情">
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

        <div id="map"><%--地图容器--%>

            <!-- Popup -->
            <div id="popup" class="ol-popup" >
                <a href="#" id="popup-closer" class="ol-popup-closer"></a>
                <div id="popup-content">
                </div>
            </div>



            <span id="reset"><button class="btn btn-info btn-xs" data-toggle="tooltip" data-placement="right" title="复位" style="background-color: #7897BC"><span class="glyphicon glyphicon-repeat" aria-hidden="true"></span></button></span>



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
                        src: 'img/blueIcon.png' //图标的url
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
                //判断当前单击处是否有要素，捕获到要素时弹出popup
                var feature = map.forEachFeatureAtPixel(evt.pixel, function (feature, layer) { return feature; });
                if (feature) {
                    content.innerHTML = ''; //清空popup的内容容器
                    addFeatrueInfo(featuerInfo); //在popup中加载当前要素的具体信息
                    if (popup.getPosition() == undefined) {
                        popup.setPosition(coordinate); //设置popup的位置
                    }
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
        $.post("ViewCurrentWaterQualityServlet",function (data)
        {


            var tableStr='<table class="table table-bordered" id="shuiZhiTable">\n' +
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

                rowStr='<tr">\n' +
                    '                        <td>'+belongStation+'</td>\n' +
                    '                        <td>'+dateTime+'</td>\n' +
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
            $("#shuiZhiTable").html(tableStr);

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
                   '                        <td><button class="btn btn-info btn-xs" onclick="viewDetails(\''+stationName+'\');">查看详情</button></td>\n' +
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

            var tableStr=' <table class="table table-bordered" id="shuiQingTable">\n' +
                '                   <tr class="success">\n' +
                '                       <th>河流</th>\n' +
                '                       <th>站名</th>\n' +
                '                       <th>日期</th>\n' +
                '                       <th>水位</th>\n' +
                '                       <th>流量</th>\n' +
                '                       <th>超警戒/汛限水位</th>\n' +
                '                   </tr>';

            for(var i=0;i<data.length;i++)
            {
                var obj = data[i];
                var riverName=obj.riverName;
                var stationName=obj.siteName;
                var date=obj.collectionDate;
                var dateTime=new Date(date).toLocaleString();
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
                    '                   </tr>';
                tableStr+=hangStr;

            }
            var endStr=' </table>\n';
            tableStr+=endStr;
            $("#shuiQingTable").html(tableStr);



        });


    }



    //实例化地图对象加载地图
    var googleLayer = new ol.layer.GoogleMapLayer({layerType: ol.source.GoogleLayerType.TERRAIN});//Google图层
    var map = new ol.Map({
        layers: [googleLayer],
        target: 'map',
        view: new ol.View({
            center:ol.proj.fromLonLat([115.81, 32.89]),
            zoom: 6
        })
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





    $("#site").dialog
    (
        {
            closeText:"关闭",
            height:500,
            width:350,
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





   /* //地图视图的初始参数
    var firstview = map.getView();
    var firstzoom = firstview.getZoom();
    var firstcenter = firstview.getCenter();
    var firstrotation = firstview.getRotation();


    $("#reset").click(function ()
    {
        firstview.setCenter(firstcenter); //初始中心点
        firstview.setRotation(firstrotation); //初始旋转角度
        firstview.setZoom(firstzoom); //初始缩放级数
    });
*/


    //根据图层类型加载Google地图
    function loadGoogleMap(mapType)
    {
        switch (mapType)
        {
            case "terrain": //地形
                googleLayer = new ol.layer.GoogleMapLayer({
                    layerType: ol.source.GoogleLayerType.TERRAIN
                });
                break;
            case "vector": //矢量
                googleLayer = new ol.layer.GoogleMapLayer({
                    layerType: ol.source.GoogleLayerType.VEC
                });
                break;
            case "raster": //影像
                googleLayer = new ol.layer.GoogleMapLayer({
                    layerType: ol.source.GoogleLayerType.RASTER
                });
                break;
            case "road": //道路
                googleLayer = new ol.layer.GoogleMapLayer({
                    layerType: ol.source.GoogleLayerType.ROAD
                });
            default:
        }
        map.addLayer(googleLayer); //添加Google地图图层
    }

    //初始化图层切换控件
    function onlayerSwitcherBtn()
    {
        var layerType = $("#layerSwitcherBtn option:selected").val();
        map.removeLayer(googleLayer); //移除Google图层
        loadGoogleMap(layerType); //根据图层类型重新加载Google图层
    }



</script>
</body>
</html>
