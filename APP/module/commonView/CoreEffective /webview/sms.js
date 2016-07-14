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