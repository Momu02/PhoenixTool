require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "page.forum_layout.chat"
import "cjson"
import "com.narcissus.encrypt.*"
dialog= ProgressDialog.show(this,nil, "加载中..",false, false).hide()
dialog.show()
activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(chat))
activity.setRequestedOrientation(1)
title.getPaint().setFakeBoldText(true)
exit.getPaint().setFakeBoldText(true)

url,admin,user,password,key,isEncrypt,secret,chatRoomId,chatRoomName=...
title.setText(chatRoomName)

--返回按钮事件
exit.onClick=function ()
  activity.finish()
end

layoutList={
  LinearLayout;
  layout_width="fill";
  layout_height="fill";
  {
    RelativeLayout;
    layout_width="match_parent";
    layout_marginTop="10dp";
    {
      LinearLayout;
      layout_width="match_parent";
      layout_marginRight="50dp";
      gravity="left";
      {
        CardView;
        radius="20dp";
        CardBackgroundColor="#00FAFAFA";
        layout_width="40dp";
        layout_marginLeft="10dp";
        layout_height="40dp";
        CardElevation="0dp";
        {
          ImageView;
          id="head";
          layout_height="match_parent";
          layout_width="match_parent";
          scaleType="centerCrop";
        };
      };
      {
        LinearLayout;
        orientation="vertical";
        layout_marginLeft="5dp";
        {
          TextView;
          text="name";
          textSize="16sp";
          id="name";
          textColor=textc;
        };
        {
          TextView;
          text="content";
          id="content";
          textColor=textc;
        };
        {
          TextView;
          text="time";
          textSize="13sp";
          id="time";
          textColor=textc;
        };
      };
    };
    {
      RelativeLayout;
      layout_width="match_parent";
      layout_marginLeft="10dp";
      {
        CardView;
        layout_alignParentRight="true";
        CardBackgroundColor=backgroundc;
        layout_width="40dp";
        layout_height="40dp";
        id="headSpace";
        layout_marginRight="10dp";
        CardElevation="0dp";
        radius="20dp";
        {
          ImageView;
          id="myHead";
          layout_height="match_parent";
          layout_width="match_parent";
          scaleType="centerCrop";
        };
      };
      {
        LinearLayout;
        layout_width="match_parent";
        orientation="vertical";
        layout_toLeftOf="headSpace";
        gravity="right";
        {
          TextView;
          id="myName";
          textSize="16sp";
          text="myName";
          textColor=textc;
        };
        {
          TextView;
          text="myContent";
          id="myContent";
          textColor=textc;
        };
        {
          TextView;
          text="myTime";
          textSize="13sp";
          id="myTime";
          textColor=textc;
        };
      };
    };
  };
  {
    TextView;
    id="id";
    visibility=8;
  };
};


--加载数量，目前技术没法实现聊天室的顶部分页
--后续水仙官方会研究原生开发，解决这个问题
num=50
--声明列表加载函数，num参数为加载数量
function loadList(num)
  if isEncrypt then
    codekey=Narcissus.encrypt(key)
   else
    codekey=key
  end
  adp=nil
  adp=LuaAdapter(activity,layoutList)
  --声明接口
  local api=url.."main/api/chat/chat_list.php"
  --请求体
  local body={
    ["admin"]=admin,
    ["user"]=user,
    ["password"]=password,
    ["num"]=tostring(num),
    ["id"]=chatRoomId,
    ["key"]=codekey
  }
  Http.post(api,body,nil,nil,function (code,body)
    if code==200 then
      --请求成功，解析JSON数据
      local data=cjson.decode(body)
      --判断状态码是否为1
      if data.code==1 then
        --成功，截取列表数据
        local data=data.data
        --判断有多少组JSON数据
        if #data!=0 then
          list.setVisibility(View.VISIBLE)

          --遍历JSON
          for i,v in ipairs(data) do
            --截取单个列表项
            local item=data[i]
            --添加列表数据
            if item.user==user then
              head1=0
              name1=""
              content1=""
              time1=""
              head2=item.head
              name2=item.name
              content2=item.content
              time2=item.time
             else
              head1=item.head
              name1=item.name
              content1=item.content
              time1=item.time
              head2=0
              name2=""
              content2=""
              time2=""
            end
            adp.add{
              myHead=head2,
              myName=name2,
              myContent=content2,
              myTime=time2,
              id=item.id,
              head=head1,
              name=name1,
              content=content1,
              time=time1
            }
          end
          dialog.dismiss()
          list.Adapter=adp
         else
          list.setVisibility(View.GONE)
        end
       else
        --失败
        提示(data.msg)
        dialog.dismiss()
      end
     else
      --请求失败
      提示("Http error code:"..code)
      dialog.dismiss()
    end
  end)
end

--调用列表加载函数
loadList(num,false)

--列表的点击事件
list.onItemClick=function(parent,v,pos,id)
  if isEncrypt then
    codekey=Narcissus.encrypt(key)
   else
    codekey=key
  end
  --获取消息id
  local chatId=v.Tag.id.Text
  dialog=AlertDialog.Builder(this)
  .setMessage("确定要删除该消息吗")
  .setPositiveButton("删除",{onClick=function(v)
      local api=url.."main/api/chat/chat_delete.php"
      local body={
        ["admin"]=admin,
        ["user"]=user,
        ["password"]=password,
        ["id"]=chatId,
        ["key"]=codekey
      }
      Http.post(api,body,nil,nil,function (code,body)
        if code==200 then
          local data=cjson.decode(body)
          提示(data.msg)
          if data.code==1 then
            --刷新列表
            loadList(num)
          end
         else
          提示("Http error code:"..code)
        end
      end)
    end})
  .setNeutralButton("取消",nil)
  .show()dialog.create()
end

--加载新消息函数
function loadNew()
  if isEncrypt then
    codekey=Narcissus.encrypt(key)
   else
    codekey=key
  end
  --声明接口
  local api=url.."main/api/chat/chat_new.php"
  --请求体
  local body={
    ["admin"]=admin,
    ["user"]=user,
    ["password"]=password,
    ["num"]=tostring(num),
    ["id"]=chatRoomId,
    ["key"]=codekey
  }
  Http.post(api,body,nil,nil,function (code,body)
    if code==200 then
      --请求成功，解析JSON数据
      local data=cjson.decode(body)
      --判断状态码是否为1
      if data.code==1 then
        --成功，截取数据
        local item=data.data
        if item.user==user then
          head1=0
          name1=""
          content1=""
          time1=""
          head2=item.head
          name2=item.name
          content2=item.content
          time2=item.time
         else
          head1=item.head
          name1=item.name
          content1=item.content
          time1=item.time
          head2=0
          name2=""
          content2=""
          time2=""
        end
        adp.add{
          myHead=head2,
          myName=name2,
          myContent=content2,
          myTime=time2,
          id=item.id,
          head=head1,
          name=name1,
          content=content1,
          time=time1
        }
        adp.notifyDataSetChanged()
       else
        --失败
        提示(data.msg)
      end
     else
      --请求失败
      提示("Http error code:"..code)
    end
  end)
end

--发送按钮事件
sendButton.onClick=function ()
  if isEncrypt then
    codekey=Narcissus.encrypt(key)
   else
    codekey=key
  end
  --获取内容
  local sendContent=content.Text
  if sendContent!="" then
    --发送请求
    local api=url.."main/api/chat/chat_send.php"
    local body={
      ["admin"]=admin,
      ["user"]=user,
      ["password"]=password,
      ["id"]=chatRoomId,
      ["content"]=sendContent,
      ["key"]=codekey
    }
    Http.post(api,body,nil,nil,function (code,body)
      if code==200 then
        local data=cjson.decode(body)
        提示(data.msg)
        if data.code==1 then
          --清空输入框
          content.setText("")
          --加载新消息
          loadNew()
        end
       else
        提示("Http error code:"..code)
      end
    end)
  end
end