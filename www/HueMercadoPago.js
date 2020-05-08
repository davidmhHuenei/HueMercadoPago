var exec = require('cordova/exec');

var MPConfig = function(){
    var publicKey = "";
    var accessToken = "";
};

MPConfig.prototype.init() = function(publicKey, accessToken){
    MPConfig.publicKey = publicKey;
    MPConfig.accessToken = accessToken;
    return this;
};
exports.realizarPago = function (preferenceId, success, error) {
    if (!MPConfig.publicKey || !MPConfig.accessToken){
        error("No se encontraron seteados la publicKey y el accessToken. Debes llamar a MPConfig.init(a, b).");
    }else{
        exec(success, error, 'HueMercadoPago', 'realizarPago', [MPConfig.publicKey, MPConfig.accessToken, preferenceId]);
    }    
};
