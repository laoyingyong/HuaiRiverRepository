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
    <%--<link href="css/ol.css" rel="stylesheet">--%>
    <link rel="stylesheet" href="css/jquery-ui.min.css"/>
    <link rel="stylesheet" href="css/bootstrap-select.css">
    <style>
        .layerSwitcherDiv{
            height: 30px;
            magin-right:10px;
            /*position: absolute;*/
            background-color: #F5F5F5;
            /*width: 120px;*/
            border: 1px solid;
            z-index: 2000;/*处在图层的上面*/
            font-size:14px;
            font-family:"微软雅黑";
        }

        #mapSelect{
            right: 0px;
            top: 45px;
            z-index: 2000;
            position: absolute;
        }


        #zoom_in{
            left: 5px;
            top: 90px;
            position: absolute;
            z-index: 2000;
        }
        #zoom_out{
            left: 5px;
            top: 140px;
            position: absolute;
            z-index: 2000;
        }

        #reset{
            left: 5px;
            top: 230px;
            position: absolute;
            z-index: 2000;
        }




        /* 鼠标位置控件层样式设置 */
        #mouse-position
        {
            float:left;
            position:absolute;
            bottom:5px;
            width:140px;
            height:20px;
            z-index:2000;   /*在地图容器中的层，要设置z-index的值让其显示在地图上层*/
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
        <div class="col-sm-1" >
            <select class="layerSwitcherDiv" id="waterQualitySelect" onchange="findByName();">
                <option>--水质监测站--</option>
            </select>
        </div>
        <div class="col-sm-8 col-sm-offset-1">
            <ul class="nav nav-pills">
                <li role="presentation"><a href="javascript:shuiQing();">实时水情</a></li>
                <li role="presentation"><a href="javascript:findSite();">水质站点查询</a></li>
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
                    <select class="selectpicker"  data-style="btn-info" data-width="auto" id="layerSwitcherBtn" onchange="onlayerSwitcherBtn();">
                        <option value="terrain">谷歌地形图</option>
                        <option value="vector">谷歌矢量图</option>
                        <option value="raster">谷歌遥感图</option>
                        <option value="road">谷歌交通图</option>
                    </select>

                </li>
            </ul>

        </div>



    </div><%--row end--%>
    <div class="row">
        <div id="map"><%--地图容器--%>

            <div id="main" style="width: 400px;height:400px;right: 5px;bottom: 5px;position: absolute;z-index: 2000"></div>

            <span id="zoom_in"><button class="btn btn-info btn-sm"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></button></span>
            <span id="zoom_out"><button class="btn btn-info btn-sm"><span class="glyphicon glyphicon-minus" aria-hidden="true"></span></button></span>
            <span id="reset"><button class="btn btn-info btn-sm"><span class="glyphicon glyphicon-repeat" aria-hidden="true"></span></button></span>


            <!-- Popup -->
            <div id="popup2" class="ol-popup" >
                <a href="#" id="popup-closer" class="ol-popup-closer"></a>
                <div id="popup-content">
                </div>
            </div>


            <div id="dialog-confirm" title="图形属性信息设置">
                <label>信息类别(infoType):警戒区域</label><br />
                <label>名称(name):</label>
                <input type="text" value="" id="name" />
                <br />
                <label>省市(city):</label>
                <input type="text"  id="city" placeholder="如：淮南" onchange="getCityValue();"/>
            </div>
            <div id="dialog-delete" title="删除热区要素确认">
                <label>请确认是否删除该要素</label><br />
            </div>

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

            <!-- Popup -->
            <div id="popup"></div>

            <div id="mouse-position" class="bg-info">
            </div>



        </div><%--地图容器end--%>

    </div><%--row end--%>

</div><%--container end--%>



<script>

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
                   '                        <td><button class="btn btn-info btn-xs">查看监测数据</button></td>\n' +
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
                var stationName=obj.stationName;
                var date=obj.date;
                var waterLevel=obj.waterLevel;
                var flow=obj.flow;
                var over=obj.over;

                var hangStr=' <tr class="info">\n' +
                    '                       <td>'+riverName+'</td>\n' +
                    '                       <td>'+stationName+'</td>\n' +
                    '                       <td>'+date+'</td>\n' +
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


    //水质监测站下拉列表状态发生改变时的回调函数
    function findByName()
    {
        var value=$("#waterQualitySelect").val();//获取下拉列表的值

        $.post("ViewWaterQulityInfoServlet",{stationName:value},function (data)
        {
            for(var i=0;i<data.length;i++)
            {
                var obj = data[i];
                var belongStation=obj.belongStation;
                var date=obj.date;
                var ph=obj.ph;
                var phquaity=obj.phquality;
                var oxygen=obj.oxygen;
                var oxygenquality=obj.oxygenquality;
                var nitrogen=obj.nitrogen;
                var nitrogenquality=obj.nitrogenquality;
                var permangan=obj.permangan;
                var permanganquality=obj.permanganquality;
                var orgacarbon=obj.orgacarbon;
                var orgacarbonquality=obj.orgacarbonquality;



                // 基于准备好的dom，初始化echarts实例
                var myChart = echarts.init(document.getElementById('main'));

                // 指定图表的配置项和数据
                var option =
                {
                    title:
                    {
                        x:'center',
                        y: 'bottom',
                        text: belongStation+":"+date
                    },
                    series:
                    {
                        type: 'sunburst',
                        data:
                        [
                        {
                            name: 'PH',
                            children:
                            [{
                                value: 1,
                                name: ph
                            },
                            {
                                value: 1,
                                name: phquaity
                            }
                            ]
                        },
                        {
                            name: '溶解氧',
                            children: [{
                                name: oxygen,
                                value: 1
                            }, {
                                name: oxygenquality,
                                value: 1
                            }]
                        },  {
                            name: '氨氮',
                            children: [{
                                name: nitrogen,
                                value: 1
                            }, {
                                name: nitrogenquality,
                                value: 1
                            }]
                        },
                            {
                                name: '高锰酸钾',
                                children: [{
                                    name: permangan,
                                    value: 1
                                }, {
                                    name: permanganquality,
                                    value: 1
                                }]
                            },
                            {
                                name: '总有机碳',
                                children: [{
                                    name: orgacarbon,
                                    value: 1
                                }, {
                                    name: orgacarbonquality,
                                    value: 1
                                }]
                            }
                        ]
                    }
                };

                // 使用刚指定的配置项和数据显示图表。
                myChart.setOption(option);

            }

        });

        $.post("FindLocationByNameServlet",{stationName:value},function (data)//发送ajax请求
        {
            var longitude = data.longitude;//经度
            var latitude = data.latitude;//纬度
            var stationName=data.stationName;//测站名
            var introduction=data.introduction;//简述

            var stationPosition = ol.proj.fromLonLat([longitude, latitude]);
            //示例标注点的信息对象
            var featuerInfo =
                {
                    geo: stationPosition,
                    att:
                        {
                            title: stationName, //标注信息的标题内容
                            titleURL: "http://www.openlayers.org/", //标注详细信息链接
                            text:introduction, //标注内容简介
                            imgURL: "img/bangbu.png" //标注的图片
                        }
                }


            /**
             * 创建标注样式函数,设置image为图标ol.style.Icon
             * @param {ol.Feature} feature 要素
             */
            var createLabelStyle = function (feature)
            {
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
                geometry: new ol.geom.Point(stationPosition),
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
            var container = document.getElementById('popup2');
            var content = document.getElementById('popup-content');
            var closer = document.getElementById('popup-closer');

            /**
             * 在地图容器中创建一个Overlay
             */
            var popup2 = new ol.Overlay(/** @type {olx.OverlayOptions} */({
                element: container,
                autoPan: true,
                positioning: 'bottom-center',
                stopEvent: false,
                autoPanAnimation:
                    {
                        duration: 250
                    }
            }));
            map.addOverlay(popup2);

            /**
             * 添加关闭按钮的单击事件（隐藏popup）
             * @return {boolean} Don't follow the href.
             */
            closer.onclick = function ()
            {
                popup2.setPosition(undefined);  //未定义popup位置
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
                    if (popup2.getPosition() === undefined)
                    {
                        popup2.setPosition(coordinate); //设置popup的位置
                    }
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





    //实例化鼠标位置控件（MousePosition）
    var mousePositionControl = new ol.control.MousePosition({
        coordinateFormat: ol.coordinate.createStringXY(4), //坐标格式
        projection: 'EPSG:4326',//地图投影坐标系（若未设置则输出为默认投影坐标系下的坐标）
        className: 'custom-mouse-position', //坐标信息显示样式，默认是'ol-mouse-position'
        target: document.getElementById('mouse-position'), //显示鼠标位置信息的目标容器
        undefinedHTML: '&nbsp;'//未定义坐标的标记
    });



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





    var map;//声明一个地图对象
    //地图容器初始化
    var googleLayer; //加载的Google图层
    var projection = ol.proj.get('EPSG:3857');

    //初始化Google图层
    googleLayer = new ol.layer.GoogleMapLayer({
        layerType: ol.source.GoogleLayerType.TERRAIN
        });
        //初始化地图容器
    map = new ol.Map({
            layers: [googleLayer, vectLayer,hotSpotsLayer],
            target: 'map', //地图容器div的ID
            view: new ol.View({
                projection: projection, //投影坐标系
                //center:[12308196.042592192, 2719935.2144997073],
                center:ol.proj.transform([116.83359,32.63142],'EPSG:4326', 'EPSG:3857' ),

                minZoom: 2,
                zoom: 7
            }),
        controls: ol.control.defaults({//地图中默认控件
//                attributionOptions: /** @type {ol.control.Attribution} */({
//                    collapsible: true //地图数据源信息控件是否可展开,默认为true
//                })
        }).extend([mousePositionControl])//加载鼠标位置控件

        });







    /**
     * 在地图容器中创建一个Overlay
     */
    var element = document.getElementById('popup');
    var popup = new ol.Overlay(/** @type {olx.OverlayOptions} */({
        element: element,
        positioning: 'bottom-center',
        stopEvent: false
    }));
    map.addOverlay(popup);


    /**
     * 通过后台查询热区要素
     */
    function selectRegData()
    {
        var opType = "select";  //查询数据
        var tableName = "HotSportsInfo";  //数据表名称

        $.post("../FindAllGraphServlet",{type: opType, table: tableName },function (data)
        {
            if(data.length==0)
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


                var pointArray=geome.split(";")
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

        if (hit)
        {
            //当前鼠标位置选中要素
            var feature = map.forEachFeatureAtPixel(e.pixel,
                function (feature, layer)
                {
                    return feature;
                });
            //如果当前存在热区要素
            if (feature)
            {
                //显示热区图层
                hotSpotsLayer.setVisible(true);
                //控制添加热区要素的标识（默认为false）
                if (preFeature != null)
                {
                    if (preFeature === feature)
                    {
                        flag = true; //当前鼠标选中要素与前一个选中要素相同
                    }
                    else
                    {

                        flag = false; //当前鼠标选中要素不是前一个选中要素
                        hotSpotsSource.removeFeature(preFeature); //将前一个热区要素移除
                        preFeature = feature; //更新前一个热区要素对象
                    }
                }
                //如果当前选中要素与之前选中要素不同，在热区绘制层添加当前要素
                if (!flag)
                {
                    $(element).popover('destroy'); //销毁popup
                    flashFeature = feature; //当前热区要素
                    flashFeature.setStyle(flashStyle); //设置要素样式
                    hotSpotsSource.addFeature(flashFeature); //添加要素
                    hotSpotsLayer.setVisible(true); //显示热区图层
                    preFeature = flashFeature; //更新前一个热区要素对象
                }
                //弹出popup显示热区信息
                popup.setPosition(e.coordinate); //设置popup的位置
                $(element).popover({
                    placement: 'top',
                    html: true,
                    content: feature.get('name')
                });
                $(element).css("width", "120px");
                $(element).popover('show'); //显示popup

            }
            else
            {
                hotSpotsSource.clear(); //清空热区图层数据源
                flashFeature = null; //置空热区要素
                $(element).popover('destroy'); //销毁popup
                hotSpotsLayer.setVisible(false); //隐藏热区图层
            }
        }
        else
        {
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
        var opType = "insert";  //插入数据
        var tableName = "HotSportsInfo";  //数据表名称

       $.post("../AddGraphInfoServlet",{ type: opType, table: tableName, geo: geoData, att: attData},function (data)
       {
           alert(data.msg);

       });


    }

    function getCityValue() //获取城市输入框中的值
    {
        var city = $("#city").val(); //所属城市
        return city;
    }

    /**
     * 将绘制的几何数据与对话框设置的属性数据提交到后台处理
     */
    function submitData()
    {
        var name = $("#name").val(); //名称
        var city = getCityValue();
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
            function (feature, layer)
            {
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
        var opType = "delete";  //删除数据
        var tableName = "HotSportsInfo";  //数据表名称

        $.post("../DeleGraphServlet",{type: opType, table: tableName, fID: regID},function (data)
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
            open: function (event, ui)
            {
                $(".ui-dialog-titlebar-close", $(this).parent()).hide(); //隐藏默认的关闭按钮
            },
            //对话框功能按钮
            buttons:
            {
                "删除": function ()
                {
                    deleteData(currentFeature);  //通过后台删除数据库中的热区要素数据并同时删除前端绘图
                    $(this).dialog('close'); //关闭对话框
                },
                "取消": function ()
                {
                    $(this).dialog('close'); //关闭对话框

                }
            }
        });


    /**
     * 【显示热区】功能按钮处理函数
     */
    document.getElementById('showReg').onclick = function ()
    {
        map.un('pointermove', pointermoveFun, this); //移除鼠标移动事件监听
        selectRegData(); //通过后台查询热区要素显示并实现热区功能
    };


    /**
     * 【绘制热区】功能按钮处理函数
     */
    document.getElementById('drawReg').onclick = function ()
    {
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
    document.getElementById('deleteReg').onclick = function ()
    {
        map.un('pointermove', pointermoveFun, this); //移除鼠标移动事件监听
        map.un('singleclick', singleclickFun, this); //移除鼠标单击事件监听
        map.on('singleclick', singleclickFun, this); //添加鼠标单击事件监听
    };




    //地图视图的初始参数
    var firstview = map.getView();
    var firstzoom = firstview.getZoom();
    var firstcenter = firstview.getCenter();
    var firstrotation = firstview.getRotation();


    $("#zoom_in").click(function ()
    {
        var view = map.getView();
        var zoom = view.getZoom();
        view.setZoom(zoom + 1);
    });

    $("#zoom_out").click(function ()
    {
        var view = map.getView();
        var zoom = view.getZoom();
        view.setZoom(zoom - 1);
    });

    $("#reset").click(function ()
    {
        firstview.setCenter(firstcenter); //初始中心点
        firstview.setRotation(firstrotation); //初始旋转角度
        firstview.setZoom(firstzoom); //初始缩放级数
    });



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
