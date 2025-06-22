NewBar={shouldDismiss=true}

function Nbar(fill)
  local w=activity.width

  local layout={
    LinearLayout,
    Gravity="top",
    paddingTop=activity.getResources().getDimensionPixelSize(luajava.bindClass("com.android.internal.R$dimen")().status_bar_height);
    {
      CardView,
      layout_height=-2,
      layout_width=-1,
      CardElevation="0",
      CardBackgroundColor="#FFc04851",
      Radius="4dp",
      alpha=0.96,
      layout_margin="25dp";
      {
        LinearLayout,
        layout_height=-2,
        layout_width=-1,
        gravity="left|center",
        padding="16dp";
        --paddingTop="12dp";
        --paddingBottom="12dp";
        {
          TextView,
          textColor=0xffffffff,
          textSize="16sp";
          layout_height=-2,
          layout_width=-2,
          text=fill;
          Typeface=字体("product")
        },
      }
    }
  }

  local function addView(view)
    local mLayoutParams=ViewGroup.LayoutParams
    (-1,-1)
    activity.Window.DecorView.addView(view,mLayoutParams)
  end

  local function removeView(view)
    activity.Window.DecorView.removeView(view)
  end

  function indefiniteDismiss(NewBar)
    task(10000,function()
      if NewBar.shouldDismiss==true then
        NewBar:dismiss()
       else
        indefiniteDismiss(NewBar)
      end
    end)
  end

  function NewBar:dismiss()
    local view=self.view
    view.animate().translationY(300)
    .setDuration(400)
    .setInterpolator(AccelerateDecelerateInterpolator())
    .setListener(Animator.AnimatorListener{
      onAnimationEnd=function()
        removeView(view)
      end
    }).start()
  end

  NewBar.__index=NewBar

  function NewBar.build()
    local mNewBar={}
    setmetatable(mNewBar,NewBar)
    mNewBar.view=loadlayout(layout)
    mNewBar.bckView=mNewBar.view
    .getChildAt(0)
    mNewBar.textView=mNewBar.bckView
    .getChildAt(0)
    local function animate(v,tx,dura)
      ValueAnimator().ofFloat({v.translationX,tx}).setDuration(dura)
      .addUpdateListener( ValueAnimator.AnimatorUpdateListener
      {
        onAnimationUpdate=function( p1)
          local f=p1.animatedValue
          v.translationX=f
          v.alpha=1-math.abs(v.translationX)/w
        end
      }).addListener(ValueAnimator.AnimatorListener{
        onAnimationEnd=function()
          if math.abs(tx)>=w then
            removeView(mNewBar.view)
          end
        end
      }).start()
    end
    local frx,p,v,fx=0,0,0,0
    mNewBar.bckView.setOnTouchListener(View.OnTouchListener{
      onTouch=function(view,event)
        if event.Action==event.ACTION_DOWN then
          mNewBar.shouldDismiss=false
          frx=event.x-dp2px(8)
          fx=event.x-dp2px(8)
         elseif event.Action==event.ACTION_MOVE then
          if math.abs(event.rawX-dp2px(8)-frx)>=2 then
            v=math.abs((frx-event.rawX-dp2px(8))/(os.clock()-p)/1000)
          end
          p=os.clock()
          frx=event.rawX-dp2px(8)
          view.translationX=frx-fx
          view.alpha=1-math.abs(view.translationX)/w
         elseif event.Action==event.ACTION_UP then
          mNewBar.shouldDismiss=true
          local tx=view.translationX
          if tx>=w/5 then
            animate(view,w,(w-tx)/v)
           elseif tx>0 and tx<w/5 then
            animate(view,0,tx/v)
           elseif tx<=-w/5 then
            animate(view,-w,(w+tx)/v)
           else
            animate(view,0,-tx/v)
          end
          fx=0
        end
        return true
      end
    })
    return mNewBar
  end

  function NewBar:show()
    local view=self.view
    addView(view)
    view.translationY=300
    view.animate().translationY(0)
    .setInterpolator(AccelerateDecelerateInterpolator())
    .setDuration(400).start()
    indefiniteDismiss(self)
  end

  NewBar.build():show()
end