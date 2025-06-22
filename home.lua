require("import")
local NotificationModule = require "mods.notification_module"
local update = require "update"

-- 导入必要的模块
import("android.app.*")
import("android.os.*")
import("android.widget.*")
import("android.view.*")
import("android.graphics.Paint")
import("items")
import("http")
import ("fun1")
import "mods.qing"
import "android.graphics.Typeface"
import "android.graphics.Bitmap"
import "android.view.animation.AccelerateInterpolator"
import "android.view.ViewAnimationUtils"
import "android.R$animator"
import "item.item"
import "android.net.Uri"
import "android.content.Intent"
import "http"
import "cjson"
import "mods.muk"
import "java.lang.Math"
import "android.view.animation.AlphaAnimation"
import "android.view.animation.Animation"
import "android.view.animation.RotateAnimation"
import "android.widget.PopupWindow"
import 'us.feras.mdv.MarkdownView'
import "com.narcissus.encrypt.*"

url,user,password,isLogined=...
admin = "1336315242"
key = "9bd6331262d90de013e3"
secret = "00eceefd840f6b87f5dd"
isEncrypt = true

if isLogined==false then
  task(1000,function()
    this.setSharedData("popRecord", 1)
    弹出登录()
  end)
 else
  task(1000,function()
    签到()
  end)
end

-- 在 Activity 启动时调用
function onCreate()
  -- 调用 fetchData 函数
  update.fetchData(function(data)
    -- 这里可以处理其他逻辑
  end)
end

-- 处理活动结果
function onActivityResult(a, b, c)
  if b == 1100 then -- 日夜模式切换
    设置主题()
    activity.recreate()
   elseif b == 1300 then
   elseif b == 1600 then
  end
end

-- 校园网验证
校园网登录验证()
vpn检测()

-- 初始化设置数据
function 初始化设置数据()
  if this.getSharedData("OASwitch") == nil then
    this.setSharedData("主题色", 0xFF607D8B)
    this.setSharedData("OASwitch", "true")
    this.setSharedData("OA刷新间隔", "10")
    this.setSharedData("课表高度", "40%h")
    this.setSharedData("OA高度", "40%h")
    this.setSharedData("课表格子高度", "50dp")
    this.setSharedData("weatherposition", "金平区")
    this.setSharedData("NewRemindSwitch", "true")
    this.setSharedData("NewRedSwitch", "true")
    this.setSharedData("卡片Items", cjson.encode({ true, true, true, true, true }))
  end

  local savedData = this.getSharedData("卡片Items")
  if savedData then
    local selectedItems = cjson.decode(savedData)
    this.setSharedData("作业", selectedItems[1] and "true" or "false")
    this.setSharedData("课表", selectedItems[2] and "true" or "false")
    this.setSharedData("OA", selectedItems[3] and "true" or "false")
    this.setSharedData("一卡通", selectedItems[4] and "true" or "false")
    this.setSharedData("天气", selectedItems[5] and "true" or "false")
  end
end

初始化设置数据()

function 文件初始化()
  -- 创建下载目录
  File("/storage/emulated/0/Phoenix/Download").mkdirs()

  -- 初始化文件
  local 文件列表 = {
    { 路径 = activity.getLuaDir().. "/set/message.txt", 默认内容 = "" },
    { 路径 = activity.getLuaDir().. "/set/OAHistoryRecord.txt", 默认内容 = "" },
    { 路径 = activity.getLuaDir().. "/set/CookOA.txt", 默认内容 = "1" }
  }

  for _, 文件 in ipairs(文件列表) do
    local 文件句柄 = io.open(文件.路径, "r")
    if 文件句柄 == nil then
      写入文件(文件.路径, 文件.默认内容)
     else
      文件句柄:close() -- 关闭文件句柄
    end
  end
end

-- 调用初始化函数
文件初始化()

-- 设置主题相关
if 全局主题值=="Day" then
  TitleMenuBarColor = 图标("navnight")
  MoreColor = 图标("MoreBlack")
  TipsColor = 图标("NightTips")
 else
  TitleMenuBarColor = "image/icon/navnav.png"
  MoreColor = "image/icon/More.png"
  TipsColor = "image/icon/Tips.png"
end


import("content")
import("drawer")

-- 加载侧滑栏和标题栏
layout = { DrawerLayout, id = "mDrawer" }
table.insert(layout, content)
table.insert(layout, drawer)
activity.setContentView(loadlayout(layout))

-- 标题字变粗
title.getPaint().setFakeBoldText(true)

-- 设置标题栏波纹颜色
RippleHelper(btn).RippleColor = 0x1C51FFFF
RippleHelper(btn1).RippleColor = 0x1C51FFFF
RippleHelper(btn2).RippleColor = 0x1CFFFFFF
RippleHelper(btn3).RippleColor = 0x1CFFFFFF

-- 侧滑栏核心代码
import "android.widget.AdapterView"

-- 菜单数据结构
local menu_items = {
  {type = 1, title = "主页", icon = "home"},
  {type = 1, title = "论坛", icon = "forum"},
  {type = 3}, -- 分割线
  {type = 1, title = "设置", icon = "settings"},
  {type = 1, title = "联系开发者", icon = "contact"},
  {type = 1, title = "公告", icon="announcement"},
  {type = 1, title = "下载管理", icon = "download"},
  {type = 3}, -- 分割线
  {type = 1, title = "分享", icon = "share"},
  {type = 1, title = "捐赠", icon = "donate"},
  {type = 1, title = "退出", icon = "exit"}
}

-- 侧滑栏布局定义
drawer_item = {
  { -- 普通项 (type=1)
    LinearLayout,
    layout_width = "match_parent",
    layout_height = "48dp",
    gravity = "center|left",
    {
      ImageView,
      id = "ivIcon",
      layout_marginLeft = "24dp",
      layout_width = "24dp",
      layout_height = "24dp"
    },
    {
      TextView,
      id = "tvTitle",
      layout_marginLeft = "16dp",
      textSize = "14sp",
      textColor = textc,
      Typeface = 字体("product")
    }
  },
  { -- 选中项 (type=2)
    LinearLayout,
    layout_width = "match_parent",
    layout_height = "48dp",
    gravity = "center|left",
    background = "#20000000",
    {
      ImageView,
      id = "ivIcon",
      ColorFilter = 主题色,
      layout_marginLeft = "24dp",
      layout_width = "24dp",
      layout_height = "24dp"
    },
    {
      TextView,
      id = "tvTitle",
      layout_marginLeft = "16dp",
      textSize = "14sp",
      textColor = 主题色,
      Typeface = 字体("product")
    }
  },
  { -- 分割线 (type=3)
    View,
    layout_width = "match_parent",
    layout_height = "1dp",
    background = "#33000000"
  }
}

-- 初始化适配器
adp = LuaMultiAdapter(activity, drawer_item)

-- 数据加载（修改后）
adp.clear()
for _, item in ipairs(menu_items) do
  if item.type == 3 then
    -- 分割线类型不调用图标函数
    adp.add{__type = 3}
   else
    -- 其他类型正常处理
    local item_type = item.type == 2 and 2 or 1
    adp.add{
      __type = item_type,
      ivIcon = {src = 图标(item.icon or "default")}, -- 添加默认值
      tvTitle = {text = item.title}
    }
  end
end

-- 设置适配器
drawer_list.setAdapter(adp)

-- 高亮函数优化（修改后）
function ch_light(selectedTitle)
  for i, item in ipairs(menu_items) do
    if item.type ~= 3 then -- 跳过分割线项
      if item.title == selectedTitle then
        item.type = 2
       elseif item.type == 2 then
        item.type = 1
      end
    end
  end

  adp.clear()
  for _, item in ipairs(menu_items) do
    if item.type == 3 then
      adp.add{__type = 3}
     else
      local item_type = item.type == 2 and 2 or 1
      adp.add{
        __type = item_type,
        ivIcon = {src = 图标(item.icon or "default")}, -- 添加默认值
        tvTitle = {text = item.title}
      }
    end
  end
end

local HomeRecord = this.getSharedData("HomeRecord")
if HomeRecord == "论坛" then
  ltclicked=true
  delay(500,function()
    if url then
      require "ForumHomepageCode"
      加载论坛()
      签到()
     else
      提示("论坛维护中")
    end
  end)
  控件隐藏(page_home)
  控件可见(page_forum)
 else
  --[[local file = File(activity.getLuaDir().. "/set/ForumAccount").exists()
  if file and url then
    delay(2000,加载论坛)
    签到()
  end]]
end

ch_light(HomeRecord)

drawer_list.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick = function(_, view, position, id)
    mDrawer.closeDrawer(3)

    -- 跳过分割线点击
    local item = menu_items[position + 1]
    if not item or item.type == 3 then return end

    -- 使用数据源获取文本
    local s = item.title

    if s == "退出" then
      activity.finishAffinity()
     elseif s == "主页" then
      ch_light(s)
      this.setSharedData("HomeRecord", s)
      控件可见(page_home)
      控件隐藏(page_forum)
     elseif s == "论坛" then
      ch_light(s)
      require "ForumHomepageCode"
      加载论坛()
      if ltclicked~=true then
        delay(500,function()
          ltclicked=true
          if url then
            加载论坛()
            签到()
           else
            提示("论坛维护中")
          end
        end)
      end
      this.setSharedData("HomeRecord", s)
      控件可见(page_forum)
      控件隐藏(page_home)
     elseif s == "分享" then
      提示("稍等...")
      -- 调用 fetchData 函数获取数据
      update.fetchData(function(data)
        if data and data.备用链接 then
          -- 分享逻辑
          local text = "我正在使用同学开发的Phoenix，集成了众多实用的功能，来一起使用吧(ฅ>ω<*ฅ)\n下载链接："..data.备用链接
          local intent = Intent(Intent.ACTION_SEND)
          intent.setType("text/plain")
          intent.putExtra(Intent.EXTRA_SUBJECT, "分享")
          intent.putExtra(Intent.EXTRA_TEXT, text)
          intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
          activity.startActivity(Intent.createChooser(intent, "分享到:"))
         else
          -- 如果没有获取到备用链接，提示用户
          提示("无法获取分享链接，请检查网络连接")
        end
      end)
     elseif s == "关于" then
      -- 双按钮对话框("关于软件","点击“联系作者”可以联系我\n本软件未开源，链接见主页","完成","联系作者",function()关闭对话框(an)end,function()QQ("")关闭对话框(an)end)
     elseif s == "捐赠" then
      跳转页面("page/donate")
     elseif s == "设置" then
      跳转页面("setting")
     elseif s == "联系开发者" then
      activity.newActivity("script/kfhome", {url, admin, user, password, key, isEncrypt})
     elseif s == "公告" then
      提示("请稍等...")
      公告()
     elseif s == "下载管理" then
      File("/sdcard/Phoenix/Download").mkdirs()
      path = "/sdcard/Phoenix/Download"
      activity.newActivity("page/FileManager", {path})
     else
      Snakebar(s)
    end
  end
})

-- 标题栏点击事件处理
function btn.onClick()
  mDrawer.openDrawer(3)
end

function 头像id.onClick()
  this.setSharedData("popRecord", 1)
  弹出登录()
end

function btn1.onClick()
  activity.newActivity("script/chatMess", {url, admin, user, password, key, isEncrypt, secret})
end

function btn2.onClick()
  if 全局主题值=="Night" then
    TipsColor = 图标("Tips")
   else
    TipsColor = 图标("NightTips")
  end
  io.open(activity.getLuaDir().. "/set/TipsColor.txt", "w"):write(TipsColor):close()
  activity.newActivity("script/mess", {url, admin, user, password, key, isEncrypt, secret})
end

-- 右上角添加菜单
pophome = PopupMenu(activity, menu)
menu = pophome.Menu
menu.add("公众号").onMenuItemClick = function()
  弹窗 = {
    FrameLayout,
    layout_width = 'fill',
    {
      LinearLayout,
      orientation = 'vertical',
      layout_width = 'fill',
      {
        ImageView;
        src = 'image/officialaccount.png';
        layout_width = '480dp';
        layout_height = '250dp';
        layout_gravity = 'center';
      };
    };
  }
  xxx = AlertDialog.Builder(this)
  xxx.setTitle("截图到微信扫码关注")
  xxx.setView(loadlayout(弹窗))
  xxx.setPositiveButton("知道了", nil)
  xxx = xxx.show()
  import "android.graphics.drawable.ColorDrawable"
  xxx.getWindow().setBackgroundDrawable(ColorDrawable(0x00000000))
end

menu.add("教程").onMenuItemClick = function()
  update.fetchData(function(data)
    if data and data.教程链接 then
      弹窗网页(data.教程链接)
    end
  end)
end

menu.add("聊天室").onMenuItemClick = function()
  activity.newActivity("script/chatRoom", {url, admin, user, password, key, isEncrypt, secret})
end

function btn3.onClick()
  pophome.show()
end

-- 封装页面加载逻辑
local pageLoaders = {
  [0] = function()
    if not LoadingCheck1 then
      task(100,function() 界面1加载() end)
      LoadingCheck1 = true
    end
  end,
  [1] = function()
    vpnurl = "https://webvpn.stu.edu.cn/portal/#!/login"
    local vpnweb = vpn.getSettings()
    if this.getSharedData("NightMode") == "true" then
      vpnweb.setForceDark(WebSettings.FORCE_DARK_ON)
    end
    vpn.loadUrl(vpnurl)
  end,
  [2] = function()
    if not LoadingCheck3 then
      import "fun3"
      界面3加载()
      LoadingCheck3 = true
    end
  end,
  [3] = function()
    if not 音乐网页加载 then
      musicurl = "https://60s.coom.cn/"
      local myfreemp3musics = myfreemp3music.getSettings()
      myfreemp3musics.setJavaScriptEnabled(true)
      if this.getSharedData("NightMode") == "true" then
        myfreemp3musics.setForceDark(WebSettings.FORCE_DARK_ON)
      end
      myfreemp3music.setWebViewClient{
        onPageFinished = function(view, url)
          local targetColor = string.gsub(转0x(主题色), "^#FF", "#")
          local jsquchu = string.format([[
                              // 获取所有的<style>元素
            var styleElements = document.getElementsByTagName('style');
            for (var i = 0; i < styleElements.length; i++) {
                var styleElement = styleElements[i];
                // 获取元素的文本内容
                var textContent = styleElement.textContent;
                // 替换.root-color类选择器中的颜色值
                var newTextContent = textContent.replace(/(\.root-color\s*{color:)[^;]+(;})/g, '$1%s$2');
                // 将修改后的内容重新赋值给textContent
                styleElement.textContent = newTextContent;
            }
            // 获取元素并修改背景颜色为透明等其他操作（这里保持不变，可按需继续调整）
            var element = document.getElementById('lylme');
            if (element) {
                element.style.backgroundColor = 'transparent';
            }
            var header = document.querySelector('header');
            if (header) {
                while (header.firstChild) {
                    header.removeChild(header.firstChild);
                }
            }
            var saveimgButton = document.getElementById('saveimg');
            if (saveimgButton) {
                saveimgButton.parentNode.removeChild(saveimgButton);
            }
                    ]], targetColor)
          myfreemp3music.evaluateJavascript(jsquchu, nil)
        end
      }
      myfreemp3music.loadUrl(musicurl)
      音乐网页加载 = true
    end
  end
}

-- 页面滑动监听
pagev.addOnPageChangeListener({
  onPageScrolled = function(a, b, c)
    local scrollBefore = activity.getWidth() / 4 * (b + a)
    scrollbar.setX(scrollBefore)
  end,
  onPageSelected = function(position)
    local loader = pageLoaders[position]
    if loader then
      loader()
    end
  end
})

--[[
delay(3000, function()
  -- 侧滑栏飘落特效
  import "com.mslh.LeafView"
  h = activity.getLuaPath("image/icon/Snowflakes")
  u = h..".png"
  l.addView(LeafView(this, u))
end)
]]

-- 标题下功能栏点击事件处理
tab1.onClick = function()
  pagev.showPage(0)
end

tab2.onClick = function()
  pagev.showPage(1)
end

tab3.onClick = function()
  pagev.showPage(2)
end

tab3.onLongClick = function()
  提示("状态验证中...")
  if url then
    local api=url.."main/api/user/user_vip.php"
    codekey=Narcissus.encrypt(key)
    local body={
      ["admin"]=admin,
      ["user"]=user,
      ["password"]=password,
      ["key"]=codekey
    }
    Http.post(api,body,nil,nil,function (code,body)
      if code==200 then
        local data=cjson.decode(body)
        if data.code==1 then
          if data.msg==1 then
            跳转页面("page/kx")
            提示("欢迎使用Phoenix选课系统 Power by 默睦")
           else
            if 授权状态 == true then
              if this.getSharedData("kxSwitch")=="true" then
                跳转页面("page/kx")
                提示("欢迎使用Phoenix选课系统 Power by 默睦")
               else
                提示("会员入口已关闭，请等待开启，已跳转入普通入口")
              end
             else
              提示("已进入教务系统选课入口")
              pagev.showPage(3)
              delay(500,function() myfreemp3music.loadUrl("jw.stu.edu.cn") end)
            end
          end
         else
          提示(data.msg)
        end
       else
        提示("Http error code:"..code)
      end
    end)
   else
    if 授权状态 == true then
      if this.getSharedData("kxSwitch")=="true" then
        跳转页面("page/kx")
        提示("欢迎使用Phoenix选课系统 Power by 默睦")
       else
        提示("会员入口已关闭，请等待开启，已跳转入普通入口")
      end
     else
      提示("已进入教务系统选课入口")
      pagev.showPage(3)
      delay(500,function() myfreemp3music.loadUrl("https://jw.stu.edu.cn/jsxsd/framework/xsMainV.htmlx") end)
    end
  end
end

tab4.onClick = function()
  pagev.showPage(3)
end

-- 悬浮球配置
function setupFloatingButton()
  Thread(Runnable({
    run = function()
      import "android.view.animation.Animation$AnimationListener"
      import "android.view.animation.ScaleAnimation"
      function CircleButton(InsideColor, radiu,...)
        import "android.graphics.drawable.GradientDrawable"
        drawable = GradientDrawable()
        drawable.setShape(GradientDrawable.RECTANGLE)
        drawable.setColor(InsideColor)
        drawable.setCornerRadii({radiu, radiu, radiu, radiu, radiu, radiu, radiu, radiu});
        for k, v in ipairs({...}) do
          v.setBackgroundDrawable(drawable)
        end
      end
      CircleButton(转0x(barbackgroundc), 100, bt, bt1, bt2)
      bt.onClick = function(v)
        if bt1.getVisibility() == 0 then
          bt2.startAnimation(ScaleAnimation(1.0, 0.0, 1.0, 0.0, 1, 0.5, 1, 0.5).setDuration(200))
          bt2.setVisibility(View.INVISIBLE)
          bt1.startAnimation(ScaleAnimation(1.0, 0.0, 1.0, 0.0, 1, 0.5, 1, 0.5).setDuration(300))
          bt1.setVisibility(View.INVISIBLE)
          bt.text = "快捷"
         else
          bt1.setVisibility(View.VISIBLE)
          bt2.setVisibility(View.VISIBLE)
          bt1.startAnimation(ScaleAnimation(0.0, 1.0, 0.0, 1.0, 1, 0.5, 1, 0.5).setDuration(200))
          bt2.startAnimation(ScaleAnimation(0.0, 1.0, 0.0, 1.0, 1, 0.5, 1, 0.5).setDuration(300))
          bt.text = "关闭"
        end
      end
      bt1.onClick = function(v)
        bt1.startAnimation(ScaleAnimation(1.0, 0.0, 1.0, 0.0, 1, 0.5, 1, 0.5).setDuration(200))
        bt1.setVisibility(View.INVISIBLE)
        bt2.startAnimation(ScaleAnimation(1.0, 0.0, 1.0, 0.0, 1, 0.5, 1, 0.5).setDuration(300))
        bt2.setVisibility(View.INVISIBLE)
        bt.text = "快捷"
        activity.newActivity("script/chatRoom", {url, admin, user, password, key, isEncrypt, secret})
      end
      bt2.onClick = function(v)
        bt1.startAnimation(ScaleAnimation(1.0, 0.0, 1.0, 0.0, 1, 0.5, 1, 0.5).setDuration(200))
        bt1.setVisibility(View.INVISIBLE)
        bt2.startAnimation(ScaleAnimation(1.0, 0.0, 1.0, 0.0, 1, 0.5, 1, 0.5).setDuration(300))
        bt2.setVisibility(View.INVISIBLE)
        bt.text = "快捷"
        跳转页面("page/AI")
      end
    end
  })).start()
end

setupFloatingButton()

-- 读取TipsColor
Thread(Runnable({
  run = function()
    local tipsColorFile = io.open(activity.getLuaDir().. "/set/TipsColor.txt")
    if tipsColorFile then
      local tipsColor = tipsColorFile:read("*a")
      tipsColorFile:close()
      activity.runOnUiThread(Runnable({
        run = function()
          TipsColor = tipsColor
        end
      }))
    end
  end
})).start()

-- 图颜文和校园网账号读取
Thread(Runnable({
  run = function()
    图颜文(
    function(一图)
      import "android.graphics.drawable.BitmapDrawable"
      activity.runOnUiThread(Runnable({
        run = function()
          title_box.setBackground(BitmapDrawable(loadbitmap(一图)))
        end
      }))
    end,
    function(一言)
      activity.runOnUiThread(Runnable({
        run = function()
          yiyan.setText(一言)
        end
      }))
    end
    )
    local localMsFile = io.open(activity.getLuaDir().. "/set/message.txt")
    if localMsFile then
      local localMs = localMsFile:read("*a")
      localMsFile:close()
      local username = localMs:match('username":"(.-)"')
      if username then
        activity.runOnUiThread(Runnable({
          run = function()
            名字id.setText("欢迎 ".. username)
            时间=os.date("%Y年%m月%d日 星期%w")
            签名id.setText(时间)
            timenow.setText(时间)
          end
        }))
      end
    end
  end
})).start()

-- 定义公告函数
function 公告()
  -- 调用 a.lua 的 fetchData 函数获取数据
  update.fetchData(function(data)
    if data and data.feedbacksay then
      -- 使用获取到的 feedbacksay 显示对话框
      单按钮对话框("公告(实时更新):", data.feedbacksay, "知道了", function() an.dismiss() end, 1)
     else
      -- 如果没有获取到 feedbacksay，显示默认提示
      单按钮对话框("公告(实时更新):", "暂无公告", "知道了", function() an.dismiss() end, 1)
    end
  end)
end

-- 创建主线程的 Handler 实例
local mainHandler = Handler(Looper.getMainLooper())

-- 获取刷新间隔时间，单位为秒，默认值为 60 秒
local refreshInterval = tonumber(this.getSharedData("OA刷新间隔")) or 10
local refreshIntervalMillis = refreshInterval * 1000 -- 转换为毫秒

-- 定义定时刷新任务
local function startOARefreshTask1()
  -- 启动 OA 提示线程
  Thread(Runnable({
    run = function()
      import "mods.Newbar"
      if this.getSharedData("OASwitch") == "true" then
        local filename = activity.getLuaDir() .. "/set/OAHistoryRecord.txt"
        function saveTextToFile(text)
          local file = io.open(filename, "a+")
          file:write(text)
          file:close()
        end
        function loadTextFromFile()
          local file = io.open(filename, "r")
          if file then
            local text = file:read("*a")
            file:close()
            return text
           else
            return nil
          end
        end
        local file = io.open(activity.getLuaDir() .. "/set/CookOA.txt", "r")
        if file ~= "" and file then
          oatoken = file:read("*a")
          file:close()
          if oatoken ~= "" then
            local url = 'http://wechat.stu.edu.cn/webservice_oa/oa_stu_/GetDoc'
            local data = "token=" .. oatoken .. "&subcompany_id=0&keyword=&row_start=0&row_end=17"
            local data1 = tostring(data)
            local header = {
              ["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8"
            }
            Http.post(url, data, 'utf8', header, function(状态码, c)
              if 状态码 == 200 then
                网页框架 = c:gmatch('DOCSUBJECT":"(.-)",')
                网页框架表 = {}
                更新的 = {}
                for i in 网页框架 do
                  table.insert(网页框架表, i)
                end
                local 文本1 = ''
                显示文本 = ''
                for k, v in pairs(网页框架表) do
                  local 文本1 = '\n' .. string.format('%s', v)
                  local oldText = loadTextFromFile()
                  local pattern = 文本1
                  :gsub(" -", "%%-")
                  :gsub("%-", "-")
                  :gsub("「", "%%「")
                  :gsub("；", "%%；")
                  :gsub("：", "%%：")
                  :gsub("！", "%%！")
                  :gsub(" 、", "%%、")
                  :gsub("；", "%%；")
                  :gsub("…", "%%…")
                  :gsub("%%", "%%%%")
                  :gsub("%[", "%%[")
                  :gsub("%]", "%%]")
                  :gsub("［", "%%［")
                  :gsub("］", "%%］")
                  :gsub("“", "%%“")
                  :gsub("”", "%%”")
                  :gsub(" （", "%%（")
                  :gsub(" ）", "%%）")
                  :gsub("%)", "%%)")
                  :gsub("%(", "%%(")
                  :gsub("—", "%%—")
                  :gsub("」", "%%」")
                  :gsub("。", "%%。")
                  :gsub("&lt;", "%%<")
                  :gsub("&gt;", "%%>")
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
                  local match1 = string.match(oldText, pattern)
                  if match1 == nil then
                    table.insert(更新的, v)
                    saveTextToFile(文本1)
                  end
                end
                for k, v in pairs(更新的) do
                  显示文本 = 显示文本 .. '\n' .. string.format('%s', v)
                end
                if 显示文本 ~= "" then
                  activity.runOnUiThread(Runnable({
                    run = function()
                      Nbar("OA更新啦：\n" .. 显示文本)
                      -- 调用通知模块创建通知
                      NotificationModule.createNotification(activity, "OA有更新", 显示文本)
                      震动(300)
                    end
                  }))
                end
               else
                activity.runOnUiThread(Runnable({
                  run = function()
                    Nbar('获取内容失败')
                  end
                }))
              end
            end)
          end
        end
      end
    end
  })).start()

  -- 定时调用自身，实现周期性刷新
  mainHandler.postDelayed(startOARefreshTask1, refreshIntervalMillis)
end

-- 启动定时刷新任务
startOARefreshTask1()


function onResume()
  -- 更新UI状态，例如检查夜间模式是否开启并相应调整主题
  if 全局主题值=="Day" then
    TitleMenuBarColor = 图标("navnight")
    MoreColor = 图标("MoreBlack")
    TipsColor = 图标("NightTips")
   else
    TitleMenuBarColor = "image/icon/navnav.png"
    MoreColor = "image/icon/More.png"
    TipsColor = "image/icon/Tips.png"
  end
end