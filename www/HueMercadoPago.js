var exec = require('cordova/exec');


exports.realizarPago = function (publicKey, preferenceId, success, error) {    
    exec(success, error, 'HueMercadoPago', 'realizarPago', [publicKey, preferenceId]);        
};
