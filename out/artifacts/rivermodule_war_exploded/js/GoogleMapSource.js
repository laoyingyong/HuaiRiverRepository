goog.provide('ol.source.GoogleMapSource');
goog.provide('ol.source.GoogleType');
goog.require('ol.source.TileImage');


ol.source.GoogleLayerType = {
    VEC: 'vector',            //Google矢量数据
    RASTER: 'raster',         //Google影像数据
    ROAD: 'road',             //Google道路数据
    TERRAIN: 'terrain'       //Google地形数据
};
/**
* @classdesc
* @constructor
* @param {options} options Google地图参数.
* @api
*/
ol.source.GoogleMapSource = function (options) {

    this.ip = goog.isDef(options.ip) ? options.ip : null;

    this.port = goog.isDef(options.port) ? options.port : null;

    //图层类型，默认为矢量图
    this.layerType = goog.isDef(options.layerType) ? options.layerType : ol.source.GoogleLayerType.VEC,
    /**
    * @public
    * @type {number}
    * 最大分辨率
    */
    this.maxResolution = null;
    //根据投影获取地图范围
    var tileProjection = goog.isDef(options.projection) ? options.projection : null;
    //瓦片范围
    this.tileExtent = [-20037508.3427892, -20037508.3427892, 20037508.3427892, 20037508.3427892];
    if (tileProjection != null) {
        this.tileExtent = tileProjection.getExtent();
    }

    //设置地图范围
    this.extent = goog.isDef(options.extent) ? options.extent : this.tileExtent;

    /**
    * @public
    * @type {Array.<number>}
    * 地图的原点，可由外部指定,默认左下角
    */
    this.origin = goog.isDef(options.origin) ? options.origin : ol.extent.getCorner(this.extent, ol.extent.Corner.TOP_LEFT);
    /**
    * @public
    * @type {number}
    * 瓦片地图总级数
    */
    this.maxZoom = goog.isDef(options.maxZoom) ? (options.maxZoom <= 24 ? options.maxZoom : 24) : 24;

    /**
    * @public
    * @type {number}
    * 地图图片大小
    */
    this.tileSize = goog.isDef(options.tileSize) ? options.tileSize : 256;
    //分辨率数组，根据传入的分辨率或范围计算得到
    this.resolutions = this.getResolutions();

    this.baseURL = goog.isDef(options.baseURL) ? options.baseURL :this.getBaseURL();
    /**
    * @private
    * @type {Array.<number>}
    * 创建网格(内部调用)
    */
    this.tileGrid = new ol.tilegrid.TileGrid({
        origin: this.origin, //数组类型，如[0,0],
        resolutions: this.resolutions, //分辨率
        tileSize: this.tileSize //瓦片图片大小
    });

    goog.base(this, {
        attributions: options.attributions,
        extent: this.extent,
        tileExtent: this.tileExtent,
        ip: this.ip,
        port: this.port,
        layerType: this.layerType,
        logo: options.logo,
        opaque: options.opaque,
        projection: options.projection,
        state: goog.isDef(options.state) ?
        /** @type {ol.source.State} */(options.state) : undefined,
        tileGrid: this.tileGrid,
        tilePixelRatio: options.tilePixelRatio,
        crossOrigin: goog.isDef(options.crossOrigin) ? options.crossOrigin : null  //"anonymous"为跨域调用,
    });

    this.tileUrlFunction = goog.isDef(options.tileUrlFunction) ?
          options.tileUrlFunction :
          this.tileUrlFunctionExtend;

};
goog.inherits(ol.source.GoogleMapSource, ol.source.TileImage);

/**
* 创建基地址
*/
ol.source.GoogleMapSource.prototype.getBaseURL = function () {
    var url_base = "";
    switch (this.layerType) {
        case ol.source.GoogleLayerType.VEC:
            url_base = "http://mt" + Math.round(Math.random() * 3) + ".google.cn/vt/lyrs=m@207000000&hl=zh-CN&gl=CN&src=app&s=Galile";
            break;
        case ol.source.GoogleLayerType.RASTER:
            url_base = "http://mt" + Math.round(Math.random() * 3) + ".google.cn/vt?lyrs=s@173&hl=zh-Hans-CN&gl=CN&token=63145";
            break;
        case ol.source.GoogleLayerType.ROAD:
            url_base = "http://mt" + Math.round(Math.random() * 3) + ".google.cn/vt/imgtp=png32&lyrs=h@248000000,highlight:0x342eaef8dd85f26f:0x39c2c9ac6c582210@1%7Cstyle:maps&hl=zh-CN&gl=CN&src=app&s=Galileo";
            break;
        case ol.source.GoogleLayerType.TERRAIN:
           // url_base = "http://mt" + Math.round(Math.random() * 3) + ".google.cn/vt/lyrs=t@132,r@248000000&hl=zh-CN&src=app&s=Galileo";
            url_base = "http://mt" + Math.round(Math.random() * 3) + ".google.cn/vt/lyrs=t@132,r@249000000&hl=zh-CN&src=app&s=Galileo";
//            url_base = "http://mt" + Math.round(Math.random() * 3) + ".google.cn/vt?lyrs=t&scale=1";
            break;
    }
    return url_base;
}
/**
* 创建分辨率数组
*/
ol.source.GoogleMapSource.prototype.getResolutions = function () {
    if (this.maxResolution == null) {
        var width = ol.extent.getWidth(this.tileExtent);
        var height = ol.extent.getHeight(this.tileExtent);
        this.maxResolution = (width <= height ? height : width) / (this.tileSize);
    }
    var opt_resolutions = new Array(this.maxZoom);
    for (z = 0; z < this.maxZoom; ++z) {
        opt_resolutions[z] = this.maxResolution / Math.pow(2, z);
    }
    return opt_resolutions;
};


/**
* 拼接url取图地址
* @param {Array.<number>} tileCoord 数据格式包含级数、行号、列号.
* @param {string} pixelRatio 像素比率
* @param {ol.proj.Projection} projection 投影
*/
ol.source.GoogleMapSource.prototype.tileUrlFunctionExtend = function (tileCoord, pixelRatio, projection) {
    //判断返回的当前级数的行号和列号是否包含在整个地图范围内
    if (this.tileGrid != null) {
        var tileRange = this.tileGrid.getTileRangeForExtentAndZ(this.extent, tileCoord[0], tileRange);
        if (!tileRange.contains(tileCoord)) {
            return;
        }
    }
    var urlTemplate = "";
    switch (this.layerType) {
        case ol.source.GoogleLayerType.VEC:
        case ol.source.GoogleLayerType.RASTER:
        case ol.source.GoogleLayerType.ROAD:
        case ol.source.GoogleLayerType.TERRAIN:
            urlTemplate = this.baseURL + "&x=" + '{x}' + "&y=" + '{y}' + "&z=" + '{z}';
            break;
    }
    var z = tileCoord[0];
    var x = tileCoord[1];
    var y = -(tileCoord[2] + 1);
    //var y = Math.pow(2, z) - 1 - tileCoord[2];

    return new goog.Uri(urlTemplate.replace('{x}', x.toString()).replace('{y}', y.toString()).replace('{z}', z.toString()));
};