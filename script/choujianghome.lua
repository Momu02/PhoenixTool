require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.choujianghome"
import "android.graphics.BitmapFactory"
import "android.content.Intent"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(choujianghome))

url,admin,user,password,key,isEncrypt,secret=...

--按钮事件
function moneyPrize()
  prize("积分")
end

function vipPrize()
  prize("会员")
end

function customizePrize()
  prize("自定义")
end

function prize(prizeType)
  activity.newActivity("script/prize",{url,admin,user,password,key,prizeType,isEncrypt,secret})
end