require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import 'us.feras.mdv.MarkdownView'
import "page.forum_layout.issue"
import "cjson"
import "android.content.Intent"
import "java.net.URLEncoder"
import "com.kn.okhtttp.*"
import "okhttp3.*"
import "java.io.File"
import "com.narcissus.encrypt.*"

activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(issue))

topTitle.getPaint().setFakeBoldText(true)
exit.getPaint().setFakeBoldText(true)


url,admin,user,password,key,plateId,isEncrypt,secret=...

--返回按钮事件
exit.onClick=function ()
  activity.finish()
end

--调用图库函数
function selectImg()
  local intent= Intent(Intent.ACTION_PICK)
  intent.setType("image/*")
  this.startActivityForResult(intent, 1)
end

--图像1按钮事件
img1.onClick=function ()
  --图像序号
  imgNum=1
  --调用图库函数
  selectImg()
end

--图像2按钮事件
img2.onClick=function ()
  --图像序号
  imgNum=2
  --调用图库函数
  selectImg()
end

--图像3按钮事件
img3.onClick=function ()
  --图像序号
  imgNum=3
  --调用图库函数
  selectImg()
end

img4.onClick=function ()
  --图像序号
  imgNum=4
  --调用图库函数
  selectImg()
end

--回调事件
function onActivityResult(req, res, intent)
  if res==-1 and intent then
    local cursor =this.getContentResolver().query(intent.getData(), nil, nil, nil, nil)
    cursor.moveToFirst()
    import "android.provider.MediaStore"
    local idx = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA)
    fileSrc = cursor.getString(idx)
    --fileSrc回调路径路径
    import "android.graphics.BitmapFactory"
    bit =BitmapFactory.decodeFile(fileSrc)
    --判断图像序号
    if imgNum==1 then
      image1Src=fileSrc
      image1Bit=bit
      img1.setImageBitmap(bit)
     elseif imgNum==2 then
      image2Src=fileSrc
      image2Bit=bit
      img2.setImageBitmap(bit)
     elseif imgNum==3 then
      image3Src=fileSrc
      image3Bit=bit
      img3.setImageBitmap(bit)
     elseif imgNum==4 then
      image4Src=fileSrc
      image4Bit=bit
      img4.setImageBitmap(bit)
    end
  end
end

function upload(url,datas,files,cookie,ua,header)
  --该函数感谢由“产品经理不是经理”提供
  --目前修复了该函数的几处问题

  local client=OkHttpClient()
  local request=Request.Builder()
  request.url(url)
  local arr=MultipartBody.Builder()
  arr.setType(MultipartBody.FORM)
  if datas then
    for key,value in pairs(datas) do
      arr.addFormDataPart(key,value)
    end
  end
  if files then
    for name,path in pairs(files) do
      --对文件名进行编码，以防文件包含中文时出现报错
      local encodedFileName = URLEncoder.encode(path, "UTF-8")
      arr.addFormDataPart("file[]",encodedFileName,RequestBody.create(MediaType.parse("image/jpg"),File(path)))
    end
  end
  local requestBody=arr.build()
  request.post(requestBody)
  if cookie then
    request.header("Cookie",cookie)
  end
  if ua then
    request.header("User-Agent",ua)
  end
  if header then
    for key,value in pairs(header) do
      request.header(key,value)
    end
  end

  local callz=client.newCall(request.build())
  -- 同步请求
  local response=callz.execute()
  local body=response.body().string()
  local cookie=response.headers("Cookie")
  local code=response.code()
  local headers=response.headers()
  return body,cookie,code,headers
end

--发表按钮事件
issueButton.onClick=function ()
  --获取标题
  local issueTitle=title.Text
  --获取内容
  local issueContent=content.Text
  --判断是否为空
  if issueTitle=="" or issueContent=="" then
    提示("不能为空")
   elseif #issueTitle > 40 then
    提示("标题不能过长")
   else
    提示("发表中…")
    --声明接口
    local api=url.."main/api/forum/issue.php"
    if isEncrypt then
      codekey=Narcissus.encrypt(key)
     else
      codekey=key
    end
    --请求体
    local body={
      ["admin"]=admin,
      ["user"]=user,
      ["password"]=password,
      ["plate_id"]=plateId,
      ["title"]=issueTitle,
      ["content"]=issueContent,
      ["key"]=codekey
    }
    --上传文件
    local file={
      ["img1"]=image1Src,
      ["img2"]=image2Src,
      ["img3"]=image3Src,
      ["img4"]=image4Src
    }

    local body,cookie,code,header=upload(api,body,file)
    if code==200 then
      local data=cjson.decode(body)
      提示(data.msg)
      if data.code==1 then
        local intent=luajava.newInstance("android.content.Intent")
        intent.putExtra("set","1")
        activity.setResult(1,intent)
        activity.finish()
      end
     else
      提示("Http error code:"..code)
    end
  end
end

--文本框改变
content.addTextChangedListener({
  onTextChanged=function()
    if content.Text == "" then
     else
      bt2.loadMarkdown(content.Text)
    end
  end
})


---悬浮球配置
import "android.view.animation.Animation$AnimationListener"
import "android.view.animation.ScaleAnimation"
import "android.view.animation.ScaleAnimation"
function CircleButton (InsideColor,radiu,...)
  import "android.graphics.drawable.GradientDrawable"
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setColor(InsideColor)
  drawable.setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu});
  for k,v in ipairs({...}) do
    v.setBackgroundDrawable(drawable)
  end
end
CircleButton(转0x(barbackgroundc),100,bt,bt1)

bt.onClick=function(v)
  if bt1.getVisibility()==0 then
    bt1.startAnimation(ScaleAnimation(1.0, 0.0, 1.0, 0.0,1, 0.5, 1, 0.5).setDuration(300))
    bt1.setVisibility(View.INVISIBLE)
    bt.text="预览"
   else
    bt1.setVisibility(View.VISIBLE)
    bt1.startAnimation(ScaleAnimation(0.0, 1.0, 0.0, 1.0,1, 0.5, 1, 0.5).setDuration(200))
    bt.text="关闭"
  end
end

----