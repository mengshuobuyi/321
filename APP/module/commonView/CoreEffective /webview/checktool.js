/**
 * CheckToolsExist plugin
 *
 */
var CheckToolsExist = function() { 

}

CheckToolsExist.prototype.checkThird = function(successCallback,Name) {

alert("addconstrutor  12123");
    return QWJSBridge.exec(successCallback , null , 'PluginCheckThird' , 'checkThird' , [Name]);
};

QWJSBridge.addConstructor(function() {

alert("addconstrutor");
	QWJSBridge.addPlugin('checkToolsExist', new CheckToolsExist());
});

//window.plugins.checkToolsExist.checkThird(suc,"pdf")