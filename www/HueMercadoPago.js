var exec = require('cordova/exec');

exports.realizarPago = function (arg0, success, error) {
    exec(success, error, 'HueMercadoPago', 'realizarPago', [arg0]);
};
