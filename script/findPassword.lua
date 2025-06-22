require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.findPassword"
import "http"
import "cjson"
import "mods.muk"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(findPassword))


url,admin,key,isEncrypt,secret=...

--按钮事件
sendMail.onClick=function ()
  --获取编辑框账号
  local user=user.Text
  --声明找回密码接口
  local api=url.."main/api/user/find_password.php"
  --请求体
  if isEncrypt then
    codekey=Narcissus.encrypt(key)
   else
    codekey=key
  end
  local body={
    ["admin"]=admin,
    ["user"]=user,
    ["key"]=codekey
  }
  Http.post(api,body,nil,nil,function (code,body)
    if code==200 then
      --解析JSON
      local data=cjson.decode(body)
      提示("main120"..data.msg)
     else
      --请求失败
      提示("main121".."Http error code:"..code)
    end
  end)
end