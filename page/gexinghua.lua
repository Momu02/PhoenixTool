require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "mods.muk"

-- 个性化设置页面布局
layout = {
  LinearLayout;
  layout_height = "fill";
  layout_width = "fill";
  background = backgroundc;
  {
    LinearLayout,
    layout_width = "fill",
    layout_height = "fill",
    orientation = "vertical";
    {
      LinearLayout;
      id = "toolbar";
      layout_width = "fill";
      layout_height = "56dp";
    };
    {
      ListView;
      layout_height = "fill";
      layout_width = "-1";
      id = "settings_list";
    };
  };
}
activity.setContentView(loadlayout(layout))

-- 个性化设置数据
data = {
  {__type = 2, title = "其他个性化"},
  {__type = 1, subtitle = "设置主页背景"},
  {__type = 1, subtitle = "设置主题颜色"},
  {__type = 1, subtitle = "设置主页功能卡片透明度"},
  {__type = 1, subtitle = "设置侧滑栏透明度"}
}

-- 个性化设置项布局模板
about_item ={
  {--标题 图标 type1
    LinearLayout;
    layout_width = "fill";
    layout_height = "64dp";
    gravity = "center_vertical";
    {
      TextView;
      id = "subtitle";
      textSize = "16sp";
      textColor = textc;
      layout_marginLeft = "16dp";
      layout_weight = 1;
    };
  };
  {--大标题 type2
    LinearLayout;
    layout_width = "fill";
    layout_height = "-2";
    {
      TextView;
      Focusable = true;
      layout_marginTop = "12dp";
      layout_marginBottom = "12dp";
      gravity = "center_vertical";
      id = "title";
      textSize = "15sp";
      textColor = 主题色;
      layout_marginLeft = "16dp";
    };
  };
}

-- 壁纸设置相关函数
function 壁纸()
  弹窗 =
  {
    FrameLayout;
    layout_width = 'fill';
    {
      LinearLayout;
      orientation = 'vertical';
      layout_width = 'fill';
      {
        ImageView;
        layout_gravity = 'center';
        src = "/storage/emulated/0/Phoenix/Wallpaper/1.png";
        layout_width ='match_parent';
        layout_height ='match_parent';
        scaleType = 'fitXY';
        id = "b";
      };
    };
  };
  xxx = AlertDialog.Builder(this)
  xxx.setView(loadlayout(弹窗))
  xxx.setPositiveButton("选择", 切换壁纸)
  xxx.setNegativeButton("保存", 应用壁纸)
  xxx = xxx.show()
  import "android.graphics.drawable.ColorDrawable"
  xxx.getWindow().setBackgroundDrawable(ColorDrawable(0x00000000))
end

function 切换壁纸()
  import("android.content.Intent")
  local intent = Intent(Intent.ACTION_PICK)
  intent.setType("image/*")
  this.startActivityForResult(intent, 1)
  壁纸()
  function onActivityResult(requestCode, resultCode, intent)
    if intent then
      local cursor = this.getContentResolver().query(intent.getData(), nil, nil, nil)
      cursor.moveToFirst()
      import("android.provider.MediaStore")
      local idx = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA)
      fileSrc = cursor.getString(idx)
      bit = nil
      import("android.graphics.BitmapFactory")
      bit = BitmapFactory.decodeFile(fileSrc)
      b.setImageBitmap(bit)
    end
  end
end

function SavePicture(name, bm)
  if bm then
    import("java.io.FileOutputStream")
    import("java.io.File")
    import("android.graphics.Bitmap")
    name = tostring(name)
    f = File(name)
    out = FileOutputStream(f)
    bm.compress(Bitmap.CompressFormat.PNG, 90, out)
    out.flush()
    out.close()
    return true
   else
    return false
  end
end

function 应用壁纸(v)
  import("android.renderscript.Element")
  import("android.renderscript.Allocation")
  import("android.renderscript.RenderScript")
  import("android.graphics.Bitmap")
  import("android.renderscript.ScriptIntrinsicBlur")
  import("android.graphics.Matrix")
  import("android.graphics.drawable.BitmapDrawable")
  b.setDrawingCacheEnabled(true)
  bm = b.getDrawingCache()
  name = "/storage/emulated/0/Phoenix/Wallpaper/1.png";
  Snakebar("保存成功，重启软件生效")
  SavePicture(name, bm)
end


-- 个性化设置项点击事件处理函数
tab = {
  ["设置主页背景"] = function()
    壁纸()
  end,
  ["设置主题颜色"] = function()
    activity.newActivity('page/SetTheme')
  end,
  ["设置主页功能卡片透明度"] = function()
    -- 此处可添加透明度设置逻辑，如弹出对话框输入透明度值并保存到 SharedData
  end,
  ["设置侧滑栏透明度"] = function()
    -- 此处可添加透明度设置逻辑，如弹出对话框输入透明度值并保存到 SharedData
  end
}

-- 创建适配器并设置给 ListView
adp = LuaMultiAdapter(this, data, about_item)
settings_list.setAdapter(adp)

-- ListView 点击事件处理
settings_list.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick = function(id, v, zero, one)
    (tab[tostring(v.Tag.subtitle.Text)] or function() end) (tab, one)
    adp.notifyDataSetChanged()--更新列表
  end
})
