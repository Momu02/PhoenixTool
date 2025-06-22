require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "page.forum_layout.selfhome"
import "http"
import "cjson"
import "android.graphics.BitmapFactory"
import "android.content.Intent"
import "mods.muk"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(selfhome))


url,admin,user,password,key,isEncrypt,secret=...


--声明main函数
function main()
  --声明接口
  local api=url.."main/api/user/user_data.php"
  --请求体
  if isEncrypt then
    codekey=Narcissus.encrypt(key)
   else
    codekey=key
  end
  local body={
    ["admin"]=admin,
    ["user"]=user,
    ["password"]=password,
    ["key"]=codekey
  }
  Http.post(api,body,nil,nil,function (code,body)
    if code==200 then
      local data=cjson.decode(body)
      --判断是否获取成功
      if data.code==1 then
        --截取数据
        local data=data.data
        --设置头像
        head.setImageBitmap(loadbitmap(data.head))
        --设置昵称
        name.setText(data.name)
        --设置余额
        wallet.setText(data.wallet)
        --设置会员状态
        vip.setText(data.vip_state)
        --设置签名
        signatrue.setText(data.signatrue)
        --设置封禁
        ban.setText(tostring(tointeger(data.ban)))
        --设置签到状态
        sigState.setText(data.sig_state)
        --设置称号
        title.setText(data.title)
        --设置邮箱
        mail.setText(data.mail)
        --设置性别
        gender.setText(data.gender)
        --设置关注
        follow.setText(tostring(tointeger(data.follow)))
        --设置粉丝
        fans.setText(tostring(tointeger(data.fans)))
       else
        提示(data.msg)
      end
     else
      提示("Http error code:"..code)
    end
  end)
end

--界面返回事件，res为-1修改头像，1为修改昵称，2为修改签名，3为修改密码
--4为扣除余额，5为转账余额
function onActivityResult(req, res, intent)
  if res==1 then
    --修改昵称返回事件
    if intent then
      local pathstr=intent.getStringExtra("newName");
      if pathstr then
        name.setText(pathstr)
      end
    end
   elseif res==2 then
    --修改签名返回事件
    if intent then
      local pathstr=intent.getStringExtra("newSignatrue")
      if pathstr then
        signatrue.setText(pathstr)
      end
    end
   elseif res==3 then
    --修改密码返回事件
    if intent then
      local pathstr=intent.getStringExtra("newPassword")
      if pathstr then
        password=pathstr
      end
    end
   elseif res==4 or res==5 then
    --扣除余额返回事件
    if intent then
      local pathstr=intent.getStringExtra("newWallet")
      if pathstr then
        wallet.setText(pathstr)
      end
    end
    --修改邮箱回调事件
   elseif res==6 then
    if intent then
      local pathstr=intent.getStringExtra("newMail")
      if pathstr then
        mail.setText(pathstr)
      end
    end
    --修改性别回调事件
   elseif res==7 then
    if intent then
      local pathstr=intent.getStringExtra("newGender")
      if pathstr then
        gender.setText(pathstr)
      end
    end
    --图像选择回调事件
   elseif res==-1 and intent then
    local cursor =this.getContentResolver ().query(intent.getData(), nil, nil, nil, nil)
    cursor.moveToFirst()
    import "android.provider.MediaStore"
    local idx = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA)
    fileSrc = cursor.getString(idx)
    bit=nil
    --fileSrc回调路径路径
    import "android.graphics.BitmapFactory"
    bit =BitmapFactory.decodeFile(fileSrc)
    --图片上传
    提示("头像上传中...")
    local api=url.."main/api/user/user_set.php"
    if isEncrypt then
      codekey=Narcissus.encrypt(key)
     else
      codekey=key
    end
    local body={
      ["admin"]=admin,
      ["user"]=user,
      ["password"]=password,
      ["project"]="head",
      ["key"]=codekey
    }
    local file={
      ["file"]=fileSrc
    }
    local body,cookie,code,header=http.upload(api,body,file)
    if code==200 then
      local data=cjson.decode(body)
      提示(data.msg)
      if data.code==1 then
        head.setImageBitmap(bit)
      end
     else
      提示("Http error code:"..code)
    end
  end
end



--签到按钮事件
sig.onClick=function ()
  local api=url.."main/api/user/user_sig.php"
  if isEncrypt then
    codekey=Narcissus.encrypt(key)
   else
    codekey=key
  end
  local body={
    ["admin"]=admin,
    ["user"]=user,
    ["password"]=password,
    ["key"]=codekey
  }
  Http.post(api,body,nil,nil,function (code,body)
    if code==200 then
      local data=cjson.decode(body)
      提示(data.msg)
      if data.code==1 then
        main()
      end
     else
      提示("Http error code:"..code)
    end
  end)
end

--修改昵称按钮事件
setName.onClick=function ()
  activity.newActivity("script/setName",{url,admin,user,password,key,isEncrypt,secret})
end

--修改签名按钮事件
setSignatrue.onClick=function ()
  activity.newActivity("script/setSignatrue",{url,admin,user,password,key,isEncrypt,secret})
end

--修改密码按钮事件
setPassword.onClick=function ()
  activity.newActivity("script/setPassword",{url,admin,user,password,key,isEncrypt,secret})
end

--修改头像按钮事件
setHead.onClick=function ()
  local intent= Intent(Intent.ACTION_PICK)
  intent.setType("image/*")
  this.startActivityForResult(intent, 1)
end

--扣除余额按钮事件
setWallet.onClick=function ()
  activity.newActivity("script/setWallet",{url,admin,user,password,key,wallet.Text,isEncrypt,secret})
end

--转账余额按钮事件
transfer.onClick=function ()
  activity.newActivity("script/transfer",{url,admin,user,password,key,wallet.Text,isEncrypt,secret})
end

--查询用户按钮事件
userData.onClick=function ()
  activity.newActivity("script/userData",{url,admin,user,password,key,isEncrypt,secret})
end

--判断是否为会员按钮事件
isVip.onClick=function ()
  local api=url.."main/api/user/user_vip.php"
  if isEncrypt then
    codekey=Narcissus.encrypt(key)
   else
    codekey=key
  end
  local body={
    ["admin"]=admin,
    ["user"]=user,
    ["password"]=password,
    ["key"]=codekey
  }
  Http.post(api,body,nil,nil,function (code,body)
    if code==200 then
      local data=cjson.decode(body)
      if data.code==1 then
        if data.msg==1 then
          dialog=AlertDialog.Builder(this)
          .setMessage("已开通会员")
          .show()dialog.create()
         else
          dialog=AlertDialog.Builder(this)
          .setMessage("未开通会员")
          .show()dialog.create()
        end
       else
        提示(data.msg)
      end
     else
      提示("Http error code:"..code)
    end
  end)
end

--举报用户按钮事件
report.onClick=function ()
  activity.newActivity("script/report",{url,admin,user,password,key,isEncrypt,secret})
end

--修改邮箱按钮事件
setMail.onClick=function ()
  activity.newActivity("script/setMail",{url,admin,user,password,key,isEncrypt,secret})
end

--修改性别按钮事件
setGender.onClick=function ()
  activity.newActivity("script/setGender",{url,admin,user,password,key,isEncrypt,secret})
end

--关注列表按钮事件
followList.onClick=function ()
  activity.newActivity("script/followList",{url,admin,user,password,key,isEncrypt,secret})
end

--粉丝列表按钮事件
fansList.onClick=function ()
  activity.newActivity("script/fansList",{url,admin,user,password,key,isEncrypt,secret})
end

--转账记录按钮事件
transferRecord.onClick=function ()
  activity.newActivity("script/transferRecord",{url,admin,user,password,key,isEncrypt,secret})
end

CardSecretExchange.onClick=function ()
  activity.newActivity("script/kamihome",{url,admin,user,password,key,isEncrypt,secret})
end