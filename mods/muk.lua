require "import"
import "mods.imports"

globalData={
  casUrl=""
}

状态栏高度=activity.getResources().getDimensionPixelSize(luajava.bindClass("com.android.internal.R$dimen")().status_bar_height)
型号 = Build.MODEL
SDK版本 = tonumber(Build.VERSION.SDK)
安卓版本 = Build.VERSION.RELEASE
ROM类型 = string.upper(Build.MANUFACTURER)
内部存储路径=Environment.getExternalStorageDirectory().toString().."/"

应用版本名=activity.getPackageManager().getPackageInfo(activity.getPackageName(), PackageManager.GET_ACTIVITIES).versionName;
应用版本=activity.getPackageManager().getPackageInfo(activity.getPackageName(), PackageManager.GET_ACTIVITIES).versionCode;

function openWebPage(web弹窗, url)
  activity.newActivity("webliulan",{web弹窗,url})
end

function 震动(chixutime)
  --震动
  import "android.content.Context"
  --导入包
  vibrator = activity.getSystemService(Context.VIBRATOR_SERVICE)
  vibrator.vibrate( long{100,chixutime} ,-1)

end

function 状态栏颜色(n)
  pcall(function()
    local window=activity.getWindow()
    window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
    window.setStatusBarColor(n)
    statusbarcolor=n
    if SDK版本>=23 then
      if n==0x3f000000 then
        window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
        window.setStatusBarColor(0xffffffff)
       else
        window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_VISIBLE)
        window.setStatusBarColor(n)
      end
    end
    if Build.VERSION.SDK_INT >= 19 then
      activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
    end
  end)
end

function 导航栏颜色(n,n1)
  pcall(function()
    local window=activity.getWindow()
    window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
    window.setNavigationBarColor(n)
    if SDK版本>=23 then
      if n==0x3f000000 then
        window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR|View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
        window.setNavigationBarColor(0xffffffff)
       else
        if n1 then
          window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR|View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
         else
          window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_VISIBLE)
        end
        window.setNavigationBarColor(n)
      end
    end
  end)
end


function dp2px(dpValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return dpValue * scale + 0.5
end

function px2dp(pxValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return pxValue / scale + 0.5
end

function px2sp(pxValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity;
  return pxValue / scale + 0.5
end

function sp2px(spValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return spValue * scale + 0.5
end

function 写入文件(路径,内容)
  xpcall(function()
    f=File(tostring(File(tostring(路径)).getParentFile())).mkdirs()
    io.open(tostring(路径),"w"):write(tostring(内容)):close()
  end,function()
    提示("写入文件 "..路径.." 失败")
  end)
end

function 读取文件(路径)
  if 文件是否存在(路径) then
    rtn=io.open(路径):read("*a")
   else
    rtn=""
  end
  return rtn
end

function 复制文件(from,to)
  xpcall(function()
    LuaUtil.copyDir(from,to)
  end,function()
    提示("复制文件 从 "..from.." 到 "..to.." 失败")
  end)
end

function 创建文件夹(file)
  xpcall(function()
    File(file).mkdir()
  end,function()
    提示("创建文件夹 "..file.." 失败")
  end)
end

function 创建文件(file)
  xpcall(function()
    File(file).createNewFile()
  end,function()
    提示("创建文件 "..file.." 失败")
  end)
end

function 创建多级文件夹(file)
  xpcall(function()
    File(file).mkdirs()
  end,function()
    提示("创建文件夹 "..file.." 失败")
  end)
end

function 文件是否存在(file)
  return File(file).exists()
end

function 删除文件(file)
  xpcall(function()
    LuaUtil.rmDir(File(file))
  end,function()
    提示("删除文件(夹) "..file.." 失败")
  end)
end

function 获取文件修改时间(path)
  f = File(path);
  cal = Calendar.getInstance();
  time = f.lastModified()
  cal.setTimeInMillis(time);
  return cal.getTime().toLocaleString()
end

function 内置存储(t)
  return Environment.getExternalStorageDirectory().toString().."/"..t
end

function 压缩(from,to,name)
  ZipUtil.zip(from,to,name)
end

--
function 主题(str)
  --str="夜"
  全局主题值=str
  if 全局主题值=="Day" then
    primaryc="#448aff"
    secondaryc="#fdd835"
    textc="#212121"
    stextc="#424242"
    backgroundc="#ffffffff"
    主题色=this.getSharedData("主题色")
    barbackgroundc="#efffffff"
    cardbackc="#ffffffff"
    viewshaderc="#E0FFFFFF"
    grayc="#ECEDF1"
    状态栏颜色(0x3f000000)
    导航栏颜色(0x3f000000)
    _window = activity.getWindow();
    _window.setBackgroundDrawable(ColorDrawable(0xffffffff));
    _wlp = _window.getAttributes();
    _wlp.gravity = Gravity.BOTTOM;
    _wlp.width = WindowManager.LayoutParams.MATCH_PARENT;
    _wlp.height = WindowManager.LayoutParams.MATCH_PARENT;--WRAP_CONTENT
    _window.setAttributes(_wlp);
    activity.setTheme(android.R.style.Theme_DeviceDefault_Light_NoActionBar)
   elseif 全局主题值=="Night" then
    主题色=this.getSharedData("主题色")
    primaryc="#ff3368c0"--主要颜色
    secondaryc="#ffbfa328"--次要颜色
    textc="#ffffff"--文字颜色
    stextc="#666666"--副文字颜色
    backgroundc="#ff191919"--背景颜色
    barbackgroundc="#ef191919"--bar背景颜色
    cardbackc="#ff212121"
    viewshaderc="#90000000"
    grayc="#212121"
    状态栏颜色(0xff000000)
    导航栏颜色(0x3fFFFFFF)
    _window = activity.getWindow();
    _window.setBackgroundDrawable(ColorDrawable(0xff191919));
    _wlp = _window.getAttributes();
    _wlp.gravity = Gravity.BOTTOM;
    _wlp.width = WindowManager.LayoutParams.MATCH_PARENT;
    _wlp.height = WindowManager.LayoutParams.MATCH_PARENT;--WRAP_CONTENT
    _window.setAttributes(_wlp);
    activity.setTheme(android.R.style.Theme_DeviceDefault_NoActionBar)
  end
end
--



function 设置主题()
  if this.getSharedData("NightMode")=="true" then
    主题("Night")
   else
    主题("Day")
  end
end

设置主题()

pcall(function()activity.getActionBar().hide()end)

function 沉浸状态栏(n1,n2,n3)
  pcall(function()
    local window=activity.getWindow()
    window.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
    pcall(function()
      window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
      window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
      window.setStatusBarColor(Color.TRANSPARENT)
      window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_STABLE)
    end)
    if SDK版本>=23 then
      if n1 then
        window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_STABLE|View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR|View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
       elseif n2 then
        window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_STABLE|View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
       elseif n3 then
        window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_STABLE|View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR)
      end
    end

  end)
end


function setupNestedScrolling(listView, scrollView)
  import "android.view.MotionEvent"
  import "android.widget.ListView"
  listView.setOnTouchListener(View.OnTouchListener {
    onTouch = function(v, event)
      if event.getAction() == MotionEvent.ACTION_MOVE then
        if not listView.canScrollVertically(-1) then
          -- ListView不能向上滚动时允许ScrollView拦截事件
          scrollView.requestDisallowInterceptTouchEvent(true)

         else
          -- ListView可以向上滚动时禁止ScrollView拦截事件
          scrollView.requestDisallowInterceptTouchEvent(true)
        end
      end
      return false
    end
  })
end

function activity背景颜色(color)
  _window = activity.getWindow();
  _window.setBackgroundDrawable(ColorDrawable(color));
  _wlp = _window.getAttributes();
  _wlp.gravity = Gravity.BOTTOM;
  _wlp.width = WindowManager.LayoutParams.MATCH_PARENT;
  _wlp.height = WindowManager.LayoutParams.MATCH_PARENT;--WRAP_CONTENT
  _window.setAttributes(_wlp);
end

function 转0x(j)
  -- 互转
  if type(j) == "string" and j:match("#(.+)") then
    jj = j:match("#(.+)")
    jjj = tonumber("0x".. jj)
   else
    -- 0x转#，这里要确保传入的是非字符串类型的十六进制数值时正确转换，先转为十六进制字符串再拼接#
    jjj = string.format("#%06X", j)
  end
  return jjj
end

function toast(resource, text)
  toast_layout = {
    LinearLayout;
    orientation="vertical";
    {
      LinearLayout;
      gravity="center";
      layout_width="wrap_content";
      layout_height="wrap_content";
      {
        CardView;
        layout_marginLeft="10dp";
        radius="15dp";
        layout_width="wrap_content";
        layout_marginBottom="10dp";
        CardElevation="0dp";
        layout_marginRight="10dp";
        layout_marginTop="10dp";
        backgroundColor="0xFF38393B";
        layout_height="wrap_content";
        {
          LinearLayout;
          layout_marginLeft="10%w";
          layout_gravity="right";
          gravity="center";
          layout_width="wrap_content";
          layout_height="5%h";
          {
            TextView;
            layout_marginLeft="5dp";
            id="text_toast";
            layout_marginRight="10dp";
            textSize="15sp";
            textColor="0xFFFFFFFF";
          };
        };
        {
          LinearLayout;
          gravity="center";
          layout_height="5%h";
          layout_width="10%w";
          layout_gravity="left";
          layout_marginLeft="1%w";
          {
            ImageView;
            padding="5dp";
            src="icon.png";
            id="image_toast";
          };
        };
      };
    };
  };
  local duration_in_milliseconds = 5000 -- 5秒钟
  toast布局 = loadlayout(toast_layout)
  local toast = Toast.makeText(activity, "", duration_in_milliseconds).setView(toast布局).show()
  image_toast.setImageBitmap(loadbitmap(activity.getLuaDir() .."/".. resource))
  text_toast.setText(text)
end

function 提示(t)
  local w=activity.width

  local tsbj={
    LinearLayout,
    Gravity="bottom",
    {
      CardView,
      layout_width="-1";
      layout_height="-2";
      CardElevation="0",
      CardBackgroundColor=转0x(textc)-0x3f000000,
      Radius="8dp",
      layout_margin="16dp";
      layout_marginBottom="64dp";
      {
        LinearLayout,
        layout_height=-2,
        layout_width="-2";
        gravity="left|center",
        padding="16dp";
        paddingTop="12dp";
        paddingBottom="12dp";
        {
          TextView,
          textColor=转0x(backgroundc),
          textSize="14sp";
          layout_height=-2,
          layout_width=-2,
          text=t;
          Typeface=字体("product")
        },
      }
    }
  }

  Toast.makeText(activity,t,Toast.LENGTH_SHORT).setGravity(Gravity.BOTTOM|Gravity.CENTER, 0, 0).setView(loadlayout(tsbj)).show()
end


SnackerBar={shouldDismiss=true}
Snakebarnum=0

function Snakebar(fill)
  local w=activity.width

  local layout={
    LinearLayout,
    Gravity="bottom",
    paddingTop=activity.getResources().getDimensionPixelSize(luajava.bindClass("com.android.internal.R$dimen")().status_bar_height);
    {
      CardView,
      layout_height=-2,
      layout_width="200dp",
      layout_marginBottom=px2dp(Snakebarnum*160),
      CardElevation="0",
      CardBackgroundColor="#FF202124",
      Radius="4dp",
      layout_margin="16dp";
      {
        LinearLayout,
        layout_height=-2,
        layout_width=-1,
        gravity="left|center",
        padding="16dp";
        --paddingTop="12dp";
        --paddingBottom="12dp";
        {
          TextView,
          textColor=0xffffffff,
          textSize="14sp";
          layout_height=-2,
          id="Snakebartext",
          layout_width=-2,
          text=fill;
          Typeface=字体("product");
        },
      }
    }
  }

  local function addView(view)
    Snakebarnum=Snakebarnum+1
    local mLayoutParams=ViewGroup.LayoutParams
    (-1,-1)
    activity.Window.DecorView.addView(view,mLayoutParams)
  end

  local function removeView(view)
    activity.Window.DecorView.removeView(view)
  end

  function indefiniteDismiss(snackerBar)
    task(5000,function()
      if snackerBar.shouldDismiss==true then
        snackerBar:dismiss()
       else
        indefiniteDismiss(snackerBar)
      end
    end)
  end

  function SnackerBar:dismiss()
    Snakebarnum=Snakebarnum-1
    local view=self.view
    view.animate().translationY(500)
    .setDuration(400)
    .setInterpolator(AccelerateDecelerateInterpolator())
    .setListener(Animator.AnimatorListener{
      onAnimationEnd=function()
        removeView(view)
      end
    }).start()
  end

  SnackerBar.__index=SnackerBar

  function SnackerBar.build()
    local mSnackerBar={}
    setmetatable(mSnackerBar,SnackerBar)
    mSnackerBar.view=loadlayout(layout)
    mSnackerBar.bckView=mSnackerBar.view
    .getChildAt(0)
    mSnackerBar.textView=mSnackerBar.bckView
    .getChildAt(0)
    local function animate(v,tx,dura)
      ValueAnimator().ofFloat({v.translationX,tx}).setDuration(dura)
      .addUpdateListener( ValueAnimator.AnimatorUpdateListener
      {
        onAnimationUpdate=function( p1)
          local f=p1.animatedValue
          v.translationX=f
          v.alpha=1-math.abs(v.translationX)/w
        end
      }).addListener(ValueAnimator.AnimatorListener{
        onAnimationEnd=function()
          if math.abs(tx)>=w then
            removeView(mSnackerBar.view)
          end
        end
      }).start()
    end
    local frx,p,v,fx=0,0,0,0
    mSnackerBar.bckView.setOnTouchListener(View.OnTouchListener{
      onTouch=function(view,event)
        if event.Action==event.ACTION_DOWN then
          mSnackerBar.shouldDismiss=false
          frx=event.x-dp2px(8)
          fx=event.x-dp2px(8)
         elseif event.Action==event.ACTION_MOVE then
          if math.abs(event.rawX-dp2px(8)-frx)>=2 then
            v=math.abs((frx-event.rawX-dp2px(8))/(os.clock()-p)/1000)
          end
          p=os.clock()
          frx=event.rawX-dp2px(8)
          view.translationX=frx-fx
          view.alpha=1-math.abs(view.translationX)/w
         elseif event.Action==event.ACTION_UP then
          mSnackerBar.shouldDismiss=true
          local tx=view.translationX
          if tx>=w/5 then
            animate(view,w,(w-tx)/v)
           elseif tx>0 and tx<w/5 then
            animate(view,0,tx/v)
           elseif tx<=-w/5 then
            animate(view,-w,(w+tx)/v)
           else
            animate(view,0,-tx/v)
          end
          fx=0
        end
        return true
      end
    })
    return mSnackerBar
  end

  function SnackerBar:show()
    local view=self.view
    addView(view)
    view.translationY=300
    view.animate().translationY(0)
    .setInterpolator(AccelerateDecelerateInterpolator())
    .setDuration(400).start()
    indefiniteDismiss(self)
  end
  SnackerBar.build():show()
end

function 随机数(最小值,最大值)
  return math.random(最小值,最大值)
end

function 设置视图(t)
  activity.setContentView(loadlayout(t))
end

function 信息判断(code)
  if code/200==1 then
    return true
   else
    return false
  end
end

function 静态渐变(a,b,id,fx)
  if fx=="竖" then
    fx=GradientDrawable.Orientation.TOP_BOTTOM
  end
  if fx=="横" then
    fx=GradientDrawable.Orientation.LEFT_RIGHT
  end
  drawable = GradientDrawable(fx,{
    a,--右色
    b,--左色
  });
  id.setBackgroundDrawable(drawable)
end

ripple = activity.obtainStyledAttributes({android.R.attr.selectableItemBackgroundBorderless}).getResourceId(0,0)
ripples = activity.obtainStyledAttributes({android.R.attr.selectableItemBackground}).getResourceId(0,0)

function 波纹(id,lx)
  xpcall(function()
    for index,content in pairs(id) do
      if lx=="圆白" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
      end
      if lx=="方白" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
      end
      if lx=="圆黑" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
      end
      if lx=="方黑" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
      end
      if lx=="圆主题" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3f448aff})))
      end
      if lx=="方主题" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3f448aff})))
      end
      if lx=="圆自适应" then
        if 全局主题值=="Day" then
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
         else
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
        end
      end
      if lx=="方自适应" then
        if 全局主题值=="Day" then
          content.backgroundDrawable=(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3f000000})))
         else
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
        end
      end
    end
  end,function(e)end)
end

function 控件可见(a)
  a.setVisibility(View.VISIBLE)
end

function 控件不可见(a)
  a.setVisibility(View.INVISIBLE)
end

function 控件隐藏(a)
  a.setVisibility(View.GONE)
end

function 对话框按钮颜色(dialog,button,WidgetColor)
  if button==1 then
    dialog.getButton(dialog.BUTTON_POSITIVE).setTextColor(WidgetColor)
   elseif button==2 then
    dialog.getButton(dialog.BUTTON_NEGATIVE).setTextColor(WidgetColor)
   elseif button==3 then
    dialog.getButton(dialog.BUTTON_NEUTRAL).setTextColor(WidgetColor)
  end
end

function 关闭对话框(an)
  an.dismiss()
end

-- 定义函数，接收标题、提示内容、回调函数作为参数
function 输入对话框(title, promptText, callback)
  InputLayout = {
    LinearLayout;
    orientation = "vertical";
    Focusable = true,
    FocusableInTouchMode = true,
    {
      TextView;
      id = "Prompt",
      textSize = "15sp",
      layout_marginTop = "10dp";
      layout_marginLeft = "3dp",
      layout_width = "80%w";
      layout_gravity = "center",
      text = promptText; -- 使用传入的提示内容参数
    };
    {
      EditText;
      hint = "输入";
      layout_marginTop = "5dp";
      layout_width = "80%w";
      layout_gravity = "center",
      id = "edit";
    };
  };

  AlertDialog.Builder(this)
  .setTitle(title) -- 使用传入的标题参数
  .setView(loadlayout(InputLayout))
  .setPositiveButton("确定", {
    onClick = function(v)
      if callback then -- 判断回调函数是否存在，如果存在则调用
        callback(edit.Text)
      end
    end
  })
  .setNegativeButton("取消", nil)
  .show()

  import "android.view.View$OnFocusChangeListener"
  edit.setOnFocusChangeListener(OnFocusChangeListener{
    onFocusChange = function(v, hasFocus)
      if hasFocus then
        Prompt.setTextColor(0xFD009688)
      end
    end
  })
end


function 控件圆角(view,radiu,InsideColor)
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setColor(InsideColor)
  drawable.setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu});
  view.setBackgroundDrawable(drawable)
end

function 获取Cookie(url)
  import "android.webkit.CookieSyncManager"
  import "android.webkit.CookieManager"
  local cookieManager = CookieManager.getInstance();
  return cookieManager.getCookie(url);
end

function 设置Cookie(url,b)
  import "android.webkit.CookieSyncManager"
  import "android.webkit.CookieManager"
  local cookieManager = CookieManager.getInstance();
  cookieManager.removeSessionCookie() -- 移除会话 Cookie
  cookieManager.removeAllCookie() -- 移除所有 Cookie
  CookieSyncManager.getInstance().sync() -- 同步 Cookie 更改
  return cookieManager.setCookie(url,b);
end

function 获取文件拓展名(str)
  return str:match(".+%.(%w+)$")
end

function 三按钮对话框(bt,nr,qd,qx,ds,qdnr,qxnr,dsnr,gb)
  if 全局主题值=="Day" then
    bwz=0x3f000000
   else
    bwz=0x3fffffff
  end

  local gd2 = GradientDrawable()
  gd2.setColor(转0x(backgroundc))--填充
  local radius=dp2px(16)
  gd2.setCornerRadii({radius,radius,radius,radius,0,0,0,0})--圆角
  gd2.setShape(0)--形状，0矩形，1圆形，2线，3环形
  local dann={
    LinearLayout;
    layout_width="-1";
    layout_height="-1";
    {
      LinearLayout;
      orientation="vertical";
      layout_width="-1";
      layout_height="-2";
      Elevation="4dp";
      BackgroundDrawable=gd2;
      id="ztbj";
      {
        TextView;
        layout_width="-1";
        layout_height="-2";
        textSize="20sp";
        layout_marginTop="24dp";
        layout_marginLeft="24dp";
        layout_marginRight="24dp";
        Text=bt;
        Typeface=字体("product-Bold");
        textColor=primaryc;
      };
      {
        ScrollView;
        layout_width="-1";
        layout_height="-1";
        {
          TextView;
          layout_width="-1";
          layout_height="-2";
          textSize="14sp";
          layout_marginTop="8dp";
          layout_marginLeft="24dp";
          layout_marginRight="24dp";
          layout_marginBottom="8dp";
          Typeface=字体("product");
          Text=nr;
          textColor=textc;
          id="sandhk_wb";
        };
      };
      {
        LinearLayout;
        orientation="horizontal";
        layout_width="-1";
        layout_height="-2";
        gravity="right|center";
        {
          CardView;
          layout_width="-2";
          layout_height="-2";
          radius="2dp";
          background="#00000000";
          layout_marginTop="8dp";
          layout_marginLeft="24dp";
          layout_marginBottom="24dp";
          Elevation="0";
          onClick=dsnr;
          {
            TextView;
            layout_width="-1";
            layout_height="-2";
            textSize="16sp";
            Typeface=字体("product-Bold");
            paddingRight="16dp";
            paddingLeft="16dp";
            paddingTop="8dp";
            paddingBottom="8dp";
            Text=ds;
            textColor=stextc;
            BackgroundDrawable=activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{bwz}));
          };
        };
        {
          LinearLayout;
          orientation="horizontal";
          layout_width="-1";
          layout_height="-2";
          layout_weight="1";
        };
        {
          CardView;
          layout_width="-2";
          layout_height="-2";
          radius="2dp";
          background="#00000000";
          layout_marginTop="8dp";
          layout_marginLeft="8dp";
          layout_marginBottom="24dp";
          Elevation="0";
          onClick=qxnr;
          {
            TextView;
            layout_width="-1";
            layout_height="-2";
            textSize="16sp";
            Typeface=字体("product-Bold");
            paddingRight="16dp";
            paddingLeft="16dp";
            paddingTop="8dp";
            paddingBottom="8dp";
            Text=qx;
            textColor=stextc;
            BackgroundDrawable=activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{bwz}));
          };
        };
        {
          CardView;
          layout_width="-2";
          layout_height="-2";
          radius="4dp";
          background=primaryc;
          layout_marginTop="8dp";
          layout_marginLeft="8dp";
          layout_marginRight="24dp";
          layout_marginBottom="24dp";
          Elevation="1dp";
          onClick=qdnr;
          {
            TextView;
            layout_width="-1";
            layout_height="-2";
            textSize="16sp";
            paddingRight="16dp";
            paddingLeft="16dp";
            Typeface=字体("product-Bold");
            paddingTop="8dp";
            paddingBottom="8dp";
            Text=qd;
            textColor=backgroundc;
            BackgroundDrawable=activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{bwz}));
          };
        };
      };
    };
  };

  dl=AlertDialog.Builder(activity)
  dl.setView(loadlayout(dann))
  if gb==0 then
    dl.setCancelable(false)
  end
  an=dl.show()
  local window = an.getWindow();
  window.setBackgroundDrawable(ColorDrawable(0x00ffffff));
  local wlp = window.getAttributes();
  wlp.gravity = Gravity.BOTTOM;
  wlp.width = WindowManager.LayoutParams.MATCH_PARENT;
  wlp.height = WindowManager.LayoutParams.WRAP_CONTENT;
  window.setAttributes(wlp);
end


function 双按钮对话框(bt,nr,qd,qx,qdnr,qxnr,gb)
  if 全局主题值=="Day" then
    bwz=0x3f000000
   else
    bwz=0x3fffffff
  end

  local gd2 = GradientDrawable()
  gd2.setColor(转0x(backgroundc))--填充
  local radius=dp2px(16)
  gd2.setCornerRadii({radius,radius,radius,radius,0,0,0,0})--圆角
  gd2.setShape(0)--形状，0矩形，1圆形，2线，3环形
  local dann={
    LinearLayout;
    layout_width="-1";
    layout_height="-1";
    {
      LinearLayout;
      orientation="vertical";
      layout_width="-1";
      layout_height="-2";
      Elevation="4dp";
      BackgroundDrawable=gd2;
      id="ztbj";
      {
        TextView;
        layout_width="-1";
        layout_height="-2";
        textSize="20sp";
        layout_marginTop="24dp";
        layout_marginLeft="24dp";
        layout_marginRight="24dp";
        Text=bt;
        Typeface=字体("product-Bold");
        textColor=primaryc;
      };
      {
        ScrollView;
        layout_width="-1";
        layout_height="-1";
        {
          TextView;
          layout_width="-1";
          layout_height="-2";
          textSize="14sp";
          layout_marginTop="8dp";
          layout_marginLeft="24dp";
          layout_marginRight="24dp";
          layout_marginBottom="8dp";
          Typeface=字体("product");
          Text=nr;
          textColor=textc;
        };
      };
      {
        LinearLayout;
        orientation="horizontal";
        layout_width="-1";
        layout_height="-2";
        gravity="right|center";
        {
          CardView;
          layout_width="-2";
          layout_height="-2";
          radius="2dp";
          background="#00000000";
          layout_marginTop="8dp";
          layout_marginLeft="8dp";
          layout_marginBottom="24dp";
          Elevation="0";
          onClick=qxnr;
          {
            TextView;
            layout_width="-1";
            layout_height="-2";
            textSize="16sp";
            Typeface=字体("product-Bold");
            paddingRight="16dp";
            paddingLeft="16dp";
            paddingTop="8dp";
            paddingBottom="8dp";
            Text=qx;
            textColor=stextc;
            BackgroundDrawable=activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{bwz}));
          };
        };
        {
          CardView;
          layout_width="-2";
          layout_height="-2";
          radius="4dp";
          background=primaryc;
          layout_marginTop="8dp";
          layout_marginLeft="8dp";
          layout_marginRight="24dp";
          layout_marginBottom="24dp";
          Elevation="1dp";
          onClick=qdnr;
          {
            TextView;
            layout_width="-1";
            layout_height="-2";
            textSize="16sp";
            paddingRight="16dp";
            paddingLeft="16dp";
            Typeface=字体("product-Bold");
            paddingTop="8dp";
            paddingBottom="8dp";
            Text=qd;
            textColor=backgroundc;
            BackgroundDrawable=activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{bwz}));
          };
        };
      };
    };
  };

  dl=AlertDialog.Builder(activity)
  dl.setView(loadlayout(dann))
  if gb==0 then
    dl.setCancelable(false)
  end
  an=dl.show()
  window = an.getWindow();
  window.setBackgroundDrawable(ColorDrawable(0x00ffffff));
  wlp = window.getAttributes();
  wlp.gravity = Gravity.BOTTOM;
  wlp.width = WindowManager.LayoutParams.MATCH_PARENT;
  wlp.height = WindowManager.LayoutParams.WRAP_CONTENT;
  window.setAttributes(wlp);
end

function 单按钮对话框(bt,nr,qd,qdnr,gb)
  if 全局主题值=="日" then
    bwz=0x3f000000
   else
    bwz=0x3fffffff
  end

  local gd2 = GradientDrawable()
  gd2.setColor(转0x(backgroundc))--填充
  local radius=dp2px(16)
  gd2.setCornerRadii({radius,radius,radius,radius,0,0,0,0})--圆角
  gd2.setShape(0)--形状，0矩形，1圆形，2线，3环形
  local dann={
    LinearLayout;
    layout_width="-1";
    layout_height="-1";
    {
      LinearLayout;
      orientation="vertical";
      layout_width="-1";
      layout_height="-2";
      Elevation="4dp";
      BackgroundDrawable=gd2;
      id="ztbj";
      {
        TextView;
        layout_width="-1";
        layout_height="-2";
        textSize="20sp";
        layout_marginTop="24dp";
        layout_marginLeft="24dp";
        layout_marginRight="24dp";
        Typeface=Typeface.createFromFile(File(activity.getLuaDir().."/font/product.ttf"));
        Text=bt;
        textColor=primaryc;
      };
      {
        RelativeLayout;
        layout_width="-1";
        layout_height="-1";
        {
          ScrollView;
          layout_width="-1";
          layout_height="-1";
          layout_marginBottom=dp2px(24+8+16+8)+sp2px(16);
          {
            TextView;
            layout_width="-1";
            layout_height="-2";
            textSize="14sp";
            layout_marginTop="8dp";
            layout_marginLeft="24dp";
            layout_marginRight="24dp";
            layout_marginBottom="8dp";
            Typeface=Typeface.createFromFile(File(activity.getLuaDir().."/font/product.ttf"));
            Text=nr;
            textColor=textc;
          };
        };
        {
          LinearLayout;
          layout_width="-1";
          layout_height="-1";
          gravity="bottom|center";
          {
            LinearLayout;
            orientation="horizontal";
            layout_width="-1";
            layout_height="-2";
            gravity="right|center";
            background=barbackgroundc;
            {
              CardView;--24+8
              layout_width="-2";
              layout_height="-2";
              radius="4dp";
              background=primaryc;
              layout_marginTop="8dp";
              layout_marginLeft="8dp";
              layout_marginRight="24dp";
              layout_marginBottom="24dp";
              Elevation="1dp";
              onClick=qdnr;
              {
                TextView;--16+8
                layout_width="-1";
                layout_height="-2";
                textSize="16sp";
                paddingRight="16dp";
                paddingLeft="16dp";
                Typeface=Typeface.createFromFile(File(activity.getLuaDir().."/font/product.ttf"));
                paddingTop="8dp";
                paddingBottom="8dp";
                Text=qd;
                textColor=backgroundc;
                BackgroundDrawable=activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{bwz}));
              };
            };
          };
        };
      };
    };
  };
  dl=AlertDialog.Builder(activity)
  dl.setView(loadlayout(dann))
  if gb==0 then
    dl.setCancelable(false)
  end
  an=dl.show()
  window = an.getWindow();
  window.setBackgroundDrawable(ColorDrawable(0x00ffffff));
  wlp = window.getAttributes();
  wlp.gravity = Gravity.BOTTOM;
  wlp.width = WindowManager.LayoutParams.MATCH_PARENT;
  wlp.height = WindowManager.LayoutParams.WRAP_CONTENT;
  window.setAttributes(wlp);
end

function 解压缩(压缩路径,解压缩路径)
  xpcall(function()
    ZipUtil.unzip(压缩路径,解压缩路径)
  end,function()
    提示("解压文件 "..压缩路径.." 失败")
  end)
end

function openFile(path)
  --意图2（打开文件）
  import "android.webkit.MimeTypeMap"
  import "android.content.Intent"
  import "android.net.Uri"
  import "java.io.File"
  import "android.content.FileProvider"
  FileName=tostring(File(path).Name)
  ExtensionName=FileName:match("%.(.+)")
  Mime=MimeTypeMap.getSingleton().getMimeTypeFromExtension(ExtensionName)
  if Mime then
    intent2 = Intent()
    intent2.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    intent2.setAction(Intent.ACTION_VIEW);
    --  intent2.setDataAndType(Uri.fromFile(File(path)), Mime);
    intent2.setDataAndType(FileProvider.getUriForFile(this,this.getPackageName(),File(path)),Mime)
    intent2.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);--允许临时的读
    intent2.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION|Intent.FLAG_GRANT_WRITE_URI_PERMISSION);--允许临时的读和写
   else
    提示("没有合适的应用打开该文件")
    return false
  end
  openIntent(intent2)
end

function 压缩(原路径,压缩路径,名称)
  xpcall(function()
    LuaUtil.zip(原路径,压缩路径,名称)
  end,function()
    提示("压缩文件 "..原路径.." 至 "..压缩路径.."/"..名称.." 失败")
  end)
end

function 重命名文件(旧,新)
  xpcall(function()
    File(旧).renameTo(File(新))
  end,function()
    提示("重命名文件 "..旧.." 失败")
  end)
end

function 移动文件(旧,新)
  xpcall(function()
    File(旧).renameTo(File(新))
  end,function()
    提示("移动文件 "..旧.." 至 "..新.." 失败")
  end)
end

function 跳转页面(ym,cs)
  if cs then
    activity.newActivity(ym,cs)
   else
    activity.newActivity(ym)
  end
end

function 渐变跳转页面(ym,cs)
  if cs then
    activity.newActivity(ym,android.R.anim.fade_in,android.R.anim.fade_out,cs)
   else
    activity.newActivity(ym,android.R.anim.fade_in,android.R.anim.fade_out)
  end
end

function 隐藏标题栏()
  activity.ActionBar.hide()
end

function 检测键盘()
  imm = activity.getSystemService(Context.INPUT_METHOD_SERVICE)
  isOpen=imm.isActive()
  return isOpen==true or false
end

function 隐藏键盘()
  activity.getSystemService(INPUT_METHOD_SERVICE).hideSoftInputFromWindow(WidgetSearchActivity.this.getCurrentFocus().getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS)
end

function 显示键盘(id)
  activity.getSystemService(INPUT_METHOD_SERVICE).showSoftInput(id, 0)
end

function 关闭页面()
  activity.finish()
end

function 复制文本(文本)
  activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(文本)
  提示("已复制")
end

function QQ群(h)
  url="mqqapi://card/show_pslcard?src_type=internal&version=1&uin="..h.."&card_type=group&source=qrcode"
  activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
end

function QQ(h)
  import "android.content.Intent"
  import "android.net.Uri"
  url="mqqwpa://im/chat?chat_type=wpa&uin="..h
  activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
end

function 全屏()
  activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
end

function 退出全屏()
  activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
end

function 图标(n)
  return "image/icon/"..n..".png"
end

function 高斯模糊(id,tp,radius1,radius2)
  function blur( context, bitmap, blurRadius)
    renderScript = RenderScript.create(context);
    blurScript = ScriptIntrinsicBlur.create(renderScript, Element.U8_4(renderScript));
    inAllocation = Allocation.createFromBitmap(renderScript, bitmap);
    outputBitmap = bitmap;
    outAllocation = Allocation.createTyped(renderScript, inAllocation.getType());
    blurScript.setRadius(blurRadius);
    blurScript.setInput(inAllocation);
    blurScript.forEach(outAllocation);
    outAllocation.copyTo(outputBitmap);
    inAllocation.destroy();
    outAllocation.destroy();
    renderScript.destroy();
    blurScript.destroy();
    return outputBitmap;
  end
  bitmap=loadbitmap(tp)
  function blurAndZoom(context,bitmap,blurRadius,scale)
    return zoomBitmap(blur(context,zoomBitmap(bitmap, 1 / scale), blurRadius), scale);
  end

  function zoomBitmap(bitmap,scale)
    w = bitmap.getWidth();
    h = bitmap.getHeight();
    matrix = Matrix();
    matrix.postScale(scale, scale);
    bitmap = Bitmap.createBitmap(bitmap, 0, 0, w, h, matrix, true);
    return bitmap;
  end


  加深后的图片=blurAndZoom(activity,bitmap,radius1,radius2)
  id.setImageBitmap(加深后的图片)
end

function 获取应用信息(archiveFilePath)
  pm = activity.getPackageManager()
  info = pm.getPackageInfo(archiveFilePath, PackageManager.GET_ACTIVITIES);
  if info ~= nil then
    appInfo = info.applicationInfo;
    appName = tostring(pm.getApplicationLabel(appInfo))
    packageName = appInfo.packageName; --安装包名称
    version=info.versionName; --版本信息
    icon = pm.getApplicationIcon(appInfo);--图标
  end
  return packageName,version,icon
end

function 编辑框颜色(eid,color)
  eid.getBackground().setColorFilter(PorterDuffColorFilter(color,PorterDuff.Mode.SRC_ATOP))
end



function 下载文件(链接,文件名)
  downloadManager=activity.getSystemService(Context.DOWNLOAD_SERVICE);
  local request=DownloadManager.Request(Uri.parse(链接));
  request.setAllowedNetworkTypes(DownloadManager.Request.NETWORK_MOBILE|DownloadManager.Request.NETWORK_WIFI);
  request.setDestinationInExternalPublicDir("Phoenix/Download/",文件名);
  request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
  downloadManager.enqueue(request);
  Snakebar("正在下载文件，下载到:/storage/emulated/0/Phoenix/Download/"..文件名.."\n请查看通知栏以查看下载进度。")
end

function QYAPP文件(u,u2)
  if u2=="EXTERNAL" then
    if u =="" or u==nil then
      return "Phoenix"
     else
      return "Phoenix/"..u
    end
   else
    if u =="" or u==nil then
      return 内置存储("Phoenix")
     else
      return 内置存储("Phoenix/"..u)
    end
  end
end

function 获取文件MIME(name)
  ExtensionName=tostring(name):match("%.(.+)")
  Mime=MimeTypeMap.getSingleton().getMimeTypeFromExtension(ExtensionName)
  return tostring(Mime)
end

function xdc(url,path)
  require "import"
  import "java.net.URL"
  local ur =URL(url)
  import "java.io.File"
  file=File(path);
  local con = ur.openConnection();
  local co = con.getContentLength();
  local is = con.getInputStream();
  local bs = byte[1024]
  local len,read=0,0
  import "java.io.FileOutputStream"
  local wj= FileOutputStream(path);
  len = is.read(bs)
  while len~=-1 do
    wj.write(bs, 0, len);
    read=read+len
    pcall(call,"ding",read,co)
    len = is.read(bs)
  end
  wj.close();
  is.close();
  pcall(call,"dstop",co)
end
function appDownload(url,path)
  thread(xdc,url,path)
end

function 安装apk(安装包路径)
  activity.installApk(activity.getLuaDir(安装包路径))
end

function 下载文件对话框(title,url,path,ex)
  appDownload(url,path)
  local gd2 = GradientDrawable()
  gd2.setColor(转0x(backgroundc))--填充
  local radius=dp2px(16)
  gd2.setCornerRadii({radius,radius,radius,radius,0,0,0,0})--圆角
  gd2.setShape(0)--形状，0矩形，1圆形，2线，3环形
  local 布局={
    LinearLayout,
    id="appdownbg",
    layout_width="fill",
    layout_height="fill",
    orientation="vertical",
    BackgroundDrawable=gd2;
    {
      TextView,
      id="appdownsong",
      text=title,
      --  typeface=Typeface.DEFAULT_BOLD,
      layout_marginTop="24dp",
      layout_marginLeft="24dp",
      layout_marginRight="24dp",
      layout_marginBottom="8dp",
      textColor=primaryc,
      textSize="20sp",
    },
    {
      TextView,
      id="appdowninfo",
      text="已下载：0MB/0MB\n下载状态：准备下载",
      --id="显示信息",
      --  typeface=Typeface.MONOSPACE,
      layout_marginRight="24dp",
      layout_marginLeft="24dp",
      layout_marginBottom="8dp",
      textSize="14sp",
      textColor=textc;
    },
    {
      ProgressBar,
      id="进度条",
      style="?android:attr/progressBarStyleHorizontal",
      layout_width="fill",
      progress=0,
      max=100;
      layout_marginRight="24dp",
      layout_marginLeft="24dp",
      layout_marginBottom="24dp",
    },
  }
  local dldown=AlertDialog.Builder(activity)
  dldown.setView(loadlayout(布局))
  进度条.IndeterminateDrawable.setColorFilter(PorterDuffColorFilter(转0x(primaryc),PorterDuff.Mode.SRC_ATOP))
  dldown.setCancelable(false)
  local ao=dldown.show()
  window = ao.getWindow();
  window.setBackgroundDrawable(ColorDrawable(0x00ffffff));
  wlp = window.getAttributes();
  wlp.gravity = Gravity.BOTTOM;
  wlp.width = WindowManager.LayoutParams.MATCH_PARENT;
  wlp.height = WindowManager.LayoutParams.WRAP_CONTENT;
  window.setAttributes(wlp);


  function ding(a,b)--已下载，总长度(byte)
    appdowninfo.Text=string.format("%0.2f",a/1024/1024).."MB/"..string.format("%0.2f",b/1024/1024).."MB".."\n下载状态：正在下载"
    进度条.progress=(a/b*100)
  end

  function dstop(c)--总长度
    --[[if path:find(".bin") then
      lpath=path
      path=path:gsub(".bin",".apk")
      重命名文件(lpath,path)
    end]]
    关闭对话框(ao)

    if url:find("step")~=nil then
      提示("导入中…稍等哦(^^♪")
      解压缩(path,ex)
      删除文件(path)
      提示("导入完成ʕ•ٹ•ʔ")
     else
      提示("下载完成，大小"..string.format("%0.2f",c/1024/1024).."MB，储存在："..path)
      if path:find(".apk$")~=nil then
        双按钮对话框("安装APP",[===[您下载了安装包文件，要现在安装吗？]===],"立即安装","取消",function() 关闭对话框(an) 安装apk(path)end,function()关闭对话框(an)end)
       else
        openFile(path)
      end
    end
  end

end

function 申请权限(权限)
  ActivityCompat.requestPermissions(this,权限,1)
end
--申请权限({Manifest.permission.WRITE_EXTERNAL_STORAGE})--不可用

function 判断悬浮窗权限()
  if (Build.VERSION.SDK_INT >= 23 and not Settings.canDrawOverlays(this)) then
    return false
   elseif Build.VERSION.SDK_INT < 23 then
    return ""
   else
    return true
  end
end

function 获取悬浮窗权限()
  intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION);
  intent.setData(Uri.parse("package:" .. activity.getPackageName()));
  activity.startActivityForResult(intent, 100);
end

--[[if Settings.canDrawOverlays(this)==false then

  intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION);
  intent.setData(Uri.parse("package:" .. activity.getPackageName()));
  this.startActivity(intent);

  双按钮对话框("烦人但是必不可少的权限(； ･`д･´)","MUKSK的正常运行需要以下权限：\n悬浮窗权限（显示步骤教程）\n存储权限（保存数据）","开启权限","退出",function()
    获取权限()
    权限=1
  end,function()
    关闭对话框(an)
    关闭页面()
  end,0)

end]]


function 浏览器打开(pageurl)
  import "android.content.Intent"
  import "android.net.Uri"
  viewIntent = Intent("android.intent.action.VIEW",Uri.parse(pageurl))
  activity.startActivity(viewIntent)
end

function 设置图片(preview,url)
  preview.setImageBitmap(loadbitmap(url))
end

function 字体(t)
  return Typeface.createFromFile(File(activity.getLuaDir().."/font/"..t..".ttf"))
end

function 开关颜色(id,color,color2)
  id.ThumbDrawable.setColorFilter(PorterDuffColorFilter(转0x(color),PorterDuff.Mode.SRC_ATOP))
  id.TrackDrawable.setColorFilter(PorterDuffColorFilter(转0x(color2),PorterDuff.Mode.SRC_ATOP))
end

function 获取信息(nr,sth)
  Http.get(nr,function(code,content,cookie,header)
    --print(code,content)
    --print(code,content)
    if 0<code and code<400 then
      sth(content)
     else
      sth("error")
    end
  end)
end

--[[
function 微信扫一扫()
  intent = activity.getPackageManager().getLaunchIntentForPackage("com.tencent.mm");
  intent.putExtra("LauncherUI.From.Scaner.Shortcut", true);
  activity.startActivity(intent);
end]]

function 微信扫一扫()
  import "android.content.Intent"
  import "android.content.ComponentName"
  intent = Intent();
  intent.setComponent( ComponentName("com.tencent.mm", "com.tencent.mm.ui.LauncherUI"));
  intent.putExtra("LauncherUI.From.Scaner.Shortcut", true);
  intent.setFlags(335544320);
  intent.setAction("android.intent.action.VIEW");
  activity.startActivity(intent);
end

function 支付宝扫一扫()
  import "android.net.Uri"
  import "android.content.Intent"
  uri = Uri.parse("alipayqr://platformapi/startapp?saId=10000007");
  intent = Intent(Intent.ACTION_VIEW, uri);
  activity.startActivity(intent);
end

function 支付宝捐赠()
  --https://qr.alipay.com/fkx06301lzsvnw6bnfkfqe5
  xpcall(function()
    local url = "alipayqr://platformapi/startapp?saId=10000007&clientVersion=3.7.0.0718&qrcode=https://qr.alipay.com/fkx06301lzsvnw6bnfkfqe5"
    activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)));
  end,
  function()
    local url = "https://qr.alipay.com/fkx06301lzsvnw6bnfkfqe5";
    activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)));
  end)
end

function 颜色字体(t,c)--文本id，颜色
  local sp = SpannableString(t)
  sp.setSpan(ForegroundColorSpan(转0x(c)),0,#sp,Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
  return sp
end

function 翻译(str,sth)
  retstr=str
  import "com.kn.rhino.*"
  import "java.net.URLEncoder"

  res=Js.runFunction(activity,[[function token(a) {
    var k = "";
    var b = 406644;
    var b1 = 3293161072;

    var jd = ".";
    var sb = "+-a^+6";
    var Zb = "+-3^+b+-f";

    for (var e = [], f = 0, g = 0; g < a.length; g++) {
        var m = a.charCodeAt(g);
        128 > m ? e[f++] = m: (2048 > m ? e[f++] = m >> 6 | 192 : (55296 == (m & 64512) && g + 1 < a.length && 56320 == (a.charCodeAt(g + 1) & 64512) ? (m = 65536 + ((m & 1023) << 10) + (a.charCodeAt(++g) & 1023), e[f++] = m >> 18 | 240, e[f++] = m >> 12 & 63 | 128) : e[f++] = m >> 12 | 224, e[f++] = m >> 6 & 63 | 128), e[f++] = m & 63 | 128)
    }
    a = b;
    for (f = 0; f < e.length; f++) a += e[f],
    a = RL(a, sb);
    a = RL(a, Zb);
    a ^= b1 || 0;
    0 > a && (a = (a & 2147483647) + 2147483648);
    a %= 1E6;
    return a.toString() + jd + (a ^ b)
};

function RL(a, b) {
    var t = "a";
    var Yb = "+";
    for (var c = 0; c < b.length - 2; c += 3) {
        var d = b.charAt(c + 2),
        d = d >= t ? d.charCodeAt(0) - 87 : Number(d),
        d = b.charAt(c + 1) == Yb ? a >>> d: a << d;
        a = b.charAt(c) == Yb ? a + d & 4294967295 : a ^ d ;
    }
    return a
};]],"token",{str})
  url="https://translate.google.cn/translate_a/single?"
  datastr=""
  data={"client=webapp",
    "sl=auto",
    "tl=zh-CN",
    "hl=zh-CN",
    "dt=at",
    "dt=bd",
    "dt=ex",
    "dt=ld",
    "dt=md",
    "dt=qca",
    "dt=rw",
    "dt=rm",
    "dt=ss",
    "dt=t",
    "ie=UTF-8",
    "oe=UTF-8",
    "source=btn",
    "ssel=0",
    "tsel=0",
    "kc=0",
    "tk="..res,
    "q="..URLEncoder.encode(str)}
  datastr=table.concat(data,"&")
  Http.get(url..datastr,{["User-Agent"]="Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7"},function(code,content)
    rettior=content
    sth()
  end)
end

function MD5(str)

  local HexTable = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"}
  local A = 0x67452301
  local B = 0xefcdab89
  local C = 0x98badcfe
  local D = 0x10325476

  local S11 = 7
  local S12 = 12
  local S13 = 17
  local S14 = 22
  local S21 = 5
  local S22 = 9
  local S23 = 14
  local S24 = 20
  local S31 = 4
  local S32 = 11
  local S33 = 16
  local S34 = 23
  local S41 = 6
  local S42 = 10
  local S43 = 15
  local S44 = 21

  local function F(x,y,z)
    return (x & y) | ((~x) & z)
  end
  local function G(x,y,z)
    return (x & z) | (y & (~z))
  end
  local function H(x,y,z)
    return x ~ y ~ z
  end
  local function I(x,y,z)
    return y ~ (x | (~z))
  end
  local function FF(a,b,c,d,x,s,ac)
    a = a + F(b,c,d) + x + ac
    a = (((a & 0xffffffff) << s) | ((a & 0xffffffff) >> 32 - s)) + b
    return a & 0xffffffff
  end
  local function GG(a,b,c,d,x,s,ac)
    a = a + G(b,c,d) + x + ac
    a = (((a & 0xffffffff) << s) | ((a & 0xffffffff) >> 32 - s)) + b
    return a & 0xffffffff
  end
  local function HH(a,b,c,d,x,s,ac)
    a = a + H(b,c,d) + x + ac
    a = (((a & 0xffffffff) << s) | ((a & 0xffffffff) >> 32 - s)) + b
    return a & 0xffffffff
  end
  local function II(a,b,c,d,x,s,ac)
    a = a + I(b,c,d) + x + ac
    a = (((a & 0xffffffff) << s) | ((a & 0xffffffff) >> 32 - s)) + b
    return a & 0xffffffff
  end



  local function MD5StringFill(s)
    local len = s:len()
    local mod512 = len * 8 % 512
    --需要填充的字节数
    local fillSize = (448 - mod512) // 8
    if mod512 > 448 then
      fillSize = (960 - mod512) // 8
    end

    local rTab = {}

    --记录当前byte在4个字节的偏移
    local byteIndex = 1
    for i = 1,len do
      local index = (i - 1) // 4 + 1
      rTab[index] = rTab[index] or 0
      rTab[index] = rTab[index] | (s:byte(i) << (byteIndex - 1) * 8)
      byteIndex = byteIndex + 1
      if byteIndex == 5 then
        byteIndex = 1
      end
    end
    --先将最后一个字节组成4字节一组
    --表示0x80是否已插入
    local b0x80 = false
    local tLen = #rTab
    if byteIndex ~= 1 then
      rTab[tLen] = rTab[tLen] | 0x80 << (byteIndex - 1) * 8
      b0x80 = true
    end

    --将余下的字节补齐
    for i = 1,fillSize // 4 do
      if not b0x80 and i == 1 then
        rTab[tLen + i] = 0x80
       else
        rTab[tLen + i] = 0x0
      end
    end

    --后面加原始数据bit长度
    local bitLen = math.floor(len * 8)
    tLen = #rTab
    rTab[tLen + 1] = bitLen & 0xffffffff
    rTab[tLen + 2] = bitLen >> 32

    return rTab
  end

  --	Func:	计算MD5
  --	Param:	string
  --	Return:	string
  ---------------------------------------------

  function string.md5(s)
    --填充
    local fillTab = MD5StringFill(s)
    local result = {A,B,C,D}

    for i = 1,#fillTab // 16 do
      local a = result[1]
      local b = result[2]
      local c = result[3]
      local d = result[4]
      local offset = (i - 1) * 16 + 1
      --第一轮
      a = FF(a, b, c, d, fillTab[offset + 0], S11, 0xd76aa478)
      d = FF(d, a, b, c, fillTab[offset + 1], S12, 0xe8c7b756)
      c = FF(c, d, a, b, fillTab[offset + 2], S13, 0x242070db)
      b = FF(b, c, d, a, fillTab[offset + 3], S14, 0xc1bdceee)
      a = FF(a, b, c, d, fillTab[offset + 4], S11, 0xf57c0faf)
      d = FF(d, a, b, c, fillTab[offset + 5], S12, 0x4787c62a)
      c = FF(c, d, a, b, fillTab[offset + 6], S13, 0xa8304613)
      b = FF(b, c, d, a, fillTab[offset + 7], S14, 0xfd469501)
      a = FF(a, b, c, d, fillTab[offset + 8], S11, 0x698098d8)
      d = FF(d, a, b, c, fillTab[offset + 9], S12, 0x8b44f7af)
      c = FF(c, d, a, b, fillTab[offset + 10], S13, 0xffff5bb1)
      b = FF(b, c, d, a, fillTab[offset + 11], S14, 0x895cd7be)
      a = FF(a, b, c, d, fillTab[offset + 12], S11, 0x6b901122)
      d = FF(d, a, b, c, fillTab[offset + 13], S12, 0xfd987193)
      c = FF(c, d, a, b, fillTab[offset + 14], S13, 0xa679438e)
      b = FF(b, c, d, a, fillTab[offset + 15], S14, 0x49b40821)

      --第二轮
      a = GG(a, b, c, d, fillTab[offset + 1], S21, 0xf61e2562)
      d = GG(d, a, b, c, fillTab[offset + 6], S22, 0xc040b340)
      c = GG(c, d, a, b, fillTab[offset + 11], S23, 0x265e5a51)
      b = GG(b, c, d, a, fillTab[offset + 0], S24, 0xe9b6c7aa)
      a = GG(a, b, c, d, fillTab[offset + 5], S21, 0xd62f105d)
      d = GG(d, a, b, c, fillTab[offset + 10], S22, 0x2441453)
      c = GG(c, d, a, b, fillTab[offset + 15], S23, 0xd8a1e681)
      b = GG(b, c, d, a, fillTab[offset + 4], S24, 0xe7d3fbc8)
      a = GG(a, b, c, d, fillTab[offset + 9], S21, 0x21e1cde6)
      d = GG(d, a, b, c, fillTab[offset + 14], S22, 0xc33707d6)
      c = GG(c, d, a, b, fillTab[offset + 3], S23, 0xf4d50d87)
      b = GG(b, c, d, a, fillTab[offset + 8], S24, 0x455a14ed)
      a = GG(a, b, c, d, fillTab[offset + 13], S21, 0xa9e3e905)
      d = GG(d, a, b, c, fillTab[offset + 2], S22, 0xfcefa3f8)
      c = GG(c, d, a, b, fillTab[offset + 7], S23, 0x676f02d9)
      b = GG(b, c, d, a, fillTab[offset + 12], S24, 0x8d2a4c8a)

      --第三轮
      a = HH(a, b, c, d, fillTab[offset + 5], S31, 0xfffa3942)
      d = HH(d, a, b, c, fillTab[offset + 8], S32, 0x8771f681)
      c = HH(c, d, a, b, fillTab[offset + 11], S33, 0x6d9d6122)
      b = HH(b, c, d, a, fillTab[offset + 14], S34, 0xfde5380c)
      a = HH(a, b, c, d, fillTab[offset + 1], S31, 0xa4beea44)
      d = HH(d, a, b, c, fillTab[offset + 4], S32, 0x4bdecfa9)
      c = HH(c, d, a, b, fillTab[offset + 7], S33, 0xf6bb4b60)
      b = HH(b, c, d, a, fillTab[offset + 10], S34, 0xbebfbc70)
      a = HH(a, b, c, d, fillTab[offset + 13], S31, 0x289b7ec6)
      d = HH(d, a, b, c, fillTab[offset + 0], S32, 0xeaa127fa)
      c = HH(c, d, a, b, fillTab[offset + 3], S33, 0xd4ef3085)
      b = HH(b, c, d, a, fillTab[offset + 6], S34, 0x4881d05)
      a = HH(a, b, c, d, fillTab[offset + 9], S31, 0xd9d4d039)
      d = HH(d, a, b, c, fillTab[offset + 12], S32, 0xe6db99e5)
      c = HH(c, d, a, b, fillTab[offset + 15], S33, 0x1fa27cf8)
      b = HH(b, c, d, a, fillTab[offset + 2], S34, 0xc4ac5665)

      --第四轮
      a = II(a, b, c, d, fillTab[offset + 0], S41, 0xf4292244)
      d = II(d, a, b, c, fillTab[offset + 7], S42, 0x432aff97)
      c = II(c, d, a, b, fillTab[offset + 14], S43, 0xab9423a7)
      b = II(b, c, d, a, fillTab[offset + 5], S44, 0xfc93a039)
      a = II(a, b, c, d, fillTab[offset + 12], S41, 0x655b59c3)
      d = II(d, a, b, c, fillTab[offset + 3], S42, 0x8f0ccc92)
      c = II(c, d, a, b, fillTab[offset + 10], S43, 0xffeff47d)
      b = II(b, c, d, a, fillTab[offset + 1], S44, 0x85845dd1)
      a = II(a, b, c, d, fillTab[offset + 8], S41, 0x6fa87e4f)
      d = II(d, a, b, c, fillTab[offset + 15], S42, 0xfe2ce6e0)
      c = II(c, d, a, b, fillTab[offset + 6], S43, 0xa3014314)
      b = II(b, c, d, a, fillTab[offset + 13], S44, 0x4e0811a1)
      a = II(a, b, c, d, fillTab[offset + 4], S41, 0xf7537e82)
      d = II(d, a, b, c, fillTab[offset + 11], S42, 0xbd3af235)
      c = II(c, d, a, b, fillTab[offset + 2], S43, 0x2ad7d2bb)
      b = II(b, c, d, a, fillTab[offset + 9], S44, 0xeb86d391)

      --加入到之前计算的结果当中
      result[1] = result[1] + a
      result[2] = result[2] + b
      result[3] = result[3] + c
      result[4] = result[4] + d
      result[1] = result[1] & 0xffffffff
      result[2] = result[2] & 0xffffffff
      result[3] = result[3] & 0xffffffff
      result[4] = result[4] & 0xffffffff
    end

    --将Hash值转换成十六进制的字符串
    local retStr = ""
    for i = 1,4 do
      for _ = 1,4 do
        local temp = result[i] & 0x0F
        local str = HexTable[temp + 1]
        result[i] = result[i] >> 4
        temp = result[i] & 0x0F
        retStr = retStr .. HexTable[temp + 1] .. str
        result[i] = result[i] >> 4
      end
    end

    return retStr
  end

  return string.md5(str)

end

function 闪动字体(控件,频率,颜色1,颜色2,颜色3,颜色4)
  import "android.animation.ObjectAnimator"
  import "android.animation.ArgbEvaluator"
  import "android.animation.ValueAnimator"
  import "android.graphics.Color"
  colorAnim = ObjectAnimator.ofInt(控件,"textColor",{颜色1,颜色2,颜色3,颜色4})
  colorAnim.setDuration(频率)
  colorAnim.setEvaluator(ArgbEvaluator())
  colorAnim.setRepeatCount(ValueAnimator.INFINITE)
  colorAnim.setRepeatMode(ValueAnimator.REVERSE)
  colorAnim.start()
end

--查询已安装的APP
function 查找()
  require "import"
  import "android.content.Intent"
  Thread.sleep(100)
  pm = activity.getPackageManager()
  intent = Intent(Intent.ACTION_MAIN, nil)
  intent.addCategory(Intent.CATEGORY_LAUNCHER)
  resolveInfos = pm.queryIntentActivities(intent, 0)
  if resolveInfos ~= nil and resolveInfos.size() > 0 then
    for i=0,resolveInfos.size()-1 do
      call("刷新",resolveInfos[i].activityInfo.applicationInfo.loadIcon(pm),resolveInfos[i].activityInfo.applicationInfo.loadLabel(pm),resolveInfos[i].activityInfo.packageName)
      Thread.sleep(100)
    end
  end
end

function 刷新(image,text1,text2)
  应用包名适配器.add{应用图标=image,应用名称="["..text1.."]",应用包名=text2}
  应用包名适配器.notifyDataSetChanged()
end

function getApk(packageName)
  --通过包名获取程序源文件路径
  appDir = activity.getPackageManager().getApplicationInfo(packageName, 0).sourceDir
  return appDir
end

function 确认框(an,包名)
  editPackage.setText(包名)
  an.dismiss()
end

import "android.content.res.ColorStateList"
import "android.content.Context"
function tintList(color)
  return ColorStateList({
    {android.R.attr.state_checked},
    {-android.R.attr.state_checked}
  }, {color,color})
end

function 加QQ群(群号)
  import "android.content.Intent"
  import "android.net.Uri"
  activity.startActivity(Intent(Intent.ACTION_VIEW,Uri.parse("mqqapi://card/show_pslcard?src_type=internal&version=1&uin="..群号.."&card_type=group&source=qrcode")))
end


function QQ聊天(账号)
  import "android.content.Intent"
  import "android.net.Uri"
  this.startActivity(Intent(Intent.ACTION_VIEW,Uri.parse("mqqapi://card/show_pslcard?uin="..账号)))
end

设置边框 = function(view, Thickness, FrameColor, InsideColor, radiu)
  import("android.graphics.drawable.GradientDrawable")
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setStroke(Thickness, FrameColor)
  drawable.setColor(InsideColor)
  drawable.setCornerRadii({
    radiu,
    radiu,
    radiu,
    radiu,
    radiu,
    radiu,
    radiu,
    radiu
  })
  view.setBackgroundDrawable(drawable)
end

function NoScrollPageView()

  return luajava.override(luajava.bindClass("android.widget.PageView"),{

    onInterceptTouchEvent=function(super,event)

      return false

    end,

    onTouchEvent=function(super,event)

      return false

    end

  })
end

function 校验文本(控件ID,提示内容)
  if 控件ID.text == nil
    || 控件ID.text == ""
    || 控件ID.text == "选择内存范围" || 控件ID.text == "类型" then
    Snakebar(提示内容)
    return true
  end
end

function 流畅旋转(控件,频率,顺时针,逆时针)
  import "android.view.animation.LinearInterpolator"
  c = ObjectAnimator()
  c.setTarget(控件)
  c.setDuration(频率)
  c.setRepeatCount(ValueAnimator.INFINITE)
  c.setPropertyName("rotation")
  c.setFloatValues({顺时针,逆时针})
  c.setRepeatMode(ValueAnimator.INFINITE)
  c.setInterpolator(LinearInterpolator())
  c.start()
end

--RC4加解密算法(lua实现)
function swap(list, i, j)
  list[i], list[j] = list[j], list[i]
end

--初始化密钥流(KSA - Key Scheduling Algorithm)
function ksa(key)
  local key_length = #key
  local S = {}
  --初始置换过程
  for i = 0, 255 do
    S[i] = i
  end
  local j = 0
  --密钥与初始置换的混合
  for i = 0, 255 do
    j = (j + S[i] + key:byte((i % key_length) + 1)) % 256
    swap(S, i, j)
  end
  return S
end

--伪随机生成算法 (PRGA - Pseudo-Random Generation Algorithm)
function prga(S, text)
  local i, j, K = 0, 0, {}
  --根据密钥流生成密文或明文
  for l = 1, #text do
    i = (i + 1) % 256
    j = (j + S[i]) % 256
    swap(S, i, j)
    K[l] = string.char(bit32.bxor(text:byte(l), S[(S[i] + S[j]) % 256]))
  end
  return table.concat(K)
end

--RC4 加密解密函数
--由于RC4是一个可逆加密算法
--因此可以使用相同的函数进行加密和解密操作
function RC4(key, text)
  local S = ksa(key)
  return prga(S, text)
end

--将字符串转换为十六进制
function toHex(string)
  return (string:gsub(".", function(c)
    return string.format("%02X", c:byte())
  end))
end

--将十六进制转换为字符串
function fromHex(hex)
  return (hex:gsub("..", function(cc)
    return string.char(tonumber(cc, 16))
  end))
end

--使用 RC4 加密函数
function encrypt(key, text)
  local encrypted = RC4(key, text)
  return toHex(encrypted):upper()
end

--使用 RC4 解密函数
function decrypt(key, encrypted_text)
  local text = fromHex(encrypted_text)
  return RC4(key, text)
end

utw_img=function(imgpath,winlockmodel)
  local imglayout={
    LinearLayout;
    gravity="center";
    layout_width="match_parent";
    orientation="vertical";
    layout_height="match_parent";
    {
      PhotoView;
      layout_width="match_parent";
      layout_height="match_parent";
      src=imgpath;
    };
  };

  import "android.graphics.*"
  local winlock = winlockmodel or true
  local utwimg=Dialog(activity)
  utwimg.setContentView(loadlayout(imglayout))
  utwimg.getWindow().setBackgroundDrawableResource(android.R.color.transparent);
  utwimg.getWindow().setGravity(Gravity.CENTER)--默认底部 CENTER中 TOP顶
  utwimg.setCanceledOnTouchOutside(winlock);
  utwimg.getWindow().getAttributes().width =(activity.getWidth()*1)
  utwimg.getWindow().getAttributes().height =(activity.getWidth()*1)
  utwimg.show()
end

function date2week(year,month,day)
  local t={0,3,3,6,1,4,6,2,5,0,3,5}
  if(month<3)then
    year=year-1
  end
  local t={0,3,2,5,0,3,5,1,4,6,2,4}
  local year=year+year/4-year/100+year/400
  local week=tointeger((year+t[month]+day)%7)
  local weekTab = {
    [0] = "周日",--"星期日",
    [1] = "周一",--"星期一",
    [2] = "周二",--"星期二",
    [3] = "周三",--"星期三",
    [4] = "周四",--"星期四",
    [5] = "周五",--"星期五",
    [6] = "周六",--"星期六",
  }
  return weekTab[week]
end


function 流畅旋转(控件,频率,顺时针,逆时针)
  import "android.animation.ObjectAnimator"
  import "android.animation.ValueAnimator"
  import "android.view.animation.LinearInterpolator"

  c = ObjectAnimator()
  c.setTarget(控件)
  c.setDuration(频率)
  c.setRepeatCount(ValueAnimator.INFINITE)
  c.setPropertyName("rotation")
  c.setFloatValues({顺时针,逆时针})
  c.setRepeatMode(ValueAnimator.INFINITE)
  c.setInterpolator(LinearInterpolator())
  c.start()
end

function 跳转网页(url)
  activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
end

function vpn检测()
  back=false
  thread(function()
    while true do
      require "import"
      import "java.net.NetworkInterface"
      import "java.util.Collections"
      import "java.util.Enumeration"
      import "java.util.Iterator"
      local niList = NetworkInterface.getNetworkInterfaces()
      if niList ~= nil then
        local it = Collections.list(niList).iterator()
        while it.hasNext() do
          local intf = it.next()
          if intf.isUp() and intf.getInterfaceAddresses().size() ~= 0 then
            if String("tun0").equals(intf.getName()) or String("ppp0").equals(intf.getName()) then

              activity.finish()
              back = true
             else
              --print("未开启VPN")
              back = false
            end
          end
        end
      end
      Thread.sleep(1000)
    end
  end)
end

function 列表逐显动画(list,time)--0.1
  --导入类
  import "android.view.animation.AnimationUtils"
  import "android.view.animation.LayoutAnimationController"


  --创建一个Animation对象
  animation = AnimationUtils.loadAnimation(activity,android.R.anim.slide_in_left)

  --得到对象
  lac = LayoutAnimationController(animation)

  --设置控件显示的顺序
  lac.setOrder(LayoutAnimationController.ORDER_NORMAL)
  --LayoutAnimationController.ORDER_NORMAL 顺序显示
  --LayoutAnimationController.ORDER_REVERSE 反显示
  --LayoutAnimationController.ORDER_RANDOM 随机显示

  --设置控件显示间隔时间
  lac.setDelay(time)--这里单位是秒

  --设置组件应用
  list.setLayoutAnimation(lac)
end

-- 封装延时执行函数
function delay(delayTime, executeFunction)
  local ti = Ticker()
  ti.Period = delayTime -- 设置定时器周期
  ti.start()
  ti.onTick = function()
    ti.stop() -- 执行完毕后停止定时器
    executeFunction() -- 执行传入的函数
  end
end

function 水珠动画(view,time)
  import "android.animation.ObjectAnimator"
  ObjectAnimator().ofFloat(view,"scaleX",{1.2,.8,1.1,.9,1}).setDuration(time).start()
  ObjectAnimator().ofFloat(view,"scaleY",{1.2,.8,1.1,.9,1}).setDuration(time).start()
end

function 校园网登录验证()
  -- 判断是否连接wifi
  local wifi = activity.Context.getSystemService(Context.WIFI_SERVICE)
  if wifi.isWifiEnabled() then
    Http.get("https://www.baidu.com",function(code,content)
      if code==200 then
       else
        --无网络
        local function print_response(code, content)
          if code == 200 then
            local online = content:match([[online":1]])
            if not online then
              local localMs = io.open(activity.getLuaDir().."/set/message.txt"):read("*a")
              if localMs ~= nil then
                local username = localMs:match('username":"(.-)"')
                local password = localMs:match('password":"(.-)"')
                if username and password then
                  local url = "https://a.stu.edu.cn/ac_portal/login.php"
                  local data = "opr=pwdLogin&userName="..username.."&pwd="..password.."&ipv4or6=&rememberPwd=0"
                  local data1 = tostring(data)
                  local charset = "utf-8"
                  local header = { ["ContentType"] = "application/x-www-form-urlencoded" }
                  Http.post(url, data1, nil, charset, header, function(c, res)
                    local 校园网验证 = res:match("success':true")
                    if 校园网验证 ~= nil then
                      Snakebar("校园网认证成功！")
                     else
                      Snakebar("发生错误，请将下列代码反馈给开发者："..res)
                    end
                  end)
                end
              end
            end
           else
            Snakebar("验证校园网登录状态失败！请把代码反馈给开发者或自行解决："..content)
          end
        end
        local url = "https://a.stu.edu.cn/ac_portal/login.php"
        local header = { ["ContentType"] = "application/x-www-form-urlencoded" }
        local data = "opr=online_check"
        local data1 = tostring(data)
        Http.post(url, data1, nil, nil, header, print_response)
      end
    end)
  end
end

function 签名验证()
  import "android.content.pm.PackageManager"
  local pm = activity.getPackageManager();
  local pm=pm.getPackageInfo(activity.getPackageName(),PackageManager.GET_SIGNATURES).signatures[0].hashCode()
  pms=-672009692
  if pm~=pms then
    提示("软件完整性验证不通过！")
    os.exit()
  end
end


function 自动旋转()
  import "android.content.pm.ActivityInfo"
  activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR)
end

function 卡片(边框厚度,边框颜色,背景颜色,圆角度)
  import "android.graphics.drawable.GradientDrawable"
  drawable=GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setStroke(边框厚度,tonumber(边框颜色))--边框厚度和背景颜色
  drawable.setColor(tonumber(背景颜色))--背景颜色
  drawable.setCornerRadius(圆角度)--圆角
  return drawable
end

function 新消息提示(内容)
  ts={
    LinearLayout;
    {
      CardView;
      Elevation="0";
      backgroundColor="0x00000000";
      {
        FrameLayout;
        id="背景";
        {
          ImageView;
          id="图片";
          layout_width="35dp";
          src="icon.png";--这里放图片路径
          layout_marginLeft="5dp";
          layout_height="40dp";
        };
        {
          TextView;
          id="TEXT";
          text="开启成功 ";
          layout_marginLeft="50dp";
          textSize="20sp";
          layout_marginTop="7dp";
        };
      };
    };
  };
  local toast=Toast.makeText(activity,内容,Toast.LENGTH_SHORT).setView(loadlayout(ts)).show()
  TEXT.text=内容.."  "
  背景.BackgroundDrawable=卡片(0,0xFFFFFFFF,0xFFFFFFFF,30);--设置布局的背景 美化
end

function 图颜文(photocallback,textcallback,timecallback)
  Http.get("http://m.wufazhuce.com/",function(code,content)
    if code ==200 then
      一言=content:match([[<p%sclass="text%pcontent%pshort"%sid="quote">(.-)</p>]])
      一图=content:match([[<div%sclass="home%pimg"%sstyle="background%pimage:url%p(.-)%p">]])
      目标链接=content:match([[<meta property="og:url" content="(.-)" />
<meta property="og:title" content="「ONE · 一个」]])
      photocallback(一图)
      textcallback(一言)
    end
  end
  )
end

function ai(messages, callback)--提示词也要在第一个参数中
  --调用参数示例，是一个表
  --[[local conversationHistory = {
    {role = "system", content = systemPrompt},
    {role = "user", content = "如没有其他强调，请每次回答我时都只局限于该话题"},
    {role = "assistant", content = "好的，我将仅局限于讨论关于汕头大学以及PhoenixTool的话题。"}
}
历史）
    ai(conversationHistory, function(success, response)
        if success then
            -- 将AI回复加入历史(可选记忆功能)
            --table.insert(conversationHistory, {role = "assistant", content = response})
            end
             end))
]]
  local api_key = "e9097b9a11fd09a01a216598ea952e7c.wH06ZzAdcZxk8EUF"
  -- 发送请求
  Http.post("https://open.bigmodel.cn/api/paas/v4/chat/completions", cjson.encode{
    model = "glm-4-flash-250414",
    messages = messages
  }, nil, nil, {
    ["Content-Type"] = "application/json",
    ["Authorization"] = "Bearer ".. api_key
  }, function(code, content)
    if code == 200 then
      local data = cjson.decode(content)
      callback(true, data.choices[1].message.content)
     else
      callback(false, "HTTP错误 "..code..(content or ""))
    end
  end)
end

function 签到()
  local api=url.."main/api/user/user_sig.php"
  import "com.narcissus.encrypt.*"
  secret="00eceefd840f6b87f5dd"
  if isEncrypt then
    codekey=Narcissus.encrypt(key)
   else
    codekey=key
  end
  local body={
    ["admin"]=admin,
    ["user"]=user,
    ["password"]=password,
    ["key"]=codekey
  }
  Http.post(api,body,nil,nil,function (code,body)
    if code==200 then
      local data=cjson.decode(body)
      if data.msg ~="你已经签到过了" then
        --提示(data.msg)
      end
      if data.code==1 then
        提示("签到成功~")
      end
     else
      提示("Http error code:"..code)
    end
  end)
end


-- 字母转数字并格式化为两位数的函数
function lettersToFormattedNumbers(letters)
  local formattedNumbers = {}

  for i = 1, #letters do
    local char = letters:sub(i, i) -- 获取当前字符
    local upperChar = string.upper(char)

    if upperChar >= 'A' and upperChar <= 'Z' then
      local number = upperChar:byte() - string.byte('A') + 1
      table.insert(formattedNumbers, string.format("%02d", number))
     elseif char:match("%d") then
      table.insert(formattedNumbers, char)
    end
  end

  return table.concat(formattedNumbers)
end

-- 数字转字母的逆转换函数
function formattedNumbersToLetters(numbers)
  local letters = {}
  local i = 1

  while i <= #numbers do
    local char = numbers:sub(i, i)

    -- 检查是否是数字字符
    if char:match("%d") then
      -- 如果是数字，检查后面是否是两位数
      if i < #numbers and numbers:sub(i, i + 1):match("^%d%d$") then
        -- 转换为字母
        local num = tonumber(numbers:sub(i, i + 1))
        local letter = string.char(num + string.byte('A') - 1)
        table.insert(letters, letter)
        i = i + 2 -- 跳过两位数
       else
        -- 单个数字直接添加空字符或其他处理
        table.insert(letters, char)
        i = i + 1
      end
     else
      i = i + 1 -- 继续下一个字符
    end
  end

  return table.concat(letters)
end

function 弹出登录()
  import "json"
  --设置弹出式窗口布局
  popbj={
    LinearLayout;--线性布局
    Orientation='vertical';--布局方向
    background='#00ffffff';--布局背景颜色(或者图片路径)
    gravity='center';--设置居中
    layout_width='85%w';--布局宽度
    layout_height='65%h';--布局高度
    {
      CardView;--卡片控件
      layout_margin='10';--卡片边距
      layout_gravity='center';--重力属性
      Elevation='10';--阴影属性
      layout_width='fill';--卡片宽度
      layout_height='fill';--卡片高度
      radius='20';--卡片圆角
      CardBackgroundColor='#ffffff';--卡片背景颜色
      {
        LinearLayout;--线性布局
        Orientation='vertical';--布局方向
        layout_width='fill';--布局宽度
        layout_height='fill';--布局高度
        gravity='center';--设置居中
        {
          CardView;
          radius="20dp";
          layout_marginTop="5dp";
          layout_margin="10dp";
          layout_width="60%w";
          id="c1",
          {
            EditText;
            layout_margin="10dp";
            id="用户";
            layout_width="match_parent";
            hint="校园网账号";
            background="#";
            singleLine=true;
          };
        };
        {
          CardView;
          radius="20dp";
          layout_margin="10dp";
          layout_width="60%w";
          layout_marginTop="-2dp";
          id="c2",
          {
            EditText;
            layout_margin="10dp";
            id="密码";
            layout_width="match_parent";
            hint="校园网密码";
            background="#";
            singleLine=true;
          };
        };
        {
          CardView;
          radius="20dp";
          layout_margin="10dp";
          layout_width="60%w";
          layout_marginTop="5dp";
          id="c1",
          {
            EditText;
            layout_margin="10dp";
            id="论坛昵称";
            layout_width="match_parent";
            hint="论坛昵称(注册必填，登录不用)";
            background="#";
            textSize="13sp";
            singleLine=true;
          };
        };
        {
          CardView;
          radius="20dp";
          layout_margin="10dp";
          layout_width="60%w";
          layout_marginTop="5dp";
          id="c1",
          {
            EditText;
            layout_margin="10dp";
            id="论坛密码";
            layout_width="match_parent";
            hint="论坛密码";
            background="#";
            singleLine=true;
          };
        };
        {
          RippleLayout,--水波纹布局
          layout_width='wrap';--布局宽度
          layout_height='wrap';--布局高度
          RippleColor='#ffffff';--水波纹颜色
          layout_marginTop="20dp";
          Circle=true;--长按圆圈
          {
            Button;--按钮控件
            onClick=function()
              if 密码.text ~= 论坛密码.text and 论坛密码.text~="" then
                a={
                  username=用户.text;
                  password=密码.text
                }
                localMs = json.encode(a)
                --OAtoken保存
                userPassword="username="..localMs:match('username":"(.-)"').."&".."password="..localMs:match('password":"(.-)"')
                OApost="http://wechat.stu.edu.cn/webservice_oa/oa_stu_/login_post"
                Http.post(OApost,userPassword,function(a,b)
                  if b=="" then
                    提示("登录失败，可能是啥输错了")
                   else
                    写入文件(activity.getLuaDir().."/set/message.txt",localMs)
                    写入文件(activity.getLuaDir().."/set/CookOA.txt",b)
                    --获取编辑框账号密码
                    local user=lettersToFormattedNumbers(用户.Text)
                    local password=论坛密码.Text
                    --判断是否为空
                    --调用水仙登录接口
                    local api=url.."main/api/user/login.php"
                    if isEncrypt then
                      codekey=Narcissus.encrypt(key)
                     else
                      codekey=key
                    end
                    --请求体
                    local body={
                      ["admin"]=admin,
                      ["user"]=user,
                      ["password"]=password,
                      ["key"]=codekey
                    }
                    Http.post(api,body,nil,nil,function(code, body)
                      if code == 200 then
                        --请求成功，解析JSON
                        local data=cjson.decode(body)
                        if data.msg=="账号不存在" then
                          --获取昵称
                          local name=论坛昵称.Text
                          --获取验证码
                          if user=="" or password=="" or name=="" then
                            提示("不能为空")
                           elseif password=="123456" then
                            提示("不能输太简单啊Ծ‸ Ծ ")
                           else
                            --声明接口
                            local api=url.."main/api/user/register.php"
                            --请求体
                            if isEncrypt then
                              codekey=Narcissus.encrypt(key)
                             else
                              codekey=key
                            end
                            local body={
                              ["admin"]=admin,
                              ["user"]=user,
                              ["password"]=password,
                              ["name"]=name,
                              ["key"]=codekey
                            }
                            Http.post(api,body,nil,nil,function (code,body)
                              if code==200 then
                                --请求成功，解析JSON
                                local data=cjson.decode(body)
                                if data.msg=="注册成功" then
                                  提示("注册成功，再点一次完成登录")
                                 else
                                  提示(data.msg)
                                end
                               else
                              end
                            end)
                          end
                         elseif data.msg=="密码错误" then
                          提示("论坛密码错误")
                         else
                          提示("论坛"..data.msg.."，欢迎："..用户.text.."！")
                          pop.dismiss()

                          activity.recreate()--重置当前界面

                          --读取code判断是否为1
                          if data.code == 1 then
                            local loginFile=user.."|"..password
                            --存入文件
                            io.open(activity.getLuaDir().."/set/ForumAccount","w"):write(loginFile):close()
                          end
                        end
                       else
                        -- 请求失败
                        提示("HTTP error code:"..code)
                      end
                    end)
                  end
                end)
               else
                提示("请输入论坛密码！")
              end
            end;
            text='Login';--显示的文本
            textSize='16sp';--文本大小
            textColor='#ffffff';--文本颜色
            layout_width='60%w';--按钮宽度
            layout_height='150';--按钮高度
            BackgroundDrawable=rrs1;
          };
        };
        {
          TextView;
          Typeface=字体("product");
          textColor="#5CAB7D";
          gravity="center";
          textSize="14dp";
          id="声明";
          text="论坛未注册会自动注册";
          layout_marginTop="10dp";
        };
        {
          TextView;
          Typeface=字体("product");
          textColor="#5CD4FF";
          layout_gravity="right";
          textSize="14dp";
          onClick=function()
            提示("请发邮件至896662462@qq.com，账号默认与校园网账号相同")
          end;
          text="忘꯭记꯭论꯭坛꯭密꯭码";
          layout_marginRight="5dp";
        };
      }
    };
  };


  pop=PopupWindow(activity)--创建PopupWindow弹出式窗口
  pop.setContentView(loadlayout(popbj))--设置布局
  pop.setWidth(activity.Width*0.8)--设置宽度
  pop.getBackground().setAlpha(0)--将pop自带的背景透明
  pop.setHeight(activity.Height*0.6)--设置高度
  pop.setFocusable(true)--设置可获得焦点
  pop.setTouchable(true)--设置可触摸
  --设置点击外部区域是否可以消失
  pop.setOutsideTouchable(false)
  --居中显示
  pop.setOnDismissListener(PopupWindow.OnDismissListener{
    onDismiss = function()
      this.setSharedData("popRecord",0)
    end
  })
  if this.getSharedData("popRecord") == 1 then
    pop.showAtLocation(view, Gravity.CENTER, 0, 0)
  end
end

function 弹窗网页(url)
  弹网页={
    LinearLayout;
    layout_height="600dp";
    gravity="center";
    orientation="vertical";
    layout_width="match_parent";
    {
      LuaWebView;
      layout_height="600dp";
      layout_width="match_parent";
      id="弹窗网页浏览";
    };
    {
      Button;
      layout_width="match_parent";
      text="知道了";
      onClick=function() dialog1.dismiss() end
    };
  }
  dialog= AlertDialog.Builder(this)
  dialog1=dialog.show()
  dialog1.getWindow().setContentView(loadlayout(弹网页));
  弹窗网页浏览.loadUrl(url)
  import "android.graphics.drawable.ColorDrawable"
  dialog1.getWindow().setBackgroundDrawable(ColorDrawable(0x00000000));
end

function 仿GG弹窗(类型)
  --调用直接用即可，一个单选弹窗
  数据类型数组 = {
    {类型简称="D",数据类型="Dword",类型名称="D：Dword(-2,147,483,648 - 4,294,967,295)",类型单选框=false,类型代码=1,类型颜色=0xFF88DAE4},
    {类型简称="F",数据类型="Float",类型名称="F：Float(-3.4e+38 - 3.4e+38)",类型单选框=false,类型代码=2,类型颜色=0xFFDB7777},
    {类型简称="E",数据类型="Double",类型名称="E：Double(-1.8e+308 - 1.8e+308)",类型单选框=false,类型代码=3,类型颜色=0xFFFCECB8},
    {类型简称="W",数据类型="Word",类型名称="W：Word(-32,768 - 65535)",类型单选框=false,类型代码=4,类型颜色=0xFF11BF59},
    {类型简称="B",数据类型="Byte",类型名称="B：Byte(-128 - 255)",类型单选框=false,类型代码=5,类型颜色=0xFFCF93D9},
    {类型简称="Q",数据类型="Qword",类型名称="Q：Qword(-9,223,372,036,854,775,808 - 18,446,744,073,709,551,615)",类型单选框=false,类型代码=6,类型颜色=0xFF36B2EA},
  }

  layout2={
    CardView;
    id="adaptLine";
    CardBackgroundColor='0xA9000000';
    radius=25;
    layout_height="wrap";
    layout_width="fill";
    {
      LinearLayout;
      layout_height="fill";
      layout_width="fill";
      orientation="vertical";
      {
        TextView;
        text="数据类型列表";
        id="dataTypeText";
        layout_marginTop="16dp";
        textColor="0xFFFFFFFF";
        textSize="16sp";
        layout_margin="15dp";
      };
      {
        ListView;
        id="dataTypeList";
        layout_height="wrap";
        layout_width="fill";
      };
      {
        Button;
        id="selectType";
        layout_gravity="right";
        text="确认";
        textColor="0xFFFFFFFF";
        layout_width="100dp";
        layout_height="40dp";
        layout_marginBottom="18dp";
        layout_marginRight="18dp";
      };
    }
  };

  local dl = LuaDialog(this)
  .setView(loadlayout(layout2))
  类型选择弹窗=dl.show()
  import "android.graphics.drawable.ColorDrawable"
  dl.getWindow().setBackgroundDrawable(ColorDrawable(0x00000000));

  item=
  {
    LinearLayout;
    layout_height="45dp";
    layout_width="fill";
    orientation="horizontal";
    {
      LinearLayout;
      orientation="horizontal";
      layout_height="wrap";
      layout_width="fill";
      gravity="left|center";
      {
        LinearLayout;
        gravity="left|center";
        layout_height="wrap";
        layout_width="280dp";
        {
          TextView;
          id="类型名称";
          layout_marginLeft="10dp";
          textSize="13sp";
          text="Jh：Java heap [3.26GB]";
          textColor="0xFF6CAE6F";
        };
      };
      {
        LinearLayout;
        gravity="center|right";
        layout_height="wrap";
        layout_width="-1";
        {
          CheckBox;
          id="类型单选框";
          clickable=false,
          focusable=false,
          layout_marginRight="5dp";
          ButtonTintList=ColorStateList({{android.R.attr.state_checked},{-android.R.attr.state_checked}},{0xFF00B9FF,0xFF00B9FF}),
        };
      };
    };
  };
  local data={}
  --创建适配器
  数据类型适配器=LuaAdapter(activity,data,item)
  --设置适配器
  dataTypeList.setAdapter(数据类型适配器)
  for i=1,#数据类型数组 do
    table.insert(data,{
      类型单选框={checked=数据类型数组[i]["类型单选框"],ButtonTintList=ColorStateList({{android.R.attr.state_checked},{-android.R.attr.state_checked}},{数据类型数组[i]["类型颜色"],数据类型数组[i]["类型颜色"]}),
      },
      类型名称={text=数据类型数组[i]["类型名称"],textColor=数据类型数组[i]["类型颜色"]},
      类型代码=数据类型数组[i]["类型代码"],
      数据类型=数据类型数组[i]["数据类型"],
      类型简称=数据类型数组[i]["类型简称"],
    })
  end
  数据类型适配器.notifyDataSetChanged()

  dataTypeList.onItemClick=function(l,v,p,i)
    --反选
    local box=data[p+1].类型单选框
    box.checked=not box.checked

    --赋值
    if 类型=="主特征码" then
      mainFeatureType.setText(data[p+1].数据类型)
      主特征码类型代码 = data[p+1].类型代码

     else if 类型=="副特征码" then
        副特征码类型简称 = data[p+1].类型简称
        副特征码类型代码 = data[p+1].类型代码
        副特征码数据类型 = data[p+1].数据类型
        副特征码类型颜色 = data[p+1].类型名称.textColor
        副特征码类型名称 = data[p+1].类型名称.text
        editValueType.text = 副特征码数据类型
       else if 类型=="修改数值" then
          修改数值类型简称 = data[p+1].类型简称
          修改数值类型代码 = data[p+1].类型代码
          修改数值数据类型 = data[p+1].数据类型
          修改数值类型颜色 = data[p+1].类型名称.textColor
          修改数值类型名称 = data[p+1].类型名称.text
          editValueType.text = 修改数值数据类型
        end
      end
    end
    -- 重置复选框状态
    for k,v in ipairs(data) do
      local boxStatus=v.类型单选框
      if boxStatus == box then
        continue
      end
      --修改复选框状态
      boxStatus.checked=false
    end

    数据类型适配器.notifyDataSetChanged()
    return false
  end

  设置边框(selectType, 5, 0xFFFFFFFF, 0x00000000, 20)
  闪动字体(dataTypeText,4000,0xffFF8080,0xff8080FF,0xff80ffff,0xff80ff80)
  selectType.onClick = function()
    关闭对话框(类型选择弹窗)
  end
end


--get封装
function okget(url, headers, cookie, b, callback)
  import 'com.kn.okhttp.*'
  import 'okhttp3.*'

  local okHttpClient = OkHttpClient.Builder()
  .followRedirects(b) -- 禁用自动重定向
  .build()

  -- 构建请求
  local requestBuilder = Request.Builder()
  .url(url) -- 请求URL

  -- 添加 Cookie 到请求头
  if cookie then
    requestBuilder.addHeader("Cookie", cookie)
  end

  -- 添加自定义请求头
  if headers then
    for key, value in pairs(headers) do
      requestBuilder.addHeader(key, value)
    end
  end

  local request = requestBuilder.build()
  okHttpClient.newCall(request).enqueue(Callback{
    onFailure = function(call, e)
      print("Request failed: " .. tostring(e)) -- 更详细的错误信息
    end,
    onResponse = function(call, response)
      local responseCode = response.code() -- 获取响应状态码
      local responseHeaders = response.headers() -- 获取响应头部
      local responseBody = response.body().string() -- 获取响应体

      -- 在主线程中调用回调
      activity.runOnUiThread(function()
        if callback then
          callback(responseCode, responseBody, responseHeaders) -- 调用回调函数
        end
      end)
    end
  })
end




--[[
okget(url, nil, cookie, b, function(code, body, headers)
  print("1"..code) -- 处理响应状态码
  print("2"..body) -- 处理响应体
  print(headers) -- 处理响应头
end)
]]

--post封装
function okpost(url, body, headers, cookie, callback)
  import 'com.kn.okhttp.*'
  import 'okhttp3.*'

  local okHttpClient = OkHttpClient.Builder()
  .followRedirects(false) -- 禁用重定向
  .build()

  -- 创建请求
  local requestBuilder = Request.Builder()
  .url(url) -- 请求URL
  .post(RequestBody.create(MediaType.parse("application/x-www-form-urlencoded"), body))

  -- 添加自定义请求头
  if headers then
    for key, value in pairs(headers) do
      requestBuilder.addHeader(key, value) -- 注意这里是使用 requestBuilder，而不是 request.newBuilder()
    end
  end

  -- 添加 Cookie 到请求头
  if cookie then
    requestBuilder.addHeader("Cookie", cookie)
  end

  local request = requestBuilder.build() -- 构建最终请求

  -- 发起请求
  okHttpClient.newCall(request).enqueue(Callback{
    onFailure = function(call, e) -- 失败请求
      print(e)
    end,
    onResponse = function(call, response) -- 请求成功
      local responseCode = response.code() -- 获取响应状态码
      local responseHeaders = response.headers() -- 获取响应头部
      local responseBody = response.body().string() -- 获取响应体
      -- 在主线程中调用回调
      activity.runOnUiThread(function()
        if callback then
          callback(responseCode, responseBody, responseHeaders) -- 调用回调函数
        end
      end)
    end
  })
end



--[[
okpost("", "key1=value1&key2=value2", nil, function(code, body, headers)
  print(code) -- 处理响应状态码
  print(body) -- 处理响应体
  print(headers) -- 处理响应头
end)
]]


function urlEncode(str)
  if str then
    return string.gsub(str, "([^%w])", function(c)
      return string.format("%%%02X", string.byte(c))
    end)
   else
    return ""
  end
end

runid=0
function performLogin(username, password, callback)
  if runid > 5 then
    提示("本次课表数据更新失败")
    return
  end
  runid=runid+1
  --提示("数据加载中...\n(如果多次重复加载请退出重进")
  写入文件(activity.getLuaDir().."/set/CAScookie.txt", "")
  -- ⭐获取my_client_ticket参数，或SERVERID
  local casApi = 'https://jw.stu.edu.cn/rump_frontend/login/?next=https://jw.stu.edu.cn/'
  okget(casApi, nil, nil,false, function(code, body,headers)
    cookie = headers.get("set-cookie")
    --默认为模式一，上面https://jw.stu.edu.cn/rump_frontend/login/?next=https://jw.stu.edu.cn/
    local my_client_ticket_setCookie = "my_client_ticket" .. (cookie:match("my_client_ticket(.-);") or "")
    if my_client_ticket_setCookie=="my_client_ticket" then
      --模式二
      SERVERID = "SERVERID" .. (tostring(headers):match("set%-cookie: SERVERID(.-);") or "")
    end

    if my_client_ticket_setCookie ~="my_client_ticket" then
      --模式一
      globalData.casUrl = "https://sso.stu.edu.cn/login?service=https://sec1.stu.edu.cn/rump_frontend/loginFromCas/"
     else
      --模式二
      globalData.casUrl = "https://sso.stu.edu.cn/login?service=http%3A%2F%2Fjw.stu.edu.cn%2F"
    end
    --print("当前模式网址："..globalData.casUrl)

    okget(globalData.casUrl, nil, cookie,false, function(code, body, headers)
      if my_client_ticket_setCookie ~="my_client_ticket" then
        --模式一获取JSESSIONID
        JSESSIONID = "JSESSIONID" .. (tostring(headers):match("set%-cookie: JSESSIONID(.-);") or "")
        postcookie=my_client_ticket_setCookie.."; "..JSESSIONID
       else
        --模式二(未完善)
        JSESSIONID = tostring(headers["Set-Cookie"]):match("%[(.-)%]") or ""
      end

      if code == 200 then
        -- ⭐获取 lt 和 execution 字段(模式一二同)
        local execution = string.match(body, 'name="execution" value="([^"]+)"')
        local lt = string.match(body, 'name="lt" value="([^"]+)"')
        -- 将提取的数据放入 authData
        local authData = "_eventId=submit" ..
        "&execution=" .. urlEncode(execution) ..
        "&username=" .. urlEncode(username) ..
        "&password=" .. urlEncode(password) ..
        "&lt=" .. urlEncode(lt)
        local heade = {
          ["Content-Type"] = "application/x-www-form-urlencoded",
        }
        -- ⭐尝试 POST 提交账号密码给 CAS 登录
        --模式二中cookie只提交JSESSIONID
        okpost(globalData.casUrl, authData, heade, postcookie, function(code, body, headers)
          --print("请开启抓包")
          task(200,function()
            if code == 302 then
              -- ⭐提取 CASTGC 和 _UT_还有username
              local CASTGC = "CASTGC" .. (tostring(headers):match("set%-cookie: CASTGC(.-)\n") or "")
              local UT = "_UT_" .. (tostring(headers):match("set%-cookie: _UT_(.-)\n") or "")
              --print("这是旧的UT："..UT)
              local usernamecookie = "username" .. (tostring(headers):match("set%-cookie: username(.-)\n") or "")
              local locationUrl = headers.get("Location") -- 获取Location字段
              if my_client_ticket_setCookie ~="my_client_ticket" then
                --模式一
                getjscookie=my_client_ticket_setCookie
               else
                --模式二中提交：JSESSIONID，SERVERID
                getjscookie=JSESSIONID..SERVERID
              end
              --此时模式一是https://sec1.stu.edu.cn/rump_frontend/loginFromCas/?ticket=ST-2148261-nVBbpWqYmaROFQ3zVIHV-cas52
              if my_client_ticket_setCookie ~="my_client_ticket" then
                --模式一
                getjsandsecookie=my_client_ticket_setCookie..";"..CASTGC..";"..UT
               else
                getjsandsecookie=CASTGC..";"..UT..";"..JSESSIONID
              end
              --模式一获取新的JSESSIONID以及服务区
              --注意，这里code完全是随机的，要么302要么200，我们只需要200的，如果302就循环
              Http.get("https://jw.stu.edu.cn/",getjsandsecookie,nil,nil,function(code,content,cookie,header)
                local JSESSIONID = tostring(header["Set-Cookie"]):match("%[(.-)%]") or ""
                local SERVERID = tostring(JSESSIONID:match("SERVERID=(.-);") or "")
                if JSESSIONID=="" then
                  performLogin(username, password, callback)
                 else
                  local JSESSIONID = "JSESSIONID="..JSESSIONID:match("JSESSIONID=(.-);")
                  local newlocationurl = tostring(header["Location"]):match("%[(.-)%]")
                  if newlocationurl then
                    myredirect(newlocationurl,myredirectcookie)
                   else
                    --接下来手动重定向
                    local singleQuoteMatch = string.match(body, "href='([^']+)'")
                    local doubleQuoteMatch = string.match(body, 'href="([^"]+)" id')
                    if singleQuoteMatch then
                      globalData.casUrl = singleQuoteMatch
                     elseif doubleQuoteMatch then
                      globalData.casUrl = doubleQuoteMatch
                     else
                      globalData.casUrl = "https://sso.stu.edu.cn/login?service=http%3A%2F%2Fjw.stu.edu.cn%2F"
                    end
                    local trycookiere=CASTGC..";"..UT..";"..my_client_ticket_setCookie..";"..JSESSIONID..";"..usernamecookie
                    --获取新的UT
                    okget(globalData.casUrl, nil, trycookiere, false, function(code, body, headers)
                      --print(body.."\n"..tostring(headers))
                      newUT = "_UT_" .. (tostring(headers):match("set%-cookie: _UT_(.-);") or "")
                      --print("这是新的UT："..newUT)
                      local newlocationurl = headers.get("Location")
                      local newlocationurl = string.gsub(newlocationurl, '^http:', 'https:')
                      --获取重定向method网址
                      Http.get(newlocationurl,CASTGC..";"..newUT..";"..my_client_ticket_setCookie..";"..JSESSIONID..";SERVERID="..SERVERID,nil,nil,function(code,content,cookie,header)
                        local newlocationurl = tostring(header["Location"]):match("%[(.-)%]")
                        local newlocationurl = string.gsub(newlocationurl, '^http:', 'https:')
                        --第二次get这个jw.stu.edu.cn
                        Http.get(newlocationurl,CASTGC..";"..newUT..";"..my_client_ticket_setCookie..";"..JSESSIONID..";SERVERID="..SERVERID,nil,nil,function(code,content,cookie,header)
                          local newlocationurl = tostring(header["Location"]):match("%[(.-)%]")
                          local newlocationurl = string.gsub(newlocationurl, '^http:', 'https:')
                          local myredirectcookie = string.gsub(CASTGC..";"..my_client_ticket_setCookie, 'Path=/;', '')
                          local finalcookie=myredirectcookie..";"..JSESSIONID..";SERVERID="..SERVERID..";"..newUT
                          okget(newlocationurl, nil, finalcookie, false, function(code, body, headers)
                            local newlocationurl = headers.get("Location")
                            local newJSESSIONID = "JSESSIONID="..tostring(headers):match("JSESSIONID=(.-);")
                            Http.get(newlocationurl,finalcookie..";"..newJSESSIONID,nil,nil,function(code,content,cookie,header)
                              写入文件(activity.getLuaDir().."/set/CAScookie.txt", finalcookie..";"..newJSESSIONID)
                              if callback then
                                callback() -- 将 cookie 传递给回调函数
                              end
                            end)
                          end)
                        end)
                      end)
                    end)
                  end
                end
              end)
              --end)
             elseif code == 301 then
              Http.post(globalData.casUrl, authData, function(resCode, resBody)
                print(resBody)
              end)
             else
            end
          end)end)
       elseif code == 302 then
        local locationUrl = string.gsub(headers['Location'], '^http:', 'https:')

      end
    end)
  end)
end

function hy(np,duraction)
  f={
    CardView;
    radius="0.1dp";
    background="#403939";
    CardElevation="0.1dp";
    {
      LinearLayout;
      layout_width="fill";
      gravity="center";
      -- orientation="horizontal";
      layout_margin="5dp";
      {
        TextView;
        textColor="#FFFFFF";
        id="nr";
        layout_marginLeft="3dp";
        textSize="14dp";
        text="text";
        layout_marginRight="10dp";
      };
    };
  };
  out=loadlayout(f)
  nr.Text=np
  local toast=Toast.makeText(activity,"text",duraction).setView(out).setGravity(Gravity.CENTER, 0, 10).show()
end