package com.huenei.plugins.mercadopago;

import android.content.Intent;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.app.Activity;

import com.mercadopago.android.px.core.MercadoPagoCheckout;
import com.mercadopago.android.px.model.Payment;
import com.mercadopago.android.px.model.exceptions.MercadoPagoError;
import okhttp3.*;
/**
 * This class echoes a string called from JavaScript.
 */
public class HueMercadoPago extends CordovaPlugin {
    private static final int REQUEST_CODE = 1;
    private CallbackContext callbackContext;
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        this.callbackContext = callbackContext;
        if (action.equals("coolMethod")) {
            String preferenceId = args.getString(0);
            this.coolMethod(preferenceId);
            return true;
        }
        return false;
    }

    private void coolMethod(String preferenceId) {
        new MercadoPagoCheckout.Builder("TEST-c98a211b-42d5-45a3-a186-e87606d62c0a", preferenceId).build()
                .startPayment(this.cordova.getActivity(), REQUEST_CODE);
    }

    public void onActivityResult(final int requestCode, final int resultCode, final Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQUEST_CODE) {
            if (resultCode == MercadoPagoCheckout.PAYMENT_RESULT_CODE) {
                final Payment payment = (Payment) data.getSerializableExtra(MercadoPagoCheckout.EXTRA_PAYMENT_RESULT);
                this.callbackContext.success(payment.getPaymentStatus());
                //Done!
            } else if (resultCode == Activity.RESULT_CANCELED) {
                if (data != null && data.getExtras() != null
                        && data.getExtras().containsKey(MercadoPagoCheckout.EXTRA_ERROR)) {
                    final MercadoPagoError mercadoPagoError =
                            (MercadoPagoError) data.getSerializableExtra(MercadoPagoCheckout.EXTRA_ERROR);
                            callbackContext.error(mercadoPagoError.getMessage());
                    //Resolve error in checkout
                } else {
                    //Resolve canceled checkout
                }
            }
        }
    }
}
