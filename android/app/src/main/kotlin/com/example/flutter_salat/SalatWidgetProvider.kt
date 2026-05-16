package com.example.flutter_salat

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class SalatWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.salat_widget_layout).apply {
                val prayerName = widgetData.getString("prayer_name", "---")
                val prayerTime = widgetData.getString("prayer_time", "--:--")
                
                setTextViewText(R.id.prayer_name, prayerName)
                setTextViewText(R.id.prayer_time, prayerTime)
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
