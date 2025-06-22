function 判断有无导航栏()
  import "android.view.ViewConfiguration"
  import "android.view.KeyCharacterMap"
  import "android.view.KeyEvent"
  --通过判断设备是否有返回键、菜单键(不是虚拟键,是手机屏幕外的按键)来确定是否有navigation bar
  local hasMenuKey = ViewConfiguration.get(this).hasPermanentMenuKey();
  local hasBackKey = KeyCharacterMap.deviceHasKey(KeyEvent.KEYCODE_BACK);
  if (!hasMenuKey && !hasBackKey) then
    --做任何你需要做的,这个设备有一个导航栏
    导航状态 = true;
   else
    导航状态 = false;
  end
  return 导航状态;
end

function 状态栏高()
  local h=activity.getResources().getDimensionPixelSize(luajava.bindClass("com.android.internal.R$dimen")().status_bar_height)
  return h
end
function 转分辨率(sdp)
  import "android.util.TypedValue"
  dm=this.getResources().getDisplayMetrics()
  types={px=0,dp=1,sp=2,pt=3,["in"]=4,mm=5}
  n,ty=sdp:match("^(%-?[%.%d]+)(%a%a)$")
  return TypedValue.applyDimension(types[ty],tonumber(n),dm)
end
function 变色动画(控件,color1,color2,时长)
  import "android.animation.ArgbEvaluator"
  import "android.animation.ObjectAnimator"
  ObjectAnimator.ofInt(控件,"backgroundColor",{color1,color2}).setDuration(时长).setEvaluator(ArgbEvaluator()).start()
end

function 图片变色动画(控件,color1,color2,时长)
  import "android.animation.ArgbEvaluator"
  import "android.animation.ObjectAnimator"
  ObjectAnimator.ofInt(控件,"ColorFilter",{color1,color2}).setDuration(时长).setEvaluator(ArgbEvaluator()).start()
end

function 透明动画(对象,参数,时长)
  import "android.animation.ObjectAnimator"
  ObjectAnimator().ofFloat(对象,"alpha",参数).setDuration(时长).start()
end
function 水珠动画(view,time)
  import "android.animation.ObjectAnimator"
  ObjectAnimator().ofFloat(view,"scaleX",{1.2,.8,1.1,.9,1}).setDuration(time).start()
  ObjectAnimator().ofFloat(view,"scaleY",{1.2,.8,1.1,.9,1}).setDuration(time).start()
end

function 旋转动画(控件,角度,时间)
  import "android.animation.ObjectAnimator"
  ObjectAnimator().ofFloat(控件,"rotation",角度).setDuration(时间).start()
end

function 纵振动画(控件,方向,位移,时间)
  import "android.animation.ObjectAnimator"
  ObjectAnimator().ofFloat(控件,方向,位移).setDuration(时间).start()
end

function 缩放动画(控件,比例,时间)
  import "android.animation.ObjectAnimator"
  ObjectAnimator().ofFloat(控件,"scaleX",比例).setDuration(时间).start()
  ObjectAnimator().ofFloat(控件,"scaleY",比例).setDuration(时间).start()
end

function 列表高度()
  if activity.getHeight()<=转分辨率("630dp") then
    高度="630dp"
   else
    高度=activity.getHeight()-状态栏高()
  end
  return 高度
end


function 列表高度二()
  if activity.getHeight()*.54<=转分辨率("150dp") then
    高度二=转分辨率("150dp")+activity.getHeight()*.46
   else
    高度二=activity.getHeight()-状态栏高()-转分辨率("50dp")
  end
  return 高度二
end

import "java.io.*"
function 保存图片(bitmap,name)
  local f=File("/sdcard/"..name)
  local path=BufferedOutputStream(FileOutputStream(f))
  bitmap.compress(Bitmap.CompressFormat.JPEG,50,path)
  return true
end

function 缩略图片(图片,比例)
  model={}
  h=图片.getHeight()
  w=图片.getWidth()
  import "android.graphics.Bitmap"
  curPic = Bitmap.createBitmap(图片.getWidth()/比例+1,图片.getHeight()/比例+1,Bitmap.Config.ARGB_4444);
  for n=0,h/比例 do
    model[n]={}
    for t=0,w/比例 do
      c=图片.getPixel(t*比例,n*比例)

      if c ==-0 then

       else
        curPic.setPixel(t,n,c);
      end
    end
  end
  return curPic
end


function qing高斯模糊(活动,位图,模糊度,加深)
  import "android.graphics.Matrix"
  import "android.graphics.Bitmap"
  import "android.renderscript.Allocation"
  import "android.renderscript.Element"
  import "android.renderscript.ScriptIntrinsicBlur"
  import "android.renderscript.RenderScript"
  local renderScript = RenderScript.create(活动);
  local blurScript = ScriptIntrinsicBlur.create(renderScript,Element.U8_4(renderScript));
  local inAllocation = Allocation.createFromBitmap(renderScript,位图);
  local outputBitmap = 位图;
  local outAllocation = Allocation.createTyped(renderScript,inAllocation.getType());
  blurScript.setRadius(模糊度);
  blurScript.setInput(inAllocation);
  blurScript.forEach(outAllocation);
  outAllocation.copyTo(outputBitmap);
  inAllocation.destroy();
  outAllocation.destroy();
  renderScript.destroy();
  blurScript.destroy();
  local w = outputBitmap.getWidth();
  local h = outputBitmap.getHeight();
  local matrix = Matrix();
  matrix.postScale(加深,加深);
  return Bitmap.createBitmap(outputBitmap,0,0,w,h,matrix,true);
end