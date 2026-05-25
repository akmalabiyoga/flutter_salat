package com.example.flutter_salat

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import es.antonborri.home_widget.HomeWidgetLaunchIntent

/**
 * Salat Standard Widget - Uses minute-by-minute updates
 */
class SalatWidgetSmallProvider : HomeWidgetProvider() {
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
                setTextViewText(R.id.prayer_status, calculatedData.prayerStatus)
                setTextViewText(R.id.secondary_prayer, calculatedData.secondaryPrayer)
                
                // Ensure Chronometers and containers are hidden
                setViewVisibility(R.id.prayer_countdown, View.GONE)
                setViewVisibility(R.id.prayer_status, View.VISIBLE)
                setViewVisibility(R.id.secondary_prayer_container, View.GONE)
                setViewVisibility(R.id.secondary_prayer, View.VISIBLE)

                // Launch main activity when clicked
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        // Schedule next update (either next prayer or next minute)
        calculatedData.nextUpdateTimeMillis?.let { nextTime ->
            scheduleUpdate(context, nextTime)
        }
    }

    private fun scheduleUpdate(context: Context, timeMillis: Long) {
        val intent = Intent(context, SalatWidgetSmallProvider::class.java).apply {
            action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            val ids = AppWidgetManager.getInstance(context)
                .getAppWidgetIds(ComponentName(context, SalatWidgetSmallProvider::class.java))
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
