package com.example.powervpn;

import android.content.Intent;
import android.net.VpnService;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.powervpn.app/vpn";
    private static final int VPN_REQUEST_CODE = 0x0F;
    private MethodChannel.Result pendingResult;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
                if (call.method.equals("startVpn")) {
                    Intent intent = VpnService.prepare(MainActivity.this);
                    if (intent != null) {
                        pendingResult = result;
                        startActivityForResult(intent, VPN_REQUEST_CODE);
                    } else {
                        startVpnService();
                        result.success(true);
                    }
                } else if (call.method.equals("stopVpn")) {
                    stopVpnService();
                    result.success(true);
                } else {
                    result.notImplemented();
                }
            });
    }

    private void startVpnService() {
        Intent intent = new Intent(this, PowerVpnVpnService.class);
        startService(intent);
    }

    private void stopVpnService() {
        Intent intent = new Intent(this, PowerVpnVpnService.class);
        stopService(intent);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == VPN_REQUEST_CODE) {
            if (resultCode == RESULT_OK) {
                startVpnService();
                if (pendingResult != null) {
                    pendingResult.success(true);
                    pendingResult = null;
                }
            } else {
                if (pendingResult != null) {
                    pendingResult.error("USER_DENIED", "User denied VPN permission", null);
                    pendingResult = null;
                }
            }
        } else {
            super.onActivityResult(requestCode, resultCode, data);
        }
    }
}
