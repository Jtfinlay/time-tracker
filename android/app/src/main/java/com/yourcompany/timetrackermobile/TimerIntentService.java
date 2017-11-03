package com.yourcompany.timetrackermobile;

import android.app.IntentService;
import android.app.Notification;
import android.app.PendingIntent;
import android.content.Intent;
import android.widget.Toast;

public class TimerIntentService extends IntentService {

    public TimerIntentService() {
        super("TimerIntentService");
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        String CHANNEL_ID = "finlay.tracker01";

        Intent notificationIntent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent =
                PendingIntent.getActivity(this, 0, notificationIntent, 0);

        Notification notification =
                new Notification.Builder(this)
                        .setContentTitle("Toilet timer")
                        .setContentText("0:42")
                        .setSmallIcon(R.drawable.ic_timer)
                        .setContentIntent(pendingIntent)
                        .setTicker("ticker.?")
                        .build();


        startForeground(3444, notification);
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
}
