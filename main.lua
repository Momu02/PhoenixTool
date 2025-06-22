require "import"
import "android.content.Context"
import "java.io.File"

--[[
打包前
1.删/set
3.更新开关打开
4.vpn检测打开
5.关调试
6.删none课表
7.清除缓存
]]


local 壁纸路径 = "/storage/emulated/0/Phoenix/Wallpaper/1.png"
-- 壁纸初始化
if not File(壁纸路径).exists() then
  File("/storage/emulated/0/Phoenix/Wallpaper/").mkdirs()
  LuaUtil.copyDir(activity.getLuaDir().."/image/wallpaper/Wallpaper.png",壁纸路径)
end

import "android.app.ProgressDialog"
local dialog1= ProgressDialog.show(this,nil, "加载中..欢迎使用喵",false, false).hide()
dialog1.show()
import "android.content.pm.PackageManager"
-- 获取 PackageManager
pm = activity.getPackageManager()
permissions = (PackageManager.PERMISSION_GRANTED == pm.checkPermission("android.permission.WRITE_EXTERNAL_STORAGE", activity.getPackageName()))

function 论坛登录相关()
  local file = File(activity.getLuaDir().. "/set/ForumAccount").exists()
  if file then
    local file = io.input(activity.getLuaDir().. "/set/ForumAccount")
    local str = io.read("*a")
    io.close()
    local pos = string.find(str, "|")
    user = string.sub(str, 1, pos - 1)
    password = string.sub(str, pos + 1)
    isLogined = true
   else
    isLogined = false
    this.setSharedData("popRecord", 1)
  end
  xcn = activity.getApplicationContext().getSystemService(Context.CONNECTIVITY_SERVICE).getActiveNetworkInfo()
  if xcn then
    import "com.narcissus.tool.*"
    local function fetchUrl()
      local success, result = pcall(NarcissusTool.getUrl)
      if success then
        if result ~= nil then
          return result
         else
          提示("获取URL失败")
          return nil
        end
       else
        提示("获取URL时发生错误: " .. result)
        return nil
      end
    end

    url = fetchUrl()
    -- 根据权限情况执行代码
    if (permissions) then
      task(200,function()
        dialog1.dismiss()
        if url then
          activity.newActivity("home",{url,user,password,isLogined})
         else
          提示("论坛维护中")
          activity.newActivity("home",{"","","",isLogined})
        end
        activity.finish()
      end)
     else
      提示("木有权限，请先给权限");
      activity.finish()
      -- 可以在这里请求权限或者给出提示
      -- 如果需要，可以在这里添加请求权限的代码
    end
  end
end
论坛登录相关()


