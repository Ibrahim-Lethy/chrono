package com.vicolo.chrono

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.provider.Settings
import android.view.accessibility.AccessibilityManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.vicolo.chrono/alarm"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isDeviceAdminActive" -> result.success(isDeviceAdminActive())
                    "requestDeviceAdmin"  -> { requestDeviceAdmin(); result.success(null) }
                    "removeDeviceAdmin"   -> { removeDeviceAdmin(); result.success(null) }
                    "isAccessibilityServiceEnabled" -> result.success(isAccessibilityEnabled())
                    "openAccessibilitySettings"     -> { openAccessibilitySettings(); result.success(null) }
                    else -> result.notImplemented()
                }
            }
    }

    private fun isDeviceAdminActive(): Boolean {
        val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val component = ComponentName(this, AlarmDeviceAdminReceiver::class.java)
        return dpm.isAdminActive(component)
    }

    private fun requestDeviceAdmin() {
        val component = ComponentName(this, AlarmDeviceAdminReceiver::class.java)
        val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN).apply {
            putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, component)
            putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION,
                "Required to prevent uninstallation while alarm is active.")
        }
        startActivity(intent)
    }

    private fun removeDeviceAdmin() {
        val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val component = ComponentName(this, AlarmDeviceAdminReceiver::class.java)
        dpm.removeActiveAdmin(component)
    }

    private fun isAccessibilityEnabled(): Boolean {
        val manager = getSystemService(Context.ACCESSIBILITY_SERVICE) as AccessibilityManager
        val enabledServices = Settings.Secure.getString(
            contentResolver,
            Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
        ) ?: return false
        return enabledServices.contains("${packageName}/.AlarmAccessibilityService")
    }

    private fun openAccessibilitySettings() {
        startActivity(Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
    }
}
