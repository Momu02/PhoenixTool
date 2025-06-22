require "import"
import "android.widget.*"
import "android.view.*"

activity.setRequestedOrientation(0);

import "java.io.File"
--布局表中调用
import "android.graphics.Typeface"
function 字体(t)
  return Typeface.createFromFile(File(activity.getLuaDir().."/res/"..t..".ttf"))
end
--隐藏状态栏
activity.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
--导航栏
activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION)

results=...

FullScreenLayout={
  LinearLayout,
  orientation="vertical",
  layout_width="fill",
  layout_height="fill",
  Gravity="center",
  {
    TextView,
    text=results,
    Typeface=字体("Product2");
    textSize="80",
  },
}
activity.setContentView(loadlayout(FullScreenLayout))




