require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "com.narcissus.encrypt.*"


admin = "1336315242"
key = "9bd6331262d90de013e3"
secret = "00eceefd840f6b87f5dd"
isEncrypt = true


--以下是论坛的代码
--注意此处应该加判断，当没登录账号密码时不执行
function 加载论坛()
  if isLogined==true then
    local HomeRecord = this.getSharedData("HomeRecord")
    if HomeRecord == "论坛" then
      dialog= ProgressDialog.show(this,nil, "加载中..",false, false).hide()
      dialog.show()
    end
    num=0
    --定义列表布局
    layoutList = {
      LinearLayout;
      layout_width = "fill";
      layout_height = "fill";
      {
        LinearLayout;
        layout_height = "150dp";
        layout_width = "fill";
        layout_marginLeft = "7.5dp";
        layout_marginRight = "7.5dp";
        orientation = "horizontal";
        {
          FrameLayout;
          layout_height = "fill";
          layout_width = "fill";
          layout_weight = 1;
          {
            CardView;
            layout_height = "fill";
            layout_width = "fill";
            layout_margin = "7.5dp";
            radius = "15dp"; -- 降低圆角半径
            elevation = "4dp"; -- 降低阴影层级
            CardBackgroundColor = backgroundc;
            {
              LinearLayout;
              layout_height = "fill";
              layout_width = "fill";
              orientation = "vertical";
              {
                LinearLayout;
                orientation = "horizontal";
                layout_width = "fill";
                {
                  FrameLayout;
                  layout_height = "fill";
                  layout_width = "80dp"; -- 缩小宽度
                  {
                    CardView;
                    layout_height = "60dp";
                    layout_width = "60dp";
                    layout_gravity = "center";
                    radius = "15dp"; -- 降低圆角半径
                    elevation = "0dp"; -- 去除阴影
                    CardBackgroundColor = 主题色;
                    {
                      ImageView;
                      layout_height = "40dp";
                      layout_width = "40dp";
                      layout_gravity = "center";
                      colorFilter = "#ffffffff";
                      id = "plateIcon";
                    }
                  };
                };
                {
                  LinearLayout;
                  orientation = "vertical";
                  layout_width = "fill";
                  layout_marginLeft = "-10dp"; -- 减少 margin
                  {
                    TextView;
                    id = "name";
                    textSize = "20dp"; -- 降低字体大小
                    textColor = textc;
                    layout_height = "70dp";
                    layout_width = "fill";
                    layout_marginLeft = "20dp";
                    gravity = "center|left";
                  };
                  {
                    TextView;
                    id = "content1";
                    textSize = "12dp"; -- 降低字体大小
                    textColor = "#FFD2D2D2";
                    layout_height = "wrap_content";
                    layout_width = "fill";
                    layout_marginLeft = "20dp";
                    layout_marginTop = "-10dp"; -- 减少 marginTop
                    gravity = "center|left";
                  };
                  {
                    FrameLayout;
                    layout_height = "fill";
                    layout_width = "fill";
                    {
                      CardView;
                      layout_height = "4dp"; -- 降低高度
                      layout_width = "fill";
                      layout_marginLeft = "20dp";
                      layout_marginRight = "20dp";
                      layout_marginTop = "20dp"; -- 减少 marginTop
                      layout_gravity = "left|bottom";
                      radius = "2dp";
                      elevation = "0dp";
                      CardBackgroundColor = 主题色;
                    };
                  };
                };
                {
                  TextView;
                  visibility=8,
                  id="plateId";
                  textColor="#ffff0000";
                  text="plateId";
                };
              };
            };
          };
        };
      };
    };



    -- 列表适配器
    forumadp = LuaAdapter(activity, layoutList);
    forumadp.clear()
    列表逐显动画(ForumList,0.1)

    --声明列表加载函数，num参数为分页数，new参数为是否继续加载列表，true为是，false为重新加载
    function loadList(num,new)
      --声明接口
      local api=url.."main/api/forum/plate_list.php"
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
                if utf8.len(item.content)>30 then
                  plateContent=utf8.sub(item.content,0,30).."…"
                 else
                  plateContent=item.content
                end
                --添加列表数据

                forumadp.add{
                  name=item.name,
                  content1=plateContent,
                  plateUser=item.user,
                  plateId=item.id,
                  plateIcon=item.icon
                }
              end
              dialog.dismiss()
              --Snakebar("论坛登录成功喵")
              --如果new为true，则刷新列表
              if new then
                forumadp.notifyDataSetChanged()
               else
                --否则重新加载列表
                ForumList.Adapter=forumadp
              end
             else
              --如果为0，修改newList变量，禁止分页加载
              newList=0
            end
           else
            --失败
            --需要增加日志功能
            提示("论坛打开失败，尝试重新加载...失败原因："..data.msg)
            loadList(num,new)
          end
         else
          loadList(num,new)
        end
      end)
    end

    --调用loadList函数
    loadList(num,false)

    --列表下滑到底事件，加载分页
    ForumList.setOnScrollListener{
      onScrollStateChanged=function(l,s)
        if ForumList.getLastVisiblePosition()==ForumList.getCount()-1 then
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

    --版块点击事件
    ForumList.onItemClick=function(parent,v,pos,id)
      --获取板块ID
      local plateId=v.Tag.plateId.Text
      --跳转板块主页
      activity.newActivity("script/forum", {url, admin, user, password, key, plateId, isEncrypt, secret})
    end
    ---------------------

    --这是page2的-----------------
    --获取个人中心信息
    function main111()
      --声明接口
      local api=url.."main/api/user/user_data.php"
      --请求体
      if isEncrypt then
        codekey=Narcissus.encrypt(key)
       else
        codekey=key
      end
      local body={
        ["admin"]=admin,
        ["user"]=user,
        ["password"]=password,
        ["key"]=codekey
      }
      Http.post(api,body,nil,nil,function (code,body)
        if code==200 then
          local data=cjson.decode(body)
          --判断是否获取成功
          if data.code==1 then
            --截取数据
            local data=data.data
            --设置头像
            head.setImageBitmap(loadbitmap(data.head))
            --设置昵称
            myname.setText(data.name)
            --设置余额
            wallet.setText(data.wallet)
            --设置会员状态
            --vip.setText(data.vip_state)
            --设置签名
            signature.setText(data.signatrue)
            --设置封禁
            --ban.setText(tostring(tointeger(data.ban)))
            --设置签到状态
            --sigState.setText(data.sig_state)
            --设置称号
            --title.setText(data.title)
            --设置邮箱
            --mail.setText(data.mail)
            --设置性别
            --gender.setText(data.gender)
            --设置关注
            follow.setText(tostring(tointeger(data.follow)))
            --设置粉丝
            fans.setText(tostring(tointeger(data.fans)))
           else
            main111()
          end
         else
          main111()
        end
      end)
    end

    main111()


    huadong.onScrollChange=function(a,b,j,y,u)
      title_box.setY(-j*.29)
      if j>activity.getHeight()*.1+转分辨率("200dp") then
        list_box.setY(-j+(activity.getHeight()*.1+转分辨率("200dp")))
      end

      if j<=转分辨率("100dp") then
        bottom_bar.setY(bottom_bar.getTop()+j)
      end
    end

    bottom_bar_two.setAlpha(0)

    pagef.addOnPageChangeListener{
      onPageScrolled=function(a,b,c)
        ftb.Rotation=c/6
        if b>0 then
          bottom_bar_one.setAlpha(1-b)
          bottom_bar_two.setAlpha(b)
        end
        --print(a,b,c)
      end}

    import "java.io.File"
    import "android.graphics.Typeface"
    local bf=File(activity.getLuaDir().."/font/zt2.ttf");
    local tf=Typeface.createFromFile(bf)
    title_one.setTypeface(tf);


    function 获取屏幕高度()
      import "android.content.Context"
      import "com.nirenr.Point"
      import "android.graphics.Point"
      local windowManager =activity.getApplication().getSystemService(Context.WINDOW_SERVICE);
      local display = windowManager.getDefaultDisplay();
      local outPoint = Point();
      if (Build.VERSION.SDK_INT >= 19) then
        --可能有虚拟按键的情况
        display.getRealSize(outPoint);
       else
        --不可能有虚拟按键
        display.getSize(outPoint);
      end
      return outPoint.y
    end

    pmh=activity.getHeight()

    ase=true

    huadong2.onScrollChange=function(a,b,j,y,u)

      back_img.setY(-j*.3)

      bar_box.setY(-j)

      if j>0 and j<=.19*activity.getHeight() then

        head_box.setScaleX(((.19*pmh)-j)/(.19*pmh)).setScaleY(((.19*pmh)-j)/(.19*pmh))

      end

      if j==0 then
        --滑动到顶时
       elseif j<=pmh*.20 then
        --开始下滑时
        if not ase then
          --上滑恢复时
          变色动画(标题栏,主题色,0x00000000,500)
          变色动画(detail_box,主题色,0x00000000,500)
          --title.setTextColor(0xFF000000)
          ase=true
        end

       elseif j>=pmh*.20 and j<=(pmh*.43-状态栏高()-转分辨率("50dp")) then
        if ase then
          变色动画(标题栏,0x00000000,主题色,500)
          变色动画(detail_box,0x00000000,主题色,500)
          ase=false
        end

       elseif j>=(pmh*.43-状态栏高()-转分辨率("50dp")) then
        --title.setTextColor(0xFFFFFFFF)
      end

    end

    import "java.io.File"
    import "android.graphics.Typeface"
    local bf=File(activity.getLuaDir().."/font/zt.otf");
    local tf=Typeface.createFromFile(bf)
    signature.setTypeface(tf);





    adapter2=LuaAdapter(activity,item)

    adapter2.add{item_img=loadbitmap("image/wallpaper/1.png")}
    adapter2.add{item_img=loadbitmap("image/wallpaper/2.png")}
    adapter2.add{item_img=loadbitmap("image/wallpaper/3.png")}

    home_page.Adapter=PageAdapter(adapter2)
    function 设置控件宽(控件,宽度)
      local linearParams = 控件.getLayoutParams()
      linearParams.width=宽度
      控件.setLayoutParams(linearParams)
    end

    home_page.addOnPageChangeListener{
      onPageScrolled=function(a,b,c)
        if a==0 and b>0 and b<1 then
          设置控件宽(huatiao_a,转分辨率("16dp")-转分辨率("8dp")*b)
          设置控件宽(huatiao_b,转分辨率("8dp")+转分辨率("8dp")*b)
         elseif a==1 and b>0 and b<1 then
          设置控件宽(huatiao_b,转分辨率("16dp")-转分辨率("8dp")*b)
          设置控件宽(huatiao_c,转分辨率("8dp")+转分辨率("8dp")*b)
         elseif a==2 and b>0 and b<1 then
          设置控件宽(huatiao_c,转分辨率("16dp")-转分辨率("8dp")*b)
          设置控件宽(huatiao_d,转分辨率("8dp")+转分辨率("8dp")*b)
        end
      end}

    myname.onClick=function()
      activity.newActivity("script/setName",{url,admin,user,password,key,isEncrypt,secret})
    end

    import "android.view.MotionEvent"

    signature.onClick=function ()
      activity.newActivity("script/setSignatrue",{url,admin,user,password,key,isEncrypt,secret})
    end

    head.onClick=function ()
      local intent= Intent(Intent.ACTION_PICK)
      intent.setType("image/*")
      this.startActivityForResult(intent, 1)
    end

    followList.onClick=function ()
      activity.newActivity("script/followList",{url,admin,user,password,key,isEncrypt,secret})
    end

    fansList.onClick=function ()
      activity.newActivity("script/fansList",{url,admin,user,password,key,isEncrypt,secret})
    end

    walletRanking.onClick=function()
      activity.newActivity("script/walletRanking",{url,admin,user,password,key,isEncrypt,secret})
    end

    --[[ goods.onClick=function()
    activity.newActivity("script/goodshome",{url,admin,user,password,key,isEncrypt,secret})
  end
]]
    --界面返回事件，res为-1修改头像，1为修改昵称，2为修改签名，3为修改密码
    --4为扣除余额，5为转账余额
    function onActivityResult(req, res, intent)
      if res==1 then
        --修改昵称返回事件
        if intent then
          local pathstr=intent.getStringExtra("newName");
          if pathstr then
            myname.setText(pathstr)
          end
        end
       elseif res==2 then
        --修改签名返回事件
        if intent then
          local pathstr=intent.getStringExtra("newSignatrue")
          if pathstr then
            signature.setText(pathstr)
          end
        end
       elseif res==3 then
        --修改密码返回事件
        if intent then
          local pathstr=intent.getStringExtra("newPassword")
          if pathstr then
            password=pathstr
          end
        end
       elseif res==4 or res==5 then
        --扣除余额返回事件
        if intent then
          local pathstr=intent.getStringExtra("newWallet")
          if pathstr then
            wallet.setText(pathstr)
          end
        end
        --修改邮箱回调事件
       elseif res==6 then
        if intent then
          local pathstr=intent.getStringExtra("newMail")
          if pathstr then
            mail.setText(pathstr)
          end
        end
        --修改性别回调事件
       elseif res==7 then
        if intent then
          local pathstr=intent.getStringExtra("newGender")
          if pathstr then
            gender.setText(pathstr)
          end
        end
        --图像选择回调事件
       elseif res==-1 and intent then
        local cursor =this.getContentResolver ().query(intent.getData(), nil, nil, nil, nil)
        cursor.moveToFirst()
        import "android.provider.MediaStore"
        local idx = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA)
        fileSrc = cursor.getString(idx)
        bit=nil
        --fileSrc回调路径路径
        import "android.graphics.BitmapFactory"
        bit =BitmapFactory.decodeFile(fileSrc)
        --图片上传
        提示("头像上传中...")
        local api=url.."main/api/user/user_set.php"
        if isEncrypt then
          codekey=Narcissus.encrypt(key)
         else
          codekey=key
        end
        local body={
          ["admin"]=admin,
          ["user"]=user,
          ["password"]=password,
          ["project"]="head",
          ["key"]=codekey
        }
        local file={
          ["file"]=fileSrc
        }
        local body,cookie,code,header=http.upload(api,body,file)
        if code==200 then
          local data=cjson.decode(body)
          提示("main105"..data.msg)
          if data.code==1 then
            head.setImageBitmap(bit)
          end
         else
          提示("main106".."Http error code:"..code)
        end
      end
    end



    -- 设置嵌套滑动处理
    setupNestedScrolling(ForumList, huadong)

    ftb_one.onTouch=function(view,event)

      a=event.getAction()&255

      switch a

       case MotionEvent.ACTION_DOWN

        缩放动画(view,{1,1.2},100)

       case MotionEvent.ACTION_MOVE

       case MotionEvent.ACTION_UP

        缩放动画(view,{1.2,1},100)

      end

      return true

    end

    ftb_two.onTouch=function(view,event)

      a=event.getAction()&255

      switch a

       case MotionEvent.ACTION_DOWN

        缩放动画(view,{1,1.2},100)

       case MotionEvent.ACTION_MOVE

       case MotionEvent.ACTION_UP

        缩放动画(view,{1.2,1},100)

      end

      return true

    end

    ftb_three.onTouch=function(view,event)

      a=event.getAction()&255

      switch a

       case MotionEvent.ACTION_DOWN

        缩放动画(view,{1,1.2},100)

       case MotionEvent.ACTION_MOVE

       case MotionEvent.ACTION_UP

        缩放动画(view,{1.2,1},100)

      end

      return true

    end

    ftb_four.onTouch=function(view,event)
      a=event.getAction()&255

      switch a
       case MotionEvent.ACTION_DOWN
        缩放动画(view,{1,1.2},100)
       case MotionEvent.ACTION_MOVE
        -- 处理 MotionEvent.ACTION_MOVE
       case MotionEvent.ACTION_UP
        activity.newActivity("script/choujianghome",{url,admin,user,password,key,isEncrypt,secret})

        缩放动画(view,{1.2,1},100)
      end

      return true
    end



    ftb_five.onTouch=function(view,event)

      a=event.getAction()&255

      switch a

       case MotionEvent.ACTION_DOWN

        缩放动画(view,{1,1.2},100)

       case MotionEvent.ACTION_MOVE

       case MotionEvent.ACTION_UP
        -- 分享逻辑
        local text = "我正在使用同学开发的PhoenixTool，集成了众多实用的功能，来一起使用吧(ฅ>ω<*ฅ)\n关注公众号STUTool即可下载哦"
        local intent = Intent(Intent.ACTION_SEND)
        intent.setType("text/plain")
        intent.putExtra(Intent.EXTRA_SUBJECT, "分享")
        intent.putExtra(Intent.EXTRA_TEXT, text)
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        activity.startActivity(Intent.createChooser(intent, "分享到:"))

        缩放动画(view,{1.2,1},100)

      end

      return true

    end

    ftb_six.onTouch=function(view,event)

      a=event.getAction()&255

      switch a

       case MotionEvent.ACTION_DOWN

        缩放动画(view,{1,1.2},100)

       case MotionEvent.ACTION_MOVE

       case MotionEvent.ACTION_UP
        activity.newActivity("script/goodshome",{url,admin,user,password,key,isEncrypt,secret})


        缩放动画(view,{1.2,1},100)

      end

      return true

    end

    ftb_seven.onTouch=function(view,event)

      a=event.getAction()&255

      switch a

       case MotionEvent.ACTION_DOWN

        缩放动画(view,{1,1.2},100)

       case MotionEvent.ACTION_MOVE

       case MotionEvent.ACTION_UP

        缩放动画(view,{1.2,1},100)

      end

      return true

    end

    ftb_eight.onTouch=function(view,event)

      a=event.getAction()&255

      switch a

       case MotionEvent.ACTION_DOWN

        缩放动画(view,{1,1.2},100)

       case MotionEvent.ACTION_MOVE

       case MotionEvent.ACTION_UP
        activity.newActivity("script/chatRoom",{url,admin,user,password,key,isEncrypt,secret})

        缩放动画(view,{1.2,1},100)

      end

      return true

    end



  end
end