goog.provide('ol.layer.GoogleMapLayer');
goog.require('ol.layer.Tile');
goog.require('ol.source.GoogleMapSource');


/**
* @constructor
* @extends {ol.layer.Tile}
* @fires ol.render.Event
* @param opt_options: Layer options.
* @opt_options: extent(图层范围)，origin(瓦片原点)默认情况下都不需要赋值，则默认取图层范围的左下角
* @opt_options: layerType(图层类型)，默认情况下为"vector"
* @api stable
*/
ol.layer.GoogleMapLayer = function (opt_options) {
    var options = goog.isDef(opt_options) ? opt_options : {};
    goog.base(this,  /** @type {olx.layer.LayerOptions} */(options));

    var source = goog.isDef(options.source) ? options.source : null;

    if (source == null) {
        source = new ol.source.GoogleMapSource(options);
    }
    this.setSource(source);
};
goog.inherits(ol.layer.GoogleMapLayer, ol.layer.Tile);