require "import"
-- 导入必要的模块
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.content.Context"
import "android.net.Uri"
import "com.lua.*"
import "android.content.Intent"
import "android.app.Activity"
import "mods.muk"
import "android.webkit.CookieSyncManager"
import "android.webkit.CookieManager"

value1,value2=...


-- 定义字体
字体("product")

-- 返回上一页函数
function 返回()
  activity.finish()
end

-- 浏览器布局定义
浏览器 = {
  LinearLayout,
  orientation = "vertical",
  layout_height = "-1",
  background = "/storage/emulated/0/Phoenix/Wallpaper/1.png",
  layout_width = "fill",
  {
    LinearLayout,
    layout_width = "match_parent",
    layout_height = "45dp",
    layout_marginRight = "-19dp",
    layout_marginTop = "30dp",
    layout_gravity = "right",
    {
      TextView,
      textSize = "16sp",
      text = "Phoenix by言和",
      id = "浏览器标题",
      textColor = "#F8FAFF",
      Typeface = 字体("product")
    },
    {
      Button,
      text = "复制网址",
      layout_width = "80dp",
      alpha = 0.85,
      onClick = "复制网址"
    },
    {
      Button,
      text = "UA设置",
      layout_width = "80dp",
      alpha = 0.85,
      onClick = "UA设置"
    },
    {
      Button,
      alpha = 0.83,
      layout_width = "80dp",
      text = "返回",
      onClick = "返回"
    }
  },
  {
    LinearLayout,
    orientation = "vertical",
    layout_width = "fill",
    layout_height = "fill",
    {
      LuaWebView,
      id = "llq",
      layout_height = "match_parent",
      layout_width = "match_parent"
    }
  }
}

activity.setContentView(loadlayout(浏览器))

-- 复制网址函数
function 复制网址()
  Snakebar("已复制")
  local clipboardService = activity.getSystemService(Context.CLIPBOARD_SERVICE)
  clipboardService.setText(llq.getUrl())
end

-- 浏览器标题长按事件处理
浏览器标题.onLongClick = function()
  if value1:match("by") then
   else
    弹窗(value1)
  end
end

-- 弹窗函数
function 弹窗(message)
  AlertDialog.Builder(this)
  .setTitle("介绍")
  .setMessage(message)
  .setPositiveButton("知道了", function() end)
  .setNegativeButton("复制链接", 复制网址)
  .show()
end

-- 获取WebView设置
webSettings = llq.getSettings()

-- 支持JS
webSettings.setJavaScriptEnabled(true)

-- 设置WebView缩放相关属性
webSettings.setSupportZoom(true)
webSettings.setDisplayZoomControls(false)
webSettings.setBuiltInZoomControls(true)
webSettings.setUseWideViewPort(true)
webSettings.setLoadWithOverviewMode(true)

-- 设置夜间模式（如果适用）
if this.getSharedData("webNM") == "true" then
  webSettings.setForceDark(WebSettings.FORCE_DARK_ON)
end

-- 加载初始URL
llq.loadUrl(value2)

-- UA设置函数
function UA设置()
  local items = {"移动端UA", "桌面端UA", "塞班UA", "神秘UA", "QQ浏览器UA", "百度无广告UA"}

  AlertDialog.Builder(this)
  .setTitle("设置UA")
  .setItems(items, {onClick = function(dialog, which)
      local uaStrings = {
        ["移动端UA"] = "Mozilla/5.0 (Linux; Android 7.1.2; Build/NJH47F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.109 Safari/537.36",
        ["桌面端UA"] = "User-Agent:Mozilla/5.0 (Windows NT 6.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1",
        ["塞班UA"] = "user-agent = Mozilla/5.0 (SymbianOS/9.4; Series60/5.0 Nokia5800d-1/60.0.003; Profile/MIDP-2.1 Configuration/CLDC-1.1 ) AppleWebKit/533.4 (KHTML, like Gecko) NokiaBrowser/7.3.1.33 Mobile Safari/533.4 3gpp-gba",
        ["神秘UA"] = "user-agent = Mozilla/5.0Dalvik/2( Linux; U;NEM-AL10Build/HONORNEM-AL10; Youku;7.1.4;)AppleWebKit/537.36( KHTML, like Gecko)Version/4.0Safari/537.36( Baidu;P16.0)iPhone/7.1Android/8.0",
        ["QQ浏览器UA"] = "User-Agent: MQQBrowser/26 Mozilla/5.0 (Linux; U; Android 2.3.7; zh-cn; MB200 Build/GRJ22; CyanogenMod-7) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1",
        ["百度无广告UA"] = "Mozilla/5.0 (Linux; Android 7.0; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/48.0.2564.116 Mobile Safari/537.36 T7/10.3 SearchCraft/2.6.2 (Baidu; P1 7.0)"
      }
      local selectedUA = uaStrings[items[which]]
      if selectedUA then
        print(selectedUA)
        llq.getSettings().setUserAgentString(selectedUA)
        llq.reload()
      end
    end})
  .show()
end

-- WebView客户端设置
llq.setWebViewClient{
  onPageFinished = function(view, url)
    local filename = activity.getLuaDir().. "/set/nowurl.txt"
    io.open(filename, "w"):write(url):close()

    -- 判断是否为登录页面，尝试自动登录
    if url:match("login") then
      local localMs = io.open(activity.getLuaDir().. "/set/message.txt"):read("*a")
      local username = localMs:match('username":"(.-)"')
      local password = localMs:match('password":"(.-)"')
      if username then
        local jsLDAP = string.format([[
                var ldapAccountInput = document.getElementById('ldap_account');
                var ldapPasswordInput = document.getElementById('ldap_password');
                var okButton = document.getElementById('btn_ok');

                if (ldapAccountInput && ldapPasswordInput && okButton) {
                    ldapAccountInput.value = '%s';
                    ldapPasswordInput.value = '%s';
                    okButton.click();
                }
                ]], username, password)

        local jsNormal = string.format([[
                var usernameInput = document.getElementById('username');
                var passwordInput = document.getElementById('password');
                var loginButton = document.getElementById('login');

                if (usernameInput && passwordInput && loginButton) {
                    usernameInput.value = '%s';
                    passwordInput.value = '%s';
                    loginButton.click();
                }
                ]], username, password)

        view.evaluateJavascript(jsLDAP.. jsNormal, nil)
       else
        dialog = AlertDialog.Builder(this)
        .setMessage("请先打开侧边栏登录校园网账号才会自动登录")
        .show()
        dialog.create()
      end
    end
  end,
  shouldOverrideUrlLoading = function(view, url)
    -- 可在此添加自定义的URL加载逻辑
  end
}

-- WebView下载监听器设置
llq.setDownloadListener({
  onDownloadStart = function(url, userAgent, contentDisposition, mimetype, contentLength)
    提示("下载中...")
    local downloadManager = activity.getSystemService(Context.DOWNLOAD_SERVICE)
    local request = DownloadManager.Request(Uri.parse(url))
    local cookies = 获取Cookie(url)
    local filename = url:match("/([^/]+)$")

    request.setMimeType("application/octet-stream")
    request.addRequestHeader("Cookie", cookies)
    request.setAllowedNetworkTypes(DownloadManager.Request.NETWORK_MOBILE or DownloadManager.Request.NETWORK_WIFI)
    request.setDestinationInExternalPublicDir("Phoenix/Download", filename)
    request.setTitle(filename)
    request.setDescription("下载路径：Phonenix/Download")
    request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)

    downloadManager.enqueue(request)
  end
})

uploadMessageAboveL = 0
llq.setWebChromeClient(LuaWebChrome(LuaWebChrome.IWebChrine{
  onShowFileChooser = function(v, fic)
    uploadMessageAboveL = fic
    local intet = Intent(Intent.ACTION_GET_CONTENT)
    intet.addCategory(Intent.CATEGORY_OPENABLE)
    intet.setType("*/*")
    activity.startActivityForResult(Intent.createChooser(intet, "File Chooser"), 1)
    return true
  end
}))

-- 处理活动结果
onActivityResult=function(req,res,intent)
  if (res == Activity.RESULT_CANCELED) then
    if(uploadMessageAboveL~=nil )then
      uploadMessageAboveL.onReceiveValue(nil);
    end
  end
  local results
  if (res == Activity.RESULT_OK)then
    if(uploadMessageAboveL==nil or type(uploadMessageAboveL)=="number")then
      return;
    end
    if (intent ~= nil) then
      local dataString = intent.getDataString();
      local clipData = intent.getClipData();
      if (clipData ~= nil) then
        results = Uri[clipData.getItemCount()];
        for i = 0,clipData.getItemCount()-1 do
          local item = clipData.getItemAt(i);
          results[i] = item.getUri();
        end
      end
      if (dataString ~= nil) then
        results = Uri[1];
        results[0]=Uri.parse(dataString)
      end
    end
  end
  if(results~=nil)then
    uploadMessageAboveL.onReceiveValue(results);
    uploadMessageAboveL = nil;
  end
end