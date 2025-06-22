require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "cjson"
import "page.forum_layout.followList"
import "com.narcissus.encrypt.*"
activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(followList))


url,admin,user,password,key,isEncrypt,secret=...


--定义布局
layoutList={
  LinearLayout;
  layout_height="fill";
  layout_width="fill";
  {
    LinearLayout;
    layout_marginTop="10dp";
    layout_width="match_parent";
    gravity="left|center";
    orientation="horizontal";
    {
      CardView;
      layout_width="40dp";
      CardElevation="0dp";
      radius="20dp";
      layout_height="40dp";
      layout_marginLeft="10dp";
      {
        ImageView;
        scaleType="centerCrop";
        layout_width="match_parent";
        layout_height="match_parent";
        id="head";
      };
    };
    {
      LinearLayout;
      layout_marginLeft="10dp";
      orientation="vertical";
      {
        TextView;
        text="name";
        textColor=textc;
        id="name";
      };
      {
        TextView;
        text="user";
        id="user";
        visibility=8;
      };
    };
  };
};

adp=LuaAdapter(activity,layoutList)
--分页数
num=0

--列表加载函数
function loadList(new)
  local api=url.."main/api/user/follow_list.php"
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
      local data=cjson.decode(body)
      if data.code==1 then
        local data=data.data
        --判断JSON数据数量是否为0
        if #data!=0 then
          --如果不为0，隐藏布局
          space.setVisibility(View.GONE)
          --如果为10，重置newList变量，允许分页加载，这是因为水仙的分页加载为10个列表项
          if #data==10 then
            newList=nil
          end
          --遍历JSON
          for i,v in ipairs(data) do
            --截取JSON
            local item=data[i]
            --打印列表
            adp.add{name=item.name,user=item.user,head=item.head}
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
          newList=1
        end
       else
        提示(data.msg)
      end
     else
      提示("Http error code:"..code)
    end
  end)
end

--调用列表加载函数
loadList(false)

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
        loadList(true)
      end
    end
  end}