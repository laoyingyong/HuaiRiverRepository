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
    <script src="js/jquery-ui.min.js"></script>
    <link href="css/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <%--<link href="css/ol.css" rel="stylesheet">--%>
    <link rel="stylesheet" href="css/jquery-ui.min.css"/>
    <style>
        .layerSwitcherDiv{
            height: 30px;
            right: 0px;
            top: 0px;
            position: absolute;
            background-color: #F5F5F5;
            width: 120px;
            border: 1px solid;
            z-index: 2000;/*处在图层的上面*/
            font-size:14px;
            font-family:"微软雅黑";
        }

        #mapType{   /*地图类型选择*/
            color:gray;
            right: 130px;
            top:5px;
            position: absolute;
            z-index: 2000;
        }

        #zoom_in{
            left: 5px;
            top: 10px;
            position: absolute;
            z-index: 2000;
        }
        #zoom_out{
            left: 5px;
            top: 60px;
            position: absolute;
            z-index: 2000;
        }

        #reset{
            left: 5px;
            top: 150px;
            position: absolute;
            z-index: 2000;
        }



        #map{
            width:100%;
            height:100%;
        }


        #menu
        {
            width:300px;
            height:45px;
            left:50px;
            top: 10px;
            z-index: 2000;
            position: absolute;
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




    </style>
    <script>



    </script>
</head>
<body>
<div class="container-fluid">
    <div class="row">


        <div id="map"><%--地图容器--%>
            <span id="mapType" >地图类型:</span>
            <span id="zoom_in"><button class="btn btn-info btn-sm"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></button></span>
            <span id="zoom_out"><button class="btn btn-info btn-sm"><span class="glyphicon glyphicon-minus" aria-hidden="true"></span></button></span>
            <span id="reset"><button class="btn btn-info btn-sm"><span class="glyphicon glyphicon-repeat" aria-hidden="true"></span></button></span>
            <!-- 地图底图切换列表 -->
            <select class="layerSwitcherDiv" id="layerSwitcherBtn" onchange="onlayerSwitcherBtn()">
                <option value="terrain">谷歌地形图</option>
                <option value="vector">谷歌矢量图</option>
                <option value="raster">谷歌遥感图</option>
                <option value="road">谷歌交通图</option>
            </select>



            <div id="menu">
                <%--<label class="title" > 热区功能：</label>--%>
                <button id="showReg" class="btn btn-primary btn-sm" title="加载热区后请用鼠标移动到热区范围显示其信息">显示热区</button>
                <button id="drawReg" class="btn btn-primary btn-sm" title="单击绘制热区按钮后请用鼠标在地图上绘制热区">绘制热区</button>
                <button id="deleteReg" class="btn btn-primary btn-sm" title="单击删除热区按钮后请用鼠标在地图上选中删除要素操作">删除热区</button>
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

            <!-- Popup -->
            <div id="popup" class="ol-popup" ></div>

            <div id="mouse-position" class="bg-info">
            </div>



        </div><%--地图容器end--%>


    </div><%--row end--%>

</div><%--container end--%>



<script>

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
            buttons: {
                "提交": function () {
                    submitData(); //提交几何与属性信息到后台处理
                    $(this).dialog('close'); //关闭对话框
                },
                "取消": function () {
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
        if (feature) {
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
