require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.adminAdd"
import "cjson"
import "android.content.Intent"
import "mods.muk"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(adminAdd))



url,admin,user,password,key,plateId,isEncrypt,secret=...


--添加按钮事件
addButton.onClick=function ()
  local addUser=addUser.Text
  if addUser=="" then
    提示("不能为空")
   else
    local api=url.."main/api/forum/admin_add.php"
    if isEncrypt then
      codekey=Narcissus.encrypt(key)
     else
      codekey=key
    end
    local body={
      ["admin"]=admin,
      ["user"]=user,
      ["password"]=password,
      ["to_user"]=addUser,
      ["id"]=plateId,
      ["key"]=codekey
    }
    Http.post(api,body,nil,nil,function (code,body)
      if code==200 then
        local data=cjson.decode(body)
        提示("main107"..data.msg)
        if data.code==1 then
          local intent=luajava.newInstance("android.content.Intent")
          intent.putExtra("set","1")
          activity.setResult(1,intent)
          activity.finish()
        end
       else
        提示("main108".."Http error code:"..code)
      end
    end)
  end
end