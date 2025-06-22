require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.prizeQuery"
import "cjson"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(prizeQuery))


url,admin,user,password,key,prizeType,id,isEncrypt,secret=...

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
  ["id"]=id,
  ["key"]=codekey
}
Http.post(api,body,nil,nil,function (code,body)
  if code==200 then
    local data=cjson.decode(body)
    if data.code==1 then
      --截取数据
      local data=data.data
      if prizeType=="会员" then
        maxNum=data.max..data.unit
        minNum=data.min..data.unit
       else
        maxNum=data.max
        minNum=data.min
      end
      --设置名称
      name.setText(data.name)
      --设置价格
      money.setText(data.money)
      --设置最大获得
      max.setText(maxNum)
      --设置最小获得
      min.setText(minNum)
      --设置概率
      chance.setText(tostring(data.chance))
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