require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.transfer"
import "http"
import "cjson"
import "mods.muk"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(transfer))


url,admin,user,password,key,walletNum,isEncrypt,secret=...


--修改按钮事件
setButton.onClick=function ()
  local api=url.."main/api/user/user_transfer.php"
  if isEncrypt then
    key=Narcissus.encrypt(key)
   else
    key=key
  end
  local body={
    ["admin"]=admin,
    ["user"]=user,
    ["password"]=password,
    ["to_user"]=toUser.Text,
    ["num"]=num.Text,
    ["key"]=codekey
  }
  Http.post(api,body,nil,nil,function (code,body)
    if code==200 then
      local data=cjson.decode(body)
      提示(data.msg)
      if data.code==1 then
        local intent=luajava.newInstance("android.content.Intent")
        local nums=num.Text
        local nowWallet=walletNum-nums;
        intent.putExtra("newWallet",tostring(tointeger(nowWallet)))
        activity.setResult(5,intent)
        activity.finish()
      end
     else
      提示("Http error code:"..code)
    end
  end)
end