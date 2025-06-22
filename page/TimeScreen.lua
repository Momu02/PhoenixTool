require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
--隐藏状态栏
import "android.view.WindowManager"
activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)

颜色="#FF000000"
kksosoks=
{
  LinearLayout;
  gravity="center";
  layout_width="fill";
  layout_height="fill";
  id="背景";
  background=颜色;
  {
    LinearLayout;
    Focusable=true,
    FocusableInTouchMode=true,
    {
      LinearLayout;
      gravity="center";
      layout_width="fill";
      layout_height="fill";
      orientation="horizontal";
      {
        TextView;
        textSize="74sp";
        id="asp3";
        text="加载中";
        Typeface=字体("Product3");
        gravity="center";
        textColor=(0x48ffffff);
      };
      {
        TextView;
        textSize="90sp";
        id="asp";
        Typeface=字体("Product4");
        text="00:00";
        gravity="center";
        textColor=(0xffdbdbdb);
      };
      {
        TextView;
        gravity="center";
        Typeface=字体("Product4");
        id="asp29";
        text=":";
        textSize="90sp";
        textColor=(0x48ffffff);
      };
      {
        TextView;
        gravity="center";
        Typeface=字体("Product4");
        id="asp2";
        text="0";
        textSize="90sp";
        textColor=(0x48ffffff);
      };
    };
  };
};
activity.setTheme(android.R.style.Theme_DeviceDefault_Light_NoActionBar)
activity.setContentView(loadlayout(kksosoks))
activity.setRequestedOrientation(0)





function mb()
  if tonumber(os.date("%H"))>=tonumber("24") then
    asp3.setText("半夜")
   elseif tonumber(os.date("%H"))>=tonumber("19") then
    asp3.setText("晚上")
   elseif tonumber(os.date("%H"))>=tonumber("17") then
    asp3.setText("傍晚")
   elseif tonumber(os.date("%H"))>=tonumber("14") then
    asp3.setText("下午")
   elseif tonumber(os.date("%H"))>=tonumber("12") then
    asp3.setText("中午")
   elseif tonumber(os.date("%H"))>=tonumber("10") then
    asp3.setText("上午")
   elseif tonumber(os.date("%H"))>=tonumber("7") then
    asp3.setText("早上")
   elseif tonumber(os.date("%H"))<=tonumber("5") then
    asp3.setText("清晨")
  end
  asp.setText(os.date("%H:%M"))
  asp2.setText(os.date("%S"))
  --本地时间总和

end


--线程函数
function ap()
  --调用主线程函数

  require "import"
  activity.setRequestedOrientation(0)
  --Thread.sleep(1000)--延迟1000毫秒
  while( true ) do

    Thread.sleep(1000)--延迟1000毫秒


    call("mb")


  end





end

thread(ap)
asp3.getPaint().setFakeBoldText(true)
asp.getPaint().setFakeBoldText(true)
asp2.getPaint().setFakeBoldText(true)

白="打开"
背景.onClick=function()
  import "android.animation.ObjectAnimator"
  import "android.animation.ArgbEvaluator"
  import "android.animation.ValueAnimator"
  import "android.graphics.Color"

  if 白=="打开" then
    白="关闭"
    view=背景
    color1 = 0xFF000000;
    color2 = 0xFFFAFAFA;
    colorAnim = ObjectAnimator.ofInt(view,"backgroundColor",{color1, color2})
    colorAnim.setDuration(600)
    colorAnim.setEvaluator(ArgbEvaluator())
    colorAnim.setRepeatCount(0)
    --colorAnim.setRepeatMode(ValueAnimator.REVERSE)
    colorAnim.start()
    asp3.textColor=0xff3d3d3d
    asp.textColor=0xff3d3d3d
    asp2.textColor=0xff3d3d3d
    asp29.textColor=0xff3d3d3d
    -- 背景.setBackgroundColor(Color.parseColor("#FFFFFFFF"));
   else
    白="打开"
    view=背景
    color1 = 0xFFFAFAFA;
    color2 = 0xFF000000;
    colorAnim = ObjectAnimator.ofInt(view,"backgroundColor",{color1, color2})
    colorAnim.setDuration(600)
    colorAnim.setEvaluator(ArgbEvaluator())
    colorAnim.setRepeatCount(0)
    --colorAnim.setRepeatMode(ValueAnimator.REVERSE)
    colorAnim.start()
    asp3.textColor=0x48ffffff
    asp.textColor=0xffdbdbdb
    asp2.textColor=0x48ffffff
    asp29.textColor=0x48ffffff
    --背景.setBackgroundColor(Color.parseColor("#FF000000"));
  end
end