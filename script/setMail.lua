require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.setMail"
import "http"
import "cjson"
import "mods.muk"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(setMail))


url,admin,user,password,key,isEncrypt,secret=...


--邮箱发送按钮事件
sendMail.onClick=function ()
  local api=url.."main/api/user/mail_code.php"
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
      提示(data.msg)
     else
      提示("Http error code:"..code)
    end
  end)
end

--修改按钮事件
setButton.onClick=function ()
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
    ["project"]="mail",
    ["mail"]=newMail.Text,
    ["code"]=codeMail.Text,
    ["key"]=codekey
  }
  Http.post(api,body,nil,nil,function (code,body)
    if code==200 then
      local data=cjson.decode(body)
      提示(data.msg)
      if data.code==1 then
        local intent=luajava.newInstance("android.content.Intent")
        intent.putExtra("newMail",newMail.Text)
        activity.setResult(6,intent)
        activity.finish()
      end
     else
      提示("Http error code:"..code)
    end
  end)
end