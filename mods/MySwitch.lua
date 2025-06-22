import "android.view.animation.*"
import "android.animation.*"
import "android.graphics.drawable.*"
import "android.graphics.*"

return function(...)
  local view=View(...)
  local tag={
    progress=0,
    check=false,
    color1=0xffE5E5E5,
    color2=0xffE5E5E5,
    onChange=lambda;
  }
  view.tag=tag

  local BackgroundDrawable=LuaDrawable(function(ca,pa,self)
    local w=ca.width--150
    local h=ca.height--75
    local rect=RectF(5,5,w-5,h-5)

    pa.setAntiAlias(true)
    .setStrokeWidth(5)
    .setStyle(Paint.Style.STROKE)
    return function(ca)
      pa.setColor(tag.color1)
      ca.drawRoundRect(rect,h/2,h/2,pa)
    end
  end)

  local ForegroundDrawable=LuaDrawable(function(ca,pa,self)
    local w=ca.width--150
    local h=ca.height--75
    local rect=RectF()
    local color=ArgbEvaluator()

    pa.setAntiAlias(true)
    .setStyle(Paint.Style.FILL)

    return function(ca)
      local progress=tag.progress
      if tag.check
        progress=1-progress
      end

      pa.setColor(color.evaluate(progress,int(tag.color1),int(tag.color2)))
      rect.set(((w-(w/6.5*2)-(h/2))*progress)+(w/6.5),(h/2)-(h/4)+((1-progress)*((h/4)-5)),((w-(w/6.5*2)-(h/2))*progress)+(w/6.5)+(h/2),h/2+(h/4)-((1-progress)*((h/4)-5)))
      ca.drawRoundRect(rect,h/2,h/2,pa)
    end
  end)

  local anim=ObjectAnimator.ofFloat({1,0})
  .addUpdateListener(function(self)
    local v=self.getAnimatedValue()
    tag.progress=v
    ForegroundDrawable.invalidateSelf()
    if v==0
      tag.onChange(view,tag.check)
    end
  end)
  .setDuration(200)
  .setRepeatMode(Animation.RESTART)
  .setInterpolator(LinearInterpolator())


  view.onTouch=function(v,e)
    v.performHapticFeedback(HapticFeedbackConstants.LONG_PRESS,HapticFeedbackConstants.FLAG_IGNORE_GLOBAL_SETTING)
    tag.check=!tag.check
    anim.start()
  end

  function tag.getChecked()
    return tag.check
  end

  function tag.setChecked(b)
    tag.check=b
    tag.progress=0
    ForegroundDrawable.invalidateSelf()
    return tag
  end

  function tag.getTrackColor()
    return tag.color1
  end

  function tag.setTrackColor(color)
    tag.color1=color
    BackgroundDrawable.invalidateSelf()
    return tag
  end

  function tag.getThumbColor()
    return tag.color2
  end

  function tag.setThumbColor(color)
    tag.color2=color
    ForegroundDrawable.invalidateSelf()
    return tag
  end

  function tag.setWidth(n)
    view.post(function()
      local params=view.getLayoutParams()
      params.width=n or 130
      view.setLayoutParams(params)
    end)
    return tag
  end

  function tag.getWidth()
    return view.getWidth()
  end

  function tag.setHeight(n)
    view.post(function()
      local params=view.getLayoutParams()
      params.height=n or 65
      view.setLayoutParams(params)
    end)
    return tag
  end

  function tag.getHeight()
    return view.getHeight()
  end

  view.post(function()
    local params=view.getLayoutParams()
    params.width=130
    params.height=65
    view
    .setLayoutParams(params)
    .setBackground(BackgroundDrawable)
    .setForeground(ForegroundDrawable)
  end)
  return view
end