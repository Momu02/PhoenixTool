require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.checkQuery"
import "cjson"
import "android.content.Intent"
import "android.view.animation.TranslateAnimation"
import "android.content.*"
import "android.view.inputmethod.InputMethodManager"
import "mods.muk"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(checkQuery))

title.getPaint().setFakeBoldText(true)
exit.getPaint().setFakeBoldText(true)
forumTitle.getPaint().setFakeBoldText(true)

url,admin,user,password,key,forumId,isEncrypt,secret=...



--返回按钮事件
exit.onClick=function ()
  activity.finish()
end

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
Http.post(api,body,nil,nil,function (code,body)
  if code==200 then
    local data=cjson.decode(body)
    if data.code==1 then
      --截取数据
      local data=data.data
      --设置头像
      head.setImageBitmap(loadbitmap(data.head))
      --设置昵称
      name.setText(data.name)
      --设置标题
      forumTitle.setText(data.title)
      --设置内容
      forumContent.setText(data.content)
      --设置图片1
      img1.setImageBitmap(loadbitmap(data.image_1))
      --设置图片2
      img2.setImageBitmap(loadbitmap(data.image_2))
      --设置图片3
     else
      提示("main112"..data.msg)
    end
   else
    提示("main113".."Http error code:"..code)
  end
end)

--帖子删除按钮事件
forumDelete.onClick=function ()
  dialog=AlertDialog.Builder(this)
  .setMessage("确定要删除该帖子吗")
  .setPositiveButton("删除",{onClick=function(v)
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
          提示("main114"..data.msg)
          if data.code==1 then
            local intent=luajava.newInstance("android.content.Intent")
            intent.putExtra("set","1")
            activity.setResult(1,intent)
            activity.finish()
          end
         else
          提示("main115".."Http error code:"..code)
        end
      end)
    end})
  .setNeutralButton("取消",nil)
  .show()dialog.create()
end

--帖子审核通过事件
checkOperate.onClick=function ()
  dialog=AlertDialog.Builder(this)
  .setMessage("确定通过该帖子吗")
  .setPositiveButton("确定",{onClick=function(v)
      local api=url.."main/api/forum/check.php"
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
          提示("main116"..data.msg)
          if data.code==1 then
            local intent=luajava.newInstance("android.content.Intent")
            intent.putExtra("set","2")
            activity.setResult(1,intent)
            activity.finish()
          end
         else
          提示("main117".."Http error code:"..code)
        end
      end)
    end})
  .setNeutralButton("取消",nil)
  .show()dialog.create()
end