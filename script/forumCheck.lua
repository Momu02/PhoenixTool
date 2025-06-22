require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.forumCheck"
import "cjson"
import "android.content.Intent"
import "mods.muk"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(forumCheck))

title.getPaint().setFakeBoldText(true)
exit.getPaint().setFakeBoldText(true)

url,admin,user,password,key,plateId,isEncrypt,secret=...


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
    layout_width="match_parent";
    backgroundColor="#ffffff";
    layout_marginTop="10dp";
    orientation="vertical";
    {
      LinearLayout;
      layout_margin="10dp";
      gravity="center";
      orientation="horizontal";
      {
        CardView;
        radius="20dp";
        layout_height="40dp";
        layout_width="40dp";
        CardElevation="0dp";
        {
          ImageView;
          layout_height="match_parent";
          scaleType="centerCrop";
          layout_width="match_parent";
          id="head";
        };
      };
      {
        TextView;
        textColor="#000000";
        layout_marginLeft="5dp";
        text="name";
        id="name";
      };
    };
    {
      TextView;
      layout_marginLeft="10dp";
      textColor="#000000";
      text="title";
      textSize="16sp";
      id="title";
    };
    {
      TextView;
      textColor="#000000";
      layout_margin="10dp";
      text="content";
      id="content";
    };
    {
      LinearLayout;
      layout_marginLeft="10dp";
      layout_width="wrap_content";
      layout_marginRight="10dp";
      {
        CardView;
        layout_height="wrap_content";
        layout_width="match_parent";
        layout_weight="1";
        radius="10dp";
        CardElevation="0dp";
        {
          ImageView;
          adjustViewBounds="true";
          id="img1";
          layout_width="match_parent";
          maxHeight="100dp";
          scaleType="centerCrop";
          layout_height="match_parent";
          maxWidth="100dp";
        };
      };
      {
        CardView;
        layout_height="wrap_content";
        layout_width="match_parent";
        layout_weight="1";
        radius="10dp";
        CardElevation="0dp";
        {
          ImageView;
          adjustViewBounds="true";
          id="img2";
          layout_width="match_parent";
          maxHeight="100dp";
          scaleType="centerCrop";
          layout_height="match_parent";
          maxWidth="100dp";
        };
      };
      {
        CardView;
        layout_height="wrap_content";
        layout_width="match_parent";
        layout_weight="1";
        radius="10dp";
        CardElevation="0dp";
        {
          ImageView;
          adjustViewBounds="true";
          id="img3";
          layout_width="match_parent";
          maxHeight="100dp";
          scaleType="centerCrop";
          layout_height="match_parent";
          maxWidth="100dp";
        };
      };
    };
    {
      TextView;
      textSize="13sp";
      layout_margin="10dp";
      text="time";
      id="time";
    };
    {
      TextView;
      id="forumId";
      visibility=8;
    }
  };
};

--声明列表加载函数，num参数为分页数，new参数为是否继续加载列表，true为是，false为重新加载
function loadList(num,new)
  if new==false then
    adp=nil
    adp=LuaAdapter(activity,layoutList)
  end
  --声明接口
  local api=url.."main/api/forum/check_list.php"
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
    ["id"]=plateId,
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
              forumContent=utf8.sub(item.content,0,30).."…"
             else
              forumContent=item.content
            end
            --添加列表数据
            adp.add{
              head=item.head,
              name=item.name,
              title=item.title,
              content=forumContent,
              img1=item.image_1,
              img2=item.image_2,
              img3=item.image_3,
              time=item.time,
              forumId=item.id
            }
          end

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
      end
     else
      --请求失败
      提示("Http error code:"..code)
    end
  end)
end

--调用loadList函数
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
  --跳转审核详情
  activity.newActivity("script/checkQuery",{url,admin,user,password,key,forumId,isEncrypt,secret})
end

--回调事件
function onActivityResult(req, res, intent)
  if intent then
    --刷新帖子
    if res==1 then
      local pathstr=intent.getStringExtra("set");
      if pathstr then
        list.setVisibility(View.VISIBLE)
        space.setVisibility(View.GONE)
        --分页数
        num=0
        --加载列表函数
        loadList(num,false)
        if pathstr=="2" then
          local intent=luajava.newInstance("android.content.Intent")
          intent.putExtra("set","1")
          activity.setResult(1,intent)
        end
      end
    end
  end
end

--一键通过按钮事件
checkAll.onClick=function ()
  local api=url.."main/api/forum/check_all.php"
  local body={
    ["admin"]=admin,
    ["user"]=user,
    ["password"]=password,
    ["id"]=plateId,
    ["key"]=codekey
  }

  Http.post(api,body,nil,nil,function (code,body)
    if code==200 then
      local data=cjson.decode(body)
      提示(data.msg)
      if data.code==1 then
        list.setVisibility(View.GONE)
        space.setVisibility(View.VISIBLE)
        local intent=luajava.newInstance("android.content.Intent")
        intent.putExtra("set","1")
        activity.setResult(1,intent)
      end
     else
      提示("Http error code:"..code)
    end
  end)
end