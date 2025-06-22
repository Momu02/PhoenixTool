require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "java.io.File"
--布局表中调用
import "android.graphics.Typeface"
function 字体(t)
  return Typeface.createFromFile(File(activity.getLuaDir().."/res/"..t..".ttf"))
end
layout={
  LinearLayout,
  orientation="vertical",
  layout_width="fill",
  layout_height="fill",

  {
    LinearLayout;
    id='mToolbar';
    layout_width='fill';--布局宽度
    layout_height="56dp";
    orientation="vertical";
    {
      LinearLayout;
      layout_width="fill";
      orientation="horizontal";
      layout_height="56dp";
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
          src="img/__ic_fltbtn.png";
          id="Sideslip1";
          layout_width="25dp";
        };
      };
      {
        LinearLayout;
        layout_height="fill";
        layout_weight="1";
        orientation="horizontal";
        {
          TextView;
          text="源语言选择";
          layout_gravity="center";
          textSize="18sp";
          Typeface=字体("Product");
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
  {
    ListView,
    layout_width="fill",
    layout_height="fill",
    id="list",
    --dividerHeight="1",
  },
}


items=
{
  LinearLayout,
  orientation="horizontal",
  layout_width="fill",
  --layout_height="24dp",
  {
    TextView,
    layout_width="fill",
    layout_height="24dp",
    layout_margin="10dp",
    Gravity="center|left",
    --paddingLeft="40",
    textColor="#808080",
    textSize="15",
    id="name"
  },
}
activity.setContentView(loadlayout(layout))


maxText={"中文","英文","日文","韩文","法文","俄文","西班牙文"}


数据={}

for i=1,#maxText do
  table.insert(数据,{name=maxText[i]})
end

adp=LuaAdapter(activity,数据,items)
list.setAdapter(adp)

list.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(parent,v,pos,id)
    activity.result{maxText[pos+1]}
    activity.finish()
  end
})

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



