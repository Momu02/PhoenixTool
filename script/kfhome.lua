require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "page.forum_layout.kfhome"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(kfhome))

url,admin,user,password,key,isEncrypt=...
print(url,admin,user,password,key)
--在线客服按钮事件
onlineService.onClick=function ()
  activity.newActivity("script/onlineService",{url,admin,user,password,key,isEncrypt})
end

--离线客服按钮事件
robotService.onClick=function ()
  activity.newActivity("script/robotService",{url,admin,user,password,key,isEncrypt})
end