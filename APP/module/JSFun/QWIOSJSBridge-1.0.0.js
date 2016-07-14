QWIOSJSBridge = {
queue: {
ready: true,
commands: [],
timer: null
},
_constructors: []
};


// session id for calls
QWIOSJSBridge.sessionKey = 0;


/**
 * List of resource files loaded by QWIOSJSBridge.
 * This is used to ensure JS and other files are loaded only once.
 */
QWIOSJSBridge.resources = {base: true};

/**
 * Determine if resource has been loaded by QWIOSJSBridge
 *
 * @param name
 * @return
 */
QWIOSJSBridge.hasResource = function(name) {
    return QWIOSJSBridge.resources[name];
};

/**
 * Add a resource to list of loaded resources by QWIOSJSBridge
 *
 * @param name
 */
QWIOSJSBridge.addResource = function(name) {
    QWIOSJSBridge.resources[name] = true;
};

/**
 * Add an initialization function to a queue that ensures it will run and initialize
 * application constructors only once QWIOSJSBridge has been initialized.
 * @param {Function} func The function callback you want run once QWIOSJSBridge is initialized
 */
QWIOSJSBridge.addConstructor = function(func) {
    var state = document.readyState;
    if ( ( state == 'loaded' || state == 'complete' ) )
	{
		func();
	}
    else
	{
        QWIOSJSBridge._constructors.push(func);
	}
};


(function()
 {
 var timer = setInterval(function()
                         {
                         var state = document.readyState;
                         
                         if ( ( state == 'loaded' || state == 'complete' ) )
                         {
                         clearInterval(timer); // stop looking
                         // run our constructors list
                         while (setInterval._constructors.length > 0)
                         {
                         var constructor = setInterval._constructors.shift();
                         try
                         {
                         constructor();
                         }
                         catch(e)
                         {
                         if (typeof(console['log']) == 'function')
                         {
                         console.log("Failed to run constructor: " + console.processMessage(e));
                         }
                         else
                         {
                         alert("Failed to run constructor: " + e.message);
                         }
                         }
                         }
                         // all constructors run, now fire the deviceready event
                         var e = document.createEvent('Events');
                         e.initEvent('deviceready');
                         document.dispatchEvent(e);
                         }
                         }, 1);
 })();

// centralized callbacks
QWIOSJSBridge.callbackId = 0;
QWIOSJSBridge.callbacks = {};
QWIOSJSBridge.callbackStatus = {
NO_RESULT: 0,
OK: 1,
CLASS_NOT_FOUND_EXCEPTION: 2,
ILLEGAL_ACCESS_EXCEPTION: 3,
INSTANTIATION_EXCEPTION: 4,
MALFORMED_URL_EXCEPTION: 5,
IO_EXCEPTION: 6,
INVALID_ACTION: 7,
JSON_EXCEPTION: 8,
ERROR: 9
};

/**
 * Execute a QWIOSJSBridge command in a queued fashion, to ensure commands do not
 * execute with any race conditions, and only run when QWIOSJSBridge is ready to
 * receive them.
 *
 */
QWIOSJSBridge.exec = function() {
 
    QWIOSJSBridge.queue.commands.push(arguments);
    if (QWIOSJSBridge.queue.timer == null){
        QWIOSJSBridge.queue.timer = setInterval(QWIOSJSBridge.run_command, 10);
    }
};

/**
 * Internal function used to dispatch the request to QWIOSJSBridge.  It processes the
 * command queue and executes the next command on the list.  Simple parameters are passed
 * as arguments on the url.  JavaScript objects converted into a JSON string and passed as a query string argument of the url.
 *
 * Arguments may be in one of two formats:
 *   FORMAT ONE (preferable)
 * The native side will call QWIOSJSBridge.callbackSuccess or QWIOSJSBridge.callbackError,
 * depending upon the result of the action.
 *
 * @param {Function} success    The success callback
 * @param {Function} fail       The fail callback
 * @param {String} service      The name of the service to use
 * @param {String} action		The name of the action to use
 * @param {String[]} [args]     Zero or more arguments to pass to the method
 *
 * FORMAT TWO
 * @param {String} command Command to be run in QWIOSJSBridge, e.g. "ClassName.method"
 * @param {String[]} [args] Zero or more arguments to pass to the method
 * object parameters are passed as an array object [object1, object2] each object will be passed as JSON strings
 * @private
 */
QWIOSJSBridge.run_command = function() {
    if (!QWIOSJSBridge.queue.ready){
        return;
        
    }
    QWIOSJSBridge.queue.ready = false;
    
    if(!this.jsBridge){
        this.jsBridge = document.createElement("iframe");
		this.jsBridge.setAttribute("style", "display:none;");
		this.jsBridge.setAttribute("height","0px");
		this.jsBridge.setAttribute("width","0px");
		this.jsBridge.setAttribute("frameborder","0");
		document.documentElement.appendChild(this.jsBridge);
    }
    var args = QWIOSJSBridge.queue.commands.shift();
    if (QWIOSJSBridge.queue.commands.length == 0) {
        clearInterval(QWIOSJSBridge.queue.timer);
        QWIOSJSBridge.queue.timer = null;
    }
	
	var service;
	var callbackId = null;
	var start=0;
    try {
 		if (args[0] == null || typeof args[0] === "function") {
            var callback = args[0];
 			service = args[1] + "." + args[2];
			args = args[3];  //array of arguments to
 			callbackId = service + QWIOSJSBridge.callbackId++;
        	if (callback) {
            	QWIOSJSBridge.callbacks[callbackId] = {callback:callback};
        	}
 		} else {
 			service = args[0];
 			start = 1;
 		}
        
        var uri = [];
    	var dict = null;
        
        if (args != null){
            for (var i = start; i < args.length; i++) {
                var arg = args[i];
                if (arg == undefined || arg == null)
                    continue;
                if (typeof(arg) == 'object'){
                    dict = arg;
                }
                else{
                    uri.push(encodeURIComponent(arg));
                }
            }
        }
        
    	var next = callbackId != null  ?  ("/" + callbackId + "/") : "/";
        //add the sessionId in the user field of the URL conforming to RFC1808
        //emp://-1134476704@sms.send/sms.send0/1123123/hello
        var url = "emp://" + QWIOSJSBridge.sessionKey + "@"  + service + next + uri.join("/");
        
    	if (dict != null) {
        	url += "?" + encodeURIComponent(JSON.stringify(dict));
    	}
        this.jsBridge.src = url;
    } catch (e) {
        alert(e);
        console.log("QWIOSJSBridgeExec Error: "+e);
    }
};
/**
 * Called by native code when returning successful result from an action.
 *
 * @param callbackId
 * @param args
 *		args.status - QWIOSJSBridge.callbackStatus
 *		args.message - return value
 *		args.keepCallback - 0 to remove callback, 1 to keep callback in QWIOSJSBridge.callbacks[]
 */
QWIOSJSBridge.callback = function(callbackId, args) {
    
    if (QWIOSJSBridge.callbacks[callbackId]) {
        // If result is to be sent to callback
        try {
            
            QWIOSJSBridge.callbacks[callbackId].callback(args.status,args.message);
        }
        catch (e) {
            console.log("Error in success callback: "+callbackId+" = "+e);
        }
        
        // Clear callback if not expecting any more results
        if (!args.keepCallback) {
            delete QWIOSJSBridge.callbacks[callbackId];
        }
    }
};


/**
 * Does a deep clone of the object.
 *
 * @param obj
 * @return
 */
QWIOSJSBridge.clone = function(obj) {
	if(!obj) {
		return obj;
	}
    
	if(obj instanceof Array){
		var retVal = new Array();
		for(var i = 0; i < obj.length; ++i){
			retVal.push(QWIOSJSBridge.clone(obj[i]));
		}
		return retVal;
	}
    
	if (obj instanceof Function) {
		return obj;
	}
    
	if(!(obj instanceof Object)){
		return obj;
	}
	
	if (obj instanceof Date) {
		return obj;
	}
    
	retVal = new Object();
	for(i in obj){
		if(!(i in retVal) || retVal[i] != obj[i]) {
			retVal[i] = QWIOSJSBridge.clone(obj[i]);
		}
	}
	return retVal;
};

// Intercept calls to document.addEventListener and watch for unload

QWIOSJSBridge.m_document_addEventListener = document.addEventListener;

document.addEventListener = function(evt, handler, capture) {
    var e = evt.toLowerCase();
    if (e === 'unload')
	{
        QWIOSJSBridge.onUnload = function(e){ return handler(e);};
    }
    else
    {
        QWIOSJSBridge.m_document_addEventListener.call(document, evt, handler, capture);
    }
};

// Intercept calls to document.removeEventListener and watch for events that
// are generated by QWIOSJSBridge native code

QWIOSJSBridge.m_document_removeEventListener = document.removeEventListener;

document.removeEventListener = function(evt, handler, capture)
{
    var e = evt.toLowerCase();
    
    if (e === 'unload')
	{
        QWIOSJSBridge.onUnload = null;
    }
    
    QWIOSJSBridge.m_document_removeEventListener.call(document, evt, handler, capture);
};

/**
 * Method to fire event from native code
 */
QWIOSJSBridge.fireEvent = function(type, target) {
    var e = document.createEvent('Events');
    e.initEvent(type);
    
	target = target || document;
	if (target.dispatchEvent === undefined) { // ie window.dispatchEvent is undefined in iOS 3.x
		target = document;
	}
    
    target.dispatchEvent(e);
};

/**
  window back
 
 */
window.back = function(){
    QWIOSJSBridge.exec(null, "window", "back", null);
};

//add by chang, for b2c pay;
//window.bocm_pay.bcomB2C4Pay("changbiao");
///***
if (!QWIOSJSBridge.hasResource("bocm")) {
	QWIOSJSBridge.addResource("bocm");
     alert("bocmb2c4pay------");
    bocm = function() {
    };
    
    window.bocm_pay = bocm;
    
    window.bocm_pay.bocmB2C4Pay = function(params){
        alert("bocmb2c4pay");
        try {
            QWIOSJSBridge.exec(null, "bocm", "b2c4pay", [params]);
        }catch(e){
            alert(e);
        }
    }
    
};

/**
 ********************* 调 Quit 界面 ********************
 */
if (!QWIOSJSBridge.hasResource("quit")) {
    QWIOSJSBridge.addResource("quit");
    
    Quit = function(){
        
    };
    
    Quit.calloutQuitVC = function(merchParams,calloutQuitVC){
        try{
            
            QWIOSJSBridge.exec(calloutQuitVC,"quit","calloutQuitVC", [merchParams]);
        }catch(e){
            alert(e);
        }
    }
    
};

/**
 ********************* 调 Login 界面 ********************
 */
if (!QWIOSJSBridge.hasResource("login")) {
    QWIOSJSBridge.addResource("login");
    
    login = function(){
        
    };
    
    login.calloutLoginVC = function(merchParams,logincallback){
        try{
            
            QWIOSJSBridge.exec(logincallback,"login","calloutLoginVC", [merchParams]);
        }catch(e){
            alert(e);
        }
    }
    
};
/**
 ********************* 李坚测试 ********************
 */
if (!QWIOSJSBridge.hasResource("lijian")) {
    QWIOSJSBridge.addResource("lijian");
    
    lijian = function(){
        
    };
    
    lijian.calloutLijianTest = function(merchParams,lijianCallback){
        try{
            QWIOSJSBridge.exec(lijianCallback,"lijian","calloutLijianTest", [merchParams]);
           
        }catch(e){
            alert(e);
        }
    }
    
};

/**
 ********************* http ******************** a a  a a b c  a a d c  dbabccbadc
 */
if (!QWIOSJSBridge.hasResource("http")) {
    QWIOSJSBridge.addResource("http");
    HttpError = {
        OVERHTTP: 1,
        ERROR :2,
    }
    
    http = function() {
        
    }
    //登出
    http.get= function(url,json,getCallback){
        try{
            QWIOSJSBridge.exec(getCallback,"http","get", [url,json]);
        }catch(e){
            alert(e);
        }
    }
    
    http.post= function(url,json,postCallback){
        alert("come");
        try{
            QWIOSJSBridge.exec(postCallback,"http","post", [url,json]);
        }catch(e){
            alert(e);
        }
    }
    
//    http.async= function(){
//
//    
//    }
//    
//    http.sync=function(){
//    
//    }
    
    
};


/**
 ********************* Camera ********************
 */

if (!QWIOSJSBridge.hasResource("camera")) {
	QWIOSJSBridge.addResource("camera");
    CameraError = {
        UNKNOWN_ERROR : 1,
        NOT_SUPPORT_ERROR :2,
    }
    
    camera = function() {
        
    }
    
    /**
     * Gets a picture from source defined by "options.sourceType", and returns the
     * image as defined by the "options.destinationType" option.
     
     * The defaults are sourceType=CAMERA and destinationType=DATA_URL.
     *
     * @param {Function} callback
     */
    camera.open = function(callback) {
        // callback required
        if (typeof callback != "function") {
            // console.log("Camera Error: successCallback is not a function");
            return;
        }
        QWIOSJSBridge.exec(callback, "camera", "open", null);
    };
};

/**
 ********************* Geolocation ********************
 */
if (!QWIOSJSBridge.hasResource("geolocation")) {
	QWIOSJSBridge.addResource("geolocation");
	GeolocationError = {
        UNKNOWN_ERROR : 1,
        NOT_SUPPORT_ERROR : 2,
        TIME_OUT_ERROR : 3,
        NO_DATA_ERROR : 4,
    }
    
    Position = function(latitude, longitude) {
        this._latitude = latitude; // 纬度（Number）
        this.__defineGetter__("latitude", function(){return this._latitude;});
        this.__defineSetter__("latitude", function(cn){throw {message: "Cannot modify the const attribute"};});
        
        this._longitude = longitude; // 经度 (Number)
        this.__defineGetter__("longitude", function(){return this._latitude;});
        this.__defineSetter__("longitude", function(cn){throw {message: "Cannot modify the const attribute"};});
        
    };
    
    
    geolocation = function() {
        
    }
    
    /**
     * get device location
     *
     * @param {double} accuracy
     * @param {Function} callback
     */
    PluginLocation.getCurrentLocation = function(callback, accuracy) {
        try {
            QWIOSJSBridge.exec(callback, "geolocation", "getCurrentLocation", [accuracy]);
        }catch(e){
            alert(e);
        }
    };
};

/**
 ********************* accelerometer ********************
 */
if (!QWIOSJSBridge.hasResource("accelerometer")) {
	QWIOSJSBridge.addResource("accelerometer");
    AccelerometerError = {
        UNKNOWN_ERROR : 1,
        NOT_SUPPORT_ERROR : 2,
        NO_DATA_ERROR : 3,
    }
    
    Acceleration = function(x, y, z) {
        this._x = x; // 坐标系中x轴坐标值（Number）
        this.__defineGetter__("x", function(){return this._x;});
        this.__defineSetter__("x", function(cn){throw {message: "Cannot modify the const attribute"};});
        
        this._y = y; // 坐标系中y轴坐标值 (Number)
        this.__defineGetter__("y", function(){return this._y;});
        this.__defineSetter__("y", function(cn){throw {message: "Cannot modify the const attribute"};});
        
        this._z = z; // 坐标系中z轴坐标值 (Number)
        this.__defineGetter__("z", function(){return this._z;});
        this.__defineSetter__("z", function(cn){throw {message: "Cannot modify the const attribute"};});
    }
    accelerometer = function() {
        
    }
    
    accelerometer.startAccelerometer = function(callback,interval) {
        try {
            if(typeof callback != "function"){
                return;
            }
            QWIOSJSBridge.exec(callback, "accelerometer", "startAccelerometer", [interval]);
        }catch(e){
            alert(e);
        }
    };
    
    accelerometer.stopAccelerometer = function(callback) {
        try {
            QWIOSJSBridge.exec(callback, "accelerometer", "stopAccelerometer", null);
        }catch(e){
            alert(e);
        }
    };
    
};


/**
 ********************* SMS ********************
 */
if (!QWIOSJSBridge.hasResource("sms")) {
	QWIOSJSBridge.addResource("sms");
	SMSError = {
        UNKNOWN_ERROR : 1,
        NOT_SUPPORT_ERROR : 2,
        SEND_FAIL_ERROR : 3,
        TIME_OUT_ERROR : 4,
    }
    sms = function() {
        
    }
    
    /**
     * create userInterface of send message
     or jump to message application
     *
     *
     * @param {string} phoneNum
     * @param {string} content
     * @param {Function} callback
     */
    sms.send = function(phoneNum, content, callback) {
    	alert("send ====  ");
        try {
            QWIOSJSBridge.exec(callback, "sms", "send", [phoneNum,content]);
        }catch(e){
            alert(e);
        }
    };
};
/**
 ********************* QRCode ********************
 */
if (!QWIOSJSBridge.hasResource("qrcode")) {
    QWIOSJSBridge.addResource("qrcode");
    QRCodeError = {
        UNKNOWN_ERROR : 1,
        NOT_SUPPORT_ERROR : 2,
        SEND_FAIL_ERROR : 3,
        TIME_OUT_ERROR : 4,
    }
    qrcode = function() {
        
    }
    
    /**
     * create userInterface of send message
     or jump to message application
     *
     *
     * @param {string} phoneNum
     * @param {string} content
     * @param {Function} callback
     */
    qrcode.send = function(qrcode, content, callback) {
        try {
            QWIOSJSBridge.exec(callback, "qrcode", "scanQRCode", [qrcode,content]);
        }catch(e){
            alert(e);
        }
        
    };
};






/**
 ********************* Contact ********************
 */
if (!QWIOSJSBridge.hasResource("contact")) {
	QWIOSJSBridge.addResource("contact");
	
    ContactError = {
        UNKNOWN_ERROR : 1,
        OPEN_FAIL_ERROR : 2,
        ADD_FAIL_ERROR : 3,
        DEL_FAIL_ERROR : 4,
    }
    Person = function(firstName, middleName, lastName, phoneNumber, email, address) {
        this.firstName = firstName;
        this.middleName = middleName;
        this.lastName = lastName;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.address = address;
    }
    contact = function() {
        
    }
    
    contact.open = function(callback) {
        try {
            QWIOSJSBridge.exec(callback, "contact", "open", null);
        }catch(e){
            alert(e);
        }
    };
    contact.add = function(array,callback) {
        try {
            QWIOSJSBridge.exec(callback, "contact", "add", [array]);
        }catch(e){
            alert(e);
        }
    };
    contact.delete = function(array,callback) {
        try {
            QWIOSJSBridge.exec(callback, "contact", "delete", [array]);
        }catch(e){
            alert(e);
        }
    };
};
/**
 * This represents the mobile device, and provides properties for inspecting the model, version, UUID of the
 * phone, etc.
 * @constructor
 */

/**
 ********************* device ********************
 */
if (!QWIOSJSBridge.hasResource("device")) {
	QWIOSJSBridge.addResource("device");
    Device = function() {
        this.name = null;
        this.platform = null;
        this.version = null;
        this.uuid = null;
        QWIOSJSBridge.exec(deviceCallback, "device", "getDeviceInfo", null);
        
    };
    
    function deviceCallback(errorCode,info){
        if(errorCode == 0){
            device.available = true;
            device.platform = info.platform;
            device.version = info.version;
            device.name = info.name;
            device.uuid = info.uuid;
        }else{
            device.available = false;
        }
    }
    if (typeof device == "undefined") {
        device = new Device();
    }
};


//    QWIOSJSBridge.addConstructor(
//                               function() {
//                               if (typeof device == "undefined") ;
//                               device = new Device();
//                               }
//                               );

/**
 ********************* NetworkConnection ********************
 */
if (!QWIOSJSBridge.hasResource("QWNetwork")) {
	QWIOSJSBridge.addResource("QWNetwork");
    
    function connectionCallback(errorCode,info){
        if(errorCode == 0){
            http.connectType = info;
        }
    }
    
    QWNetwork = function () {
        this.connectType = null;
        
        QWIOSJSBridge.exec(connectionCallback, "http", "getConnectionInfo", null);
        
    }
    QWNetwork.prototype.isReachable = function (URI, callback){
        QWIOSJSBridge.exec(callback, "http", "isReachable", [URI]);
        
    };
    
    if (typeof http == "undefined") {
        http = new QWNetwork();
    }
    //    QWIOSJSBridge.addConstructor(
    //                               function() {
    //                               if (typeof http == "undefined") {
    //                               http = new QWNetwork();
    //                               }
    //                               }
    //                               );
}
/**
 ********************* file ********************
 */
if (!QWIOSJSBridge.hasResource("file")) {
	QWIOSJSBridge.addResource("file");
    FileError = {
        UNKNOWN_ERROR : 1,
        WRITE_FAIL_ERROR : 2,
        READ_FAIL_ERROR :3,
        REMOVE_FAIL_ERROR : 4,
        GET_FAIL_ERROR : 5,
    }
    
    FileEntry = function(name,path){
        this.name = name;
        this.fullPath = path;
    }
    
    file = function() {
        
    };
    file.write = function(name,data,callback) {
        try {
            QWIOSJSBridge.exec(callback, "file", "write", [name,data]);
        }catch(e){
            alert(e);
        }
    };
    file.read = function(name,type,callback) {
        try {
            QWIOSJSBridge.exec(callback, "file", "read", [name,type]);
        }catch(e){
            alert(e);
        }
    };
    file.remove = function(name,callback) {
        try {
            QWIOSJSBridge.exec(callback, "file", "remove", [name]);
        }catch(e){
            alert(e);
        }
    };
    file.isExist = function(name,callback) {
        try {
            QWIOSJSBridge.exec(callback, "file", "isExist", [name]);
        }catch(e){
            alert(e);
        }
    };
    file.getFile = function(name,callback) {
        try {
            QWIOSJSBridge.exec(callback, "file", "getFile", [name]);
        }catch(e){
            alert(e);
        }
    };
};

/**
 ********************* Database ********************
 */

if (!QWIOSJSBridge.hasResource("database")) {
	QWIOSJSBridge.addResource("database");
    DatabaseError = {
        UNKNOWN_ERROR : 1,
        ADD_FAIL_ERROR : 2,
        GET_FAIL_ERROR : 3,
        INSERT_FAIL_ERROR :4,
        UPDATE_FAIL_ERROR : 5,
        OPEN_FAIL_ERROR : 6,
        CLOSE_FAIL_ERROR : 7,
        EXEC_FAIL_ERROR : 8,
    }
    
    database = function(){
        
    }
    database.addData = function(sql,callback) {
        try {
            QWIOSJSBridge.exec(callback, "database", "addData", [sql]);
        }catch(e){
            alert(e);
        }
    };
    database.getData = function(sql,callback) {
        try {
            QWIOSJSBridge.exec(callback, "database", "getData", [sql]);
        }catch(e){
            alert(e);
        }
    };
    database.deleteData = function(sql,callback) {
        try {
            QWIOSJSBridge.exec(callback, "database", "deleteData", [sql]);
        }catch(e){
            alert(e);
        }
    };
    database.updateData = function(sql,callback) {
        try {
            QWIOSJSBridge.exec(callback, "database", "updateData", [sql]);
        }catch(e){
            alert(e);
        }
    };
};
/**
 ********************* video ********************
 */
/**
 * Create a UUID
 */
function UUIDcreatePart(length) {
    var uuidpart = "";
    for (var i=0; i<length; i++) {
        var uuidchar = parseInt((Math.random() * 256), 10).toString(16);
        if (uuidchar.length == 1) {
            uuidchar = "0" + uuidchar;
        }
        uuidpart += uuidchar;
    }
    return uuidpart;
}
utils = function(){
    
    
}
utils.createUUID = function() {
    return UUIDcreatePart(4) + '-' +
    UUIDcreatePart(2) + '-' +
    UUIDcreatePart(2) + '-' +
    UUIDcreatePart(2) + '-' +
    UUIDcreatePart(6);
};
var mediaObjects = {};
if (!QWIOSJSBridge.hasResource("Video")) {
	QWIOSJSBridge.addResource("Video");
    
    VideoError = {
        UNKNOWN_ERROR : 1,
        NO_FILE_ERROR : 2,
        PLAY_FAIL_ERROR : 3,
        PAUSE_FAIL_ERROR : 4,
        RESUME_FAIL_ERROR : 5,
        STOP_FAIL_ERROR :6,
    }
    
    var Video = function(src,callback) {
        this.id = utils.createUUID();
        mediaObjects[this.id] = this;
        
        this.callback = callback;
        this.src = src;
        QWIOSJSBridge.exec(this.callback, "video", "load", [this.src,this.id]);
    }
    
    Video.prototype.dispose = function() {
        try {
            QWIOSJSBridge.exec(this.callback, "video", "dispose", [this.id]);
        }catch(e){
            alert(e);
        }
    };
    
    /**
     * Start or resume playing audio file.
     */
    Video.prototype.play = function() {
        try {
            QWIOSJSBridge.exec(this.callback, "video", "play", [this.id]);
            
        }catch (e){
            alert(e);
        }
    };
    
    /**
     * Stop playing audio file.
     */
    Video.prototype.stop = function() {
        QWIOSJSBridge.exec(this.callback, "video", "stop", [this.id]);
    };
    
    /**
     * Pause playing audio file.
     */
    Video.prototype.pause = function() {
        QWIOSJSBridge.exec(this.callback, "video", "pause", [this.id]);
    };
    
    
    Video.prototype.resume = function() {
        try {
            QWIOSJSBridge.exec(this.callback, "video", "resume", [this.id]);
        }catch(e){
            alert(e);
        }
    };
};
///**
// ********************* audio ********************
// */
if (!QWIOSJSBridge.hasResource("audio")) {
	QWIOSJSBridge.addResource("audio");
    AudioError = {
        UNKNOWN_ERROR : 1,
        NO_FILE_ERROR : 2,
        PLAY_FAIL_ERROR : 3,
        PAUSE_FAIL_ERROR : 4,
        RESUME_FAIL_ERROR : 5,
        STOP_FAIL_ERROR : 6,
        GET_VOLUME_FAIL_ERROR : 7,
        SET_VOLUME_FAIL_ERROR : 8,
    }
    
    var Audio = function(src,callback) {
        this.id = utils.createUUID();
        mediaObjects[this.id] = this;
        this.src = src;
        this.callback = callback;
        
        QWIOSJSBridge.exec(this.callback, "audio", "load", [this.src,this.id]);
    }
    
    Audio.prototype.dispose = function() {
        try {
            QWIOSJSBridge.exec(this.callback, "audio", "dispose", [this.id]);
        }catch(e){
            alert(e);
        }
    };
    
    
    /**
     * Start or resume playing audio file.
     */
    Audio.prototype.play = function(numberOfLoops) {
        try {
            QWIOSJSBridge.exec(this.callback, "audio", "play", [this.id,numberOfLoops]);
            
        }catch (e){
            alert(e);
        }
    };
    
    /**
     * Stop playing audio file.
     */
    Audio.prototype.stop = function() {
        try {
            QWIOSJSBridge.exec(this.callback, "audio", "stop", [this.id]);
            
        }catch (e){
            alert(e);
        }
    };
    
    /**
     * Pause playing audio file.
     */
    Audio.prototype.pause = function() {
        try {
            QWIOSJSBridge.exec(this.callback, "audio", "pause", [this.id]);
        }catch (e){
            alert(e);
        }
    };
    
    
    Audio.prototype.resume = function() {
        try {
            QWIOSJSBridge.exec(this.callback, "audio", "resume", [this.id]);
        }catch(e){
            alert(e);
        }
    };
    
    Audio.prototype.getMaxVolume = function(callback) {
        try {
            QWIOSJSBridge.exec(callback, "audio", "getMaxVolume", [this.id]);
        }catch(e){
            alert(e);
        }
    };
    Audio.prototype.getMinVolume = function(callback) {
        try {
            QWIOSJSBridge.exec(callback, "audio", "getMinVolume", [this.id]);
        }catch(e){
            alert(e);
        }
    };
    Audio.prototype.getVolume = function(callback) {
        try {
            QWIOSJSBridge.exec(callback, "audio", "getVolume", [this.id]);
        }catch(e){
            alert(e);
        }
    };
    Audio.prototype.setVolume = function(volume,callback) {
        try {
            QWIOSJSBridge.exec(callback, "audio", "setVolume", [this.id,volume]);
        }catch(e){
            alert(e);
        }
    };
};

//=====================================================================
//var dbObjects = {};
//if (!QWIOSJSBridge.hasResource("Database")) {
//	QWIOSJSBridge.addResource("Database");
//    
//    Database = function(name,callback) {
//        this.name = name;
//        this.callback = callback;
//        
//        this.sql = null;
//        this.id = utils.createUUID();
//        dbObjects[this.id] = this;
//        
//        QWIOSJSBridge.exec(this.callback, "database", "open", [this.name,this.id]);
//    }
//    
//    Database.prototype.close = function() {
//        try {
//            QWIOSJSBridge.exec(this.callback, "database", "close", [this.id]);
//        }catch(e){
//            alert(e);
//        }
//    };
//    
//    Database.prototype.exec = function(sql) {
//        try {
//            this.sql = sql;
//            QWIOSJSBridge.exec(this.callback, "database", "exec", [this.sql,this.id]);
//        }catch (e){
//            alert(e);
//        }
//    }
//};
//
