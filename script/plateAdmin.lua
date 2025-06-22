require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.plateAdmin"
import "cjson"
import "mods.muk"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(plateAdmin))

title.getPaint().setFakeBoldText(true)
exit.getPaint().setFakeBoldText(true)
add.getPaint().setFakeBoldText(true)

url,admin,user,password,key,plateId,isEncrypt,secret=...


--返回按钮事件
exit.onClick=function ()
  activity.finish()
end

layoutList={
  LinearLayout;
  layout_width="fill";
  layout_height="fill";
  {
    CardView;
    radius="10dp";
    CardElevation="0dp";
    layout_width="match_parent";
    layout_margin="10dp";
    {
      LinearLayout;
      layout_width="match_parent";
      layout_height="match_parent";
      gravity="left|center";
      {
        CardView;
        CardElevation="0dp";
        radius="20dp";
        layout_height="40dp";
        layout_margin="10dp";
        layout_width="40dp";
        {
          ImageView;
          layout_width="match_parent";
          layout_height="match_parent";
          id="head";
          scaleType="centerCrop";
        };
      };
      {
        LinearLayout;
        orientation="vertical";
        {
          TextView;
          textColor="#00ACFF";
          text="name";
          id="name";
        };
        {
          TextView;
          textColor="#000000";
          text="adminUser";
          id="adminUser";
        };
      };
      {
        LinearLayout;
        layout_width="match_parent";
        gravity="right|center";
        {
          TextView;
          layout_marginRight="10dp";
          text="撤销";
          textSize="17sp";
          textColor="#FF0000";
          id="adminDelete";
        };
      };
    };
  };
};

--声明列表加载函数，该功能无需分页
function loadList()
  adp=nil
  adp=LuaAdapter(activity,layoutList)
  --声明接口
  local api=url.."main/api/forum/admin_list.php"
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

          --遍历JSON
          for i,v in ipairs(data) do
            --截取单个列表项
            local item=data[i]
            --添加列表数据
            adp.add{
              head=item.head,
              name=item.name,
              adminUser=item.user
            }
          end
          list.Adapter=adp
         else
          list.setVisibility(View.GONE)
          space.setVisibility(View.VISIBLE)
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

--加载函数
loadList()

--撤销按钮单击事件
list.onItemClick=function(parent,v,pos,id)
  v.Tag.adminDelete.onClick=function ()
    --获取管理员账号
    local adminUser=v.Tag.adminUser.Text
    --请求接口
    local api=url.."main/api/forum/admin_delete.php"
    if isEncrypt then
      codekey=Narcissus.encrypt(key)
     else
      codekey=key
    end
    local body={
      ["admin"]=admin,
      ["user"]=user,
      ["password"]=password,
      ["id"]=plateId,
      ["to_user"]=adminUser,
      ["key"]=codekey
    }
    Http.post(api,body,nil,nil,function (code,body)
      if code==200 then
        local data=cjson.decode(body)
        提示(data.msg)
        if data.code==1 then
          loadList()
        end
       else
        提示("Http error code:"..code)
      end
    end)
  end
end

--添加按钮事件
add.onClick=function ()
  activity.newActivity("script/adminAdd",{url,admin,user,password,key,plateId})
end

--回调事件
function onActivityResult(req, res, intent)
  if intent then
    if res==1 then
      local pathstr=intent.getStringExtra("set");
      if pathstr then
        --加载列表函数
        loadList()
      end
    end
  end
end