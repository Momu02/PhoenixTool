-- a.lua
local a = {}

-- 合并重复的导入
local imports = {
  "android.widget.*",
  "android.view.*",
  "android.app.AlertDialog",
  "android.graphics.*",
  "java.io.*",
  "java.net.*",
  "com.androlua.*",
  "android.content.*",
  "android.net.*",
  "mods.muk",
  "android.provider.Settings$Secure"
}
for _, package in ipairs(imports) do import(package) end

-- 配置常量
a.远程链接 = "https://share.weiyun.com/FMCQ5Mzw"
a.设置目录 = activity.getLuaDir().."/set/"

-- 获取应用信息
local appinfo = activity.getPackageManager().getApplicationInfo(activity.getPackageName(), 0)
a.程序名 = activity.getPackageManager().getApplicationLabel(appinfo)
local packinfo = activity.getPackageManager().getPackageInfo(activity.getPackageName(), ((32552732 / 2 / 2 - 8183) / 10000 - 6 - 231) / 9)
a.当前版本 = tostring(packinfo.versionName)

-- 定义模块函数
function a.fetchData(callback)
  Http.get(a.远程链接, nil, "UTF-8", nil, function(code, content)
    if code == 200 then
      -- 原始字符串处理流程
      local 原始内容 = content:match("<article(.-)</article>")
      local 清洗内容 = 原始内容
      :gsub("。", "/n")
      :gsub("&lt;", "<")
      :gsub("&gt;", ">")
      :gsub([[&nbsp; ]], "")
      :gsub("&nbsp;", "")
      :gsub("amp;", "")
      :gsub("</span>", "")
      :gsub('<span style="', "")
      :gsub("font", "")
      :gsub("<br />", "")
      :gsub('size:18px;">', "")
      :gsub("</p><p>", "\n")
      :gsub("</p>", " ")
      :gsub("<p>", " ")
      :gsub("<br  />", "")

      -- 字段匹配（将变量放入表中）
      local data = {
        更新开关 = 清洗内容:match("更新开关【(.-)】"),
        更新名称 = 清洗内容:match("更新名称【(.-)】"),
        备用链接 = 清洗内容:match("备用链接【(.-)】"),
        选课开关 = 清洗内容:match("选课开关【(.-)】"),
        软件大小 = 清洗内容:match("软件大小【(.-)】"),
        最新版本 = 清洗内容:match("最新版本【(.-)】"),
        更新内容 = 清洗内容:match("更新内容【(.-)】"),
        教程链接 = 清洗内容:match("教程链接【(.-)】"),
        指南链接 = 清洗内容:match("指南链接【(.-)】"),
        关闭软件 = 清洗内容:match("软件封禁开关【(.-)】"),
        远程清除数据 = 清洗内容:match("远程清除数据【(.-)】"),
        feedbacksay = 清洗内容:match("开发者的话【(.-)】"),
        下载链接 = 清洗内容:match("下载链接【(.-)】")
      }

      -- 开发者消息处理
      local readsay = 读取文件(a.设置目录.."Say.txt")
      if readsay ~= data.feedbacksay and data.feedbacksay then
        local delayedTask -- 保存延迟任务引用
        delayedTask = delay(2000, function()
          if activity.isFinishing() then
            return
          end
          dialog = AlertDialog.Builder(activity)
          .setMessage(data.feedbacksay)
          .setOnDismissListener({
            onDismiss = function()
              dialog = nil
            end
          })
          .show()
        end)
        写入文件(a.设置目录.."Say.txt", data.feedbacksay)
      end

      -- 远程清除数据
      if data.远程清除数据 == "开" then
        os.execute("rm -rf "..a.设置目录)
        os.execute("mkdir -p "..a.设置目录)
      end

      -- 软件封禁检查
      if data.关闭软件 ~= "关" then
        提示("软件出现严重问题，已强制退出")
        os.exit()
      end

      -- 设备授权验证
      local 设备码key = tostring(Secure.getString(activity.getContentResolver(), Secure.ANDROID_ID))
      local 授权状态 = false
      for v in 清洗内容:gmatch("%((.-)%)") do
        if v == 设备码key then
          授权状态 = true
          break
        end
      end

      -- 选课开关设置
      activity.setSharedData("kxSwitch", data.选课开关 == "关" and "false" or "true")

      -- 更新处理逻辑
      if data.更新开关 == "开" and data.最新版本 ~= a.当前版本 then
        local path = "/storage/emulated/0/Phoenix/"..data.最新版本..".apk"

        -- 按钮功能定义
        local function 复制链接()
          activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(data.备用链接)
          双按钮对话框("软件更新！新版本："..data.最新版本, "已复制链接，请到浏览器打开下载", "OK")
        end

        local function 更新下载()
          下载文件对话框("下载中(卡住则请用备用链接下载)", data.下载链接, path)
        end

        local function 公众号()
          local 弹窗布局 = {
            FrameLayout,
            layout_width = 'fill',
            {
              LinearLayout,
              orientation = 'vertical',
              layout_width = 'fill',
              {
                ImageView,
                src = 'image/officialaccount.png',
                layout_width = '480dp',
                layout_height = '250dp',
                layout_gravity = 'center'
              }
            }
          }
          local dialog = AlertDialog.Builder(activity)
          .setTitle("截图到微信扫码关注")
          .setView(loadlayout(弹窗布局))
          .setPositiveButton("知道了", nil)
          .show()
          dialog.getWindow().setBackgroundDrawable(ColorDrawable(0x00000000))
        end

        -- 调用原始对话框
        三按钮对话框(
        "软件更新(新版本："..data.最新版本..")",
        data.更新内容,
        "下载",
        "备用链接",
        "关注公众号",
        更新下载,
        复制链接,
        公众号,
        0)
      end

      -- 返回数据
      if callback then
        callback(data)
      end
    end
  end)
end

-- 在 onDestroy 中取消延迟任务
function onDestroy()
  if delayedTask ~= nil then
    delayedTask.cancel() -- 需要确保 delay 函数返回可取消的任务
  end
end

-- 返回模块
return a