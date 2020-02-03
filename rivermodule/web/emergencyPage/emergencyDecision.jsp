<%--
  Created by Yingyong Lao.
  User: laoyingyong
  Date: 2020-02-01
  Time: 16:58
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>应急决策处理</title>
    <script src="../js/jquery-1.11.2.min.js"></script>
    <!-- 1. 导入CSS的全局样式 -->
    <script src="../js/bootstrap.min.js"></script>
    <script src="../js/ol-debug.js"></script>
    <script src="../js/GoogleMapSource.js"></script>
    <script src="../js/GoogleMapLayer.js"></script>
    <script src="../js/jquery-ui.js"></script>
    <script src="../js/echarts.min.js"></script>
    <script src="../js/jquery-ui.js"></script>


    <link href="../css/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../css/ol.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/jquery-ui.min.css"/>
    <link rel="stylesheet" href="../css/jquery-ui.min.css"/>
    <script>
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
    </script>
    <style>
        #reset{
            left: 25px;
            top: 100px;
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
    </style>

</head>
<body>

<div class="container-fluid">
    <div class="row">
      <div class="col-sm-12">
          <ul class="nav nav-pills">
              <li role="presentation"><a href="javascript:findPollutedSite();">水质异常站点</a></li>
              <li role="presentation"><a href="javascript:emergency();">应急处理</a></li>
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

          </ul>

      </div>
    </div>

    <div class="row">
        <div class="col-sm-12">

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

            <div id="emergencyDiv" title="应急处理方法" >

            </div>

            <div id="map" style="height: 650px"><%--地图容器--%>

                <div id="popup" class="ol-popup" >
                    <a href="#" id="popup-closer" class="ol-popup-closer"></a>
                    <div id="popup-content">
                    </div>
                </div>

                <div id="mypopup"  ></div><%--热区的popup--%>


                <div id="waterDiv">
                </div>
                <%--复位--%>
                <span id="reset"><button class="btn btn-info btn-xs" data-toggle="tooltip" data-placement="right" title="复位" style="background-color: #7897BC;height:23px;width:23px"><span class="glyphicon glyphicon-repeat" aria-hidden="true"></span></button></span>
            </div><%--地图容器end--%>

        </div>

    </div><%--row end--%>

</div><%--container end--%>

<script>





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


    //实例化地图对象加载地图
    var googleLayer = new ol.layer.GoogleMapLayer({layerType: ol.source.GoogleLayerType.TERRAIN});//Google图层
    var map = new ol.Map({
        logo: false,
        layers: [googleLayer,vectLayer,hotSpotsLayer],
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
                src: '../img/blueIcon.png' //图标的url
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
        geometry: new ol.geom.Point(beijing),
        name: '北京市',  //名称属性
        population: 2115 //大概人口数（万）
    });
    iconFeature.setStyle(createLabelStyle(iconFeature));
    //矢量标注的数据源
    var vectorSource = new ol.source.Vector({
        features: [iconFeature]
    });



    $.post("../FindAlllStationServlet",function (data)
    {
        for(var i=0;i<data.length;i++)
        {
            var obj=data[i];
            var longitude=obj.longitude;
            var latitude=obj.latitude;
            var stationName=obj.stationName;

            //实例化Vector要素，通过矢量图层添加到地图容器中
            var iconFeature2 = new ol.Feature({
                geometry: new ol.geom.Point(ol.proj.fromLonLat([longitude,latitude])),
                name: stationName,  //名称属性
                population: 2115 //大概人口数（万）
            });
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
        var zuobiao=jingdu+","+weidu;
        //判断当前单击处是否有要素，捕获到要素时弹出popup
        var feature = map.forEachFeatureAtPixel(evt.pixel, function (feature, layer) { return feature; });
        if (feature)
        {

            $.post("../FindSimIntroServlet",{zuobiao:zuobiao},function (data)
            {
                var introduction=data.introduction;
                var stationName=data.stationName;
                featuerInfo.att.text=introduction;//正文
                featuerInfo.att.title=stationName;//标题


                content.innerHTML = ''; //清空popup的内容容器
                addFeatrueInfo(featuerInfo); //在popup中加载当前要素的具体信息
                if (popup.getPosition() == undefined)
                {
                    popup.setPosition(coordinate); //设置popup的位置
                }

            });



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











    // 初始化绘制热区要素信息设置对话框
    $("#emergencyDiv").dialog(
        {
            height:400,
            width:500,
            modal: true,  // 创建模式对话框
            autoOpen: false, //默认隐藏对话框
            //对话框打开时默认设置
            open: function (event, ui) {
                $(".ui-dialog-titlebar-close", $(this).parent()).hide(); //隐藏默认的关闭按钮
            },
            //对话框功能按钮
            buttons:
                {
                    "应急方案生成": function ()
                    {

                        $(this).dialog('close'); //关闭对话框
                    },
                    "取消": function ()
                    {
                        $(this).dialog('close'); //关闭对话框
                    }
                }
        });



    function emergency()
    {
        $("#emergencyDiv").dialog("open") ;
    }


    //水质异常站点按钮的回调函数
    function findPollutedSite()
    {

        $.post("../FindPollutedWaterServlet",function (data)
        {
            var divStr='<div  style="z-index: 2000;position: absolute;right: 0px;bottom: 0px;width: 600px;height: 400px;background-color: #ffffff;opacity: 0.9">\n' +
                '                    <table class="table table-bordered">\n' +
                '                        <caption style="font-size: 20px;text-align: center">近两天的异常数据(IV:轻度污染，V:中度污染，劣V：重度污染)</caption>\n' +
                '                        <tr class="success">\n' +
                '                            <th>站点名</th>\n' +
                '                            <th>时间</th>\n' +
                '                            <th>PH</th>\n' +
                '                            <th>溶解氧</th>\n' +
                '                            <th>氨氮</th>\n' +
                '                            <th>高猛酸钾</th>\n' +
                '                            <th>总有机碳</th>\n' +
                '                            <th>水质类别</th>\n' +
                '                        </tr>';
            for(var i=0;i<data.length;i++)
            {
                var obj=data[i];
                var belongStation=obj.belongStation;
                var dateTime=obj.dateTime;
                var dateStr=dateFormat("yyyy-MM-dd HH:mm",new Date(dateTime));
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

                var itemStr='<tr class="info">\n' +
                    '                            <td>'+belongStation+'</td>\n' +
                    '                            <td>'+dateStr+'</td>\n' +
                    '                            <td>'+pH+'</td>\n' +
                    '                            <td>'+dO+'</td>\n' +
                    '                            <td>'+nH4+'</td>\n' +
                    '                            <td>'+cODMn+'</td>\n' +
                    '                            <td>'+tOC+'</td>\n' +
                                                 tdStr+
                    '\n' +
                    '                        </tr>';
                divStr+=itemStr;

            }
            var endStr=' </table>\n' +
                '                </div>';
            divStr+=endStr;
            $("#waterDiv").html(divStr);

        })

        $.post("../FindPollutedSiteServlet",function (data)
        {

            /**
             * 创建矢量标注样式函数,设置image为图标ol.style.Icon
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
                        src: '../img/blueIcon2.png' //图标的url
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

            var vectorSource = new ol.source.Vector({
                features: []
            });

            for(var i=0;i<data.length;i++)
            {
                var obj=data[i];
                var stationName=obj.stationName;
                var longitude=obj.longitude;
                var latitude=obj.latitude;


                //新建一个要素 ol.Feature
                var newFeature = new ol.Feature({
                    geometry: new ol.geom.Point(ol.proj.fromLonLat([longitude,latitude])),//几何信息
                    name: stationName//名称属性
                });
                newFeature.setStyle(createLabelStyle(newFeature));//设置要素的样式
                vectorSource.addFeature(newFeature);//为矢量数据源添加feature


            }

            //矢量标注图层
            var vectorLayer = new ol.layer.Vector({
                source: vectorSource
            });

            map.addLayer(vectorLayer);

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
