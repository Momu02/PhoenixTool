require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.kamihome"
import "cjson"
import "android.content.*"
import "android.provider.Settings"
import "mods.muk"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(kamihome))

url,admin,user,password,key,isEncrypt,secret=...

layoutList={
  LinearLayout;
  layout_width='fill';
  layout_height='fill';
  {
    TextView;
    id="id";
    layout_margin="10dp";
    textColor="#000000";
  }
}
--兑换按钮事件
useButton.onClick=function ()
  --获取卡密
  local kamiCode=code.Text
  if kamiCode!="" then
    --请求接口
    local api=url.."main/api/kami/use.php"
    if isEncrypt then
      codekey=Narcissus.encrypt(key)
     else
      codekey=key
    end
    local body={
      ["admin"]=admin,
      ["user"]=user,
      ["password"]=password,
      ["code"]=kamiCode,
      ["key"]=codekey
    }
    Http.post(api,body,nil,nil,function (code,body)
      if code==200 then
        local data=cjson.decode(body)
        提示(data.msg)
       else
        提示("Http error code;"..code)
      end
    end)
  end
end

-- 获取设备的IMEI的函数
function getAndroidID(context)
  local androidID = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID)
  return androidID
end

--使用IMEI卡密按钮事件
useImei.onClick=function ()
  local api=url.."main/api/kami/use_imei.php"
  imei=getAndroidID(activity)
  if isEncrypt then
    codekey=Narcissus.encrypt(key)
   else
    codekey=key
  end
  local body={
    ["admin"]=admin,
    ["code"]=imeiCode.Text,
    ["key"]=codekey,
    ["imei"]=imei
  }

  Http.post(api,body,nil,nil,function (code,body)
    if code==200 then
      local data=cjson.decode(body)
      提示(data.msg)
      if data.code==1 then
        --这里写使用成功后的代码
      end
     else
      提示("Http error code:"..code)
    end
  end)
end