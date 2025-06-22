require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.reportRecord"
import "http"
import "cjson"
import "mods.muk"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(reportRecord))


url,admin,user,password,key,isEncrypt,secret=...


--定义布局
layoutList={
  LinearLayout;
  layout_height="fill";
  layout_width="fill";
  {
    CardView;
    layout_margin="10dp";
    layout_width="match_parent";
    radius="10dp";
    {
      LinearLayout;
      orientation="vertical";
      layout_width="match_parent";
      {
        LinearLayout;
        layout_margin="10dp";
        {
          TextView;
          textColor="#000000";
          text="举报用户:";
        };
        {
          TextView;
          text="reportName";
          textColor="#00E1FF";
          id="reportName";
        };
        {
          TextView;
          layout_marginLeft="10dp";
          text="reportUser";
          textColor="#000000";
          id="reportUser";
        };
      };
      {
        LinearLayout;
        layout_marginLeft="10dp";
        {
          TextView;
          textColor="#000000";
          text="举报时间:";
        };
        {
          TextView;
          text="time";
          textColor="#000000";
          id="time";
        };
      };
      {
        LinearLayout;
        layout_margin="10dp";
        {
          TextView;
          textColor="#000000";
          text="举报内容:";
        };
        {
          TextView;
          text="content";
          textColor="#000000";
          id="content";
        };
      };
      {
        LinearLayout;
        layout_marginLeft="10dp";
        {
          TextView;
          textColor="#000000";
          text="受理状态:";
        };
        {
          TextView;
          text="state";
          textColor="#000000";
          id="state";
        };
      };
      {
        LinearLayout;
        layout_margin="10dp";
        {
          TextView;
          textColor="#000000";
          text="受理结果:";
        };
        {
          TextView;
          text="result";
          textColor="#000000";
          id="result";
        };
      };
    };
  };
};
adp=LuaAdapter(activity,layoutList)
--分页数
num=0

--列表加载函数
function loadList(new)
  local api=url.."main/api/user/report_record.php"
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
            adp.add{reportName=item.name,reportUser=item.user,time=item.time,content=item.content,state=item.state,result=item.result}
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