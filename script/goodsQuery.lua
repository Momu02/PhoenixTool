require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.goodsQuery"
import "cjson"
import "android.content.*"
import "mods.muk"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(goodsQuery))


url,admin,user,password,key,goodsId,isEncrypt,secret=...



--请求接口
local api=url.."main/api/shop/query.php"
if isEncrypt then
  codekey=Narcissus.encrypt(key)
 else
  codekey=key
end
local body={
  ["admin"]=admin,
  ["user"]=user,
  ["password"]=password,
  ["id"]=goodsId,
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
      --设置介绍
      content.setText(data.content)
      --设置价格
      money.setText(data.money)
      --设置会员价格
      discount.setText(data.discount)
      --设置发货类型
      type.setText(data.type)
      goodsType=data.type
      --设置发货数量
      num.setText(data.num)
      --设置有效时间
      time.setText(data.end_time)
      --设置商品数量
      goodsNum.setText(data.goods_num)
     else
      提示(data.msg)
    end
   else
    提示("Http error code;"..code)
  end
end)

--购买按钮事件
buyButton.onClick=function ()
  local api=url.."main/api/shop/buy.php"
  if isEncrypt then
  codekey=Narcissus.encrypt(key)
 else
  codekey=key
end
  local body={
    ["admin"]=admin,
    ["user"]=user,
    ["password"]=password,
    ["id"]=goodsId,
    ["key"]=codekey
  }
  Http.post(api,body,nil,nil,function (code,body)
    if code==200 then
      local data=cjson.decode(body)
      提示(data.msg)
      if data.code==1 then
        --判断发货类型
        if goodsType=="会员卡密" then
          dialog=AlertDialog.Builder(this)
          .setMessage("购买成功，生成卡密为:"..data.data)
          .setPositiveButton("复制",{onClick=function(v)
              activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(data.data)
            end})
          .show()dialog.create()
         elseif goodsType=="文本" then
          dialog=AlertDialog.Builder(this)
          .setMessage("购买成功，发货文本为:"..data.data)
          .setPositiveButton("复制",{onClick=function(v)
              activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(data.data)
            end})
          .show()dialog.create()
        end
        --修改商品数量
        local num=goodsNum.Text
        if tointeger(num)>0 then
          local num=num-1
          goodsNum.setText(tostring(tointeger(num)))
        end
      end
     else
      提示("Http error code;"..code)
    end
  end)
end