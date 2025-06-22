require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.plate"
import "http"
import "cjson"
import "mods.muk"
import "com.narcissus.encrypt.*"

function TextView()
  return luajava.bindClass("android.widget.TextView")()
  .setTypeface(字体("product"))
end

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(plate))

exit.getPaint().setFakeBoldText(true)
title.getPaint().setFakeBoldText(true)

url,admin,user,password,key,isEncrypt,secret=...


--返回按钮事件
exit.onClick=function ()
  activity.finish()
end

--分页数，初始为0
num=0

--定义列表布局
layoutList={
  LinearLayout;
  layout_width="fill";
  layout_height="fill";
  {
    LinearLayout;
    orientation="vertical";
    layout_marginTop="10dp";
    backgroundColor="#FFFFFF";
    layout_width="match_parent";
    {
      LinearLayout;
      layout_margin="10dp";
      orientation="horizontal";
      {
        ImageView;
        adjustViewBounds="true";
        scaleType="centerCrop";
        layout_marginLeft="-5dp";
        maxWidth="70dp";
        id="plateIcon";
        maxHeight="70dp";
      };
      {
        TextView;
        id="name";
        layout_marginLeft="5dp";
        textColor="#000000";
        textSize="20dp";
        text="name";
      };
    };
    {
      LinearLayout;
      layout_marginLeft="10dp";
      {
        TextView;
        text="板块介绍:";
        textColor="#000000";
      };
      {
        TextView;
        id="content";
        textColor="#000000";
        text="content";
      };
    };
    {
      LinearLayout;
      layout_margin="10dp";
      visibility=8,--不可视4--隐藏8--显示0
      {
        TextView;
        text="版主:";
        textColor="#000000";
      };
      {
        TextView;
        id="plateUser";
        textColor="#00ACFF";
        text="plateUser";
      };
    };
    {
      LinearLayout;
      layout_margin="10dp";
      visibility=8,--不可视4--隐藏8--显示0
      {
        TextView;
        text="板块ID:";
        textColor="#000000";
      };
      {
        TextView;
        id="plateId";
        textColor="#ffff0000";
        text="plateId";
      };
    };
  };
};

--列表适配器
adp=LuaAdapter(activity,layoutList)

--声明列表加载函数，num参数为分页数，new参数为是否继续加载列表，true为是，false为重新加载
function loadList(num,new)
  --声明接口
  local api=url.."main/api/forum/plate_list.php"
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

          --如果为10，重置newList变量，允许分页加载，这是因为水仙的分页加载为10个列表项
          if #data==10 then
            newList=nil
          end

          --遍历JSON
          for i,v in ipairs(data) do
            --截取单个列表项
            local item=data[i]
            if utf8.len(item.content)>30 then
              plateContent=utf8.sub(item.content,0,30).."…"
             else
              plateContent=item.content
            end
            --添加列表数据
            adp.add{
              name=item.name,
              content=plateContent,
              plateUser=item.user,
              plateId=item.id,
              plateIcon=item.icon
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
  --获取板块ID
  local plateId=v.Tag.plateId.Text
  --跳转板块主页
  local intent = Intent(activity,luajava.bindClass("com.androlua.LuaActivity"));
  intent.putExtra("name","forum");
  intent.putExtra("url", url)
  intent.putExtra("admin", admin)
  intent.putExtra("user", user)
  intent.putExtra("password", password)
  intent.putExtra("key", key)
  intent.putExtra("plateId", plateId)
  intent.putExtra("isEncrypt", isEncrypt)
  intent.putExtra("secret", secret)
  local path=activity.getLuaDir().."/script/forum.lua"
  intent.setData(Uri.parse("file://"..path));
  activity.startActivity(intent,ActivityOptions.makeSceneTransitionAnimation(activity,v,"searchone").toBundle());
end