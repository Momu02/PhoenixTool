require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.userData"
import "http"
import "cjson"
import "mods.muk"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(userData))


url,admin,user,password,key,isEncrypt,secret=...



--查询按钮事件
query.onClick=function ()
  local api=url.."main/api/user/user_data.php"
  if isEncrypt then
    codekey=Narcissus.encrypt(key)
   else
    codekey=key
  end
  local body={
    ["admin"]=admin,
    ["user"]=user,
    ["password"]=password,
    ["to_user"]=toUser.Text,--账号
    ["key"]=codekey
  }
  Http.post(api,body,nil,nil,function (code,body)
    if code==200 then
      local data=cjson.decode(body)
      if data.code==1 then
        local data=data.data
        --设置头像
        head.setImageBitmap(loadbitmap(data.head))
        --设置昵称
        name.setText(data.name)
        --设置会员状态
        vip.setText(data.vip_state)
        --设置签名
        signatrue.setText(data.signatrue)
        --设置封禁
        ban.setText(tostring(tointeger(data.ban)))
        --设置称号
        title.setText(data.title)
        --设置关注
        follow.setText(tostring(tointeger(data.follow)))
        --设置粉丝
        fans.setText(tostring(tointeger(data.fans)))
        --设置关注状态
        if tointeger(data.follow_state)==1 then
          followState.setText("已关注")
         else
          followState.setText("未关注")
        end
       else
        提示(data.msg)
      end
     else
      提示("Http error code:"..code)
    end
  end)
end

--关注按钮事件
followUser.onClick=function ()
  local api=url.."main/api/user/follow.php"
  if isEncrypt then
    codekey=Narcissus.encrypt(key)
   else
    codekey=key
  end
  local body={
    ["admin"]=admin,
    ["user"]=user,
    ["password"]=password,
    ["to_user"]=toUser.Text,--账号
    ["key"]=codekey
  }

  Http.post(api,body,nil,nil,function (code,body)
    if code==200 then
      local data=cjson.decode(body)
      提示(data.msg)
      if data.code==1 then
        local followNum=tointeger(follow.Text)
        followNum=followNum+1
        follow.setText(tostring(followNum))
        followUser.setText("已关注")
      end
     else
      提示("Http error code:"..code)
    end
  end)
end

--取消关注按钮事件
followDelete.onClick=function ()
  local api=url.."main/api/user/follow_delete.php"
  if isEncrypt then
    codekey=Narcissus.encrypt(key)
   else
    codekey=key
  end
  local body={
    ["admin"]=admin,
    ["user"]=user,
    ["password"]=password,
    ["to_user"]=toUser.Text,
    ["key"]=codekey
  }

  Http.post(api,body,nil,nil,function (code,body)
    if code==200 then
      local data=cjson.decode(body)
      提示(data.msg)
      if data.code==1 then
        local followNum=tointeger(follow.Text)
        followNum=followNum-1
        follow.setText(tostring(followNum))
        followUser.setText("关注")
      end
     else
      提示("Http error code:"..code)
    end
  end)
end