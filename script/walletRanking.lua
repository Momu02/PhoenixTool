require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "page.forum_layout.walletRanking"
import "cjson"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(walletRanking))

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
    LinearLayout;
    gravity="center";
    backgroundColor=backgroundc;
    layout_marginTop="2dp";
    layout_width="match_parent";
    {
      TextView;
      layout_margin="10dp";
      id="num";
      text="num";
      textColor=textc;
    };
    {
      CardView;
      radius="20dp";
      layout_height="40dp";
      layout_margin="10dp";
      CardElevation="0dp";
      layout_width="40dp";
      {
        ImageView;
        layout_height="match_parent";
        scaleType="centerCrop";
        layout_width="match_parent";
        id="head";
      };
    };
    {
      LinearLayout;
      orientation="vertical";
      {
        TextView;
        id="user";
        text="user";
        visibility=8;
        textColor=textc;
      };
      {
        TextView;
        id="name";
        text="name";
        textColor=textc;
      };
    };
    {
      LinearLayout;
      gravity="right|center";
      layout_marginRight="10dp";
      orientation="vertical";
      layout_width="match_parent";
      {
        LinearLayout;
        gravity="center";
        orientation="vertical";
        {
          TextView;
          textSize="16sp";
          id="wallet";
          text="wallet";
          textColor=textc;
        };
        {
          TextView;
          textColor=textc;
          text="积分";
        };
      };
    };
  };
};

--声明列表加载函数，num参数为分页数，new参数为是否继续加载列表，true为是，false为重新加载
function loadList(num,new)
  if new==false then
    adp=nil
    adp=LuaAdapter(activity,layoutList)
  end
  --声明接口
  local api=url.."main/api/ranking/ranking_wallet.php"
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
            --添加列表数据
            adp.add{
              name=item.name,
              num=tostring(tointeger(item.nums)),
              user=item.user,
              head=item.head,
              wallet=item.wallet
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
        print(data.msg)
      end
     else
      --请求失败
      print("Http error code:"..code)
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