package com.huenei.plugins.mercadopago;

import android.content.Intent;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.app.Activity;
import java.io.Serializable;
import com.google.gson.Gson;
import com.mercadopago.android.px.core.MercadoPagoCheckout;
import com.mercadopago.android.px.model.Payment;
import com.mercadopago.android.px.model.exceptions.MercadoPagoError;
import okhttp3.*;
/**
 * This class echoes a string called from JavaScript.
 */
public class HueMercadoPago extends CordovaPlugin {
    private static final int REQUEST_CODE = 8091;
    private CallbackContext callbackContext;
    private class MercadoPagoResponse implements Serializable {
        private String status;
        private Long paymentId;

        public void setStatus(String status){
            this.status = status;
        }
        public String getStatus(){
            return this.status;
        }

        public void setPaymentId(Long id){
            this.paymentId = id;
        }
        public Long getPaymentId(){
            return this.paymentId;
        }
    }
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        this.callbackContext = callbackContext;
        cordova.setActivityResultCallback(this);

        if (action.equals("realizarPago")) {
            String publicKey = args.getString(0);
            String preferenceId = args.getString(1);
            this.realizarPago(publicKey, preferenceId);
            return true;
        }
        return false;
    }

    private void realizarPago(String publicKey, String preferenceId) {
        new MercadoPagoCheckout.Builder(publicKey, preferenceId).build()
                .startPayment(this.cordova.getActivity(), REQUEST_CODE);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQUEST_CODE) {
            if (resultCode == MercadoPagoCheckout.PAYMENT_RESULT_CODE) {
                final Payment payment = (Payment) data.getSerializableExtra(MercadoPagoCheckout.EXTRA_PAYMENT_RESULT);
                try{                    
                    MercadoPagoResponse mpResponse = new MercadoPagoResponse();
                    mpResponse.setPaymentId = payment.getPaymentId();
                    mpResponse.setStatus = payment.getStatus();
                    final PluginResult result = new PluginResult(PluginResult.Status.OK, new JSONObject(new Gson().toJson(mpResponse)));
                    callbackContext.sendPluginResult(result);
                }catch(Exception e){
                    e.printStackTrace();
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, e.getMessage()));
                }
            } else if (resultCode == Activity.RESULT_CANCELED) {
                if (data != null && data.getExtras() != null && data.getExtras().containsKey(MercadoPagoCheckout.EXTRA_ERROR)) {
                    final MercadoPagoError mercadoPagoError = (MercadoPagoError) data.getSerializableExtra(MercadoPagoCheckout.EXTRA_ERROR);
                    callbackContext.error(mercadoPagoError.getMessage());
                } else {
                    callbackContext.error("Cancelado por usuario");
                }
            }
        }
    }
}
