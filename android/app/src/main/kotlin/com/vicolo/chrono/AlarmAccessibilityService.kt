package com.vicolo.chrono

import android.accessibilityservice.AccessibilityService
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo

class AlarmAccessibilityService : AccessibilityService() {

    override fun onAccessibilityEvent(event: AccessibilityEvent) {
        if (event.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED &&
            event.eventType != AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED) return
        if (!isAlarmActive()) return

        val pkg = event.packageName?.toString() ?: return
        val cls = event.className?.toString() ?: return

        if ((isPowerProtectionEnabled() && isPowerDialog(pkg, cls)) ||
            (isAdminProtectionEnabled() && isSettingsEscapeSurface(pkg, cls))) {
            blockEscapeAttempt()
        }
    }

    private fun isAlarmActive(): Boolean {
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        return prefs.getBoolean("flutter.alarm_active", false)
    }

    private fun isPowerProtectionEnabled(): Boolean {
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        return prefs.getBoolean("flutter.protection_power_off_enabled", false)
    }

    private fun isAdminProtectionEnabled(): Boolean {
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        return prefs.getBoolean("flutter.protection_admin_enabled", false)
    }

    private fun isPowerDialog(pkg: String, cls: String): Boolean {
        return (pkg == "android" || pkg == "com.android.systemui") &&
               (cls.contains("GlobalActions", ignoreCase = true) ||
                cls.contains("PowerMenu", ignoreCase = true) ||
                cls.contains("ShutdownThread", ignoreCase = true))
    }

    private fun isSettingsEscapeSurface(pkg: String, cls: String): Boolean {
        if (pkg != "com.android.settings" &&
            pkg != "com.google.android.packageinstaller" &&
            pkg != "com.android.packageinstaller") {
            return false
        }

        if (cls.contains("AppInfo", ignoreCase = true) ||
            cls.contains("InstalledAppDetails", ignoreCase = true) ||
            cls.contains("ManageApplications", ignoreCase = true) ||
            cls.contains("DeviceAdmin", ignoreCase = true) ||
            cls.contains("Accessibility", ignoreCase = true)) {
            return true
        }

        val root = rootInActiveWindow ?: return false
        return containsEscapeText(root)
    }

    private fun containsEscapeText(node: AccessibilityNodeInfo?): Boolean {
        if (node == null) return false

        val text = listOfNotNull(
            node.text?.toString(),
            node.contentDescription?.toString()
        ).joinToString(" ")

        if (text.contains("Force stop", ignoreCase = true) ||
            text.contains("Uninstall", ignoreCase = true) ||
            text.contains("Deactivate", ignoreCase = true) ||
            text.contains("Device admin", ignoreCase = true) ||
            text.contains("Accessibility", ignoreCase = true) ||
            text.contains("Chrono", ignoreCase = true)) {
            return true
        }

        for (i in 0 until node.childCount) {
            if (containsEscapeText(node.getChild(i))) return true
        }
        return false
    }

    private fun blockEscapeAttempt() {
        performGlobalAction(GLOBAL_ACTION_BACK)
        Handler(Looper.getMainLooper()).postDelayed({
            val intent = packageManager.getLaunchIntentForPackage(packageName)
                ?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
            if (intent != null) {
                startActivity(intent)
            }
        }, 200)
    }

    override fun onInterrupt() {}
}
