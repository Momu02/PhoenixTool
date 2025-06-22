require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "http"

import "java.io.File"
--布局表中调用
import "android.graphics.Typeface"
function 字体(t)
  return Typeface.createFromFile(File(activity.getLuaDir().."/res/"..t..".ttf"))
end
layout=
{
  LinearLayout,
  orientation="vertical",
  layout_width="fill",
  layout_height="fill",
  Gravity="center|top",

  {
    LinearLayout;
    id='mToolbar';
    layout_width='fill';--布局宽度
    layout_height="fill";
    orientation="vertical";
    {
      LinearLayout;
      layout_width="fill";
      orientation="horizontal";
      layout_height="56dp";
      -- elevation="3dp";   
      {
        LinearLayout;
        gravity="center";
        layout_width="56dp";
        layout_height="56dp";
        id="Sideslip";
        {
          ImageView;
          layout_height="28dp";
          src="img/__ic_fltbtn.png";
          id="Sideslip1";
          -- colorFilter=io.open("/data/data/"..activity.getPackageName().."/顶栏部件颜色储存.xml"):read("*a");
          layout_width="25dp";
        };
      };
      {
        LinearLayout;
        layout_height="fill";
        layout_weight="1";
        orientation="horizontal";
        {
          TextView;
          text="翻译";
          layout_marginLeft="6sp";
          layout_gravity="center";
          textSize="18sp";
          Typeface=字体("Product");
          id="标题";
        };
      };
      {
        LinearLayout;
        gravity="center";
        layout_width="55dp";
        layout_height="55dp";
        id="menu";
        {
          LinearLayout;
          layout_gravity="right";
          layout_width="0dp";
          layout_height="0dp";
          id="menu2";
        };
        {
          ImageView;
          layout_height="25dp";
          src="img/ic_dots_vertical.png";
          id="menu1";
          colorFilter="#ff000000";
          layout_width="25dp";
        };
      };

    };
    {
      CardView;
      layout_width="fill";
      layout_height="fill";
      radius="10dp";
      -- background=io.open("/data/data/"..activity.getPackageName().."/其他部件强调色储存.xml"):read("*a");
      layout_margin='0dp';
      -- id="generate";
      Elevation="0dp";
      layout_gravity="center";
      {
        LinearLayout,
        orientation="vertical",
        layout_width="fill",
        layout_height="fill",
        Gravity="center|top",
        {
          LinearLayout,
          orientation="horizontal",
          layout_width="fill",
          layout_height="48dp",
          --  elevation="3dp",
          --  background="#FF00BCD5",
          id="title",
          {
            TextView;
            layout_width="0",
            layout_height="48dp",
            layout_weight="1",
            Gravity="center",
            -- textColor="#ffffff",
            text="中文",
            textSize="15",
            id="source",
          },
          {
            LinearLayout,
            layout_width="0",
            layout_height="48dp",
            layout_weight="1",
            Gravity="center",
            {
              ImageView,
              src="img/recording_change",
              layout_width="25dp",
              layout_height="25dp",
              -- ColorFilter="#ffffff",
              id="conversion",
            },
          },
          {
            TextView,
            layout_width="0",
            layout_height="48dp",
            layout_weight="1",
            Gravity="center",
            --textColor="#ffffff",
            text="英文",
            textSize="15",
            id="target",
          },
        },
        {
          CardView;
          radius="8dp";
          layout_width="match_parent";
          layout_margin="0dp";
          Elevation="0dp";
          layout_height="wrap_content";
          background="#FFF0F0F0";
          layout_margin="16dp";
          layout_marginTop="0dp";
          {
            EditText,
            layout_width="fill",
            layout_height="26%h",
            background="#00000000",
            hint="要翻译的内容";
            Typeface=字体("Product2");
            Gravity="top",
            padding="16dp",
            textSize="18sp";
            id="edit",
          },
        };
        {
          CardView;--卡片控件
          id="floatbuttonm";

          -- layout_gravity='bottom|right';--子控件在父布局中的对齐方式
          CardElevation='3dp';--卡片阴影
          layout_width='60dp';--卡片宽度
          layout_height='60dp';--卡片高
          radius='30dp';--卡片圆角 
          {
            LinearLayout;
            orientation="horizontal";
            layout_gravity="center";
            Gravity="center",
            id="显示";
            {
              ImageView;
              layout_margin="10dp";
              -- layout_marginLeft="36dp";
              layout_width="27dp";
              ColorFilter=0xffffffff;--给图标上色
              layout_gravity="center";
              src="img/g_translate_black.png";--获得当前网页的图标   ;
              layout_height="27dp";
            };
          };
        };
        {
          CardView,
          layout_width="match_parent",
          layout_height="28%h",
          cardElevation="0dp",
          radius="8dp";
          --layout_marginTop='0dp';
          layout_margin="16dp";
          Elevation="0dp";
          background="#FFF0F0F0";
          {
            LinearLayout,
            orientation="vertical",
            layout_width="match_parent",
            layout_height="28%h",
            {
              LinearLayout,
              orientation="horizontal",
              layout_width="fill",
              layout_height="44dp",
              --background="#ccaaee",
              Gravity="center|left",
              {
                TextView,
                layout_height="44dp",
                layout_width="52%w",
                Gravity="left",
                paddingLeft="40",
                textColor="#808080",
                text="",
                textSize="18sp",
              },
              {
                ImageView,
                src="img/trans_full_screen_normal",
                layout_width="0",
                layout_height="23dp",
                layout_marginBottom="0dp",
                layout_weight="1",
                ColorFilter=0xff2c2c2c;--给图标上色
                id="FullScreen",
              },
              {
                ImageView,
                src="img/trans_copy_normal",
                layout_width="0",
                layout_marginBottom="0dp",
                layout_height="23dp",
                layout_weight="1",
                ColorFilter=0xff2c2c2c;--给图标上色
                id="copy",
              },
              {
                ImageView,
                src="img/ic_share_app",
                layout_width="0",
                layout_marginBottom="0dp",
                layout_height="23dp",
                layout_weight="1",
                ColorFilter=0xff2c2c2c;--给图标上色
                id="share",
              },
            },
            {
              TextView,
              layout_height="match_parent",
              layout_width="match_parent",
              -- Gravity="left",
              --paddingLeft="40",
              --hint="已翻译的内容会显示在这里";
              padding="16dp",
              paddingTop='0dp';
              Typeface=字体("Product2");
              textColor="#000000",
              textIsSelectable=true,
              textSize="18sp",
              id="result",
            },
          },
        },
      },
    },
  };
};
activity.setContentView(loadlayout(layout))




--最好是单词翻译，句子翻译会不准确
--结果跟有道翻译官完全准确
--翻译类型tran_type
--[[
自动检       AUTO
中译英       ZH_CN2EN
中译日       ZH_CN2JA
中译韩       ZH_CN2KR
中译法       ZH_CN2FR
中译俄       ZH_CN2RU
中译西       ZH_CN2SP
]]

--这是本人(@yuxuan)独立做的翻译软件,用于自用
--接下来会继续完善其他翻译(百度翻译,搜狗翻译,谷歌翻译,文言文翻译,等其他翻译接口)
--代码仅作参考,如有bug，请自行修改


function 有道翻译(content,tran_type)
  edText = edit.Text:match"^%s*(.-)%s*$"
  if edText ~= "" then
    url="http://m.youdao.com/translate"
    data="inputtext="..content.."&type="..tran_type
    body,cookie,code,headers=http.post(url,data)
    for v in body:gmatch('<ul id="translateResult">(.-)</ul>') do
      v=v:match('<li>(.-)</li>')
      v=v:match"^%s*(.-)%s*$"
      return v
    end
   else
    result.Text = ""
    设置hint(result,"18sp","输入内容为空,请重新输入...")
  end
end


function 设置hint(id,size,str)
  id.hint=str
  --[[import "android.text.Spanned"
  import "android.text.SpannableString"
  import "android.text.style.AbsoluteSizeSpan"
  s = SpannableString(str);
  textSize = AbsoluteSizeSpan(size,true);
  s.setSpan(textSize,0,s.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
  id.setHint(s);]]
end


function 提示(内容)
  ToastLayout={
    CardView;
    layout_height="56dp";
    cardElevation="0dp",
    {
      TextView;
      background="#FFFF005B";
      padding="8dp";
      textSize="15sp";
      TextColor="#ffffffff";
      gravity="center";
      text="提示出错";
      id="text";
    };
  };
  toast=Toast.makeText(activity,"内容",Toast.LENGTH_SHORT).setView(loadlayout(ToastLayout))
  text.Text=tostring(内容)
  toast.show()
end


function 检测内容是否为空(str,tran_type)
  conText = edit.Text:match"^%s*(.-)%s*$"
  if conText ~= "" then
    result.Text = 有道翻译(str,tran_type)
   else
    result.Text = ""
    设置hint(result,"18sp","输入内容为空,请重新输入...")
  end
end


function 复制文本(str)
  import "android.content.*"
  activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(str)
  提示("已复制")
end

function 分享文本(str)
  import "android.content.Intent"
  intent = Intent(Intent.ACTION_SEND);
  intent.setType("text/plain");
  intent.putExtra(Intent.EXTRA_TEXT,str);
  activity.startActivityForResult(intent, 0)
end


function 翻译()
  a = source.getText()
  b = target.getText()

  if a=="自动检测" or b=="自动检测" then
    翻译类型="AUTO"
    检测内容是否为空(edit.Text,翻译类型)

   elseif a=="中文" and b=="英文" then
    翻译类型="ZH_CN2EN"
    检测内容是否为空(edit.Text,翻译类型)
   elseif a=="中文" and b=="日文" then
    翻译类型="ZH_CN2JA"
    检测内容是否为空(edit.Text,翻译类型)
   elseif a=="中文" and b=="韩文" then
    翻译类型="ZH_CN2KR"
    检测内容是否为空(edit.Text,翻译类型)
   elseif a=="中文" and b=="法文" then
    翻译类型="ZH_CN2FR"
    检测内容是否为空(edit.Text,翻译类型)
   elseif a=="中文" and b=="俄文" then
    翻译类型="ZH_CN2RU"
    检测内容是否为空(edit.Text,翻译类型)
   elseif a=="中文" and b=="西班牙文" then
    翻译类型="ZH_CN2SP"
    检测内容是否为空(edit.Text,翻译类型)


   elseif a=="英文" and b=="中文" then
    翻译类型="EN2ZH_CN"
    检测内容是否为空(edit.Text,翻译类型)
   elseif a=="日文" and b=="中文" then
    翻译类型="JA2ZH_CN"
    检测内容是否为空(edit.Text,翻译类型)
   elseif a=="韩文" and b=="中文" then
    翻译类型="KR2ZH_CN"
    检测内容是否为空(edit.Text,翻译类型)
   elseif a=="法文" and b=="中文" then
    翻译类型="FR2ZH_CN"
    检测内容是否为空(edit.Text,翻译类型)
   elseif a=="俄文" and b=="中文" then
    翻译类型="RU2ZH_CN"
    检测内容是否为空(edit.Text,翻译类型)
   elseif a=="西班牙文" and b=="中文" then
    翻译类型="SP2ZH_CN"
    检测内容是否为空(edit.Text,翻译类型)

   elseif a=="日文" and b=="英文" then
    rel = 有道翻译(edit.Text,"JA2ZH_CN")
    翻译类型="ZH_CN2EN"
    检测内容是否为空(rel,翻译类型)
   elseif a=="日文" and b=="日文" then
    rel = 有道翻译(edit.Text,"JA2ZH_CN")
    翻译类型="ZH_CN2JA"
    检测内容是否为空(rel,翻译类型)
   elseif a=="日文" and b=="韩文" then
    rel = 有道翻译(edit.Text,"JA2ZH_CN")
    翻译类型="ZH_CN2KR"
    检测内容是否为空(rel,翻译类型)
   elseif a=="日文" and b=="法文" then
    rel = 有道翻译(edit.Text,"JA2ZH_CN")
    翻译类型="ZH_CN2FR"
    检测内容是否为空(rel,翻译类型)
   elseif a=="日文" and b=="俄文" then
    rel = 有道翻译(edit.Text,"JA2ZH_CN")
    翻译类型="ZH_CN2RU"
    检测内容是否为空(rel,翻译类型)
   elseif a=="日文" and b=="西班牙文" then
    rel = 有道翻译(edit.Text,"JA2ZH_CN")
    翻译类型="ZH_CN2SP"
    检测内容是否为空(rel,翻译类型)

   elseif a=="韩文" and b=="英文" then
    rel = 有道翻译(edit.Text,"KR2ZH_CN")
    翻译类型="ZH_CN2EN"
    检测内容是否为空(rel,翻译类型)
   elseif a=="韩文" and b=="日文" then
    rel = 有道翻译(edit.Text,"KR2ZH_CN")
    翻译类型="ZH_CN2JA"
    检测内容是否为空(rel,翻译类型)
   elseif a=="韩文" and b=="韩文" then
    rel = 有道翻译(edit.Text,"KR2ZH_CN")
    翻译类型="ZH_CN2KR"
    检测内容是否为空(rel,翻译类型)
   elseif a=="韩文" and b=="法文" then
    rel = 有道翻译(edit.Text,"KR2ZH_CN")
    翻译类型="ZH_CN2FR"
    检测内容是否为空(rel,翻译类型)
   elseif a=="韩文" and b=="俄文" then
    rel = 有道翻译(edit.Text,"KR2ZH_CN")
    翻译类型="ZH_CN2RU"
    检测内容是否为空(rel,翻译类型)
   elseif a=="韩文" and b=="西班牙文" then
    rel = 有道翻译(edit.Text,"KR2ZH_CN")
    翻译类型="ZH_CN2SP"
    检测内容是否为空(rel,翻译类型)


   elseif a=="法文" and b=="英文" then
    rel = 有道翻译(edit.Text,"FR2ZH_CN")
    翻译类型="ZH_CN2EN"
    检测内容是否为空(rel,翻译类型)
   elseif a=="法文" and b=="日文" then
    rel = 有道翻译(edit.Text,"FR2ZH_CN")
    翻译类型="ZH_CN2JA"
    检测内容是否为空(rel,翻译类型)
   elseif a=="法文" and b=="韩文" then
    rel = 有道翻译(edit.Text,"FR2ZH_CN")
    翻译类型="ZH_CN2KR"
    检测内容是否为空(rel,翻译类型)
   elseif a=="法文" and b=="法文" then
    rel = 有道翻译(edit.Text,"FR2ZH_CN")
    翻译类型="ZH_CN2FR"
    检测内容是否为空(rel,翻译类型)
   elseif a=="法文" and b=="俄文" then
    rel = 有道翻译(edit.Text,"FR2ZH_CN")
    翻译类型="ZH_CN2RU"
    检测内容是否为空(rel,翻译类型)
   elseif a=="法文" and b=="西班牙文" then
    rel = 有道翻译(edit.Text,"FR2ZH_CN")
    翻译类型="ZH_CN2SP"
    检测内容是否为空(rel,翻译类型)


   elseif a=="俄文" and b=="英文" then
    rel = 有道翻译(edit.Text,"RU2ZH_CN")
    翻译类型="ZH_CN2EN"
    检测内容是否为空(rel,翻译类型)
   elseif a=="俄文" and b=="日文" then
    rel = 有道翻译(edit.Text,"RU2ZH_CN")
    翻译类型="ZH_CN2JA"
    检测内容是否为空(rel,翻译类型)
   elseif a=="俄文" and b=="韩文" then
    rel = 有道翻译(edit.Text,"RU2ZH_CN")
    翻译类型="ZH_CN2KR"
    检测内容是否为空(rel,翻译类型)
   elseif a=="俄文" and b=="法文" then
    rel = 有道翻译(edit.Text,"RU2ZH_CN")
    翻译类型="ZH_CN2FR"
    检测内容是否为空(rel,翻译类型)
   elseif a=="俄文" and b=="俄文" then
    rel = 有道翻译(edit.Text,"RU2ZH_CN")
    翻译类型="ZH_CN2RU"
    检测内容是否为空(rel,翻译类型)
   elseif a=="俄文" and b=="西班牙文" then
    rel = 有道翻译(edit.Text,"RU2ZH_CN")
    翻译类型="ZH_CN2SP"
    检测内容是否为空(rel,翻译类型)

   elseif a=="西班牙文" and b=="英文" then
    rel = 有道翻译(edit.Text,"SP2ZH_CN")
    翻译类型="ZH_CN2EN"
    检测内容是否为空(rel,翻译类型)
   elseif a=="西班牙文" and b=="日文" then
    rel = 有道翻译(edit.Text,"SP2ZH_CN")
    翻译类型="ZH_CN2JA"
    检测内容是否为空(rel,翻译类型)
   elseif a=="西班牙文" and b=="韩文" then
    rel = 有道翻译(edit.Text,"SP2ZH_CN")
    翻译类型="ZH_CN2KR"
    检测内容是否为空(rel,翻译类型)
   elseif a=="西班牙文" and b=="法文" then
    rel = 有道翻译(edit.Text,"SP2ZH_CN")
    翻译类型="ZH_CN2FR"
    检测内容是否为空(rel,翻译类型)
   elseif a=="西班牙文" and b=="俄文" then
    rel = 有道翻译(edit.Text,"SP2ZH_CN")
    翻译类型="ZH_CN2RU"
    检测内容是否为空(rel,翻译类型)
   elseif a=="西班牙文" and b=="西班牙文" then
    rel = 有道翻译(edit.Text,"SP2ZH_CN")
    翻译类型="ZH_CN2SP"
    检测内容是否为空(rel,翻译类型)
  end
end


--设置hint(edit,12,"在此输入要翻译的文本...")

显示.onClick=function()
  翻译()
end


copy.onClick=function()
  复制文本(result.Text)
end


conversion.onClick=function()
  c=target.getText()
  d=source.getText()

  source.setText(c)
  target.setText(d)
  翻译()
end


share.onClick=function()
  分享文本(result.Text)
end


FullScreen.onClick=function()
  activity.newActivity("FullScreen",{result.Text})
end


source.onClick=function()
  activity.newActivity("Source")
end


target.onClick=function()
  activity.newActivity("Target")
end


function onResult(name,...)
  返回参数=...
  if name=="Source" then
    source.setText(返回参数)
    翻译()
   elseif name=="Target" then
    target.setText(返回参数)
    翻译()
  end
end

function 波纹(id,颜色)
  import "android.content.res.ColorStateList"local attrsArray = {android.R.attr.selectableItemBackgroundBorderless}
  local typedArray =activity.obtainStyledAttributes(attrsArray)
  ripple=typedArray.getResourceId(0,0)
  Pretend=activity.Resources.getDrawable(ripple)
  Pretend.setColor(ColorStateList(int[0].class{int{}},int{颜色}))
  id.setBackground(Pretend.setColor(ColorStateList(int[0].class{int{}},int{颜色})))
end
Sideslip.onClick=function(v)
  activity.finish()
  --相当于FusionAPP的退出页面与退出程序
end
menu.onClick=function(v)
  --悬浮按钮点击时执行的事件
  pop=PopupMenu(activity,menu2)
  menu=pop.Menu
  menu.add("关于").onMenuItemClick=function(a)
    --普通对话框
    AlertDialog.Builder(this)
    .setTitle("关于")
    .setMessage("API由有道翻译提供")
    .setNegativeButton("确定",nil)
    .show()
  end
  pop.show()--显示@音六站长～
end
--activity.ActionBar.hide()
波纹(Sideslip,0xFF7F7F7F)
波纹(显示,0xFF7F7F7F)
波纹(FullScreen,0xFF7F7F7F)
波纹(copy,0xFF7F7F7F)
波纹(menu,0xFF7F7F7F)
波纹(share,0xFF7F7F7F)
波纹(conversion,0xFF7F7F7F)
import "com.nirenr.Color"
import "android.graphics.Color"
function 控件边框(id,r,t,y)
  import "android.graphics.Color"
  InsideColor = Color.parseColor(t)
  import "android.graphics.drawable.GradientDrawable"
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  --设置填充色
  drawable.setColor(InsideColor)
  --设置圆角 : 左上 右上 右下 左下
  drawable.setCornerRadii({r, r, r, r, r, r, r, r});
  --设置边框 : 宽度4.8 颜色
  drawable.setStroke(2, Color.parseColor(y))
  id.setBackgroundDrawable(drawable)
end
function dp2px(dpValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return dpValue * scale + 0.5
end
--控件边框(edit,dp2px("8"),"#00000000","#FFE0E0E0")--id，度数，内框透明，边框颜色