package com.yourcompany.timetrackermobile;

import android.app.Notification;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.os.*;

import java.util.Timer;
import java.util.TimerTask;

public class TimerService extends Service {

    private boolean isTimerRunning = false;
    private long startTime = 0;

    private Timer timer = new Timer();
    private CoreTimerTask timerTask = new CoreTimerTask();

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        System.out.println("onStartCommand");

        Bundle request = intent.getExtras();
        if (request != null) {
            String message = (String) request.get("message");
            switch (message) {
                case "start":
                    long elapsedTime = (long) request.get("elapsedTime");
                    startTime = System.currentTimeMillis() - elapsedTime;
                    if (!isTimerRunning) {
                        isTimerRunning = true;
                        timer.scheduleAtFixedRate(timerTask, 0, 1000);
                    }
                    break;
                case "stop":
                    Messenger messenger = (Messenger) request.get("messenger");
                    Bundle response = new Bundle();
                    response.putLong("elapsedTime", (System.currentTimeMillis() - startTime));

                    Message responseMessage = Message.obtain();
                    responseMessage.setData(response);
                    try {
                        messenger.send(responseMessage);
                    } catch (RemoteException e) {
                        System.err.println(e.toString());
                    }
                    stopSelf();
                    break;
            }
        }


        return START_STICKY;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private class CoreTimerTask extends TimerTask {

        private void PublishNotification(String content) {
            Intent notificationIntent = new Intent(TimerService.this, MainActivity.class);
            PendingIntent pendingIntent = PendingIntent.getActivity(TimerService.this, 0, notificationIntent, 0);

            Notification notification =
                    new Notification.Builder(TimerService.this)
                            .setContentTitle("Toilet timer")
                            .setContentText(content)
                            .setSmallIcon(R.drawable.ic_timer)
                            .setContentIntent(pendingIntent)
                            .setTicker("ticker.?")
                            .build();

            startForeground(3500, notification);
        }

        @Override
        public void run() {
            long elapsedTime = System.currentTimeMillis() - startTime;
            long min = elapsedTime / (60000);
            elapsedTime = elapsedTime % (60000);
            long sec = elapsedTime / 1000;

            String sSec = String.valueOf(sec);
            if (sec < 10) {
                sSec = "0" + sec;
            }

            PublishNotification(min + ":" + sSec);
        }
    }
}
