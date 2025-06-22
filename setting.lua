require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "cjson"

layout = {
  LinearLayout;
  id = "mainLay";
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
      DividerHeight = 0;
      id = "settings_list";
    };
  };
}
activity.setContentView(loadlayout(layout))

-- 设置页数据
data = {
  {__type = 1, title = "提醒设置"},
  {__type = 4, subtitle = "OA提醒", status = {Checked = Boolean.valueOf(this.getSharedData("OASwitch"))}},
  {__type = 3, subtitle = "OA提醒刷新间隔时间"},
  {__type = 4, subtitle = "消息弹窗提醒", status = {Checked = Boolean.valueOf(this.getSharedData("NewRemindSwitch"))}},
  {__type = 4, subtitle = "消息红点图标", status = {Checked = Boolean.valueOf(this.getSharedData("NewRedSwitch"))}},
  {__type = 1, title = "界面设置"},
  {__type = 4, subtitle = "网页黑夜模式", status = {Checked = Boolean.valueOf(this.getSharedData("webNM"))}},
  {__type = 4, subtitle = "夜间模式", status = {Checked = Boolean.valueOf(this.getSharedData("NightMode"))}},
  {__type = 4, subtitle = "横屏模式", status = {Checked = Boolean.valueOf(this.getSharedData("VerticalScreen"))}},
  {__type = 3, subtitle = "课表周数"},
  {__type = 3, subtitle = "课表节数"},
  {__type = 3, subtitle = "课表卡片高度"},
  {__type = 3, subtitle = "OA卡片高度"},
  {__type = 3, subtitle = "课表格子高度"},
  {__type = 3, subtitle = "首页卡片选项"},
  {__type = 3, subtitle = "其他个性化"},
  {__type = 1, title = "其他"},
  {__type = 3, subtitle = "获取设备码"},
  {__type = 3, subtitle = "更新日志", rightIcon = {Visibility = 0}},
  {__type = 3, subtitle = "反馈建议", rightIcon = {Visibility = 0}},
  {__type = 3, subtitle = "致谢名册"},
  {__type = 3, subtitle = "用户协议"},
}
about_item = {
  {--大标题 type1
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
  {--标题,简介 type2
    LinearLayout;
    gravity = "center";
    layout_width = "fill";
    layout_height = "64dp";
    {
      LinearLayout;
      orientation = "vertical";
      layout_height = "fill";
      gravity = "center_vertical";
      layout_weight = 1;
      {
        TextView;
        id = "subtitle";
        textSize = "16sp";
        textColor = textc;
        layout_marginLeft = "16dp";
      };
      {
        TextView;
        textColor = stextc;
        id = "message";
        textSize = "15sp";
        layout_marginLeft = "16dp";
      };
    };
  };
  {--标题 图标 type3
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
  {--标题,switch type4
    LinearLayout;
    gravity = "center_vertical";
    layout_width = "fill";
    layout_height = "64dp";
    {
      TextView;
      id = "subtitle";
      textSize = "16sp";
      textColor = textc;
      gravity = "center_vertical";
      layout_weight = 1;
      layout_height = "-1";
      layout_marginLeft = "16dp";
    };
    {
      Switch;
      id = "status";
      layout_gravity = "center";
      focusable = false; -- 确保开关不拦截点击事件
      clickable = false; -- 确保开关不拦截点击事件
      layout_marginRight = "30dp";
    }
  };
  {
    LinearLayout;
    gravity="center_vertical";
    layout_width="fill";
    layout_height="64dp";
    {
      LinearLayout;
      orientation="vertical";
      layout_height="fill";
      gravity="center_vertical";
      {
        TextView;
        id="subtitle";
        textSize="16sp";
        textColor=textc;
        layout_marginRight="16dp";
      };
      {
        LinearLayout;
        gravity="horizontal";
        {
          SeekBar;
          layout_width="150dp";
          id="拖动条";
        };
        {
          TextView;
          textColor="0xff000000";
          gravity="center";
          layout_marginLeft="-10dp";
          id="显示数值";
          text="0";
        };
      }
    };
  };

  {--分割线 type6
    LinearLayout;
    layout_width = "-1";
    layout_height = "-2";
    gravity = "center|left";
    onClick = function() end;
    {
      TextView;
      layout_width = "-1";
      layout_height = "3px";
      --background=cardback,
    };
  };
}
tab = {
  ["首页卡片选项"] = function()
    local items = {"作业", "课表", "OA", "一卡通", "天气"}
    local sharedDataKey = "卡片Items"
    local savedData = this.getSharedData(sharedDataKey)
    local selectedItems = cjson.decode(savedData) or {false, false, false, false, false}
    AlertDialog.Builder(this)
    .setTitle("选择瀑布流展示的卡片")
    .setMultiChoiceItems(items, selectedItems, function(_, which, isChecked)
      if which >= 0 and which < #selectedItems then
        selectedItems[which + 1] = isChecked
        this.setSharedData(sharedDataKey, cjson.encode(selectedItems))
      end
    end)
    .show()
  end,
  ["课表周数"] = function()
    local startfollow = {"1", "2", "3", "4", "5", "6", "7"}
    -- 获取当前选中的序号，如果没有设置则默认为1
    local starnum = tonumber(startfollow[this.getSharedData("zcnumber")]) or 7
    local tipalert = AlertDialog.Builder(this)
    .setTitle("请选择周数")
    .setSingleChoiceItems(startfollow, starnum - 1, { -- 注意这里是 starnum - 1
      onClick = function(v, p)
        starnum = p + 1 -- 存储用户选择的值
      end
    })
    .setPositiveButton("确定", nil)
    .setNegativeButton("取消", nil)
    .show()
    -- 确定按钮的点击事件
    tipalert.getButton(tipalert.BUTTON_POSITIVE).onClick = function()
      local selectedValue = tonumber(startfollow[starnum])
      this.setSharedData("zcnumber", selectedValue)
      print(selectedValue) -- 输出选择的值
      starnum = nil
      提示("重启生效")
      tipalert.dismiss() -- 关闭对话框
    end
  end,
  ["课表节数"] = function()
    local startfollow = {"1", "2", "3", "4", "5", "6", "7"}
    -- 获取当前选中的序号，如果没有设置则默认为1
    local starnum = tonumber(startfollow[this.getSharedData("jcnumber")]) or 7
    local tipalert = AlertDialog.Builder(this)
    .setTitle("请选择节数")
    .setSingleChoiceItems(startfollow, starnum - 1, { -- 注意这里是 starnum - 1
      onClick = function(v, p)
        starnum = p + 1 -- 存储用户选择的值
      end
    })
    .setPositiveButton("确定", nil)
    .setNegativeButton("取消", nil)
    .show()
    -- 确定按钮的点击事件
    tipalert.getButton(tipalert.BUTTON_POSITIVE).onClick = function()
      -- 获取用户选择的值并存储
      local selectedValue = tonumber(startfollow[starnum])
      this.setSharedData("jcnumber", selectedValue)
      print(selectedValue) -- 输出选择的值
      starnum = nil
      提示("重启生效")
      tipalert.dismiss() -- 关闭对话框
    end
  end,
  ["夜间模式"] = function()
    activity.setResult(1100,nil)
    提示("返回生效")
  end,
  ["课表卡片高度"] = function()
    输入对话框("修改课表高度","可输入400dp等\n也可输入40%h(40%屏幕高度)或wrap(自适应)\n确保课表正常显示就好了",function(input)
      this.setSharedData("课表高度",input)
      提示("重启生效")
    end)
  end,
  ["OA提醒刷新间隔时间"] = function()
    输入对话框("修改刷新间隔时间","可输入10等，单位秒\n不要设置太小",function(input)
      this.setSharedData("OA刷新间隔",input)
      提示("重启生效")
    end)
  end,
  ["课表格子高度"] = function()
    输入对话框("修改课表格子高度","可输入50dp等\n确保课表正常显示就好了",function(input)
      this.setSharedData("课表格子高度",input)
      提示("重启生效")
    end)
  end,
  ["OA卡片高度"] = function()
    输入对话框("修改OA高度","可输入400dp等\n也可输入40%h(40%屏幕高度)或wrap(自适应)\n确保OA正常显示并且能滑动就好了",function(input)
      this.setSharedData("OA高度",input)
      提示("重启生效")
    end)
  end,
  ["其他个性化"] = function() activity.newActivity('page/gexinghua') end;
  ["获取设备码"] = function()
    import "java.io.File"
    import "android.provider.Settings$Secure"
    设备码key = tostring(Secure.getString(activity.getContentResolver(), Secure.ANDROID_ID))
    import "android.content.*"
    activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(设备码key)
    提示("已复制")
  end,
  ["更新日志"] = function()
    内容 = io.open(activity.getLuaDir().. "/res/UpdateLog.txt"):read("*a")
    取消事件 = [[xxx.dismiss()]]
    确认事件 = [[打开小破站() ]]
    双按钮对话框("更新日志(当前版本：".. 应用版本名.. ")", 内容, "知道了", "问题反馈", function 关闭对话框(an) end, function 提示("发送邮件给896662462@qq.com") end)
  end,
  ["反馈建议"] = function() 提示("请在论坛版块内的反馈区发帖~") end;
  ["致谢名册"] = function() activity.newActivity('page/gongxian') end;
  ["用户协议"] = function()
    本地用户协议 = io.open(activity.getLuaDir().. "/res/UserAgreement.txt"):read("*a")
    Iamsay = 本地用户协议:match("用户协议【(.-)】")
    单按钮对话框("隐私政策及服务条款", Iamsay, "知道了", function() an.dismiss() end, 1)
  end
}
settab = {
  ["OA提醒"] = "OASwitch",
  ["消息弹窗提醒"] = "NewRemindSwitch",
  ["消息红点图标"] = "NewRedSwitch",
  ["网页黑夜模式"] = "webNM",
  ["夜间模式"] = "NightMode",
  ["横屏模式"] = "VerticalScreen"
}--设置数据
adp = LuaMultiAdapter(this, data, about_item)
settings_list.setAdapter(adp)


settings_list.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick = function(id, v, zero, one)
    if v.Tag.status ~= nil then
      if v.Tag.status.Checked then
        this.setSharedData(settab[tostring(v.Tag.subtitle.Text)] or v.Tag.subtitle.Text, "false")
        data[one].status["Checked"] = false
       else
        this.setSharedData(settab[tostring(v.Tag.subtitle.Text)] or v.Tag.subtitle.Text, "true")
        data[one].status["Checked"] = true
      end
    end
    (tab[tostring(v.Tag.subtitle.Text)] or function() end) (tab, one)
    adp.notifyDataSetChanged()--更新列表
  end
})
