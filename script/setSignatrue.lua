require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.setSignatrue"
import "http"
import "cjson"
import "mods.muk"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(setSignatrue))

url,admin,user,password,key,isEncrypt,secret=...


--修改按钮事件
setButton.onClick=function ()
  local api=url.."main/api/user/user_set.php"
  if isEncrypt then
    codekey=Narcissus.encrypt(key)
   else
    codekey=key
  end local body={
    ["admin"]=admin,
    ["user"]=user,
    ["password"]=password,
    ["project"]="signatrue",
    ["signatrue"]=signatrue.Text,
    ["key"]=codekey
  }
  Http.post(api,body,nil,nil,function (code,body)
    if code==200 then
      local data=cjson.decode(body)
      提示(data.msg)
      if data.code==1 then
        local intent=luajava.newInstance("android.content.Intent")
        intent.putExtra("newSignatrue",signatrue.Text)
        activity.setResult(2,intent)
        activity.finish()
      end
     else
      提示("Http error code:"..code)
    end
  end)
end