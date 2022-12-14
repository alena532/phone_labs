package com.example.timer;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.IBinder;
import android.os.PowerManager;
import android.util.Log;
import android.widget.Toast;

//import io.flutter.app.FlutterActivity;
//import io.flutter.plugin.common.MethodCall;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel;


import static android.content.Intent.FLAG_ACTIVITY_NEW_TASK;

public class MainActivity extends FlutterActivity  {
    static final String TAG = "rest";
    static final String CHANNEL = "com.example.timer/service";

    AppService appService;
    boolean serviceConnected = false;
    MethodChannel.Result keepResult = null;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                (call,result)->{
                    if (call.method.equals("connect")) {
                        connectToService();
                        keepResult = result;
                    } else if (serviceConnected) {
                        if (call.method.equals("start")) {
                            appService.startTimer(call.argument("duration"));
                            result.success(null);
                        } else if (call.method.equals("stop")) {
                            appService.stopTimer();
                            result.success(null);
                        } else if (call.method.equals("getCurrentSeconds")) {
                            int sec = appService.getCurrentSeconds();
                            result.success(sec);
                        }
                    } else {
                        result.error(null, "App not connected to service", null);
                    }
                }

        );
    }

    private void connectToService() {
        if (!serviceConnected) {
            Intent service = new Intent(this, AppService.class);
            startService(service);
            bindService(service, connection, Context.BIND_AUTO_CREATE);
            serviceConnected = true;
        } else {
            Log.i(TAG, "Service already connected");
            if (keepResult != null) {
                keepResult.success(null);
                keepResult = null;
            }
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Context context = getApplicationContext();
            String packageName = context.getPackageName();
            PowerManager pm = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
            if (!pm.isIgnoringBatteryOptimizations(packageName)) {
                Log.i(TAG, "onResume");
                Toast.makeText(context, "This app needs to be whitelisted", Toast.LENGTH_LONG).show();
                Intent intent = new Intent();
                intent.setAction(android.provider.Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
                intent.setFlags(FLAG_ACTIVITY_NEW_TASK);
                intent.setData(Uri.parse("package:" + packageName));
                context.startActivity(intent);
            }
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        unbindService(connection);
        serviceConnected = false;
    }

    private ServiceConnection connection = new ServiceConnection() {

        @Override
        public void onServiceConnected(ComponentName className,
                                       IBinder service) {
            AppService.AppServiceBinder binder = (AppService.AppServiceBinder) service;
            appService = binder.getService();
            serviceConnected = true;
            Log.i(TAG, "Service connected");
            if (keepResult != null) {
                keepResult.success(null);
                keepResult = null;
            }
        }

        @Override
        public void onServiceDisconnected(ComponentName arg0) {
            serviceConnected = false;
            Log.i(TAG, "Service disconnected");
        }
    };


}