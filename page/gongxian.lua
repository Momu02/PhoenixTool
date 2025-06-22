require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "mods.muk"

itemc={
  LinearLayout,
  orientation="horizontal",
  layout_width="fill",
  -- layout_height='44dp';
  --id="fpll",
  {
    ImageView;
    -- src=图标;
    layout_width='0dp';
    layout_height='56dp';
    layout_gravity='left|center';
    layout_margin='0dp';
    layout_marginLeft='0dp';
    id='菜cd单';
    ColorFilter=0xff2c2c2c;--设置图片着色
    onClick=function()
    end
  };
  {
    LinearLayout;
    layout_width="fill";
    layout_height="52dp";
    orientation="vertical";
    layout_marginLeft="14dp";
    {
      TextView;
      id="srct";
      -- layout_height="40dp";
      layout_width="fill";
      Typeface=字体("Product3");
      textColor=0xff2c2c2c,
      gravity="left|bottom",
      textSize="15sp",
    };
    {
      TextView;
      id="srcb";
      -- layout_height="40dp";
      layout_width="fill";
      Typeface=字体("Product3");
      textColor="#808080",
      gravity="left",
      layout_marginTop="6dp";
      textSize="12.5sp",
    };

  };

}
uuuu=
{
  LinearLayout;--线性布局
  Orientation='vertical';--布局方向
  layout_width='fill';--布局宽度
  layout_height='fill';--布局高度

  {
    LinearLayout;
    id='mToolbar';
    layout_width='fill';--布局宽度
    layout_height="70dp";
    orientation="vertical";
    background="#ff889758";
    {
      LinearLayout;
      layout_width="fill";
      orientation="horizontal";
      layout_height="70dp";
      -- elevation="3dp";   
      {
        LinearLayout;
        gravity="center";
        layout_width="56dp";
        layout_height="56dp";
        id="Sideslip";
        {
          ImageView;
          layout_height="28dp";
          src="png/__ic_fltbtn.png";
          id="Sideslip1";
          -- colorFilter=io.open("/data/data/"..activity.getPackageName().."/顶栏部件颜色储存.xml"):read("*a");
          layout_width="25dp";
        };
      };
      {
        LinearLayout;
        layout_height="fill";
        layout_weight="1";
        orientation="horizontal";
        layout_marginTop="23dp";
        {
          TextView;
          text="致谢名册";
          layout_gravity="center";
          textSize="18sp";
          Typeface=字体("Product3");
          id="标题";
        };
      };

      --[[  {
        LinearLayout;
        gravity="center";
        layout_width="55dp";
        layout_height="55dp";
        id="menu";
          {
        LinearLayout;
        layout_gravity="right";
        layout_width="0dp";
        layout_height="0dp";
        id="menu2";
      };
        {
          ImageView;
          layout_height="25dp";
          src="png/ic_dots_vertical.png";
          id="menu1";
          colorFilter="#ff000000";
          layout_width="25dp";
        };
      };]]


    };

  };
  {--滚动布局下必须有线性竖直布局
    LinearLayout,
    orientation="vertical",
    layout_width="fill",
    layout_height="fill",

    {
      CardView;--卡片控件
      layout_width="fill";
      elevation="2dp";
      radius="0dp";--4dp
      id="vngggggg";
      --Background="#fffefefe";
      CardBackgroundColor=深色;
      layout_margin="0dp";--10dp 
      layout_gravity="center";
      layout_height="fill";
      {--添加一个list布局，这个时候list是空的，还没有匹配数据
        --仅仅是在屏幕布局内开辟一块大空间作为list布局
        ListView;
        fastScrollEnabled=true;
        layout_width="fill";
        layout_height="fill";--高度需要更苦list多少进行计算，或者自己根据自己的不同写表达式
        --这里是分割线的意思
        dividerHeight="0";
        id="list3";
        --background="#ff4285f4",
      };
    };
  };

};
activity.setContentView(loadlayout(uuuu))
--一个小list模板已搭建好了，下面开始匹配数据

--创建一个空的列表为datas(列表就是可以存放多个数据的意思)
datas={}

--创建了三个有数据的列表
aic={}
aw3={"快手科技有限公司","Manalua手册","muk插件","互联网","小绵羊233","郁金香导航","FALua手册","yuxuan","m.wufazhuce.com","清风工作室","ASD工具箱","幻了个城fly","小绵羊233"}
mmp={"感谢快手官方捐赠0.01-0.1元不等若干次","部分经典代码","部分代码","感谢部分未提名的开源开发者","功能搜索","部分功能","部分功能的代码","翻译","阅图文API","论坛主页UI","时间屏幕","捐赠界面","课程表设计"}
--"当前为"..io.open("/data/data/"..activity.getPackageName().."/主页链接.xml"):read("*a")

--循环添加匹配有数据的列表到
--nj只是一个变量，你可以用其他变量代替
--在lua中#用来测长度，所以#aw,因为aw里面有3个数据，所以#aw=3
--就相当于  for  1,3   do
for nj=1,#aw3 do
  --给空的datas添加所有的数据
  --格式为  table.insert(空列表名称,{id=数据列表[nj]})
  table.insert(datas,{srct=aw3[nj],srcf=aic[nj],srcb=mmp[nj]})
end
--
--创建适配器，将datas里面的数据匹配给itemc小项目
yuxuan_adpqy=LuaAdapter(activity,datas,itemc)

--将小项目匹配给大list
list3.Adapter=yuxuan_adpqy
list3.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(parent,v,pos,id)
    v=pos
  end
})
x=false
--activity.ActionBar.setDisplayHomeAsUpEnabled(true)--true打开,false关闭
onOptionsItemSelected=function()--点击事件
  activity.finish()--关闭当前窗口
end
function 波纹(id,颜色)
  import "android.content.res.ColorStateList"local attrsArray = {android.R.attr.selectableItemBackgroundBorderless}
  local typedArray =activity.obtainStyledAttributes(attrsArray)
  ripple=typedArray.getResourceId(0,0)
  Pretend=activity.Resources.getDrawable(ripple)
  Pretend.setColor(ColorStateList(int[0].class{int{}},int{颜色}))
  id.setBackground(Pretend.setColor(ColorStateList(int[0].class{int{}},int{颜色})))
end
Sideslip.onClick=function(v)
  activity.finish()
  --相当于FusionAPP的退出页面与退出程序
end
--activity.ActionBar.hide()
波纹(Sideslip,0xFF7F7F7F)
--波纹(menu,0xFF7F7F7F)