package com.example.flutter_salat

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.SystemClock
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import es.antonborri.home_widget.HomeWidgetLaunchIntent

/**
 * Salat Live Widget - Uses Chronometer for real-time ticking
 */
class SalatWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        val calculatedData = PrayerTimeCalculator.calculate(widgetData)
        
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.salat_widget_small_layout).apply {
                setTextViewText(R.id.prayer_name, calculatedData.prayerName)
                setTextViewText(R.id.prayer_time, calculatedData.prayerTime)

                // Primary Prayer Ticking
                if (calculatedData.nearestPrayerTimeMillis != null) {
                    val diffMillis = calculatedData.nearestPrayerTimeMillis - System.currentTimeMillis()
                    val base = SystemClock.elapsedRealtime() + diffMillis
                    
                    setChronometerCountDown(R.id.prayer_countdown, calculatedData.isCountDown)
                    setChronometer(R.id.prayer_countdown, base, if (calculatedData.isCountDown) "In %s" else "%s ago", true)
                    
                    setViewVisibility(R.id.prayer_countdown, View.VISIBLE)
                    setViewVisibility(R.id.prayer_status, View.GONE)
                } else {
                    setTextViewText(R.id.prayer_status, calculatedData.prayerStatus)
                    setViewVisibility(R.id.prayer_countdown, View.GONE)
                    setViewVisibility(R.id.prayer_status, View.VISIBLE)
                }

                // Secondary Prayer Ticking
                if (calculatedData.secondaryTimeMillis != null && calculatedData.secondaryNameTime != null) {
                    val diffMillis = calculatedData.secondaryTimeMillis - System.currentTimeMillis()
                    val base = SystemClock.elapsedRealtime() + diffMillis
                    
                    setTextViewText(R.id.secondary_prayer_info, calculatedData.secondaryNameTime)
                    setChronometerCountDown(R.id.secondary_prayer_countdown, calculatedData.secondaryIsCountDown)
                    setChronometer(R.id.secondary_prayer_countdown, base, if (calculatedData.secondaryIsCountDown) "In %s" else "%s ago", true)
                    
                    setViewVisibility(R.id.secondary_prayer_container, View.VISIBLE)
                    setViewVisibility(R.id.secondary_prayer, View.GONE)
                } else {
                    setTextViewText(R.id.secondary_prayer, calculatedData.secondaryPrayer)
                    setViewVisibility(R.id.secondary_prayer_container, View.GONE)
                    setViewVisibility(R.id.secondary_prayer, View.VISIBLE)
                }

                // Launch main activity when clicked
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        // Schedule update at the exact next prayer time to switch modes
        calculatedData.nextUpdateTimeMillis?.let { nextTime ->
            scheduleUpdate(context, nextTime)
        }
    }

    private fun scheduleUpdate(context: Context, timeMillis: Long) {
        val intent = Intent(context, SalatWidgetProvider::class.java).apply {
            action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            val ids = AppWidgetManager.getInstance(context)
                .getAppWidgetIds(ComponentName(context, SalatWidgetProvider::class.java))
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
        }

        val pendingIntent = PendingIntent.getBroadcast(
            context,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, timeMillis + 500, pendingIntent)
    }
}
