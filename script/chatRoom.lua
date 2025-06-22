require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.chatRoom"
import "cjson"
import "mods.muk"
import "com.narcissus.encrypt.*"
dialog= ProgressDialog.show(this,nil, "加载中..",false, false).hide()
dialog.show()

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(chatRoom))
activity.setRequestedOrientation(1)
title.getPaint().setFakeBoldText(true)
exit.getPaint().setFakeBoldText(true)

url,admin,user,password,key,isEncrypt,secret=...

--返回按钮事件
exit.onClick=function ()
  activity.finish()
end

--分页数
num=0

layoutList={
  LinearLayout;
  layout_width="fill";
  layout_height="fill";
  {
    CardView;
    layout_width="match_parent";
    radius="10dp";
    layout_margin="10dp";
    {
      LinearLayout;
      orientation="vertical";
      layout_width="match_parent";
      {
        LinearLayout;
        layout_margin="10dp";
        {
          TextView;
          id="name";
          text="name";
          textColor="#000000";
          textSize="25sp";
          textStyle="bold";
        };
      };
      {
        LinearLayout;
        layout_marginLeft="10dp";
        {
          TextView;
          text="聊天室状态:";
          textColor="#000000";
        };
        {
          TextView;
          id="state";
          text="state";
          textColor="#000000";
        };
      };
      {
        TextView;
        layout_margin="10dp";
        id="content";
        text="content";
        textColor="#00BDFF";
      };
      {
        TextView;
        visibility=8;
        id="id";
      };
    };
  };
};

--声明列表加载函数，num参数为分页数，new参数为是否继续加载列表，true为是，false为重新加载
function loadList(num,new)
  if isEncrypt then
    codekey=Narcissus.encrypt(key)
   else
    codekey=key
  end
  if new==false then
    adp=nil
    adp=LuaAdapter(activity,layoutList)
  end
  --声明接口
  local api=url.."main/api/chat/chat_room.php"
  --请求体
  local body={
    ["admin"]=admin,
    ["user"]=user,
    ["password"]=password,
    ["num"]=tostring(num),
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
          --如果不为0，隐藏布局
          space.setVisibility(View.GONE)
          list.setVisibility(View.VISIBLE)

          --如果为10，重置newList变量，允许分页加载，这是因为水仙的分页加载为10个列表项
          if #data==10 then
            newList=nil
          end

          --遍历JSON
          for i,v in ipairs(data) do
            --截取单个列表项
            local item=data[i]
            if utf8.len(item.mess)>30 then
              mess=utf8.sub(item.mess,0,30).."…"
             else
              mess=item.mess
            end
            --添加列表数据
            adp.add{
              name=item.name,
              content=mess,
              state=item.gag,
              id=item.id
            }
          end
          dialog.dismiss()
          --如果new为true，则刷新列表
          if new then
            adp.notifyDataSetChanged()
           else
            --否则重新加载列表
            list.Adapter=adp
          end
         else
          --如果为0，修改newList变量，禁止分页加载
          newList=0
          if new==false then
            space.setVisibility(View.VISIBLE)
            list.setVisibility(View.GONE)
          end
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

--列表下滑到底事件，加载分页
list.setOnScrollListener{
  onScrollStateChanged=function(l,s)
    if list.getLastVisiblePosition()==list.getCount()-1 then
      --判断变量newList是否为nil，如果是则加载新页面
      if newList==nil then
        --修改newList变量，只运行加载一次，防止一直重复加载
        newList=1
        --分页数+1
        num=num+1
        --调用列表加载函数，true为刷新列表，false为重新加载列表
        loadList(num,true)
      end
    end
  end}

--列表的点击事件
list.onItemClick=function(parent,v,pos,id)
  --获取聊天室id
  local chatRoomId=v.Tag.id.Text
  --获取聊天室名
  local chatRoomName=v.Tag.name.Text
  activity.newActivity("script/chat",{url,admin,user,password,key,isEncrypt,secret,chatRoomId,chatRoomName})
end