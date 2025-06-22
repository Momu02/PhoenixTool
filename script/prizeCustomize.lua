require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.prizeCustomize"
import "cjson"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(prizeCustomize))


url,admin,user,password,key,prizeType,id,isEncrypt,secret=...


--发送请求
local api=url.."main/api/prize/prize_query.php"
if isEncrypt then
  codekey=Narcissus.encrypt(key)
 else
  codekey=key
end
local body={
  ["admin"]=admin,
  ["user"]=user,
  ["password"]=password,
  ["type"]=prizeType,
  ["style"]="text",
  ["id"]=id,
  ["key"]=codekey
}
Http.post(api,body,nil,nil,function (code,body)
  if code==200 then
    local data=cjson.decode(body)
    if data.code==1 then
      --截取数据
      local data=data.data
      --设置名称
      name.setText(data.name)
      --设置价格
      money.setText(data.money)
      --设置奖品
      prize.setText(data.prize)
     else
      print(data.msg)
    end
   else
    print("Http error code:"..code)
  end
end)

--抽奖按钮事件
prizeUse.onClick=function ()
  --发送请求
  local api=url.."main/api/prize/prize_use.php"
  if isEncrypt then
    codekey=Narcissus.encrypt(key)
   else
    codekey=key
  end
  local body={
    ["admin"]=admin,
    ["user"]=user,
    ["password"]=password,
    ["type"]=prizeType,
    ["id"]=id,
    ["key"]=codekey
  }
  Http.post(api,body,nil,nil,function (code,body)
    if code==200 then
      local data=cjson.decode(body)
      dialog=AlertDialog.Builder(this)
      .setTitle("")
      .setMessage(data.msg)
      .setPositiveButton("确定",{onClick=function(v)
        end})
      .show()dialog.create()
     else
      print("Http error code:"..code)
    end
  end)
end