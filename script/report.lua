require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.report"
import "http"
import "cjson"
import "mods.muk"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(report))


url,admin,user,password,key,isEncrypt,secret=...


--举报按钮事件
reportButton.onClick=function ()
  local api=url.."main/api/user/report.php"
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
    ["content"]=content.Text,
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

--举报记录按钮事件
reportRecord.onClick=function ()
  activity.newActivity("script/reportRecord",{url,admin,user,password,key,isEncrypt,secret})
end