package com.yourcompany.timetrackermobile;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.Messenger;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "finlay.io/timer";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
        new MethodCallHandler() {

            private Result _result;

            private Handler handler = new Handler() {
                @Override
                public void handleMessage(Message msg) {
                    Bundle bundle = msg.getData();
                    long elapsedTime = bundle.getLong("elapsedTime");
                    System.out.println("handling message: " + elapsedTime);
                    _result.success(String.valueOf(elapsedTime));
                }
            };

            @Override
            public void onMethodCall(MethodCall call, Result result) {
                _result = result;

                Intent intent = null;
                switch (call.method) {
                    case "start":
                        long elapsedTime = Long.valueOf((int) call.arguments);
                        System.out.println("Starting service with elapsedTime of " + elapsedTime);

                        intent = new Intent(MainActivity.this, TimerService.class);
                        intent.putExtra("message", "start");
                        intent.putExtra("elapsedTime", elapsedTime);
                        startService(intent);

                        result.success("started");
                        break;
                    case "stop":
                        System.out.println("Stopping service");

                        intent = new Intent(MainActivity.this, TimerService.class);
                        intent.putExtra("message", "stop");
                        intent.putExtra("messenger", new Messenger(handler));
                        startService(intent);
                        break;
                    default:
                        result.notImplemented();
                }
            }
        }
    );
  }
}
