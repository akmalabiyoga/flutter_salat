package com.example.flutter_salat

import android.content.SharedPreferences
import org.json.JSONArray
import org.json.JSONObject
import java.time.Duration
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.*

data class CalculatedWidgetData(
    val prayerName: String,
    val prayerTime: String,
    val prayerStatus: String,
    val secondaryPrayer: String
)

object PrayerTimeCalculator {

    fun calculate(widgetData: SharedPreferences): CalculatedWidgetData {
        val jsonString = widgetData.getString("prayer_times_json", null)
        
        if (jsonString == null) {
            // Fallback to existing static data if JSON is not available
            return CalculatedWidgetData(
                prayerName = widgetData.getString("prayer_name", "---") ?: "---",
                prayerTime = widgetData.getString("prayer_time", "--:--") ?: "--:--",
                prayerStatus = widgetData.getString("prayer_status", "") ?: "",
                secondaryPrayer = widgetData.getString("secondary_prayer", "") ?: ""
            )
        }

        try {
            val jsonArray = JSONArray(jsonString)
            val now = LocalDateTime.now()
            
            var lastPrayer: JSONObject? = null
            var nextPrayer: JSONObject? = null
            var minLastDuration: Duration? = null
            var minNextDuration: Duration? = null

            for (i in 0 until jsonArray.length()) {
                val prayer = jsonArray.getJSONObject(i)
                val prayerTimeStr = prayer.getString("prayerTime")
                val timeObj = LocalDateTime.parse(prayerTimeStr)

                if (timeObj.isBefore(now)) {
                    val diff = Duration.between(timeObj, now)
                    if (minLastDuration == null || diff < minLastDuration) {
                        minLastDuration = diff
                        lastPrayer = prayer
                    }
                } else if (timeObj.isAfter(now)) {
                    val diff = Duration.between(now, timeObj)
                    if (minNextDuration == null || diff < minNextDuration) {
                        minNextDuration = diff
                        nextPrayer = prayer
                    }
                }
            }

            var nearestPrayer: JSONObject? = null
            var nearestIsNext = false
            var nearestDuration: Duration? = null

            if (minLastDuration != null && minNextDuration != null) {
                if (minLastDuration < minNextDuration) {
                    nearestPrayer = lastPrayer
                    nearestIsNext = false
                    nearestDuration = minLastDuration
                } else {
                    nearestPrayer = nextPrayer
                    nearestIsNext = true
                    nearestDuration = minNextDuration
                }
            } else if (minLastDuration != null) {
                nearestPrayer = lastPrayer
                nearestIsNext = false
                nearestDuration = minLastDuration
            } else if (minNextDuration != null) {
                nearestPrayer = nextPrayer
                nearestIsNext = true
                nearestDuration = minNextDuration
            }

            if (nearestPrayer == null) {
                return CalculatedWidgetData("---", "--:--", "", "")
            }

            val nearestName = nearestPrayer.getString("prayerName")
            val nearestTimeObj = LocalDateTime.parse(nearestPrayer.getString("prayerTime"))
            val nearestTimeStr = nearestTimeObj.format(DateTimeFormatter.ofPattern("HH:mm"))
            val nearestStatus = if (nearestIsNext) {
                "In ${formatDuration(nearestDuration!!)}"
            } else {
                "${formatDuration(nearestDuration!!)} ago"
            }

            var secondaryText = ""
            var secondaryPrayer: JSONObject? = null
            var secondaryIsNext = false
            var secondaryDuration: Duration? = null

            if (nearestPrayer == lastPrayer) {
                secondaryPrayer = nextPrayer
                secondaryIsNext = true
                secondaryDuration = minNextDuration
            } else {
                secondaryPrayer = lastPrayer
                secondaryIsNext = false
                secondaryDuration = minLastDuration
            }

            if (secondaryPrayer != null && secondaryDuration != null) {
                val secName = secondaryPrayer.getString("prayerName")
                val secTimeObj = LocalDateTime.parse(secondaryPrayer.getString("prayerTime"))
                val secTimeStr = secTimeObj.format(DateTimeFormatter.ofPattern("HH:mm"))
                val durStr = formatDuration(secondaryDuration)
                secondaryText = "$secName $secTimeStr • ${if (secondaryIsNext) "In " else ""}$durStr${if (secondaryIsNext) "" else " ago"}"
            }

            return CalculatedWidgetData(
                prayerName = nearestName,
                prayerTime = nearestTimeStr,
                prayerStatus = nearestStatus,
                secondaryPrayer = secondaryText
            )

        } catch (e: Exception) {
            e.printStackTrace()
            return CalculatedWidgetData("Error", "--:--", "Data Error", "")
        }
    }

    private fun formatDuration(duration: Duration): String {
        val hours = duration.toHours()
        val minutes = duration.toMinutes() % 60
        return if (hours > 0) {
            "${hours}h ${minutes}m"
        } else {
            "${minutes}m"
        }
    }
}
