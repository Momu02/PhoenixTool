require "import"
--import "android.app.*"
--import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "java.io.File" --文件系统
import "android.app.AlertDialog" --对话框
import "android.webkit.MimeTypeMap"
import "android.content.Intent"
import "mods.muk"
import "android.net.Uri" --系统打开文件
import "com.androlua.LuaUtil" --辅助库 删除文件夹
import "android.text.format.Formatter" --格式化文件大小

layout={
  LinearLayout;
  orientation="vertical";
  layout_width="fill";
  layout_height="fill";
  {
    TextView;
    textColor=textc;
    id="path_TextView";
    text="path: /sdcard";
  };
  {
    LinearLayout;
    {
      Button;
      id="addFile_Button";
      text="+文件";
    };
    {
      Button;
      id="addDir_Button";
      text="+文件夹";
    };
  };
  {
    AbsoluteLayout;
    layout_height="-1";
    layout_width="-1";
    {
      LinearLayout;
      id="fileEdit_LinearLayout";
      layout_height="-1";
      layout_width="-1";
      orientation="vertical";
      {
        LinearLayout;
        layout_width="-1";
        {
          Button;
          id="back_Button";
          text="<返回";
        };
        {
          Button;
          id="save_Button";
          text="保存";
        };
      };
      {
        EditText;
        id="file_EditText";
        layout_height="-1";
        layout_width="-1";
        gravity="start";
        backgroundColor="#fffae8";
      };
    };
    {
      ListView;
      id="dir_ListView";
      layout_height="-1";
      layout_width="-1";
    };
  };
};
activity.setTitle("文件管理")
activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
local path = ...
activity.setContentView(loadlayout(layout))

function openFile(path)
  --意图2（打开文件）
  import "android.webkit.MimeTypeMap"
  import "android.content.Intent"
  import "android.net.Uri"
  import "java.io.File"
  import "android.content.FileProvider"
  FileName=tostring(File(path).Name)
  ExtensionName=FileName:match("%.(.+)")
  Mime=MimeTypeMap.getSingleton().getMimeTypeFromExtension(ExtensionName)
  if Mime then
    intent2 = Intent()
    intent2.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    intent2.setAction(Intent.ACTION_VIEW);
    --  intent2.setDataAndType(Uri.fromFile(File(path)), Mime);
    intent2.setDataAndType(FileProvider.getUriForFile(this,this.getPackageName(),File(path)),Mime)
    intent2.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);--允许临时的读
    intent2.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION|Intent.FLAG_GRANT_WRITE_URI_PERMISSION);--允许临时的读和写
   else
    提示("没有合适的应用打开该文件")
    return false
  end
  openIntent(intent2)
end

function openIntent(intent)
  --查询是否有该Intent的Activity
  packageManager =this. getPackageManager();
  activities = packageManager.queryIntentActivities(intent, 0);
  --activities里面不为空就有，否则就没有
  if activities.size() ==1 then
    this.startActivity(intent)
   elseif activities.size()>0 then
    import "android.content.ComponentName"
    import "com.androlua.LuaAdapter"
    dialog=AlertDialog.Builder(this)
    .setView(loadlayout{
      LinearLayout;
      Orientation='vertical';
      layout_width='fill';
      layout_height='fill';
      background='#ffffff';
      {
        GridView;
        numColumns=3;
        layout_width='fill';
        layout_height='fill';
        id="list";
      };
    })
    .setTitle("选择应用")
    .show()
    item={
      LinearLayout;
      Orientation='vertical';
      layout_width='fill';
      layout_height='wrap';
      gravity='center';
      {
        ImageView;
        layout_width='8%w';
        layout_height='8%w';
        layout_margin="10dp";
        id="icon";
      };
      {
        TextView;
        textColor=textc;
        layout_width='fill';
        layout_height='wrap';
        gravity="center";
        id="name";
        layout_marginBottom="10dp";
      };
      {
        TextView;
        textColor=textc;
        layout_width='0';
        layout_height='0';
        gravity="center";
        id="pkgname";
      };
      {
        TextView;
        textColor=textc;
        layout_width='0';
        layout_height='0';
        gravity="center";
        id="actname";
      };
    };
    data={}
    adp=LuaAdapter(this,data,item)
    list.setAdapter(adp)
    list.onItemClick=function(l,v,o,n)
      intent.setComponent(ComponentName(v.Tag.pkgname.text,v.Tag.actname.text));
      this.startActivity(intent)
      dialog.dismiss()
    end
    for i=0,activities.size()-1 do
      info=activities.get(i)
      adp.add({pkgname=info.activityInfo.packageName,
        actname=info.activityInfo.name,
        name=info.loadLabel(packageManager),
        icon=info.loadIcon(packageManager)})
    end
    path = string.match(path, "(.*)/.+$")
   else
    提示("没有合适的应用打开该内容")
    path = string.match(path, "(.*)/.+$")
  end
end



local adp = ArrayAdapter(activity, android.R.layout.simple_list_item_1)
dir_ListView.setAdapter(adp)

function update()
  path_TextView.text = "path: "..path
  if File(path).isDirectory() then --打开文件夹
    dir_ListView.setVisibility(View.VISIBLE)
    fileEdit_LinearLayout.setVisibility(View.GONE)

    adp.clear() --清空
    adp.add("../") --父文件夹
    local ls = File(path).listFiles()
    if ls then --不为空
      local fileList = luajava.astable( ls )
      table.sort(fileList, function(a,b) --排序
        return (a.isDirectory()~=b.isDirectory() and a.isDirectory()) or ((a.isDirectory()==b.isDirectory()) and a.Name<b.Name)
      end)
      for i,v in ipairs(fileList) do
        if v.isDirectory() then --文件夹
          adp.add(v.Name.."/")
         else
          local cal = Calendar.getInstance()
          local time = v.lastModified() --最后修改时间
          cal.setTimeInMillis(time)
          adp.add( v.Name.."\n\t\t\t"..Formatter.formatFileSize(activity, v.length()).."\t\t\t\t\t\t"..cal.getTime().toLocaleString() )
        end
      end
    end

   else --查看文件
    --[[
    dir_ListView.setVisibility(View.GONE)
    fileEdit_LinearLayout.setVisibility(View.VISIBLE)
    local file = io.open(path, "r")
    file_EditText.text = file:read("*a")
    file:close(file)]]
    local result = openFile(path) -- some_path是要打开的文件路径
    if result then
      -- 文件成功打开，这里可以添加后续操作，比如显示一个提示框告知用户文件已打开
      --提示("文件已成功打开")
     else
      -- 文件打开失败，这里可以添加其他操作，比如记录错误日志或者给用户更详细的错误提示
      --提示("文件打开失败，请检查文件类型或安装相关应用")
      print(path)
      openFile(path)
    end
  end
end
update()

--系统打开文件
--[[
function openFile(path)
  local FileName = tostring(File(path).Name)
  local ExtensionName = FileName:match("%.(.+)")
  local Mime = MimeTypeMap.getSingleton().getMimeTypeFromExtension(ExtensionName)
  if Mime then
    intent = Intent()
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    intent.setAction(Intent.ACTION_VIEW);
    intent.setDataAndType(Uri.fromFile(File(path)), Mime);
    activity.startActivity(intent)
    return true
   else
    return false
  end
end]]

--列表点击事件
dir_ListView.onItemClick=function(l,v,p,s)
  local name = v.Text
  if string.sub(name, -1) == "/" then
    name = string.sub(name, 1, -2)
   else
    name = string.match(name, "(.-)\n")
  end
  if name == ".." then
    path = string.match(path, "(.*)/.+$")
   else
    path = path.."/"..name
  end
  update()
end

local pop = PopupMenu(activity, path_TextView) --弹出菜单
local menu = pop.Menu
--系统打开
menu.add("打开(系统)").onMenuItemClick=function(v)
  openFile(path)
  path = string.match(path, "(.*)/.+$")
end
--删除文件/文件夹
menu.add("删除").onMenuItemClick=function(v)
  AlertDialog.Builder(this)
  .setTitle("真的要删除"..path.."吗？")
  .setMessage("（将无法恢复）")
  .setPositiveButton("删除",function
    LuaUtil.rmDir( File(path) )
    path = string.match(path, "(.*)/.+$")
    update()
    Toast.makeText(activity, "删除成功",Toast.LENGTH_SHORT).show()
  end)
  .setNeutralButton("取消",nil)
  .show()
end
--重命名/移动文件
menu.add("重命名/移动").onMenuItemClick=function(v)
  local editText = EditText(activity)

  AlertDialog.Builder(this)
  .setTitle("请输入")
  .setIcon(android.R.drawable.ic_dialog_info)
  .setView(editText)
  .setPositiveButton("确定", function
    File(path).renameTo(
    File( string.match(path, "(.*)/.+$").."/"..editText.text )
    )
    Toast.makeText(activity, "移动成功",Toast.LENGTH_SHORT).show()
    path = string.match(path, "(.*)/.+$")
    update()
  end)
  .setNegativeButton("取消", nil)
  .show();
end

--列表项目长按
dir_ListView.onItemLongClick = function(l,v,p,s)
  local name = v.text
  if string.sub(name, -1) == "/" then
    name = string.sub(name, 1, -2)
   else
    name = string.match(name, "(.-)\n")
  end
  if name == ".." then
    path = string.match(path, "(.*)/.+$")
   else
    path = path.."/"..name
  end
  pop.show() --弹出菜单
end

--返回父文件夹
back_Button.onClick = function
  path = string.match(path, "(.*)/.+$")
  update()
end

--保存文件
save_Button.onClick = function
  local file = io.open(path, "w")
  file:write(file_EditText.text)
  file:close(file)
  Toast.makeText(activity, "保存成功",Toast.LENGTH_SHORT).show()
  path = string.match(path, "(.*)/.+$")
  update()
end

--新建文件
addFile_Button.onClick = function
  local editText = EditText(activity)

  AlertDialog.Builder(this)
  .setTitle("请输入")
  .setIcon(android.R.drawable.ic_dialog_info)
  .setView(editText)
  .setPositiveButton("确定", function
    File(path.."/"..editText.text).createNewFile()
    update()
  end)
  .setNegativeButton("取消", nil)
  .show();
end

--新建文件夹
addDir_Button.onClick = function
  local editText = EditText(activity)

  AlertDialog.Builder(this)
  .setTitle("请输入")
  .setIcon(android.R.drawable.ic_dialog_info)
  .setView(editText)
  .setPositiveButton("确定", function
    File(path.."/"..editText.text).mkdirs()
    update()
  end)
  .setNegativeButton("取消", nil)
  .show();
end