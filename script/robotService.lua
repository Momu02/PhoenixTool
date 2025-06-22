require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.robotService"
import "cjson"
import "mods.muk"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(robotService))
title.getPaint().setFakeBoldText(true)
exit.getPaint().setFakeBoldText(true)

url,admin,user,password,key,isEncrypt=...

--返回按钮事件
exit.onClick=function ()
  activity.finish()
end
if isEncrypt then
  codekey=Narcissus.encrypt(key)
 else
  codekey=key
end
--获取自己的头像
local api=url.."main/api/user/user_data.php"
local body={
  ["admin"]=admin,
  ["user"]=user,
  ["password"]=password,
  ["key"]=codekey
}
Http.post(api,body,nil,nil,function (code,body)
  if code==200
    local data=cjson.decode(body)
    local data=data.data
    head=data.head
  end
end)

layoutList={
  LinearLayout;
  layout_height="fill";
  layout_width="fill";
  {
    RelativeLayout;
    layout_marginTop="10dp";
    layout_width="match_parent";
    {
      LinearLayout;
      gravity="left|center";
      layout_width="match_parent";
      layout_marginRight="50dp";
      {
        CardView;
        layout_marginLeft="10dp";
        radius="20dp";
        layout_height="40dp";
        CardBackgroundColor=backgroundc;
        CardElevation="0dp";
        layout_width="40dp";
        {
          ImageView;
          scaleType="centerCrop";
          id="head";
          layout_width="match_parent";
          layout_height="match_parent";
        };
      };
      {
        LinearLayout;
        orientation="vertical";
        layout_marginLeft="5dp";
        {
          TextView;
          id="content";
          textColor=textc;
          text="content";
        };
      };
    };
    {
      RelativeLayout;
      layout_marginLeft="10dp";
      layout_width="match_parent";
      {
        CardView;
        layout_alignParentRight="true";
        layout_marginRight="10dp";
        radius="20dp";
        layout_height="40dp";
        id="headSpace";
        CardBackgroundColor=backgroundc;
        CardElevation="0dp";
        layout_width="40dp";
        {
          ImageView;
          scaleType="centerCrop";
          id="myHead";
          layout_width="match_parent";
          layout_height="match_parent";
        };
      };
      {
        LinearLayout;
        gravity="right";
        layout_centerVertical="true";
        orientation="vertical";
        layout_toLeftOf="headSpace";
        layout_width="match_parent";
        layout_marginRight="10dp",
        {
          TextView;
          id="myContent";
          textColor=textc;
          text="myContent";
        };
      };
    };
  };
};

--列表适配
adp=LuaAdapter(activity,layoutList)
list.Adapter=adp

--发送按钮事件
sendButton.onClick=function ()
  --获取内容
  local sendContent=content.Text
  if sendContent!="" then
    --打印列表
    adp.add{
      myHead=head,
      myContent=sendContent,
      head=0,
      content=""
    }
    adp.notifyDataSetChanged()
    --发送请求
    local api=url.."main/api/service/robot_send.php"
    if isEncrypt then
      codekey=Narcissus.encrypt(key)
     else
      codekey=key
    end
    local body={
      ["admin"]=admin,
      ["user"]=user,
      ["password"]=password,
      ["content"]=sendContent,
      ["key"]=codekey
    }
    Http.post(api,body,nil,nil,function (code,body)
      if code==200 then
        local data=cjson.decode(body)
        if data.code==1 then
          local data=data.data
          --清空输入框
          content.setText("")
          --加载新消息
          adp.add{
            myHead=0,
            myContent="",
            head=data.head,
            content=data.content
          }
          adp.notifyDataSetChanged()
        end
       else
        提示("Http error code:"..code)
      end
    end)
  end
end