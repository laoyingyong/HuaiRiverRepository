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
    <link href="css/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/ol.css">
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

    </style>
    <script>



    </script>
</head>
<body>
    <div id="map"><%--地图容器--%>
    <span id="mapType">地图类型:</span>
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

</div>
<script>
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
            layers: [googleLayer],
            target: 'map', //地图容器div的ID
            view: new ol.View({
                projection: projection, //投影坐标系
                //center:[12308196.042592192, 2719935.2144997073],
                center:ol.proj.transform([116.83359,32.63142],'EPSG:4326', 'EPSG:3857' ),

                minZoom: 2,
                zoom: 7
            })
        });

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
