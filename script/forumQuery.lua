require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import 'us.feras.mdv.MarkdownView'
import "page.forum_layout.forumQuery"
import "cjson"
import "android.content.Intent"
import "android.view.animation.TranslateAnimation"
import "android.content.*"
import "android.view.inputmethod.InputMethodManager"
import "com.narcissus.encrypt.*"
dialog= ProgressDialog.show(this,nil, "加载中..",false, false).hide()
dialog.show()

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(forumQuery))

title.getPaint().setFakeBoldText(true)
exit.getPaint().setFakeBoldText(true)
forumTitle.getPaint().setFakeBoldText(true)

url,admin,user,password,key,forumId,isEncrypt,secret=...


--返回按钮事件
exit.onClick=function ()
  activity.finish()
end

--绑定回复布局事件，防误触
answerSpaceBottom.onClick=function ()
end

activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN)

--获取帖子详情内容
local api=url.."main/api/forum/forum_query.php"
if isEncrypt then
  codekey=Narcissus.encrypt(key)
 else
  codekey=key
end
local body={
  ["admin"]=admin,
  ["user"]=user,
  ["password"]=password,
  ["id"]=forumId,
  ["key"]=codekey
}

currentImage1 = ""
currentImage2 = ""
currentImage3 = ""

Http.post(api,body,nil,nil,function (code,body)
  if code==200 then
    local data=cjson.decode(body)
    if data.code==1 then
      --截取数据
      local data=data.data
      forumContenttext=data.content
      isTop=tointeger(data.top)
      --设置头像
      head.setImageBitmap(loadbitmap(data.head))
      --设置账号
      usersss0=data.user
      --设置昵称
      name.setText(data.name)
      --设置标题
      forumTitle.setText(data.title)
      --设置内容
      forumContent.loadMarkdown([[
<style type="text/css">
    /* 利用通配符选择器设置所有元素文字颜色 */
    * {
        color: ]]..textc..";} </style>"..forumContenttext)
      --设置图片1
      img1.setImageBitmap(loadbitmap(data.image_1))
      currentImage1 = data.image_1
      --设置图片2
      img2.setImageBitmap(loadbitmap(data.image_2))
      currentImage2 = data.image_2
      --设置图片3
      img3.setImageBitmap(loadbitmap(data.image_3))
      currentImage3 = data.image_3
      --设置浏览量
      watch.setText(tostring(tointeger(data.watch)))
      --设置点赞量
      praise.setText(tostring(tointeger(data.praise)))
      --设置评论量
      comment.setText(tostring(tointeger(data.comment)))
      --设置置顶状态
      --判断是不是管理员
      if usersss0 ==admin then
        topText.setVisibility(View.VISIBLE)
      end
      if tointeger(data.top)==1 then
        top.setVisibility(View.VISIBLE)
        topText.setText("取消置顶")
      end
      --判断是不是自己的帖子
      if usersss0 ==user then
        forumDelete.setVisibility(View.VISIBLE)
      end
      dialog.dismiss()
     else
      提示("130"..data.msg)
    end
   else
    提示("131Http error code:"..code)
  end
end)

帖主主页.onClick=function()
  --跳转他人主页
  activity.newActivity("script/otherhome",{url,admin,user,password,key,isEncrypt,secret,usersss0})
end

--图片点击事件
img1.onClick=function()
  utw_img(currentImage1)
end
img2.onClick=function()
  utw_img(currentImage2)
end
img3.onClick=function()
  utw_img(currentImage3)
end



--点赞按钮事件
praiseButton.onClick=function ()
  local api=url.."main/api/forum/forum_praise.php"
  if isEncrypt then
    codekey=Narcissus.encrypt(key)
   else
    codekey=key
  end
  local body={
    ["admin"]=admin,
    ["user"]=user,
    ["password"]=password,
    ["id"]=forumId,
    ["key"]=codekey
  }
  Http.post(api,body,nil,nil,function (code,body)
    if code==200 then
      local data=cjson.decode(body)
      提示(data.msg)
      --获取当前点赞数
      local praiseNum=praise.Text
      if data.msg=="点赞成功" then
        --点赞数量+1
        local praiseNum=praiseNum+1;
        praise.setText(tostring(tointeger(praiseNum)))
       elseif data.msg=="已取消点赞" then
        --点赞数量-1
        local praiseNum=praiseNum-1
        praise.setText(tostring(tointeger(praiseNum)))
      end
     else
      提示("Http error code:"..code)
    end
  end)
end

forumCopy.onClick=function()
  复制文本(forumContenttext)
end

--帖子删除事件
forumDelete.onClick=function ()
  dialog=AlertDialog.Builder(this)
  .setMessage("确定要删除该帖子吗")
  .setPositiveButton("删除",{onClick=function(v)
      --帖子删除按钮事件
      local api=url.."main/api/forum/forum_delete.php"
      if isEncrypt then
        codekey=Narcissus.encrypt(key)
       else
        codekey=key
      end
      local body={
        ["admin"]=admin,
        ["user"]=user,
        ["password"]=password,
        ["id"]=forumId,
        ["key"]=codekey
      }
      Http.post(api,body,nil,nil,function (code,body)
        if code==200 then
          local data=cjson.decode(body)
          提示(data.msg)
          if data.code==1 then
            local intent=luajava.newInstance("android.content.Intent")
            intent.putExtra("set","1")
            activity.setResult(1,intent)
            activity.finish()
          end
         else
          提示("Http error code:"..code)
        end
      end)
    end})
  .setNeutralButton("取消",nil)
  .show()dialog.create()
end

--评论分页数
num=0

--评论列表布局
layoutList={
  LinearLayout;
  layout_width="fill";
  layout_height="fill";
  id="space";
  {
    LinearLayout;
    layout_width="match_parent";
    layout_marginTop="10dp";
    {
      CardView;
      radius="20dp";
      layout_width="40dp";
      CardElevation="0dp";
      id="个人主页";
      layout_height="40dp";
      layout_marginLeft="10dp";
      {
        ImageView;
        layout_height="match_parent";
        scaleType="centerCrop";
        id="head";
        layout_width="match_parent";
      };
    };
    {
      LinearLayout;
      orientation="vertical";
      layout_marginRight="10dp";
      layout_marginLeft="5dp";
      {
        TextView;
        textSize="16sp";
        textColor=textc;
        id="name";
        text="name";
      };
      {
        TextView;
        textColor=textc;
        id="content";
        text="content";
      };
      {
        TextView;
        textSize="13sp";
        text="time";
        textColor=textc;
        id="time";
      };
      {
        LinearLayout;
        {
          TextView;
          textColor=textc;
          id="answer";
          text="answer";
        };
        {
          TextView;
          id="commentDelete";
          layout_marginLeft="10dp";
          textColor="#FF0000";
        };
      };
      {
        TextView;
        visibility=8;
        id="commentId";
      };
      {
        TextView;

        visibility=8;

        id="usersss";

      };
    };
  };
};

--回复列表布局
layoutAnswer={
  LinearLayout;
  layout_height="fill";
  layout_width="fill";
  {
    LinearLayout;
    id="space";
    layout_width="match_parent";
    layout_marginTop="10dp";
    {
      CardView;
      CardElevation="0dp";
      radius="20dp";
      id="个人主页2";
      layout_marginLeft="10dp";
      layout_width="40dp";
      layout_height="40dp";
      {
        ImageView;
        id="head";
        scaleType="centerCrop";
        layout_height="match_parent";
        layout_width="match_parent";
      };
    };
    {
      LinearLayout;
      layout_marginLeft="5dp";
      layout_marginRight="10dp";
      orientation="vertical";
      {
        LinearLayout;
        {
          TextView;
          id="name";
          textSize="16sp";
          textColor=textc;
          text="name";
        };
        {
          TextView;
          text="ps";
          textColor=textc;
          layout_marginLeft="10dp";
          textSize="16sp";
          id="ps";
        };
      };
      {
        TextView;
        text="content";
        textColor=textc;
        id="content";
      };
      {
        TextView;
        text="time";
        textColor=textc;
        textSize="13sp";
        id="time";
      };
      {
        LinearLayout;
        {
          TextView;
          id="answerDelete";
          textColor="#FF0000";
          layout_marginLeft="10dp";
        };
      };
      {
        TextView;
        id="answerId";
        visibility=8;
      };
      {
        TextView;

        visibility=8;

        id="usersss2";

      };
    };
  };
};

--声明列表加载函数，num参数为分页数，new参数为是否继续加载列表，true为是，false为重新加载
function loadList(num, new)
  if new == false then
    adp = nil
    adp = LuaAdapter(activity, layoutList)
  end
  --声明接口
  local api = url .. "main/api/forum/comment_list.php"
  --请求体
  if isEncrypt then
    codekey = Narcissus.encrypt(key)
   else
    codekey = key
  end
  local body = {
    ["admin"] = admin,
    ["user"] = user,
    ["password"] = password,
    ["num"] = tostring(num),
    ["id"] = forumId,
    ["key"] = codekey
  }
  Http.post(api, body, nil, nil, function (code, body)
    if code == 200 then
      --请求成功，解析JSON数据
      local data = cjson.decode(body)
      --判断状态码是否为1
      if data.code == 1 then
        --成功，截取列表数据
        local data = data.data
        --判断有多少组JSON数据
        if #data ~= 0 then
          --如果不为0，显示列表
          list.setVisibility(View.VISIBLE)

          --如果为10，重置newList变量，允许分页加载，这是因为水仙的分页加载为10个列表项
          if #data == 10 then
            newList = nil
          end

          --遍历JSON
          for i, v in ipairs(data) do
            --截取单个列表项
            local item = data[i]
            --判断回复数量
            local answer = ""
            if item.answer ~= 0 then
              local answerNum = tostring(tointeger(item.answer))
              answer = "展开" .. answerNum .. "条回复"
            end
            --判断是不是自己的评论
            local commentDelete = item.user == user and "删除" or nil
            --添加列表数据
            adp.add{
              head = item.head,
              name = item.name,
              usersss = item.user,
              content = item.content,
              time = item.time,
              answer = answer,
              commentId = item.id,
              commentDelete = commentDelete
            }
          end

          --如果new为true，则刷新列表
          if new then
            adp.notifyDataSetChanged()
           else
            --否则重新加载列表
            list.Adapter = adp
          end
         else
          --如果为0，修改newList变量，禁止分页加载
          newList = 0
          if new == false then
            list.setVisibility(View.GONE)
          end
        end
       else
        --失败
        提示("131" .. data.msg)
      end
     else
      --请求失败
      提示("Http error code:" .. code)
    end
  end)
end


--声明回复列表加载函数，num参数为分页数，new参数为是否继续加载列表，true为是，false为重新加载
function loadAnswer(num,new)
  if new==false then
    adpAnswer=nil
    adpAnswer=LuaAdapter(activity,layoutAnswer)
  end
  --声明接口
  local api=url.."main/api/forum/answer_list.php"
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
    ["num"]=tostring(num),
    ["id"]=commentId,
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
          --如果不为0，显示列表
          answerList.setVisibility(View.VISIBLE)

          --如果为10，重置newListAnswer变量，允许分页加载，这是因为水仙的分页加载为10个列表项
          if #data==10 then
            newListAnswer=nil
          end

          --遍历JSON
          for i,v in ipairs(data) do
            --截取单个列表项
            local item=data[i]

            --判断是不是自己的评论
            if item.user ==user then
              --添加列表数据
              adpAnswer.add{
                head=item.head,
                usersss2=item.user,
                name=item.name,
                content=item.content,
                time=item.time,
                answerId=item.id,
                ps=item.text,
                answerDelete="删除"
              }

             else
              --添加列表数据
              adpAnswer.add{
                head=item.head,
                name=item.name,
                usersss=item.user,
                content=item.content,
                time=item.time,
                answerId=item.id,
                ps=item.text
              }

            end

          end

          --如果new为true，则刷新列表
          if new then
            adpAnswer.notifyDataSetChanged()
           else
            --否则重新加载列表
            answerList.Adapter=adpAnswer
          end
         else
          --如果为0，修改newList变量，禁止分页加载
          newListAnswer=0
          if new==false then
            answerList.setVisibility(View.GONE)
          end
        end
       else
        --失败
        提示(data.msg)
      end
     else
      --请求失败
      提示("Http error code:"..code)
    end
  end)
end

--调用loadList函数
loadList(num,false)

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
        loadList(num,true)
      end
    end
  end}

--弹出键盘函数
function openKeyboard(id)
  srfa = id.getContext().getSystemService(Context.INPUT_METHOD_SERVICE)
  srfa.toggleSoftInput(0,InputMethodManager.HIDE_NOT_ALWAYS)
  local jiaodian=id--设置焦点到编辑框
  jiaodian.setFocusable(true)
  jiaodian.setFocusableInTouchMode(true)
  jiaodian.requestFocus()
  jiaodian.requestFocusFromTouch()
end


--列表点击事件
list.onItemClick = function(parent, v, pos, id)
  --获取评论id
  commentId = v.Tag.commentId.Text
  usersss = v.Tag.usersss.Text
  --user = v.Tag.my
  v.Tag.个人主页.onClick = function()
    --跳转他人主页
    --获取评论用户昵称
    activity.newActivity("script/otherhome", {url, admin, user, password, key, isEncrypt, secret, usersss})
  end

  --删除评论事件
  v.Tag.commentDelete.onClick=function ()
    dialog=AlertDialog.Builder(this)
    .setMessage("确定要删除该评论吗")
    .setPositiveButton("删除",{onClick=function(v)
        --请求接口
        local api=url.."main/api/forum/comment_delete.php"
        if isEncrypt then
          codekey=Narcissus.encrypt(key)
         else
          codekey=key
        end
        local body={
          ["admin"]=admin,
          ["user"]=user,
          ["password"]=password,
          ["id"]=commentId,
          ["key"]=codekey
        }
        Http.post(api,body,nil,nil,function (code,body)
          if code==200 then
            local data=cjson.decode(body)
            提示(data.msg)
            if data.code==1 then
              --删除成功，刷新评论
              num=0
              loadList(num,false)
            end
           else
            提示("Http error code:"..code)
          end
        end)
      end})
    .setNeutralButton("取消",nil)
    .show()dialog.create()
  end

  --展开回复事件
  v.Tag.answer.onClick=function ()
    --设置评论模式，改为回复类型
    commentType="answer"
    --设置回复类型为comment
    sendType="comment"
    --修改编辑框提示内容
    commentContent.setHint("回复评论")
    --获取评论ID
    commentId=v.Tag.commentId.Text
    --显示布局
    answerSpace.setVisibility(View.VISIBLE)
    --触发平移动画
    translation=TranslateAnimation(0, 0, 1500, 0)
    translation.setDuration(300)
    translation.setRepeatCount(0)
    --绑定动画
    answerSpaceBottom.startAnimation(translation)
    --回复分页数
    answerNums=0
    --调用加载回复函数
    loadAnswer(answerNums,false)
  end



  --点击评论回复事件
  v.Tag.space.onClick=function ()
    --回复遮罩可视
    answerLayout.setVisibility(View.VISIBLE)
    --获取评论用户昵称
    local name=v.Tag.name.Text
    --设置评论模式，改为回复类型
    commentType="answer"
    commentContent.setHint("回复"..name)
    --设置回复类型为comment
    sendType="comment"
    --设置评论输入框焦点，弹出键盘
    openKeyboard(commentContent)
  end
end

-- 隐藏回复布局函数
function answerSpaceGone()
  -- 设置评论模式，恢复评论类型
  commentType = nil
  commentContent.setHint("评论内容")
  -- 销毁回复类型
  sendType = nil

  -- 触发平移动画
  local translation = TranslateAnimation(0, 0, 0, 1500)
  translation.setDuration(300)
  translation.setRepeatCount(0)

  -- 创建动画监听器
  local animationListener = {
    onAnimationEnd = function(animation)
      -- 动画播放完毕后隐藏视图
      answerSpace.setVisibility(View.GONE)
    end,
    onAnimationStart = function(animation) end,
    onAnimationRepeat = function(animation) end
  }

  -- 绑定动画监听器
  translation.setAnimationListener(animationListener)

  -- 开始动画
  answerSpaceBottom.startAnimation(translation)
end


--绑定回复布局空白处以及打叉按钮事件
answerSpace.onClick=function ()
  answerSpaceGone()
end
answerExit.onClick=function ()
  answerSpaceGone()
end

--回复遮罩隐藏事件
answerLayout.onClick=function ()
  --设置评论类型，恢复评论模式
  commentType=nil
  commentContent.setHint("评论内容")
  --销毁回复类型
  sendType=nil
  --隐藏遮罩
  answerLayout.setVisibility(View.GONE)
end

--回复列表点击事件
answerList.onItemClick=function(parent,v,pos,id)
  --获取回复id
  local answerId=v.Tag.answerId.Text
  local usersss2=v.Tag.usersss2.Text
  --user=v.Tag.my
  v.Tag.个人主页2.onClick=function()
    --跳转他人主页
    --获取评论用户昵称
    activity.newActivity("script/otherhome",{url,admin,user,password,key,isEncrypt,secret,usersss})
  end

  --删除回复事件
  v.Tag.answerDelete.onClick=function ()
    dialog=AlertDialog.Builder(this)
    .setMessage("确定要删除该回复吗")
    .setPositiveButton("删除",{onClick=function(v)
        --请求接口
        local api=url.."main/api/forum/answer_delete.php"
        if isEncrypt then
          codekey=Narcissus.encrypt(key)
         else
          codekey=key
        end
        local body={
          ["admin"]=admin,
          ["user"]=user,
          ["password"]=password,
          ["id"]=answerId,
          ["key"]=codekey
        }
        Http.post(api,body,nil,nil,function (code,body)
          if code==200 then
            local data=cjson.decode(body)
            提示(data.msg)
            if data.code==1 then
              --删除成功，刷新回复
              answerNums=0
              loadAnswer(answerNums,false)
            end
           else
            提示("Http error code:"..code)
          end
        end)
      end})
    .setNeutralButton("取消",nil)
    .show()dialog.create()
  end

  --点击回复继续回复事件
  v.Tag.space.onClick=function ()
    --回复遮罩2可视
    answerLayout2.setVisibility(View.VISIBLE)
    --获取回复用户昵称
    local name=v.Tag.name.Text
    --设置评论模式，改为回复类型
    commentType="answer"
    commentContent.setHint("回复"..name)
    --设置回复类型为answer
    sendType="answer"
    --设置评论输入框焦点，弹出键盘
    openKeyboard(commentContent)
  end
end

--回复遮罩2隐藏事件
answerLayout2.onClick=function ()
  --重置提示内容
  commentContent.setHint("回复评论")
  --重置回复类型
  sendType="comment"
  --隐藏遮罩
  answerLayout2.setVisibility(View.GONE)
end


--评论函数，content为内容
function commentSend(content)
  local api=url.."main/api/forum/comment.php"
  if isEncrypt then
    codekey=Narcissus.encrypt(key)
   else
    codekey=key
  end
  local body={
    ["admin"]=admin,
    ["user"]=user,
    ["password"]=password,
    ["id"]=forumId,
    ["content"]=content,
    ["key"]=codekey
  }
  Http.post(api,body,nil,nil,function (code,body)
    if code==200 then
      local data=cjson.decode(body)
      提示(data.msg)
      if data.code==1 then
        --评论成功，清除编辑框内容
        commentContent.setText("")
        --刷新评论
        num=0
        loadList(num,false)
      end
     else
      提示("Http error code:"..code)
    end
  end)
end

--回复函数，content为回复内容
function answerSend(content)
  --判断回复类型
  if sendType=="comment" then
    --设置id为评论id
    id=commentId
   elseif sendType=="answer" then
    --设置id为回复id
    id=answerId
  end
  local api=url.."main/api/forum/answer.php"
  if isEncrypt then
    codekey=Narcissus.encrypt(key)
   else
    codekey=key
  end
  local body={
    ["admin"]=admin,
    ["user"]=user,
    ["password"]=password,
    ["id"]=id,
    ["content"]=content,
    ["type"]=sendType,
    ["key"]=codekey
  }
  Http.post(api,body,nil,nil,function (code,body)
    if code==200 then
      local data=cjson.decode(body)
      提示(data.msg)
      if data.code==1 then
        --回复成功，清除编辑框内容
        commentContent.setText("")
        --判断回复布局是否为可见
        if answerSpace.Visibility==8 then
          --不可见，隐藏回复遮罩
          answerLayout.setVisibility(View.GONE)
          --重置提示内容
          commentContent.setHint("评论内容")
          --重置评论模式
          commentType=nil
          --重置回复类型
          sendType=nil
          --刷新评论
          num=0
          loadList(num,false)
         else
          --可见，隐藏回复遮罩2
          answerLayout2.setVisibility(View.GONE)
          --重置提示内容
          commentContent.setHint("回复评论")
          --重置回复类型
          sendType="comment"
          --刷新回复
          answerNums=0
          loadAnswer(answerNums,false)
        end
      end
     else
      提示("Http error code:"..code)
    end
  end)
end

--[[commentContent.addTextChangedListener({
  onTextChanged=function()
    linearParams = replyExpansion.getLayoutParams()
    linearParams.height =linearParams+dp2px(10)
    replyExpansion.setLayoutParams(linearParams)
  end
})]]

commentButton.onClick=function ()
  --获取内容
  local content=commentContent.Text
  --判断是否为空
  if content!="" then
    --判断评论类型
    if commentType=="answer" then
      --类型为回复时
      answerSend(content)
     else
      --类型为评论时
      commentSend(content)
    end
  end
end

--置顶帖子按钮事件
forumTop.onClick=function ()
  if isTop==1 then
    mess="确定要取消置顶？"
    button="取消置顶"
   else
    mess="确定要置顶帖子？"
    button="置顶"
  end
  dialog=AlertDialog.Builder(this)
  .setMessage(mess)
  .setPositiveButton(button,{onClick=function(v)
      --请求接口
      local api=url.."main/api/forum/top.php"
      if isEncrypt then
        codekey=Narcissus.encrypt(key)
       else
        codekey=key
      end
      local body={
        ["admin"]=admin,
        ["user"]=user,
        ["password"]=password,
        ["id"]=forumId,
        ["key"]=codekey
      }
      Http.post(api,body,nil,nil,function (code,body)
        if code==200 then
          local data=cjson.decode(body)
          提示(data.msg)
          if data.code==1 then
            if data.msg=="置顶成功" then
              top.setVisibility(View.VISIBLE)
              topText.setText("取消置顶")
              isTop=1
             else
              top.setVisibility(View.GONE)
              topText.setText("置顶")
              isTop=0
            end
            local intent=luajava.newInstance("android.content.Intent")
            intent.putExtra("set","1")
            activity.setResult(1,intent)
          end
         else
          提示("Http error code:"..code)
        end
      end)
    end})
  .setNeutralButton("取消",nil)
  .show()dialog.create()
end