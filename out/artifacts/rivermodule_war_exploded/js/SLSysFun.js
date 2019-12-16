/************************************************************************/
/* 水利信息在线分析服务系统
*@author fmm 2015-06-09/  wjl 2015-10-10
/************************************************************************/
var map;            //地图容器
var labelType;      //当前显示哪一个div
var winHeight;      //屏幕当前高度
var winWidth;       //屏幕当前宽度

var popup; //弹出的Popup
var popupElement = $("#popup");
var popupContent = $("#popup-content");
var popupCloser = $("#popup-closer");

var preFeature = null;  //鼠标选中的前一要素

/*
*	页面初始化，在页面加载完成之后执行
*/
$(function () {

    /**
    * 添加关闭按钮的单击事件（隐藏popup）
    * @return {boolean} Don't follow the href.
    */
    popupCloser.bind("click", function () {
        popup.setPosition(undefined);  //未定义popup位置
        popupCloser.blur(); //失去焦点
        return false;
    });

    initMap();                  //初始化地图容器
    initSQBtn();                //初始化实时水情滑动按钮

    winWidth = $(window).width();
    winHeight = $(window).height();

    // 初始化卫星云图对话框
    $("#dialog").dialog({
        modal: true,  // 创建模式对话框
        autoOpen: false, //默认隐藏对话框
        height: 590, 
        width: 920,
        minWidth: 920,
        minHeight: 590,
        open: function (event, ui) {
            $("#wxytIframe").attr("src", "newYunTu.htm"); //打开对话框时加载卫星云图功能页面
        }
        ,
        close: function (event, ui) {
            $('#wxyt').attr('checked', false); //关闭对话框时不选中【卫星云图】功能项
        }
    });

})

/*
*	页面尺寸发生变化回调函数
*@author fmm 2015-07-17
*/
window.onresize = function () {
    winWidth = $(window).width();
    winHeight = $(window).height();
}

/*
*	地图容器初始化
*/
var googleLayer; //加载的Google图层
var projection = ol.proj.get('EPSG:3857');

function initMap() {
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
            center: [12308196.042592192, 2719935.2144997073],
            minZoom: 2,
            zoom:6
        })
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
    popup = new ol.Overlay(/** @type {olx.OverlayOptions} */({
        element: popupElement,
        autoPan: true,
        positioning: 'bottom-center',
        stopEvent: false,
        autoPanAnimation: {
            duration: 250
        }
    }));
    map.addOverlay(popup);

    /**
    * 为map添加点击事件监听，渲染弹出popup
    */
    map.on('singleclick', function (evt) {
        var coordinate = evt.coordinate;
        //判断当前单击处是否有要素，捕获到要素时弹出popup
        var feature = map.forEachFeatureAtPixel(evt.pixel, function (feature, layer) { return feature; });
        if (feature) {
            popupContent.innerHTML = ''; //清空popup的内容容器
            var type = feature.get('type');
            if (type == "river" || type == "Rver") {
                showDetailsInfo(feature);  //为水情要素点添加popup的信息内容
            }
            else if (type == "sq") {
                showSsyqDetailInfo(feature); //为雨情要素点添加popup的信息内容
            }
            else if (type == "typhoon") {
                showTFDetailsInfo(feature);
            }
            else {
                return;
            }
        }
    });

    /**
    * 为map添加move事件监听，变更图标大小实现选中要素的动态效果
    */
    map.on('pointermove', function (evt) {
        var coordinate = evt.coordinate;
        //判断当前鼠标悬停位置处是否有要素，捕获到要素时设置图标样式
        var feature = map.forEachFeatureAtPixel(evt.pixel, function (feature, layer) { return feature; });
        if (feature) {
            var type = feature.get('type');
            if ((type == undefined) || (type == "tfMarker") || (type == "tfCircle")) {
                return;
            }
            if ((preFeature != null) && (preFeature !== feature)) { //如果当前选中要素与前一选中要素不同，恢复前一要素样式，放大当前要素图标
                var curImgURL = feature.get('imgURL');
                var preImgURL = preFeature.get('imgURL');
                feature.setStyle(createLabelStyle(feature, curImgURL, 1.2));
                preFeature.setStyle(createLabelStyle(preFeature, preImgURL, 0.8));
                preFeature = feature;
            }
            if (preFeature == null) { //如果前一选中要素为空，即当前选中要素为首次选中要素，放大当前要素图标
                var curImgURL = feature.get('imgURL');
                feature.setStyle(createLabelStyle(feature, curImgURL, 1.2));
                preFeature = feature;
            }
        }
        else {
            if (preFeature != null) { //如果鼠标移出前一要素，恢复要素图标样式
                var imgURL = preFeature.get('imgURL');
                preFeature.setStyle(createLabelStyle(preFeature, imgURL, 0.8));
                preFeature = null;
            }
        }
    });
}

/*
*	根据图层类型加载Google地图
*/
function loadGoogleMap(mapType) {
    switch (mapType) {
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

/*
*	初始化图层切换控件
*@ahthor fmm 2015-07-10
*/
function onlayerSwitcherBtn() {
    var layerType = $("#layerSwitcherBtn option:selected").val();
    map.removeLayer(googleLayer); //移除Google图层
    loadGoogleMap(layerType); //根据图层类型重新加载Google图层
}

/*
*	显示某一选项卡的内容，如实时水情、实时雨情、台风路径等
*/
function showContentDiv(type) {
    switch (type) {
        case 1:
            $(".sqDiv").show();
            $(".ssyqDiv").hide();
            $(".tfDiv").hide();
            labelType = 1;
            $("#sssqLi").css("background-color", "#D3D2D2");
            $("#ssyqLi").css("background-color", "#BBC9DE");
            $("#tfljLi").css("background-color", "#BBC9DE");
            break;
        case 2:
            $(".sqDiv").hide();
            $(".ssyqDiv").show();
            $(".tfDiv").hide();
            labelType = 2;
            $("#sssqLi").css("background-color", "#BBC9DE");
            $("#ssyqLi").css("background-color", "#D3D2D2");
            $("#tfljLi").css("background-color", "#BBC9DE");
            break;
        case 3:
            $(".sqDiv").hide();
            $(".ssyqDiv").hide();
            $(".tfDiv").show();
            //$(".tfRightDiv").show();
            labelType = 3;
            $("#sssqLi").css("background-color", "#BBC9DE");
            $("#ssyqLi").css("background-color", "#BBC9DE");
            $("#tfljLi").css("background-color", "#D3D2D2");
            break;
        default:
            break;
    }
}

/*
*	初始化实时水情、实时雨情、台风路径滑动按钮
*@ahthor fmm 2015-06-15
*/
function initSQBtn() {
    //实时水情滑动按钮
    $("#sqSplitBtn").click(function () {
        switch (labelType) {
            case 1:
                $(".sqDiv").toggle("show");
                if ($(".sqDiv").width() == 295) {
                    $(".LabelList").hide("slow");
                    $("#sqSplitBtn").animate({ right: 0 });
                    $(".sqSplitDiv").css("background-position", "-28 0");
                } else {
                    $(".LabelList").show("slow");
                    $("#sqSplitBtn").animate({ right: 290 });
                    $(".sqSplitDiv").css("background-position", "0 0");
                }
                break;
            case 2:
                $(".ssyqDiv").toggle("show");
                if ($(".ssyqDiv").width() == 295) {
                    $(".LabelList").hide("slow");
                    $("#sqSplitBtn").animate({ right: 0 });
                    $(".sqSplitBtn").css("background-position", "-28 0");
                } else {
                    $(".LabelList").show("slow");
                    $("#sqSplitBtn").animate({ right: 290 });
                    $(".sqSplitBtn").css("background-position", "0 0");
                }
                break;
            case 3:
                $(".tfDiv").toggle("show");
                if ($(".tfDiv").width() == 1366) {
                    $(".LabelList").hide("slow");
                    $("#sqSplitBtn").animate({ right: 0 });
                    $(".sqSplitBtn").css("background-position", "-28 0");
                } else {
                    $(".LabelList").show("slow");
                    $("#sqSplitBtn").animate({ right: 296 });
                    $(".sqSplitBtn").css("background-position", "0 0");
                }
                break;
            default:
                break;
        }


    })
}

/***********************************实时水情start*******************************/
var sssqMarkerLayer = null;         //实时水情标注图层
var sssqRiverMarkerArray = null;    //实时水情河流标注数组，用来联系地图上添加的标注与实时水情表格数据
var sssqRverMarkerArray = null;     //实时水情水库标注数组，用来联系地图上添加的标注与实时水情表格数据
var IsRiver = true;                 //是否查询实时水情--河流
var IsRver = false;                 //是否查询实时水情--水库
var sssqMarkerDetailData = null;    //记录每个标注的详细信息

/*
*	实时水情复选框状态改变事件，选中时弹出实时水情详细信息窗体
*/
function sssqStateChange() {
    if ($('#sssq').prop('checked')) {   //显示实时水情详细信息窗体
        if ($("#sssqLi").length == 0) {
            var html = "<li class='labeli' id='sssqLi' onclick='showContentDiv(1)'>实时水情</li>";
            $("#labelUL").append(html);
            labelType = 1;
            changeLabelColor();
        }
        IsRiver = true;                 //初始查询实时水情--河流信息
        IsRver = false;                 //初始不查询实时水情--水库信息
        $(".sqDiv").show("slow");
        $(".ssyqDiv").hide();
        $(".tfDiv").hide(); ;
        $("#sqSplitBtn").animate({ right: 290 });
        $(".sqSplitDiv").show("slow");
        var liWidth = winWidth - 295; ;
        $(".LabelList").animate({ left: liWidth });
        $(".LabelList").show("slow");
        queryWaterInfo("river");

    } else {
        $(".sqDiv").hide("slow");       //隐藏实时水情详细信息窗体   
        if ($("#ssyq").prop("checked") == false && $("#tflj").prop("checked") == false) {
            $(".sqSplitDiv").hide("slow");
        }
        $("#RverInfo").attr("checked", false);
        $("#riverInfo").attr("checked", true);
        clearSssqMarker("river");       //清除添加的标注
        clearSssqMarker("Rver");       //清除添加的标注
        clearMarkerPop();               //清除实时水情标注详细信息框
        $("#sssqRiverTable").remove();
        $("#sssqRverTable").remove();
        $("#sssqLi").remove();
        if ($(".sqDiv").css("display") == "block") {
            changeLabelType();
            changeLabelShow();
        }
    }
}

/*
*	
*/
function changeLabelType() {
    var type = $("#labelUL li:last").text();
    switch (type) {
        case "实时水情":
            labelType = 1;
            break;
        case "实时雨情":
            labelType = 2;
            break;
        case "台风路径":
            labelType = 3
            break;
        default:
            break;
    }
}

function changeLabelShow() {
    switch (labelType) {
        case 1:
            $(".sqDiv").show();
            $(".ssyqDiv").hide();
            $(".tfDiv").hide();
            $("#sssqLi").css("background-color", "#D3D2D2");
            $("#ssyqLi").css("background-color", "#BBC9DE");
            $("#tfljLi").css("background-color", "#BBC9DE");
            break;
        case 2:
            $(".sqDiv").hide();
            $(".ssyqDiv").show();
            $(".tfDiv").hide();
            $("#sssqLi").css("background-color", "#BBC9DE");
            $("#ssyqLi").css("background-color", "#D3D2D2");
            $("#tfljLi").css("background-color", "#BBC9DE");
            break;
        case 3:
            $(".sqDiv").hide();
            $(".ssyqDiv").hide();
            $(".tfDiv").show();
            $("#sssqLi").css("background-color", "#BBC9DE");
            $("#ssyqLi").css("background-color", "#BBC9DE");
            $("#tfljLi").css("background-color", "#D3D2D2");
            break;
        default:
    }
}

function changeLabelColor() {
    switch (labelType) {
        case 1:
            $("#sssqLi").css("background-color", "#D3D2D2");
            $("#ssyqLi").css("background-color", "#BBC9DE");
            $("#tfljLi").css("background-color", "#BBC9DE");
            break;
        case 2:
            $("#sssqLi").css("background-color", "#BBC9DE");
            $("#ssyqLi").css("background-color", "#D3D2D2");
            $("#tfljLi").css("background-color", "#BBC9DE");
            break;
        case 3:
            $("#sssqLi").css("background-color", "#BBC9DE");
            $("#ssyqLi").css("background-color", "#BBC9DE");
            $("#tfljLi").css("background-color", "#D3D2D2");
            break;
        default:
    }

}

/*
*	根据类型查询水库或河流的实时水情
*@author fmm 2015-06-11
*/
function queryWaterInfo(type) {
    var urlStr = encodeURI("Handler.ashx?method=sssq&oper=waterInfo&type=" + type + "&" + Math.random());
    $.ajax({
        type: "get",
        contentType: "application/json",
        url: urlStr,
        success: sssqOnsuccess
    });
}


/*
*	清除实时水情标注,
*@author fmm 2015-06-11
*/
function clearSssqMarker(type) {
    if (sssqMarkerLayer != null) {
        if (type == "river" && sssqRiverMarkerArray != null) {       //清除实时水情--河流信息
            for (var i = 0; i < sssqRiverMarkerArray.length; i++) {
                sssqMarkerLayer.getSource().removeFeature(sssqRiverMarkerArray[i]);//移除河流标注要素
            }
            sssqRiverMarkerArray = null;
        }
        if (type == "Rver" && sssqRverMarkerArray != null) {      //清除实时水情--水库信息
            for (var i = 0; i < sssqRverMarkerArray.length; i++) {
                sssqMarkerLayer.getSource().removeFeature(sssqRverMarkerArray[i]);//移除水库标注要素
            }
            sssqRverMarkerArray = null;
        }
    }
}

/*
*	实时水情查询成功回调函数
*@author fmm 2015-06-11
*/
function sssqOnsuccess(data) {
    var resInfoArray = eval('(' + data + ')');
    if (resInfoArray == null) {
        alert("查询信息失败，请检查数据！");
        return;
    }

    addMarkers(resInfoArray);               //第一个操作：在地图上添加标注
    addResInfoToTable(resInfoArray);        //第二个操作：将数据填到实时水情表格中，并将表格和标注联系起来
}
/**
* 移动地图（以要素为中心点）
* @param {ol.Feature} feature 要素
*/
function moveTo(feature) {
    var geo = feature.getGeometry();
    var coordinate = geo.getCoordinates(); //获取要素点坐标
    map.getView().setCenter(coordinate);//设置地图中心点
}
/**
* 创建标注样式函数
* @param {ol.Feature} feature 要素
* @param {string} imgURL image图标URL
* @param {number} image图标缩放比
*/
var createLabelStyle = function (feature, imgURL, scale) {
    return new ol.style.Style({
        image: new ol.style.Icon(/** @type {olx.style.IconOptions} */({
            anchor: [0.5, 0.5],
            anchorOrigin: 'top-right',
            anchorXUnits: 'fraction',
            anchorYUnits: 'pixels',
            offsetOrigin: 'top-right',
            // offset:[-7.5,-15],
            scale: scale,  //图标缩放比例
            opacity: 1,  //透明度
            src: imgURL  //图标的url
        }))
    });
}


/*
*	根据后台返回的实时水情数据添加标注
*/
function addMarkers(resInfoArray) {
    if (sssqMarkerLayer == null) {
        //实时水情标注的矢量图层
        sssqMarkerLayer = new ol.layer.Vector({
            source:  new ol.source.Vector()
        });
        map.addLayer(sssqMarkerLayer);
    }

    var markerFeature; //标注（矢量要素）

    //实时水情--河流信息可显示
    if (this.IsRiver && $('#riverInfo').prop('checked')) {
        for (var i = 0; i < resInfoArray.length; i++) {
            var lon = resInfoArray[i].SitePntX; //X值
            var lat = resInfoArray[i].SitePntY; //Y值
            var coordinate = [parseFloat(lon), parseFloat(lat)]; //坐标点（ol.coordinate）
            var imgURL = "Libs/images/sssq-green.png"; //正常类型标注图标
            if (resInfoArray[i].WaterPos < resInfoArray[i].WarnNum) {
                imgURL = "Libs/images/sssq-red.png"; //超标类型标注图标
            }            
            //新建标注（Vector要素），通过矢量图层添加到地图容器中
            markerFeature = new ol.Feature({
                geometry: new ol.geom.Point(coordinate), //几何信息（坐标点）
                name: resInfoArray[i].SiteName,  //名称属性
                type: "river",  //类型（河流）
                info: resInfoArray[i],  //标注的详细信息
                imgURL: imgURL,  //标注图标的URL地址
                fid: "river"+ i.toString()
            });
            markerFeature.setStyle(createLabelStyle(markerFeature, imgURL,0.8));
            sssqMarkerLayer.getSource().addFeature(markerFeature);

            if (sssqRiverMarkerArray == null) {
                sssqRiverMarkerArray = new Array();
            }
            sssqRiverMarkerArray.push(markerFeature);
        }
    }

    if (this.IsRver && $('#RverInfo').prop('checked')) {
        for (var i = 0; i < resInfoArray.length; i++) {
            var lon = resInfoArray[i].SitePntX;
            var lat = resInfoArray[i].SitePntY;
            var coordinate = [parseFloat(lon), parseFloat(lat)]; //坐标点（ol.coordinate）
            var imgURL = "Libs/images/sssq-green.png";
            if (resInfoArray[i].WaterPos < resInfoArray[i].WarnNum) {
                imgURL = "Libs/images/sssq-red.png";
            }
            //新建标注（Vector要素），通过矢量图层添加到地图容器中
            markerFeature = new ol.Feature({
                geometry: new ol.geom.Point(coordinate), //几何信息（坐标点）
                name: resInfoArray[i].SiteName,  //名称属性
                type: "Rver",  //类型（河流）
                info: resInfoArray[i],  //标注的详细信息
                imgURL: imgURL,  //标注图标的URL地址
                fid: "Rver" + i.toString() 
            });
            markerFeature.setStyle(createLabelStyle(markerFeature, imgURL, 0.8));
            sssqMarkerLayer.getSource().addFeature(markerFeature);

            if (sssqRverMarkerArray == null) {
                sssqRverMarkerArray = new Array();
            }
            sssqRverMarkerArray.push(markerFeature);
        }
    }
}

/*
*	将实时水情数据添加到表格中
*/
function addResInfoToTable(resInfoArray) {
    //显示实时水情--河流信息
    if (this.IsRiver) {
        var tmpHtml = "<table id='sssqRiverTable'><tr><th>站码</th><th>站名</th><th>水位</th><th>警戒/汛眼</th><th>保证/正常高</th><th>流量</th><th>时间</th><th>地址</th></tr>";
        for (var i = 0; i < resInfoArray.length; i++) {
            var rowData = resInfoArray[i];
            var tr = "<tr class='sssqTrInfo c'><td>" + rowData.SiteNum + "</td><td>" + rowData.SiteName + "</td><td>" + rowData.WaterPos + "</td><td>" + rowData.WarnNum + "</td><td>" +
                rowData.NorNum + "</td><td>" + rowData.FlowNum + "</td><td>" + rowData.tm + "</td><td>" + rowData.SiteAddress + "</td></tr>"
            tmpHtml += tr;
        }
        tmpHtml += "</table>";
        $("#hlxxTab").append(tmpHtml);
        //设置结果列表的当前鼠标焦点项样式
        $(".sssqTrInfo").hover(function () {
            $(this).css("cursor", "pointer");
            $(this).addClass("b");
        }, function () {
            $(this).removeClass("b");
        })
        //单击结果列表项定位到标注点，并打开Popup标注
        $(".sssqTrInfo").click(function () {
            $(this).addClass("a").siblings("tr").removeClass("a");
            var index = $(".sssqTrInfo").index($(this));
            moveTo(sssqRiverMarkerArray[index]); //以当前要素为中心点移动地图
            showDetailsInfo(sssqRiverMarkerArray[index]); // 打开popup
        })
        this.IsRiver = false;
        $("#hlxxTab").show();
        $("#skxxTab").hide();
    }

    //显示实时水情--水库信息
    if (this.IsRver) {
        var tmpHtml = "<table id='sssqRverTable'><tr><th>站码</th><th>站名</th><th>水位</th><th>警戒/汛眼</th><th>保证/正常高</th><th>流量</th><th>时间</th><th>地址</th></tr>";
        for (var i = 0; i < resInfoArray.length; i++) {
            var rowData = resInfoArray[i];
            var tr = "<tr class='sssqTrInfo'><td>" + rowData.SiteNum + "</td><td>" + rowData.SiteName + "</td><td>" + rowData.WaterPos + "</td><td>" + rowData.WarnNum + "</td><td>" +
                rowData.NorNum + "</td><td>" + rowData.FlowNum + "</td><td>" + rowData.tm + "</td><td>" + rowData.SiteAddress + "</td></tr>"
            tmpHtml += tr;
        }
        tmpHtml += "</table>";
        $("#skxxTab").append(tmpHtml);
        //设置结果列表的当前鼠标焦点项样式
        $(".sssqTrInfo").hover(function () {
            $(this).css("cursor", "pointer").css("background-color", "#B2E1FF");
        }, function () {
            $(this).css("background-color", "#F7F7F7");
        })
        //单击结果列表项定位到标注点，并打开Popup标注
        $(".sssqTrInfo").click(function () {
            var index = $(".sssqTrInfo").index($(this));
            moveTo(sssqRverMarkerArray[index]); //以当前要素为中心点移动地图
            showDetailsInfo(sssqRverMarkerArray[index]); // 打开Popup标注
            $(this).css("background-color", "#7FCEFF");
        })
        this.IsRver = false;
        $("#hlxxTab").hide();
        $("#skxxTab").show();
    }
}

/*
*	显示标注对应数据的详细信息，需要进行一次查询操作
*/
function showDetailsInfo(tmark) {
    var type = tmark.get('type');
    var fInfo = tmark.get('info');
    var urlStr = encodeURI("Handler.ashx?method=sssq&oper=WaterHisInfo&type=" + type + "&siteNum=" + fInfo.SiteNum + "&" + Math.random());
    $.ajax({
        type: "get",
        contentType: "application/json",
        url: urlStr,
        async: false,
        success: onshowSiteDetailInfo
    });
    //解析水情点的查询结果，动态创建
    var n = sssqMarkerDetailData[0].SiteName.indexOf(" ");
    var str = sssqMarkerDetailData[0].SiteName.slice(0, n);
    var dataXml = "<graph caption='" + str + "水位信息' yAxisName='水位(m)' baseFontSize='12' baseFont='微软雅黑' showNames='1' decimalPrecision='0' formatNumberScale='0' bgColor='#EEEEEE'  bgAlpha='70'>";
    var names = new Array();
    var values = new Array();
    for (var i = 0; i < sssqMarkerDetailData.length; i++) {
        names[i] = sssqMarkerDetailData[i].tm.split(":")[0] + "时" + "";
        values[i] = sssqMarkerDetailData[i].WaterPos + "";
        dataXml += "<set name='" + names[i] + "' value='" + values[i] + "' />";
    }
    dataXml += "</graph>";

    if ($("#ChartRltdiv").length > 0) {
        $("#ChartRltdiv").remove();
    }
    var time = formatDate(sssqMarkerDetailData[0].TM);
    var html = '<div id="ChartRltdiv" style="width:300px;height:180px;"></div></br>'
                + '<div style="font-size: 13px;line-height: 20px;">最新水位：' + sssqMarkerDetailData[0].WaterPos + '</br>时间：' + time + '</br>站址：' + sssqMarkerDetailData[0].SiteAddress + '</div>';
    
    var geo = tmark.getGeometry();//获取标注要素点的几何
    var coordinate = geo.getCoordinates(); //获取要素点坐标
    popupContent.html(html); //设置Popup容器里的内容
    //创建渲染统计图
    var chartID = tmark.get('fid');
    var ChartObj = new FusionCharts("Libs/FusionCharts/Column3D.swf", chartID, "300", "200");
    ChartObj.setTransparent(true);
    ChartObj.setXMLData(dataXml);
    ChartObj.render("ChartRltdiv");
    //设置Popup的位置，冒泡打开Popup标注
    popup.setPosition(coordinate); 
}

/*
*	时间格式化
*/
Date.prototype.format = function (format) {
    var o = {
        "M+": this.getMonth() + 1, //month
        "d+": this.getDate(), //day
        "h+": this.getHours(), //hour
        "m+": this.getMinutes(), //minute
        "s+": this.getSeconds(), //second
        "q+": Math.floor((this.getMonth() + 3) / 3), //quarter
        "S": this.getMilliseconds() //millisecond
    }
    if (/(y+)/.test(format)) format = format.replace(RegExp.$1,
        (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o) if (new RegExp("(" + k + ")").test(format))
        format = format.replace(RegExp.$1,RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
    return format;
}

/*
*	时间格式化
*/
function formatDate(val) {
    var re = /-?\d+/;
    var m = re.exec(val);
    var d = new Date(parseInt(m[0]));
    // 按【2012-02-13 09:09:09】的格式返回日期
    return d.format("yyyy-MM-dd");
}

/*
*	清除实时水情标注详细信息框
*@author fmm 2015-06-16
*/
function clearMarkerPop() {
    if (popup.getPosition() != undefined) {
        popup.setPosition(undefined); //隐藏popup
    }

}

/*
*	查询标注对应的站点的详细信息
*@author fmm 2015-06-16
*/
function onshowSiteDetailInfo(data) {
    var resInfo = eval('(' + data + ')');
    if (resInfo == null) {
        return;
    }
    sssqMarkerDetailData = resInfo;  //将站点详细信息写到全局变量数组
}

/*
*	显示综合应用模块
*@author fmm 2015-06-09
*/
function showApplyContainer() {
    $("#coverLayer").show("slow");
    $("#comApply").show("slow");
    $(".closeDiv").show("slow");
}

/*
*	隐藏综合应用模块
*@author fmm 2015-06-11
*/
function hideApplyContainer() {
    $("#coverLayer").hide("slow");
    $("#comApply").hide("slow");
    $(".closeDiv").hide("slow");
}

/*
*	勾选河流或水库的操作
*/
function showWaterInfo(type) {
    switch (type) {
        case "river":
            if ($('#riverInfo').prop('checked')) {
                queryWaterInfo(type);
                IsRiver = true;         //表示当前河流信息可显示

            } else {
                $("#sssqRiverTable").remove();
                clearSssqMarker(type);      //清除标注
                clearMarkerPop();
                this.IsRiver = false;
            }
            break;
        case "Rver":
            if ($('#RverInfo').prop('checked')) {
                queryWaterInfo(type);
                IsRver = true;          //表示当前水库信息可显示

            } else {
                $("#sssqRverTable").remove();
                clearSssqMarker(type);      //清除标注
                clearMarkerPop();
                this.IsRver = false;
                $("#hlxxTab").show();
                $("#skxxTab").hide();
            }
            break;
        default:
    }
}

/*
*	判断显示河流table还是水库table
*@author fmm 2015-06-12
*/
function showSssqTab(type) {
    if (type == "river") {
        $("#hlxxTab").show();
        $("#skxxTab").hide();
    } else if (type == "Rver") {
        $("#hlxxTab").hide();
        $("#skxxTab").show();
    }
}
/***********************************实时水情end*******************************/

/***********************************实时雨情start*******************************/
var times = "2008-05-16";
var timee = "2008-05-16";
var timeS = " 08:00:00";
var timeE = " 17:00:00";
var ssyqResInfoArray = new Array();     //记录实时雨情数组
var ssyqMarkerLayer = null;             //实时雨情标注图层
var ssyqMarkerArray = null;             //实时雨情标注数组
var ssyqPopup = null;                   //实时雨情标注详细框
var ssyqMarkerDetailData = null;        //实时雨情详细信息

/*
*	勾选实时雨情勾选框，显示实时雨情div
*@author fmm 2015-07-06
*/
function ssyqStateChanhe() {
    if ($("#ssyqLi").length == 0) {
        var html = "<li class='labeli' id='ssyqLi' onclick='showContentDiv(2)'>实时雨情</li>";
        $("#labelUL").append(html);
        labelType = 2;
        changeLabelColor();
    }
    if ($("#ssyq").prop("checked")) {
        resetSsyqDiv();             //重置实时雨情设置
        $(".sqDiv").hide();
        $(".ssyqDiv").show("slow");
        $(".tftDiv").hide();
        $("#sqSplitBtn").animate({ right: 290 });
        $(".sqSplitDiv").show("slow");
        var liWidth = winWidth - 295; ;
        $(".LabelList").animate({ left: liWidth });
        $(".LabelList").show("slow");
        initYQTimeBtn();
        //查询雨量为100的数据
        var minRain = 50;
        var maxRain = 99.91;
        if (ssyqMarkerLayer == null) {
            //实时雨情标注的矢量图层
            ssyqMarkerLayer = new ol.layer.Vector({
                source: new ol.source.Vector()
            });
            map.addLayer(ssyqMarkerLayer);
        }
        requestRainInfo(minRain, maxRain); //查询数据
    } else {
        $("#ssyqFun").hide("slow");
        if ($("#sssq").prop("checked") == false && $("#tflj").prop("checked") == false) {
            $(".sqSplitDiv").hide("slow");
        }
        clearSsyqMarker();          //清除实时雨情标注
        clearSsyqMarkerPop();       //清除实时雨情标注详细信息框
        $("#ssyqLi").remove();
        if ($(".ssyqDiv").css("display") == "block") {
            changeLabelType();
            changeLabelShow();
        }
    }
}

/*
*	初始化实时雨情时间按钮
*@author fmm 2015-07-07
*/
function initYQTimeBtn() {
    //日前选择控件
    var dates = $("#ssyqfrom1,#ssyqfrom2").datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        yearRange: 'c-150,c+0',
        showAnim: 'slideDown',
        changeYear: true,
        autoSize: true,
        onSelect: function (selectedDate) {
            var option = this.id == "from" ? "minDate" : "maxDate",
                    instance = $(this).data("datepicker"),
                    date = $.datepicker.parseDate(
                        instance.settings.dateFormat ||
                        $.datepicker._defaults.dateFormat,
                        selectedDate, instance.settings);
            dates.not(this).datepicker("option", option, date);
        }
    });

    //小时选择下拉框
    for (var i = 0; i < 24; i++) {
        $("#fromTime").append("<option value='" + i + "'>" + i + "时</option>");
        $("#toTime").append("<option value='" + i + "'>" + i + "时</option>");
    }
    //设置默认的小时
    $('#fromTime').find('option').eq(8).attr("selected", "selected");
    $('#toTime').find('option').eq(17).attr("selected", "selected");
}

/*
*	给实时雨情三个table加上鼠标点击事件
*@author fmm 2015-07-07
*/
function showSsyqTab(type) {
    switch (type) {
        case "ylxx":
            $("#ylxxTab").show();
            $("#gszdylTab").hide();
            $("#ljtjTab").hide();
            break;
        case "gszdyl":
            $("#ylxxTab").hide();
            $("#gszdylTab").show();
            $("#ljtjTab").hide();
            break;
        case "ljtj":
            $("#ylxxTab").hide();
            $("#gszdylTab").hide();
            $("#ljtjTab").show();
            break;
        default:
            break;
    }
}

/*
*	点击雨量勾选框进行查询操作
*@author fmm 2015-07-07
*/
function onRainStateChange() {
    var minRain = 0;    //最小雨量
    var maxRain = 0;    //最大雨量

    //重置实时雨情、各市最大雨量、量级统计table
    resetSsyqTable();
    //将标注点清空
    clearSsyqMarker();

    $(".ylxxCheckbox").each(function () {
        var type = parseInt(this.value);
        if (this.checked == true) {
            switch (type) {
                case 0:
                    minRain = 0;
                    maxRain = 0.89;
                    requestRainInfo(minRain, maxRain);
                    break;
                case 10:
                    minRain = 0.9;
                    maxRain = 9.91;
                    requestRainInfo(minRain, maxRain);
                    break;
                case 25:
                    minRain = 10
                    maxRain = 24.91;
                    requestRainInfo(minRain, maxRain);
                    break;
                case 50:
                    minRain = 25;
                    maxRain = 49.91;
                    requestRainInfo(minRain, maxRain);
                    break;
                case 100:
                    minRain = 50;
                    maxRain = 99.91;
                    requestRainInfo(minRain, maxRain);
                    break;
                case 250:
                    minRain = 100;
                    maxRain = 249.91;
                    requestRainInfo(minRain, maxRain);
                case 260:
                    minRain = 250;
                    maxRain = 1000;
                    requestRainInfo(minRain, maxRain);
                    break;
                default:
                    break;
            }
        }
    });
    clearSsyqMarkerPop();       //清除实时雨情标注详细信息框
}

/*
*	实时查询雨量信息
*@author fmm 2015-07-07
*/
function requestRainInfo(minRain, maxRain) {
    var s = times + timeS;
    var e = timee + timeE;

    var urlStr = encodeURI("Handler.ashx?method=ssyq&oper=rainNum&s=" + s + "&e=" + e + "&minRain=" + minRain + "&maxRain=" + maxRain + "&" + Math.random());
    $.ajax({
        type: "get",
        contentType: "application/json",
        url: urlStr,
        async: false,
        success: onshowRainInfo
    });
}

/*
*	得到实时雨情信息回调方法，将数据添加到实时雨情三个table，并根据返回的数据添加相应的标注到地图上
*@author fmm 2015-07-08
*/
function onshowRainInfo(data) {
    if (ssyqResInfoArray != null) {
        ssyqResInfoArray = new Array();
    }
    ssyqResInfoArray = eval('(' + data + ')');
    //第一步：将数据添加雨量信息table中
    addRainInfoToYlxxTable();
    //第二步：将数据添加到各市最大雨量table中
    addRainInfoToGszdylTable();
    //第三步：将数据添加到量级统计table中
    addRainInfoToLjtjTable();
    //第四步：将数据对应的标注点添加到地图上
    addSsyqMarker();
}

/*
*	将数据添加雨量信息table中
*@author fmm 2015-07-08
*/
function addRainInfoToYlxxTable() {
    var resHtml = "";
    for (var i = 0; i < ssyqResInfoArray.length; i++) {
        resHtml += "<tr class='ssyqYlxxTrInfo ssyqTrInfo c'><td>" + ssyqResInfoArray[i].SiteNum + "</td><td>" + ssyqResInfoArray[i].SiteName + "</td><td>" + ssyqResInfoArray[i].RainNum + "</td><td>" + ssyqResInfoArray[i].SiteAddress + "</td></tr>";
    }
    $("#ylxxTable").append(resHtml);

    $(".ssyqTrInfo").hover(function () {
        $(this).css("cursor", "pointer");
        $(this).addClass("b");
    }, function () {
        $(this).removeClass("b");
    })

    $(".ssyqYlxxTrInfo").click(function () {
        $(this).addClass("a").siblings("tr").removeClass("a");
        var index = $(".ssyqYlxxTrInfo").index($(this));
        moveTo(ssyqMarkerArray[index]); //定位要素
        showSsyqDetailInfo(ssyqMarkerArray[index]); //打开Popup标注，实现详细信息
    })
}

/*
*	将数据添加到各市最大雨量table中
*@author fmm 2015-07-08
*/
function addRainInfoToGszdylTable() {
    var resHtml = "";
    for (var i = 0; i < ssyqResInfoArray.length; i++) {
        resHtml += "<tr class='ssyqZdlyTrInfo ssyqTrInfo c'><td>" + ssyqResInfoArray[i].Pro + "</td><td>" + ssyqResInfoArray[i].SiteName + "</td><td>" + ssyqResInfoArray[i].RainNum + "</td></tr>";
    }
    $("#gszdylTable").append(resHtml);

    $(".ssyqTrInfo").hover(function () {
        $(this).css("cursor", "pointer");
        $(this).addClass("b");
    }, function () {
        $(this).removeClass("b");
    })

    $(".ssyqZdlyTrInfo").click(function () {
        $(this).addClass("a").siblings("tr").removeClass("a");
        var index = $(".ssyqZdlyTrInfo").index($(this));
        moveTo(ssyqMarkerArray[index]);
        showSsyqDetailInfo(ssyqMarkerArray[index]); //打开popup
    })
}

/*
*	将数据添加到量级统计table中
*@author fmm 2015-07-08
*/
function addRainInfoToLjtjTable() {
    for (var i = 0; i < ssyqResInfoArray.length; i++) {
        var rainNum = ssyqResInfoArray[i].RainNum;
        if (rainNum > 0.1 && rainNum < 9.91) {
            $("#tr0").html(parseInt($("#tr0").text()) + 1);
        } else if (rainNum > 10 && rainNum < 24.91) {
            $("#tr1").html(parseInt($("#tr1").text()) + 1);
        } else if (rainNum > 25 && rainNum < 49.91) {
            $("#tr2").html(parseInt($("#tr2").text()) + 1);
        } else if (rainNum > 50 && rainNum < 99.9) {
            $("#tr3").html(parseInt($("#tr3").text()) + 1);
        } else if (rainNum > 100 && rainNum < 249.91) {
            $("#tr4").html(parseInt($("#tr4").text()) + 1);
        } else if (rainNum > 250 && rainNum < 1000) {
            $("#tr5").html(parseInt($("#tr5").text()) + 1);
        }
    }
}

/*
*	添加实时雨情标注，每一个雨量值对应不同的标注，并且在勾选的时候将所有的标注清空重新进行添加
*@author fmm 2015-07-09
*/
function addSsyqMarker() {
    var ssyqMarkerFeature;
    for (var i = 0; i < ssyqResInfoArray.length; i++) {
        var ssyqResInfo = ssyqResInfoArray[i];
        var lon = ssyqResInfo.SitePntX;
        var lat = ssyqResInfo.SitePntY;
        var coordinate = [parseFloat(lon), parseFloat(lat)]; //坐标点（ol.coordinate）
        var imgURL = "Libs/images/shishiyuqing/yq00.png";
        if (ssyqResInfo.RainNum > 0.9 && ssyqResInfo.RainNum < 9.91) {
            imgURL = "Libs/images/shishiyuqing/yq01.png";
        } if (ssyqResInfo.RainNum > 10 && ssyqResInfo.RainNum < 24.91) {
            imgURL = "Libs/images/shishiyuqing/yq02.png";
        } else if (ssyqResInfo.RainNum > 25 && ssyqResInfo.RainNum < 49.91) {
            imgURL = "Libs/images/shishiyuqing/yq03.png";
        } else if (ssyqResInfo.RainNum > 50 && ssyqResInfo.RainNum < 99.9) {
            imgURL = "Libs/images/shishiyuqing/yq04.png";
        } else if (ssyqResInfo.RainNum > 100 && ssyqResInfo.RainNum < 249.91) {
            imgURL = "Libs/images/shishiyuqing/yq05.png";
        } else if (ssyqResInfo.RainNum > 250 && ssyqResInfo.RainNum < 1000) {
            imgURL = "Libs/images/shishiyuqing/yq06.png";
        }

        //新建标注（Vector要素），通过矢量图层添加到地图容器中
        ssyqMarkerFeature = new ol.Feature({
            geometry: new ol.geom.Point(coordinate), //几何信息（坐标点）
            name: ssyqResInfoArray[i].SiteName,  //名称属性
            type: "sq",  //类型（河流）
            info: ssyqResInfo,  //标注的详细信息
            imgURL: imgURL,  //标注图标的URL地址
            fid: "sq" + i.toString()
        });
        ssyqMarkerFeature.setStyle(createLabelStyle(ssyqMarkerFeature, imgURL, 0.8));
        ssyqMarkerLayer.getSource().addFeature(ssyqMarkerFeature);

        if (ssyqMarkerArray == null) {
            ssyqMarkerArray = new Array();
        }
        ssyqMarkerArray.push(ssyqMarkerFeature);
    }
}

/*
*	将实时雨情标注点清空
*@author fmm 2015-07-08
*/
function clearSsyqMarker() {
    if (ssyqMarkerLayer != null) {
        for (var i = 0; ssyqMarkerArray != null && i < ssyqMarkerArray.length; i++) {
            ssyqMarkerLayer.getSource().removeFeature(ssyqMarkerArray[i]); //移除雨情标注要素
        }
        ssyqMarkerArray = null;
    }
}

/*
*	显示实时雨情详细信息
*@author fmm 2015-07-09
*/
function showSsyqDetailInfo(tmark) {
    //    clearSsyqMarkerPop();
    var s = times + timeS;
    var e = timee + timeE;
    var siteNum = tmark.get('info').SiteNum;
    var urlStr = encodeURI("Handler.ashx?method=ssyq&oper=rainInfo&s=" + s + "&e=" + e + "&siteNum=" + siteNum + "&" + Math.random());
    $.ajax({
        type: "get",
        contentType: "application/json",
        url: urlStr,
        async: false,
        success: onshowssyqRainDetailInfo
    });

    var n = ssyqMarkerDetailData[0].SiteName.indexOf(" ");
    var str = ssyqMarkerDetailData[0].SiteName.slice(0, n);
    var dataXml = "<graph caption='" + str + "雨量信息' yAxisName='雨量(mm)' showNames='1' decimalPrecision='0' formatNumberScale='0'  baseFontSize='12' baseFont='微软雅黑' bgColor='#EEEEEE'  bgAlpha='70'>";
    var names = new Array();
    var values = new Array();
    for (var i = 0; i < ssyqMarkerDetailData.length; i++) {
        names[i] = ssyqMarkerDetailData[i].tm.split(":")[0] + "时" + "";
        values[i] = ssyqMarkerDetailData[i].RainNum + "";
        dataXml += "<set name='" + names[i] + "' value='" + values[i] + "' />";
    }
    dataXml += "</graph>";

    if ($("#ChartRltdivSsyq").length > 0) {
        $("#ChartRltdivSsyq").remove();
    }
    var time = formatDate(ssyqMarkerDetailData[0].TM);
    var html = '<div id="ChartRltdivSsyq" style="width:300px;height:180px;"></div></br>'
                + '<div style="font-size: 13px;line-height: 20px;">最新雨量：' + ssyqMarkerDetailData[0].RainNum + '</br>时间：' + time + '</br>站址：' + ssyqMarkerDetailData[0].SiteAddress + '</div>';

    var geo = tmark.getGeometry();
    var coordinate = geo.getCoordinates(); //获取要素点坐标
    popupContent.html(html); //设置Popup容器里的内容
    //创建渲染统计图
    var chartID = tmark.get('fid');
    var ChartObj = new FusionCharts("Libs/FusionCharts/Line.swf", chartID, "300", "200");
    ChartObj.setTransparent(true);
    ChartObj.setXMLData(dataXml);
    ChartObj.render("ChartRltdivSsyq");
    //设置popup的位置
    popup.setPosition(coordinate);
}

/*
*	显示实时雨情详细框，记录请求到的数据
*@author fmm 2015-07-09
*/
function onshowssyqRainDetailInfo(data) {
    var resInfo = eval('(' + data + ')');
    if (resInfo == null) {
        return;
    }
    ssyqMarkerDetailData = resInfo;
}

/*
*	清除实时雨情标注详细框
*@author fmm 2015-07-09
*/
function clearSsyqMarkerPop() {
    popup.setPosition(undefined);  //未定义popup位置
}

/*
*	重置实时雨情设置
*@author fmm 2015-07-08
*/
function resetSsyqDiv() {
    //重置条件选择时间框
    $("#ssyqfrom1").val("2008-05-16");
    $("#ssyqfrom2").val("2008-05-16");
    $('#fromTime').find('option').eq(8).attr("selected", "selected");
    $('#toTime').find('option').eq(17).attr("selected", "selected");

    //重置雨量范围checkbox
    $(".ylxxCheckbox").each(function () {
        $(this).attr('checked', false);
    })
    $(".ylxxCheckbox").eq(4).attr('checked', true);

    //重置雨量信息、各市最大雨量、量级统计table
    resetSsyqTable();
}

/*
*	重置雨量信息、各市最大雨量、量级统计table
*@author fmm 2015-07-08
*/
function resetSsyqTable() {
    //将雨量信息表格清空
    if ($("#ylxxTable").length > 0) {
        $("#ylxxTable").remove();
    }
    var resHtml = "<table id='ylxxTable'><tr><th>站码</th><th>站名</th><th>雨量</th><th>站址</th></tr></table>";
    $("#ylxxTab").append(resHtml);

    //将各市最大雨量表格清空
    if ($("#gszdylTable").length > 0) {
        $("#gszdylTable").remove();
    }
    var resHtml = "<table id='gszdylTable'><tr><th>城市</th><th>地区</th><th>最大雨量</th></tr></table>";
    $("#gszdylTab").append(resHtml);

    //将量级统计表格清空
    $("#tr0").html(0);
    $("#tr1").html(0);
    $("#tr2").html(0);
    $("#tr3").html(0);
    $("#tr4").html(0);
    $("#tr5").html(0);
}
/***********************************实时雨情end*******************************/

/***********************************台风路径start*******************************/
var tfljDrawLayer = null;                   //显示台风预警线图层
var tfljPathInfoLayer = null;               //显示台风路径绘制图层
var tfljPntInfoLayer = null;                //显示台风路径点信息图层，即添加标注的图层
var tfMarkerArray = new Array();            //台风标注数组
var tfPathInfoArray = new Array();          //台风路径信息数组
var tfljPopup = null;                       //台风路径标注详细信息弹出框
var tfID = null;                            //台风ID
var tfInfoTimer = null;                     //台风路径信息绘制时间控制器
var tfDetailInfoArray = new Array();        //台风详细信息数组
var tfForcastInfoArray = new Array();       //台风预测信息数组
var tfCurrentMarker = null;                 //显示当前台风位置
var tfCurrentCircle1 = null;                //显示当前台风位置的圆圈1
var tfCurrentCircle2 = null;                //显示当前台风位置的圆圈2
var tfVectorLayer = null;                   //绘制台风的矢量图层

/*
* 勾选【台风路径】，进行三个操作
*第一：显示台风图例版
*第二：显示台风路径
*第三：查询台风数据
*@author fmm 2015-06-16
*/
function tfljStateChange() {
    if ($("#tfljLi").length == 0) {
        var html = "<li class='labeli' id='tfljLi' onclick='showContentDiv(3)'>台风路径</li>";
        $("#labelUL").append(html);
        labelType = 3;
        changeLabelColor();
    }

    //显示台风图例版
    if ($('#tflj').prop('checked')) {
        $(".tfDiv").show("slow");
        $(".sqDiv").hide();
        $(".ssyqDiv").hide();
        $("#sqSplitBtn").animate({ right: 290 });
        $(".sqSplitDiv").show("slow");
        var liWidth = winWidth - 295; ;
        $(".LabelList").animate({ left: liWidth });
        $(".LabelList").show("slow");
        map.getView().setCenter([12308196.042592192, 2719935.2144997073]);
        map.getView().setZoom(5);

        //显示台风路径
        addTfljLine();
        //查询台风数据，并将结果显示在台风模块div中
        queryWindInfo();
    } else {
        $(".tfDiv").hide("slow");
        if ($("#sssq").prop("checked") == false && $("#ssyq").prop("checked") == false) {
            $(".sqSplitDiv").hide("slow");
        }
        $("#tfInfoTab").remove();
        $("#tfDetailedInfoTab").remove();
        if (tfljDrawLayer != null) {
            tfljDrawLayer.getSource().clear();
        }
        clearTfljPop();
        clearTfljMarker();
        clearTfljPath();
        clearTimer();
        clearTFCurrentCircle();
        $("#tfljLi").remove();
        if ($(".tfDiv").css("display") == "block") {
            changeLabelType();
            changeLabelShow();
        }
    }
}

/*
*	显示台风路径
*@author fmm 2015-06-17
*/
function addTfljLine() {
    if (tfljDrawLayer == null) {
        //台风路径标线绘制层
        tfljDrawLayer = new ol.layer.Vector({
            source: new ol.source.Vector()
        });
        map.addLayer(tfljDrawLayer);
    }
    //目前需要添加四条标线
    var dots1 = new Array();
    dots1.push([11757464.4300438, 2154935.91508589]);
    dots1.push([12474016.8603311, 2154935.91508589]);
    dots1.push([12474016.8603311, 3123471.74910458]);
    var lin1 = new ol.geom.LineString(dots1);
    var linFeature1 = new ol.Feature({
        geometry: lin1 //几何信息（坐标点）
    });
    var fStyle1 = new ol.style.Style({
        stroke: new ol.style.Stroke({
            color: '#990000',
            width: 0.5
        })
    });
    linFeature1.setStyle(fStyle1);
    tfljDrawLayer.getSource().addFeature(linFeature1); //添加图形1

    var dots2 = new Array();
    dots2.push([12052238.4416644, 1804722.76625729]);
    dots2.push([13358338.895192, 1804722.76625729]);
    dots2.push([13358338.8951928, 3096586.04422852]);
    var lin2 = new ol.geom.LineString(dots2);
    var linFeature2 = new ol.Feature({
        geometry: lin2 //几何信息（坐标点）
    });
    var fStyle2 = new ol.style.Style({
        stroke: new ol.style.Stroke({
            color: '#660066',
            width: 0.5
        })
    });
    linFeature2.setStyle(fStyle2);
    tfljDrawLayer.getSource().addFeature(linFeature2); //添加图形2

    var dots3 = new Array();
    dots3.push([12245143.9872601, 1689200.13960789]);
    dots3.push([14137575.3307457, 2511525.23484571]);
    dots3.push([14137575.3307457, 4028802.02613441]);
    var lin3 = new ol.geom.LineString(dots3);
    var linFeature3 = new ol.Feature({
        geometry: lin3 //几何信息（坐标点）
    });
    var fStyle3 = new ol.style.Style({
        stroke: new ol.style.Stroke({
            color: '#6666FF',
            width: 0.5
        })
    });
    linFeature3.setStyle(fStyle3);
    tfljDrawLayer.getSource().addFeature(linFeature3); //添加图形3

    var dots4 = new Array();
    dots4.push([12245143.9872601, 1689200.13960789]);
    dots4.push([13914936.3491592, 1689200.13960789]);
    dots4.push([14694172.7847121, 2511525.23484571]);
    dots4.push([14694172.7847121, 4028802.02613441]);
    var lin4 = new ol.geom.LineString(dots4);
    var linFeature4 = new ol.Feature({
        geometry: lin4 //几何信息（坐标点）
    });
    var fStyle4 = new ol.style.Style({
        stroke: new ol.style.Stroke({
            color: '#009900',
            width: 0.5
        })
    });
    linFeature4.setStyle(fStyle4);
    tfljDrawLayer.getSource().addFeature(linFeature4); //添加图形4
}

/*
*	查询台风路径信息
*@author fmm 2015-06-17
*/
function queryWindInfo() {
    var urlStr = encodeURI("Handler.ashx?method=tflj&oper=tfInfo&" + Math.random());
    $.ajax({
        type: "get",
        contentType: "application/json",
        url: urlStr,
        success: tfljOnsuccess
    });
}

/*
*	查询台风路径信息回调函数
*@author fmm 2015-06-17
*/
function tfljOnsuccess(data) {
    var resInfoArray = eval('(' + data + ')');
    addTFResInfoToTable(resInfoArray);
}

/*
*	添加台风信息到table中
*@author fmm 2015-06-17
*/
function addTFResInfoToTable(resInfoArray) {
    var tmpHtml = "<table id='tfInfoTab'><tr><th>选择</th><th>台风编号</th><th>台风名</th><th>英文名</th></tr>";
    for (var i = 0; i < resInfoArray.length; i++) {
        var rowData = resInfoArray[i];
        var tr = "<tr class='tfljTrInfo'><td><input type='checkbox' id='tfCheckBox' onchange='queryTFDetailInfo(this)'></td><td>" + rowData.windid + "</td><td>" + rowData.windname + "</td><td>" + rowData.windeng + "</td></tr>"
        tmpHtml += tr;
    }
    tmpHtml += "</table>";
    $("#tftjxzTab").append(tmpHtml);
    //列表中鼠标选择切换每项的样式
    $(".tfljTrInfo").hover(function () {
        $(this).css("cursor", "pointer").css("background-color", "#B2E1FF");
    }, function () {
        $(this).css("background-color", "#F7F7F7");
    })
}

/*
*	查询某一个台风的具体信息（先查询预测信息，再查询详细信息）
*@author fmm 2015-06-17
*/
function queryTFDetailInfo(obj) {
    if ($("#tfCheckBox").prop("checked")) {
        var n = obj.parentNode.parentNode.childNodes[1].innerHTML.indexOf(" ");
        tfID = obj.parentNode.parentNode.childNodes[1].innerHTML.slice(0, n);

        //第三步：查询详细信息
        var urlStr2 = encodeURI("Handler.ashx?method=tflj&oper=detailInfo&tfID=" + tfID + "&" + Math.random());
        $.ajax({
            type: "get",
            contentType: "application/json",
            url: urlStr2,
            async: false,
            success: tfljDetailOnsuccess
        });
    } else {
        $("#tfDetailedInfoTab").remove();
        clearTfljPop();
        clearTfljMarker();
        clearTfljPath();
        clearTimer();
        clearTFCurrentCircle();
    }
}

/*
*	将查询到的详细信息绘制到表格
*/
function tfljDetailOnsuccess(data) {
    var resInfoArray = eval('(' + data + ')');
    addTFDetailedInfoToTable(resInfoArray);     //第一步：将信息添加到表格
    tfDetailInfoArray = resInfoArray;
    drawTFPathInfo(tfDetailInfoArray);          //第二步：画出台风的路径信息，包括标注点和路径线
    //查询台风预测信息
    var urlStr = encodeURI("Handler.ashx?method=tflj&oper=forcastInfo&tfID=" + tfID + "&" + Math.random());
    $.ajax({
        type: "get",
        contentType: "application/json",
        url: urlStr,
        async: false,
        success: tfljForcastOnsuccess
    });
}

/*
*	查询到的预测信息
*@author fmm 2015-06-17
*/
function tfljForcastOnsuccess(data) {
    var resInfoArray = eval('(' + data + ')');
    tfForcastInfoArray = resInfoArray;
}

/*
*	将台风详细信息添加到表格
*@author fmm 2015-06-17
*/
function addTFDetailedInfoToTable(resInfoArray) {
    var tmpHtml = "<table id='tfDetailedInfoTab'><tr><th>时间</th><th>风力</th><th>风速</th></tr>";
    for (var i = 0; i < resInfoArray.length; i++) {
        var rowData = resInfoArray[i];
        var tr = "<tr class='tfljDetailedTrInfo'><td style='width:140px'>" + resInfoArray[i].tm + "</td><td>" + resInfoArray[i].windstrong + "</td><td>" + resInfoArray[i].windspeed + "</td></tr>"
        tmpHtml += tr;
    }
    tmpHtml += "</table>";
    $("#tfljTab").append(tmpHtml);
    //列表中鼠标选择切换每项的样式
    $(".tfljDetailedTrInfo").hover(function () {
        $(this).css("cursor", "pointer");
        $(this).addClass("b");
    }, function () {
        $(this).removeClass("b");
    })
    //列表中每项（即每个详细点）的单击函数，进行定位并弹出Popup标注
    $(".tfljDetailedTrInfo").click(function () {
        var index = $(".tfljDetailedTrInfo").index($(this));
        map.getView().setCenter([resInfoArray[index].jindu, resInfoArray[index].weidu]);
        map.getView().setZoom(7);
        showTFDetailsInfo(resInfoArray[index]); //打开Popup标注
        $(this).addClass("a").siblings("tr").removeClass("a");
    })
}

/*
*	画出台风的详细路径信息
*@author fmm 2015-06-18
*/
function drawTFPathInfo(resInfoArray) {
    if (tfljPathInfoLayer == null) {   //将台风路径信息图层加入到地图容器       
        tfljPathInfoLayer = new ol.layer.Vector({
            source: new ol.source.Vector()
        });
        map.addLayer(tfljPathInfoLayer);
    }

    if (tfVectorLayer == null) {       //将当前台风标识绘制层添加到地图容器       
        tfVectorLayer = new ol.layer.Vector({
            source: new ol.source.Vector()
        });
        map.addLayer(tfVectorLayer);
    }

    if (tfljPntInfoLayer == null) {    //将台风点信息图层加入到地图容器
        tfljPntInfoLayer = new ol.layer.Vector({
            source: new ol.source.Vector()
        });
        map.addLayer(tfljPntInfoLayer);

    }     
    //将地图中心移到第一个点的位置，并将地图级数放大两级
    map.getView().setCenter([resInfoArray[0].jindu, resInfoArray[0].weidu]);
    map.getView().setZoom(7);
   //设置计时器动态绘制路径点与路径线
    var i = 0;
    tfInfoTimer = setInterval(function () {
        if (i < resInfoArray.length) {
            addTFPath(i, resInfoArray[i++]); //绘制台风路径点与路径线
        }
        else {
            drawTFForcastInfo();             //绘制台风的预测路径信息
            if (tfInfoTimer != null) {
                clearInterval(tfInfoTimer);
                tfInfoTimer = null;
            }
        }
    }, 300);
}

/*
*	画出台风的预测路径信息，包括标注点以及移动路径，每个国家预测路径用不同的颜色表示
*@author fmm 2015-06-18
*/
function drawTFForcastInfo() {
    var typhoonFeature;

    //第一步：画出预测台风标注点
    for (var i = 0; i < tfForcastInfoArray.length; i++) {
        simplePntInfo = tfForcastInfoArray[i]; //单个预测点
        var lon = simplePntInfo.jindu;
        var lat = simplePntInfo.weidu;
        var coord = [lon, lat]; //预测点坐标
        var n = 0;
        var tfGrade = 5;    //若无台风风力，则默认为热带气压
        var imgURL = null;
        if (simplePntInfo.windstrong != null) {
            n = simplePntInfo.windstrong.indexOf("级");
            tfGrade = simplePntInfo.windstrong.slice(0, n);
        }
        if (tfGrade == 4 || tfGrade == 5 || tfGrade == 6 || tfGrade == "         ") {
            imgURL = "Libs/images/taifeng/Wind00.png";
        }
        if (tfGrade == 7) {                             //热带气压
            imgURL = "Libs/images/taifeng/Wind06.png";
        } else if (tfGrade == 8 || tfGrade == 9) {      //热带风暴
            imgURL = "Libs/images/taifeng/Wind05.png";
        } else if (tfGrade == 10 || tfGrade == 11) {    //强热带风暴
            imgURL = "Libs/images/taifeng/Wind04.png";
        } else if (tfGrade == 12 || tfGrade == 13) {    //台风
            imgURL = "Libs/images/taifeng/Wind02.png";
        } else if (tfGrade == 14 || tfGrade == 15) {    //强台风
            imgURL = "Libs/images/taifeng/Wind03.png";
        } else if (tfGrade == 16) {                     //超强台风
            imgURL = "Libs/images/taifeng/Wind01.png";
        }

        //添加预测台风路径点，即新建标注（Vector要素）并添加到地图容器中
        typhoonFeature = new ol.Feature({
            geometry: new ol.geom.Point(coord), //几何信息（坐标点）
            //            name: resInfoArray[i].SiteName,  //名称属性
            type: "typhoon",  //类型（台风）
            info: simplePntInfo,  //标注的详细信息
            imgURL: imgURL,  //标注图标的URL地址
            fid: "typhoonPoint" + i.toString()
        });
        typhoonFeature.setStyle(createLabelStyle(typhoonFeature, imgURL, 0.8));
        tfljPntInfoLayer.getSource().addFeature(typhoonFeature);

        if (tfMarkerArray == null) {
            tfMarkerArray = new Array();
        }
        tfMarkerArray.push(typhoonFeature);
    }

    //第二步：画出预测台风路径线
    var dots1 = new Array();
    var dots2 = new Array();
    var dots3 = new Array();
    var dots4 = new Array();

    dots1.push([tfDetailInfoArray[tfDetailInfoArray.length - 1].jindu, tfDetailInfoArray[tfDetailInfoArray.length - 1].weidu]);
    dots2.push([tfDetailInfoArray[tfDetailInfoArray.length - 1].jindu, tfDetailInfoArray[tfDetailInfoArray.length - 1].weidu]);
    dots3.push([tfDetailInfoArray[tfDetailInfoArray.length - 1].jindu, tfDetailInfoArray[tfDetailInfoArray.length - 1].weidu]);
    dots4.push([tfDetailInfoArray[tfDetailInfoArray.length - 1].jindu, tfDetailInfoArray[tfDetailInfoArray.length - 1].weidu]);

    var dot = null;
    for (var i = 0; i < tfForcastInfoArray.length; i++) {
        var forecast = tfForcastInfoArray[i].forecast.slice(0, tfForcastInfoArray[i].forecast.indexOf(" ")); //国家属性
        dot = [tfForcastInfoArray[i].jindu, tfForcastInfoArray[i].weidu]; //台风预测点
        switch (forecast) {
            case "中国":
                dots1.push(dot);
                break;
            case "日本":
                dots2.push(dot);
                break;
            case "中国台湾":
                dots3.push(dot);
                break;
            case "美国":
                dots4.push(dot);
                break;
            default:
                break;
        }
    }

    var linFeature1 = new ol.Feature({
        geometry: new ol.geom.LineString(dots1) // 中国大陆预测线几何信息
    });
    //设置线1的样式
    linFeature1.setStyle(new ol.style.Style({
            stroke: new ol.style.Stroke({
                color: 'red',
                lineDash: [5,5],
                width: 1
            })
        })
    );
    var linFeature2 = new ol.Feature({
        geometry: new ol.geom.LineString(dots2) //日本预测线几何信息
    });
    //设置线2的样式
    linFeature2.setStyle(new ol.style.Style({
            stroke: new ol.style.Stroke({
                color: 'green',
                lineDash: [5,5],
                width: 1
            })
        })
    );
   var linFeature3 = new ol.Feature({
       geometry: new ol.geom.LineString(dots3) //中国台湾预测线几何信息
    });
    //设置线3的样式
    linFeature3.setStyle(new ol.style.Style({
            stroke: new ol.style.Stroke({
                color: 'gray',
                lineDash: [5,5],
                width: 1
            })
        })
    );
   var linFeature4 = new ol.Feature({
       geometry: new ol.geom.LineString(dots4) //美国预测线几何信息
    });
    //设置线4的样式
    linFeature4.setStyle(new ol.style.Style({
            stroke: new ol.style.Stroke({
                color: 'black',
                lineDash: [5,5],
                width: 1
            })
        })
    );
    //添加线要素
    tfljPathInfoLayer.getSource().addFeatures([linFeature1,linFeature2,linFeature3,linFeature4]);
}

/*
*	添加单个点(即路径点与路径线)
*@author fmm 2015-06-18
*/
function addTFPath(i, simplePntInfo) {
    var typhoonFeature; //台风路径点要素
    var size = map.getSize();  //地图容器的大小
    var bound = map.getView().calculateExtent(size); //当前地图范围
    //根据当前地图范围移动地图
    if (bound[1] > simplePntInfo.jindu || bound[2] > simplePntInfo.weidu || bound[3] < simplePntInfo.jindu || bound[0] < simplePntInfo.weidu) {
        map.getView().setCenter([simplePntInfo.jindu, simplePntInfo.weidu]);
        map.getView().setZoom(7);
    }
    var lon = simplePntInfo.jindu;
    var lat = simplePntInfo.weidu;
    var coord = [lon, lat]; //台风路径点坐标
    //第一步：绘制当前台风图片，并在台风图片的周围画两个圆圈
    //（1）绘制台风周围的圆形
    drawTFCircle([lon, lat + 20000]); //绘制圆
    //（2）绘制当前台风的图片标注
    if (tfCurrentMarker != null) {
        tfljPntInfoLayer.getSource().removeFeature(tfCurrentMarker);
    }
    var currentImg = "Libs/images/taifeng/taifeng.gif";
    tfCurrentMarker = new ol.Feature({
        geometry: new ol.geom.Point(coord), //几何信息（坐标点）
        type: "tfMarker"  //类型（当前台风标识）
    });
    var currentMarkerStyle = new ol.style.Style({
        image: new ol.style.Icon(/** @type {olx.style.IconOptions} */({
            anchorOrigin: 'bottom-left',
            anchorXUnits: 'fraction',
            anchorYUnits: 'pixels',
            offsetOrigin: 'bottom-left',
            scale: 1,  //图标缩放比例
            opacity: 1,  //透明度
            src: currentImg  //图标的url
        }))
    });
    tfCurrentMarker.setStyle(currentMarkerStyle);
    tfljPntInfoLayer.getSource().addFeature(tfCurrentMarker);
    //第二步：绘制台风路径
    var n = 0;
    var tfGrade = 5;    //若无台风风力，则默认为热带气压
    if (simplePntInfo.windstrong != null) {
        n = simplePntInfo.windstrong.indexOf("级");
        tfGrade = simplePntInfo.windstrong.slice(0, n);
    }
    var imgURL = null;
    if (tfGrade == 4 || tfGrade == 5 || tfGrade == 6) {
        imgURL = "Libs/images/taifeng/Wind00.png";
    }
    if (tfGrade == 7) {                             //热带气压
        imgURL = "Libs/images/taifeng/Wind06.png";
    } else if (tfGrade == 8 || tfGrade == 9) {      //热带风暴
        imgURL = "Libs/images/taifeng/Wind05.png";
    } else if (tfGrade == 10 || tfGrade == 11) {    //强热带风暴
        imgURL = "Libs/images/taifeng/Wind04.png";
    } else if (tfGrade == 12 || tfGrade == 13) {    //台风
        imgURL = "Libs/images/taifeng/Wind02.png";
    } else if (tfGrade == 14 || tfGrade == 15) {    //强台风
        imgURL = "Libs/images/taifeng/Wind03.png";
    } else if (tfGrade == 16) {                     //超强台风
        imgURL = "Libs/images/taifeng/Wind01.png";
    }
    //台风路径点标注要素
    typhoonFeature = new ol.Feature({
        geometry: new ol.geom.Point(coord), //几何信息（坐标点）
        type: "typhoon",  //类型（台风）
        info: simplePntInfo,  //标注的详细信息
        imgURL: imgURL,  //标注图标的URL地址
        fid: "typhoonPoint" + i.toString()
    });
    typhoonFeature.setStyle(createLabelStyle(typhoonFeature, imgURL, 0.8));
    tfljPntInfoLayer.getSource().addFeature(typhoonFeature);
    //将台风路径点要素添加到对应缓存数组中
    if (tfMarkerArray == null) {
        tfMarkerArray = new Array();
    }
    tfMarkerArray.push(typhoonFeature);

    //将台风点添加到台风路径数组
    var dot = [simplePntInfo.jindu, simplePntInfo.weidu];
    if (tfPathInfoArray == null) {
        tfPathInfoArray = new Array();
    }
    tfPathInfoArray.push(dot);
    //绘制的不是第一个点，则要绘制中间的路径线
    if (i > 0) {     
        var linFeature = new ol.Feature({
            geometry: new ol.geom.LineString(tfPathInfoArray)  //线的几何信息（坐标点）
        });
        //设置线要素的样式
        linFeature.setStyle(new ol.style.Style({
                stroke: new ol.style.Stroke({
                    color: '#EE0000',
                    width: 2
                })
            })
        );
        tfljPathInfoLayer.getSource().addFeature(linFeature); //添加线要素
    }
}

/*
*	绘制台风周围的圆形
*@author fmm 2015-07-14
*/
function drawTFCircle(origin) {
    if (tfCurrentCircle1 != null) {
        clearTFCurrentCircle();
    }
    var origin = origin;
    var radius1 = 40000;
    var radius2 = 80000;

    tfCurrentCircle1 = new ol.Feature({
        geometry: new ol.geom.Circle(origin, radius1), //第一个圆的几何信息
        type: 'tfCircle'
    });
    tfCurrentCircle2 = new ol.Feature({
        geometry: new ol.geom.Circle(origin, radius2), //第二个圆的几何信息
        type: 'tfCircle'
    });
    var circleStyle = new ol.style.Style({
        fill: new ol.style.Fill({
            color: 'rgba(255, 102, 0, 0.2)'
        }),
        stroke: new ol.style.Stroke({
            color: '#ff6600',
            width: 1
        }),
        image: new ol.style.Circle({
            radius: 7,
            fill: new ol.style.Fill({
                color: '#ff6600'
            })
        })
    });
    tfVectorLayer.setStyle(circleStyle);//设置图层要素的样式
    tfVectorLayer.getSource().addFeatures([tfCurrentCircle1, tfCurrentCircle2]); //添加要素
}

/*
*	清除台风图片周围的圆圈
*@author fmm 2015-07-14
*/
function clearTFCurrentCircle() {

    if (tfVectorLayer == null) {
        return;
    }
    else {
        var vectSource = tfVectorLayer.getSource();
        var features = vectSource.getFeatures();
        if (features != null) {
            tfVectorLayer.getSource().clear(); //清除所有要素
            tfCurrentCircle1 = null;
            tfCurrentCircle2 = null;
        }
    }
}
/*
*	显示台风的详细信息
*@author fmm 2015-06-18
*/
function showTFDetailsInfo(tmark) {
//    clearTfljPop();
    var tfInfo = tmark.get('info');
    if (tfInfo.forecast == undefined) {
        var html = '<div class="tfDetail"><div class="tfDetailHeader">详细信息</div><div class="tfDetailInfo">过去时间：' + tfInfo.tm + '</br>'
            + '经&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp 度：' + tfInfo.jindu + '</br> 纬&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp度：' + tfInfo.weidu + '</br>'
            + '最大风力：' + tfInfo.windstrong + '</br>最大风速：' + tfInfo.windspeed + '&nbsp&nbsp&nbsp米/秒</br>中心气压：' + tfInfo.qiya + '&nbsp&nbsp&nbsp百帕</br>'
            + '移动速度：' + tfInfo.movespeed + '&nbsp&nbsp&nbsp公里/小时</br>移动方向：' + tfInfo.movedirect + '</br></div></div>';
    } else {
        var html = '<div class="tfDetail"><div class="tfDetailHeader">详细信息</div><div class="tfDetailInfo">预报机构：' + tfInfo.forecast + '</br>'
            + '到达时间：' + tfInfo.tm + '</br>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp 经度：' + tfInfo.jindu + '</br>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp 纬度：' + tfInfo.weidu + '</br>'
            + '最大风力：' + tfInfo.windstrong + '</br>最大风速：' + tfInfo.windspeed + '&nbsp&nbsp&nbsp米/秒</br>中心气压：' + tfInfo.qiya + '&nbsp&nbsp&nbsp百帕</br>'
            + '移动速度：' + tfInfo.movespeed + '&nbsp&nbsp&nbsp公里/小时</br>移动方向：' + tfInfo.movedirect + '</br></div></div>';
    }

    var geo = tmark.getGeometry();
    var coordinate = geo.getCoordinates(); //获取要素点坐标
    popupContent.html(html); //设置Popup容器里的内容
    //设置popup的位置
    popup.setPosition(coordinate); 
}

/*
*	清除台风路径标注详细信息框
*@author fmm 2015-06-18
*/
function clearTfljPop() {
    if (popup.getPosition() != undefined) {
        popup.setPosition(undefined); //隐藏popup
    }
}

/*
*	清除台风路径标注
*@author fmm 2015-06-18
*/
function clearTfljMarker() {
    if (tfljPntInfoLayer != null) {             //清除标注
        for (var i = 0; i < tfMarkerArray.length; i++) {
            tfljPntInfoLayer.getSource().removeFeature(tfMarkerArray[i]);     
        }
        tfljPntInfoLayer.getSource().removeFeature(tfCurrentMarker);     
        tfMarkerArray = null;
        tfCurrentMarker = null;
    }
}

/*
*	清除台风路径绘制信息
*@author fmm 2015-06-18
*/
function clearTfljPath() {
    if (tfljPathInfoLayer != null) {
        tfljPathInfoLayer.getSource().clear();      //清除路径信息
    }
    tfPathInfoArray = null;
}

/*
*	清除台风路径绘制路径时间控制器
*@author fmm 2015-06-18
*/
function clearTimer() {
    if (tfInfoTimer != null) {
        clearInterval(tfInfoTimer);
        tfInfoTimer = null;
    }
}

/*
*	隐藏台风图例
*@author fmm 2015-06-26
*/
function hideTFContainer() {
    $("#tuliCoverLayer").hide("slow");
    $(".closeDivTF").hide("slow");
    $(".tuliContent").hide("slow");
}

/*
*	显示台风图例
*@author fmm 2015-06-26
*/
function showTFContainer() {
    $("#tuliCoverLayer").show("slow");
    $(".closeDivTF").show("slow");
    $(".tuliContent").show("slow");
}
/***********************************台风路径end*******************************/

/***********************************卫星云图start*******************************/
/*
*	打开新的页面，在新的页面展示卫星云图的信息，此页面无需传入任何参数
*@author fmm 2015-06-24
*/
function wxytStateChange() {
    if ($("#wxyt").prop("checked")) {
        $("#dialog").dialog("open"); //打开卫星云图功能窗口
    }
    else {
        $("#dialog").dialog("close"); //关闭卫星云图功能窗口
    }
}

/***********************************卫星云图end*******************************/

