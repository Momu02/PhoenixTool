require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.userForum"
import "cjson"
import "mods.muk"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(userForum))

url,admin,user,password,key,isEncrypt,secret=...


--定义列表布局
layoutList={
  LinearLayout;
  layout_width="fill";
  layout_height="fill";
  {
    LinearLayout;
    backgroundColor="#ffffff";
    layout_marginTop="10dp";
    orientation="vertical";
    layout_width="match_parent";
    {
      LinearLayout;
      layout_margin="10dp";
      orientation="horizontal";
      gravity="center";
      {
        CardView;
        CardElevation="0dp";
        layout_width="40dp";
        layout_height="40dp";
        radius="20dp";
        {
          ImageView;
          scaleType="centerCrop";
          id="head";
          layout_height="match_parent";
          layout_width="match_parent";
        };
      };
      {
        TextView;
        layout_marginLeft="5dp";
        id="name";
        text="name";
        textColor="#000000";
      };
    };
    {
      TextView;
      layout_marginLeft="10dp";
      textColor="#000000";
      text="title";
      id="title";
      textSize="16sp";
    };
    {
      TextView;
      layout_margin="10dp";
      id="content";
      text="content";
      textColor="#000000";
    };
    {
      LinearLayout;
      layout_marginLeft="10dp";
      layout_marginRight="10dp";
      layout_width="wrap_content";
      {
        CardView;
        layout_weight="1";
        radius="10dp";
        CardElevation="0dp";
        layout_height="wrap_content";
        layout_width="match_parent";
        {
          ImageView;
          scaleType="centerCrop";
          layout_width="match_parent";
          maxWidth="100dp";
          adjustViewBounds="true";
          id="img1";
          layout_height="match_parent";
          maxHeight="100dp";
        };
      };
      {
        CardView;
        layout_weight="1";
        radius="10dp";
        layout_width="match_parent";
        layout_height="wrap_content";
        layout_marginLeft="10dp";
        CardElevation="0dp";
        {
          ImageView;
          scaleType="centerCrop";
          layout_width="match_parent";
          maxWidth="100dp";
          maxHeight="100dp";
          id="img2";
          layout_height="match_parent";
          adjustViewBounds="true";
        };
      };
      {
        CardView;
        layout_weight="1";
        radius="10dp";
        layout_width="match_parent";
        layout_height="wrap_content";
        CardElevation="0dp";
        layout_marginLeft="10dp";
        {
          ImageView;
          scaleType="centerCrop";
          layout_width="match_parent";
          maxWidth="100dp";
          maxHeight="100dp";
          id="img3";
          layout_height="match_parent";
          adjustViewBounds="true";
        };
      };
    };
    {
      LinearLayout;
      layout_margin="10dp";
      layout_width="match_parent";
      {
        TextView;
        textColor="#000000";
        text="浏览:";
        textSize="13sp";
      };
      {
        TextView;
        textColor="#FF656E95";
        id="watch";
        text="watch";
        textSize="13sp";
      };
      {
        TextView;
        layout_marginLeft="10dp";
        textColor="#000000";
        text="点赞:";
        textSize="13sp";
      };
      {
        TextView;
        id="praise";
        text="praise";
        textColor="#FF656E95";
      };
      {
        TextView;
        layout_marginLeft="10dp";
        textColor="#000000";
        text="评论:";
        textSize="13sp";
      };
      {
        TextView;
        textSize="13sp";
        id="comment";
        text="comment";
        textColor="#FF656E95";
      };
    };
    {
      TextView;
      layout_marginLeft="10dp";
      id="time";
      text="time";
      textSize="13sp";
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
  local api=url.."main/api/forum/user_forum.php"
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
    ["num"]=tostring(num),
    ["to_user"]=searchUser,
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
              watch=item.watch,
              praise=tointeger(item.praise),
              comment=tointeger(item.comment),
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

--查看按钮事件
queryButton.onClick=function ()
  --获取用户账号
  searchUser=queryUser.Text
  --判断是否为空
  if queryUser!="" then
    --调用列表加载函数
    num=0
    loadList(num,false)
  end
end

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
      end
    end
  end
end