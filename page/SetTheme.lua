require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
activity.setTheme(android.R.style.Theme_DeviceDefault_Light_NoActionBar)


ThemeTabe={
  {"贴吧蓝",0xFF2196F3},
  {"酷安绿",0xFF109D58},
  {"哔哩粉",0xFFF06292},
  {"红",0xFFF44336},
  {"颐堤蓝",0xFF3F51B5},
  {"水鸭青",0xFF009688},
  {"伊藤橙",0xFFFF9800},
  {"高级紫",0xFF673AB7},
  {"古铜棕",0xFF795548},
  {"低调灰",0xFF607D8B},
  {"绝对黑",0xff000000},
  {"经典白",0xffffffff},
};


layout={
  LinearLayout;
  layout_width="-1";
  layout_height="-1";
  orientation="vertical";
  backgroundColor="#ff4285f4";
  id="toolbar";
  {
    LinearLayout;
    layout_width="match_parent";
    layout_marginTop=bar_height;

    {
      LinearLayout;
      orientation="horizontal";
      gravity="center";
      layout_height="56dp";
      layout_width="match_parent";
      {
        LinearLayout;
        layout_height="match_parent";
        gravity="center";
        id="back";
        style="?android:attr/buttonBarButtonStyle";
        onClick=function
          activity.finish()
        end;
        {
          CardView;
          layout_height="80dp";
          PreventCornerOverlap=false;
          layout_marginLeft="-15dp";
          CardElevation="0dp";
          background="#00000000";
          radius="40dp";
          UseCompatPadding=false;
          layout_width="80dp";
          {
            ImageView;
            layout_height="match_parent";
            layout_margin="-10dp";

            colorFilter="#ffffffff";
            background="#00000000";
            padding="38dp";
            src="res/back.png";
            layout_width="match_parent";
          };
        };
      };
      {
        TextView;
        lines="1" ;
        ellipsize="end";
        gravity="center|left";
        singleLine=true;
        layout_marginLeft="-15dp";
        layout_width="match_parent";
        text="主题";
        id="Title";
        Typeface=Bold;
        textSize="19dp";
        ellipsize="end";
        layout_height="match_parent";
        layout_weight="1";
        textColor="#ffffffff";
      };

    };
  };


  {
    LinearLayout;
    layout_height="fill";
    layout_width="fill";
    backgroundColor="#ffffffff";
    orientation="vertical";
    {
      GridView;
      layout_height="match_parent";
      numColumns=1;
      id="list";
      layout_width="match_parent";
    };
  };
};

--item项目布局
item={
  LinearLayout;
  layout_height="48dp";
  layout_width="-1";
  {
    CardView;
    layout_marginLeft="12dp";
    layout_height="30dp";
    elevation="1dp";
    layout_gravity="start|center";
    layout_width="30dp";
    radius="50dp";
    id="cr";
  };
  {
    TextView;
    layout_gravity="start|center";
    layout_marginLeft="12dp";
    id="name";
    textSize="18sp";
  };
  {
    LinearLayout;
    layout_height="48dp";
    layout_width="match_parent";
    gravity="center|right";
    {
      ImageView;
      visibility=8;
      layout_marginRight="12dp";
      src="res/true.png";
      layout_width="24dp";
      layout_height="24dp";
      id="ty";
    };
  };
};

activity.setContentView(loadlayout(layout))



data={}
adp=LuaAdapter(activity,data,item)
list.setAdapter(adp)

function Them()
  adp.clear()
  for i=1,#ThemeTabe do
    if i==this.getSharedData("主题") then
      状态=0
     else
      状态=8
    end
    adp.add({
      cr={
        CardBackgroundColor=ThemeTabe[i][2]
      },
      name={
        Text=ThemeTabe[i][1],
        textColor=ThemeTabe[i][2]
      },
      ty={
        colorFilter=ThemeTabe[i][2],
        Visibility=状态
      }
    })
  end
end

Them()

list.onItemClick=function(l,v,p,i)
  --储存选择的主题值
  this.setSharedData("主题",i)
  this.setSharedData("主题色",ThemeTabe[i][2])
  --设置顶栏
  toolbar.backgroundColor=ThemeTabe[i][2]
  --设置状态栏
  if Build.VERSION.SDK_INT >= 21 then
    activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS).setStatusBarColor(ThemeTabe[this.getSharedData("主题")][2]);
  end
  --刷新适配器
  Them()
end