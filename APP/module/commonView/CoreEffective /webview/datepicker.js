/**
 * DatePicker plugin
 *
 */

var Datepicker = function() {
alert("datepicker ---");
};

Datepicker.prototype.showDTpicker = function(elementID,maxDate,minDate,dtType) {

alert("prototype 123 ");
alert(elementID);
	QWJSBridge.exec(fillDate, null, "PluginDatePicker", "showdtpicker", [elementID,maxDate,minDate,dtType]);
};

QWJSBridge.addConstructor(function() {
                          alert("add  datepicker");
	QWJSBridge.addPlugin('datepicker', new Datepicker());
});

document.addEventListener("deviceready", onDeviceReady, false);
function onDeviceReady() {
	//window.plugins.datepicker.showDTpicker("username","2011-1-1","2011-12-1","0")
};
