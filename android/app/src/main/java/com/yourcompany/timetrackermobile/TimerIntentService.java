package com.yourcompany.timetrackermobile;

import android.app.IntentService;
import android.app.Notification;
import android.app.PendingIntent;
import android.content.Intent;
import android.widget.Toast;

import java.util.Timer;
import java.util.TimerTask;

public class TimerIntentService extends IntentService {

    public TimerIntentService() {
        super("TimerIntentService");
    }

    private boolean isTimerRunning = false;
    private Timer timer = new Timer();
    private CoreTimerTask timerTask = new CoreTimerTask();

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        System.out.println("Start command invoked. " + isTimerRunning);

        if (!isTimerRunning) {
            isTimerRunning = true;
            timer.scheduleAtFixedRate(timerTask, 0, 1000);
        }
        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public void onDestroy() {
        Toast.makeText(this, "killing service", Toast.LENGTH_SHORT).show();
        super.onDestroy();
    }

    @Override
    protected void onHandleIntent(Intent intent) {
        try {
            Thread.sleep(5000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    private class CoreTimerTask extends TimerTask {

        private int sec = 0;

        private void PublishNotification(String content) {
            Intent notificationIntent = new Intent(TimerIntentService.this, MainActivity.class);
            PendingIntent pendingIntent = PendingIntent.getActivity(TimerIntentService.this, 0, notificationIntent, 0);

            Notification notification =
                    new Notification.Builder(TimerIntentService.this)
                            .setContentTitle("Toilet timer")
                            .setContentText(content)
                            .setSmallIcon(R.drawable.ic_timer)
                            .setContentIntent(pendingIntent)
                            .setTicker("ticker.?")
                            .build();

            startForeground(3444, notification);
        }

        @Override
        public void run() {
            PublishNotification("0:0"+sec);
            sec++;
        }
    }
}
