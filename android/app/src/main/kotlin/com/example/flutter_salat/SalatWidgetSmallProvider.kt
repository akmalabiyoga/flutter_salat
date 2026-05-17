package com.example.flutter_salat

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import es.antonborri.home_widget.HomeWidgetLaunchIntent

class SalatWidgetSmallProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.salat_widget_small_layout).apply {
                val prayerName = widgetData.getString("prayer_name", "---")
                val prayerTime = widgetData.getString("prayer_time", "--:--")
                val prayerStatus = widgetData.getString("prayer_status", "")
                
                setTextViewText(R.id.prayer_name, prayerName)
                setTextViewText(R.id.prayer_time, prayerTime)
                setTextViewText(R.id.prayer_status, prayerStatus)

                // Launch main activity when clicked
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
