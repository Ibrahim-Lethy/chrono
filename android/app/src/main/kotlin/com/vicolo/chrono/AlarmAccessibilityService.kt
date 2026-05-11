package com.vicolo.chrono

import android.accessibilityservice.AccessibilityService
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.view.accessibility.AccessibilityEvent

class AlarmAccessibilityService : AccessibilityService() {

    override fun onAccessibilityEvent(event: AccessibilityEvent) {
        if (event.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return
        if (!isAlarmActive()) return

        val pkg = event.packageName?.toString() ?: return
        val cls = event.className?.toString() ?: return

        if (isPowerDialog(pkg, cls)) {
            performGlobalAction(GLOBAL_ACTION_BACK)
            // Relaunch alarm screen after brief delay
            Handler(Looper.getMainLooper()).postDelayed({
                val intent = packageManager.getLaunchIntentForPackage(packageName)
                    ?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
                if (intent != null) {
                    startActivity(intent)
                }
            }, 200)
        }
    }

    private fun isAlarmActive(): Boolean {
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        return prefs.getBoolean("flutter.alarm_active", false)
    }

    private fun isPowerDialog(pkg: String, cls: String): Boolean {
        return (pkg == "android" || pkg == "com.android.systemui") &&
               (cls.contains("GlobalActions", ignoreCase = true) ||
                cls.contains("PowerMenu", ignoreCase = true) ||
                cls.contains("ShutdownThread", ignoreCase = true))
    }

    override fun onInterrupt() {}
}
