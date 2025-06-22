-- notification_module.lua

require "import"

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.content.Intent"
import "android.app.PendingIntent"

-- 创建通知模块
local NotificationModule = {}

-- 创建通知的函数
function NotificationModule.createNotification(activity, title, content)
    -- 获取 NotificationManager 服务对象
    local notificationManager = activity.getSystemService(activity.NOTIFICATION_SERVICE)

    -- 如果设备版本大于等于 O，创建一个通知渠道
    if Build.VERSION.SDK_INT >= Build.VERSION_CODES.O then
        local channel = NotificationChannel("my_channel_01", "通知渠道名称", NotificationManager.IMPORTANCE_DEFAULT)
        notificationManager.createNotificationChannel(channel)
    end

    -- 创建一个 Intent，用于启动一个新的 Activity 页面
    local intent = Intent(activity, LuaActivity)
    intent.putExtra("message", "这是从通知启动的 Activity。")
    
    -- 创建一个 PendingIntent 对象，用于在用户点击通知时打开该 Activity 并传递额外数据
    local pendingIntent = PendingIntent.getActivity(activity, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)

    -- 创建一个 Notification.Builder 对象，用于构造通知
    local notificationBuilder = Notification.Builder(activity)
        .setContentTitle(title)
        .setContentText(content)
        .setSmallIcon(android.R.drawable.stat_notify_chat)
        .setOngoing(true)
        .setContentIntent(pendingIntent)

    -- 如果设备版本大于等于 O，将该通知与刚才创建的通知渠道关联
    if Build.VERSION.SDK_INT >= Build.VERSION_CODES.O then
        notificationBuilder.setChannelId("my_channel_01")
    end

    -- 使用 NotificationManager 发送该通知
    notificationManager.notify(1, notificationBuilder.build())
end

return NotificationModule
