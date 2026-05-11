package com.vicolo.chrono

import android.app.admin.DeviceAdminReceiver
import android.content.Context
import android.content.Intent

class AlarmDeviceAdminReceiver : DeviceAdminReceiver() {
    override fun onEnabled(context: Context, intent: Intent) {}
    override fun onDisabled(context: Context, intent: Intent) {}
}