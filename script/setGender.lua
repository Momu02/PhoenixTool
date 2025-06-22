require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.setGender"
import "http"
import "cjson"
import "mods.muk"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(setGender))


url,admin,user,password,key,isEncrypt,secret=...


--男单选框事件
boy.onClick=function ()
  gender=0
  girl.setChecked(false)
end

--女单选框事件
girl.onClick=function ()
  gender=1
  boy.setChecked(false)
end

--修改按钮事件
setButton.onClick=function ()
  --判断是否选择
  if not gender then
    提示("请选择性别")
   else
    if isEncrypt then
      codekey=Narcissus.encrypt(key)
     else
      codekey=key
    end
    local api=url.."main/api/user/user_set.php"
    local body={
      ["admin"]=admin,
      ["user"]=user,
      ["password"]=password,
      ["project"]="gender",
      ["gender"]=tostring(gender),
      ["key"]=codekey
    }
    Http.post(api,body,nil,nil,function (code,body)
      if code==200 then
        local data=cjson.decode(body)
        提示(data.msg)
        if data.code==1 then
          if gender==0 then
            nowGender="男"
           else
            nowGender="女"
          end
          local intent=luajava.newInstance("android.content.Intent")
          intent.putExtra("newGender",nowGender)
          activity.setResult(7,intent)
          activity.finish()
        end
       else
        提示("Http error code:"..code)
      end
    end)
  end
end