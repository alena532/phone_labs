package com.example.timer;

import android.app.Service;
import android.content.Intent;
import android.media.AudioManager;
import android.os.Binder;
import android.os.IBinder;
import android.os.SystemClock;
import android.util.Log;
import android.view.KeyEvent;

import java.util.Timer;
import java.util.TimerTask;

public class AppService extends Service {
    private final IBinder binder = new AppServiceBinder();
    private final String TAG = "rest/service";
    Timer _timer;
    int _currentSeconds = 0;

    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return START_NOT_STICKY;
    }

    @Override
    public void onDestroy() {
        Log.d(TAG, "onDestroy: ");
        _timer.cancel();
        super.onDestroy();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return binder;
    }

    public class AppServiceBinder extends Binder {
        AppService getService() {
            return  AppService.this;
        }
    }

    public void startTimer(int duration) {
        _currentSeconds = duration - 1;
        _timer = new Timer();
        Log.i(TAG, "Timer run ");
        _timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                //Log.i(TAG, "Timer run");
                if (_currentSeconds == 1) {
                    _timer.cancel();
                    Log.i(TAG, "Timer stopped");
                    _currentSeconds = 0;
                }
                else {
                    _currentSeconds--;
                }
            }
        }, 0, 1000);

        Log.i(TAG, "Timer started");
    }

    public void stopTimer() {
        _timer.cancel();
        _timer = null;
        _currentSeconds = 0;
        Log.i(TAG, "Timer stopped");
    }

    public int getCurrentSeconds() {
        return _currentSeconds;
    }
}