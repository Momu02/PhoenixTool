require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "cjson"
import 'us.feras.mdv.MarkdownView'
import "mods.muk"

layout={
  LinearLayout,
  layout_width="-1",
  layout_height="-1",
  orientation="vertical",

  {
    LinearLayout,
    layout_width="-1",
    layout_height="-1",
    orientation="vertical",
    layout_marginTop="30dp";
    layout_weight="1",
    {
      ScrollView,
      layout_width="-1",
      layout_height="-1",
      fillViewport="true",
      id="scrollView",
      {
        LinearLayout,
        layout_width="-1",
        layout_height="-1",
        background="#00000000",
        orientation="vertical",
        paddingLeft="30dp",
        paddingRight="30dp",
        id="lt",
      },
    },
  },

  {
    LinearLayout,
    layout_width="100%w",
    layout_height="50dp",
    orientation="horizontal",
    {
      EditText,
      layout_width="80%w",
      layout_height="50dp",
      textSize="15sp",
      id="et",
    },
    {
      Button,
      layout_width="20%w",
      layout_height="50dp",
      text="发送",
      onClick="发送信息",
    },
  },
}
activity.setContentView(loadlayout(layout))

-- 初始化数据
local upgrade = io.open(activity.getLuaDir().. "/res/UpdateLog.txt"):read("*a")
local oa = io.open(activity.getLuaDir().. "/set/OAHistoryRecord.txt"):read("*a")

-- 系统提示（独立存储）
local systemPrompt = [[
    从现在开始，你回答我的格式都要符合Markdown格式的要求，如果回答任何链接图片等都直接按照这个格式来回答。
    
    你是由作者言和个人开发的PhoenixTool对接的AI智能助手，
    你的任务是帮助用户熟悉该软件的使用方法，
    软件主页有首页、校外、BOX、NEWS四个板块，
    首页中包含了关于汕头大学(STU)的常用官方网站和一些常用功能；
    校外是对接了汕头大学的校外访问内部网站的网站，详细可以让用户查看使用教程；
    BOX集成了一些实用功能和网站；
    NEWS可以查看今天的新闻。
    
    用户首次使用时，请提醒用户务必要先打开软件的侧边栏进行学校校园网账号以及论坛的登录。
   
    软件的选课系统需要长按主页的BOX才可进入，正常情况下它是关闭的，只有选课时才会打开，而且需要会员资格才能使用，会员资格需要积分才可以兑换。
    
    软件有问题的话需要在侧边栏联系客服或者在软件内的论坛进行反馈。另外，作者还有个公众号STUTool
    
    下面是汕头大学的本科生综测注解的链接https://docs.qq.com/doc/DTll3ZFFOY3FtTXhL，你需要阅读综测的内容然后根据综测要求回答问题。
    
    下面是软件的更新日志，你可以根据更新日志来分析并回答用户的问题。
    ]]..upgrade..[[
    然后下面是汕头大学的OA系统获取到的历史OA，这个OA是从下到上的时间顺序，下面是最新的事情，你可以根据OA来回答一些问题：
    ]]..oa

-- 全局对话历史
local conversationHistory = {
  {role = "system", content = systemPrompt},
  {role = "user", content = "如没有其他强调，请每次回答我时都只局限于该话题"},
  {role = "assistant", content = "好的，我将仅局限于讨论关于汕头大学以及PhoenixTool的话题。"}
}

-- 初始化第一条消息
RobotLayout={
  MarkdownView;
  layout_height="wrap";
  layout_width="wrap";
  id='mark';
}
lt.addView(loadlayout(RobotLayout))
mark.loadMarkdown("你好，我是PhoenixTool的内置AI，有什么可以帮您？")

function 发送信息()
  local userInput = tostring(et.getText())
  if userInput == "" then return end

  -- 添加用户消息到UI
  MeLayout={
    TextView,
    layout_width="-1",
    layout_height="50dp",
    Gravity="center|right",
    textSize="18sp",
    text=userInput,
  }
  lt.addView(loadlayout(MeLayout))
  et.setText("")

  -- 将用户输入加入历史
  table.insert(conversationHistory, {role = "user", content = userInput})
  -- 调用AI函数（传入完整对话历史）
  ai(conversationHistory, function(success, response)
    if success then
      -- 将AI回复加入历史
      table.insert(conversationHistory, {role = "assistant", content = response})

      -- 显示AI回复
      RobotLayout={
        MarkdownView;
        layout_height="wrap";
        layout_width="wrap";
        id='mark';
      }
      lt.addView(loadlayout(RobotLayout))
      mark.loadMarkdown(response)
     else
      提示("请求失败："..response)
    end
    scrollView.fullScroll(ScrollView.FOCUS_DOWN)
  end)
end