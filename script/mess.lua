require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.mess"
import "cjson"
import "mods.muk"
import "com.narcissus.encrypt.*"
dialog= ProgressDialog.show(this,nil, "加载中..",false, true).hide()
dialog.show()


activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(mess))

title.getPaint().setFakeBoldText(true)
exit.getPaint().setFakeBoldText(true)
empty.getPaint().setFakeBoldText(true)

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
    LinearLayout;
    gravity="left|center";
    layout_width="match_parent";
    backgroundColor="#ffffff";
    layout_marginTop="2dp";
    {
      CardView;
      CardElevation="0dp";
      layout_margin="10dp";
      layout_width="40dp";
      layout_height="40dp";
      radius="20dp";
      {
        ImageView;
        scaleType="centerCrop";
        layout_width="match_parent";
        id="head";
        layout_height="match_parent";
      };
    };
    {
      LinearLayout;
      orientation="vertical";
      {
        TextView;
        textColor="#000000";
        text="name";
        id="name";
        textSize="16sp";
      };
      {
        TextView;
        text="content";
        id="content";
        textColor="#000000";
      };
      {
        TextView;
        text="time";
        id="time";
        textSize="13sp";
      };
    };
    {
      TextView;
      id="forumId";
      visibility=8;
    };
  };
};

--声明列表加载函数，num参数为分页数，new参数为是否继续加载列表，true为是，false为重新加载
function loadList(num,new)
  if new==false then
    adp=nil
    adp=LuaAdapter(activity,layoutList)
  end
  list.setVisibility(View.VISIBLE)
  --声明接口
  local api=url.."main/api/forum/mess_list.php"
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
            if utf8.len(item.content)>30 then
              content=utf8.sub(item.content,0,30).."…"
             else
              content=item.content
            end
            --添加列表数据
            adp.add{
              head=item.head,
              name=item.name,
              content=content,
              time=item.time,
              forumId=item.forum_id
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
  --获取帖子ID
  local forumId=v.Tag.forumId.Text
  --跳转帖子详情
  activity.newActivity("script/forumQuery",{url,admin,user,password,key,forumId,isEncrypt,secret})
end

--清空按钮事件
empty.onClick=function ()
  local api=url.."main/api/forum/mess_delete.php"
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
      提示(data.msg)
      if data.code==1 then
        list.setVisibility(View.GONE)
        space.setVisibility(View.VISIBLE)
      end
     else
      提示("Http error code:"..code)
    end
  end)
end