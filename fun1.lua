require("import")
import("android.app.*")
import("android.os.*")
import("android.widget.*")
import("android.view.*")
import "com.nex3z.flowlayout.FlowLayout"
import "android.graphics.Typeface"
import "mods.muk"

import "android.text.Html"
-- 全局变量区
local slideUpAnim = TranslateAnimation(0, 0, 100, 0) -- 从下方滑入，调整为正值
slideUpAnim.setDuration(200)
local slideDownAnim = TranslateAnimation(0, 0, 0, 100) -- 滑出到下方，调整为正值
slideDownAnim.setDuration(200)

-- 手势检测模块
local function initSwipeGesture(view)
  local w = activity.width
  local startX, velocity = 0, 0
  local autoHideTask = nil -- 用于存储 task 引用

  -- 定义自动隐藏函数
  local function doAutoHide()
    if view.getVisibility() == View.VISIBLE then -- 仅在控件可见时执行
      view.startAnimation(slideDownAnim)
      view.setVisibility(View.INVISIBLE)
    end
  end

  -- 设置自动隐藏
  autoHideTask = task(4000, doAutoHide)

  view.setOnTouchListener({
    onTouch = function(v, event)
      local action = event.getAction()
      local rawX = event.getRawX()

      if action == MotionEvent.ACTION_DOWN then
        startX = rawX
        velocity = 0
        return true
       elseif action == MotionEvent.ACTION_MOVE then
        local dx = rawX - startX
        velocity = dx / 0.01
        v.translationX = dx
        v.alpha = 1 - math.abs(dx) / w
        return true
       elseif action == MotionEvent.ACTION_UP then
        local tx = v.translationX
        local absTx = math.abs(tx)
        local shouldDismiss = absTx > w/5 or (math.abs(velocity) > 800 and absTx > 50)

        if shouldDismiss then
          local targetX = tx > 0 and w or -w
          local duration = math.min(400, math.abs(targetX - tx) / 800) * 1000
          local anim = TranslateAnimation(tx, targetX, 0, 0)
          v.setVisibility(View.INVISIBLE)
          anim.setDuration(5000)
          anim.setAnimationListener({
            onAnimationEnd = function()
              v.translationX = 0
              v.alpha = 1
            end
          })
          v.startAnimation(anim)
         else
          local anim = TranslateAnimation(tx, 0, 0, 0)
          anim.setDuration(200)
          anim.setAnimationListener({
            onAnimationEnd = function()
              v.translationX = 0
              v.alpha = 1
            end
          })
          v.startAnimation(anim)
        end
        return true
      end
      return false
    end
  })
end

-- 消息显示模块
local function showOAMessage(response)
  OA总结布局.translationX = 0
  OA总结布局.alpha = 1
  OA总结布局.setVisibility(View.VISIBLE)
  initSwipeGesture(OA总结布局)
  OA总结布局.startAnimation(slideUpAnim)
  OA总结.setText(Html.fromHtml(response))
end

-- 界面1加载函数
function 界面1加载()
  import "android.os.Handler"
  import "android.os.Looper"
  -- 创建主线程的Handler实例（移动到函数开头）
  local mainHandler = Handler(Looper.getMainLooper())
  -- 获取刷新间隔时间，单位为秒，默认值为60秒
  local refreshInterval = tonumber(this.getSharedData("OA刷新间隔")) or 10
  local refreshIntervalMillis = refreshInterval * 1000 -- 转换为毫秒

  -- 清空并读取登录信息文件
  io.open(activity.getLuaDir().."/set/message.txt", "a"):write(""):close()
  localMs = io.open(activity.getLuaDir().."/set/message.txt"):read("*a")

  if localMs == "" then
    mainHandler.post(Runnable({
      run = function()
        提示("请先打开侧边栏登录！")
      end
    }))
   else
    -- 提取用户名和密码，构建登录参数
    username = localMs:match('username":"(.-)"')
    password1 = localMs:match('password":"(.-)"')
    userPassword = "username="..username.."&".."password="..password1
    OApost = "http://wechat.stu.edu.cn/webservice_oa/oa_stu_/login_post"
    -- 发起登录请求，保存返回的Cookie
    Http.post(OApost, userPassword, function(a, b)
      io.open(activity.getLuaDir().."/set/CookOA.txt", "w"):write(b):close()
    end)
    TokenOa = io.open(activity.getLuaDir().."/set/CookOA.txt"):read("*a")
  end

  search_subcompany_id = 0 -- 查询所有部门
  search_keyword = "" -- 查询所有文档
  LoadingCheck1 = true

  -- 定义页面1的标签数组
  page1tab = {
    "学校官网", "东校区官网", "MYSTU", "OA系统", "教务系统", "学工系统", "水电系统", "支付系统", "图书馆", "网络信息中心", "信息公开网", "SLC",
    "本科教学质量保障平台", "本部本科生电子成绩单证明平台", "教室预约", "本部报修", "东海岸报修", "宿舍管理", "活动预约", "实验室安全考试系统",
    "网络教学平台", "NETMS", "医学院OA", "教务处", "学生处", "人事处", "文学院", "工学院", "理学院", "法学院", "医学院", "商学院",
    "长江新传学院", "长江艺设学院", "研究生学院", "继续教育学院", "理学院", "预约中心", "毕业查成绩", "物理实验虚拟仿真中心", "Booking",
    "大型仪器共享管理系统"
  }
  page1tab2 = {
    "校内邮箱", "本周课表", "一卡通查询", "校历", "微博树洞", "金凤BT", "文献查找", "脑力奥运", "综测注解", "网络故障报修", "一卡通挂失",
    "狐友树洞", "东校区地图", "校内Office365下载", "校内直播", "校内电话大全", "校招"
  }

  -- 创建圆形按钮的函数
  function CircleButton(InsideColor, radiu)
    import "android.graphics.drawable.GradientDrawable"
    drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(InsideColor)
    drawable.setCornerRadii({radiu, radiu, radiu, radiu, radiu, radiu, radiu, radiu})
    return drawable
  end

  -- 获取屏幕宽度，计算自适应宽度
  local screenWidth = activity.getWidth() - 250
  local minCardsPerRow = 3
  local adaptiveWidth = math.min(math.floor(screenWidth / minCardsPerRow), screenWidth)

  -- 循环添加页面1的卡片
  for k, v in pairs(page1tab) do
    local a = {
      LinearLayout;
      layout_width = "-2";
      {
        CardView;
        radius = "15dp";
        layout_height = "55dp";
        layout_margin = "10dp";
        onClick = v;
        elevation = "0dp";
        layout_marginTop = "0dp";
        layout_width = tostring(adaptiveWidth).."px";
        CardBackgroundColor = viewshaderc;
        layout_gravity = "center";
        {
          TextView;
          textColor = textc;
          gravity = "center";
          textSize = "14dp";
          layout_gravity = "center";
          Typeface = 字体("product");
          text = v;
        };
      };
    }
    界面1f2.addView(loadlayout(a))
    列表逐显动画(界面1f1, 0.1)
  end

  for k, v in pairs(page1tab2) do
    b = {
      LinearLayout;
      layout_width = "-2";
      {
        CardView;
        radius = "15dp";
        layout_height = "55dp";
        layout_margin = "10dp";
        onClick = v;
        elevation = "0dp";
        layout_marginTop = "0dp";
        layout_width = tostring(adaptiveWidth).."px";
        CardBackgroundColor = viewshaderc;
        layout_gravity = "center";
        {
          TextView;
          textColor = textc;
          gravity = "center";
          textSize = "14dp";
          layout_gravity = "center";
          Typeface = 字体("product");
          text = v;
        };
      };
    }
    界面1f1.addView(loadlayout(b))
    列表逐显动画(界面1f2, 0.1)
  end

  -- 天气卡片相关逻辑
  local 天气data = this.getSharedData("天气")
  if 天气data == "true" then
    Thread(Runnable({
      run = function()
        Http.get("https://uapis.cn/api/weather?name="..this.getSharedData("weatherposition"), nil, nil, nil, function(code, content, cookie, header)
          if code == 200 then
            weathercontent = cjson.decode(content)
            mainHandler.post(Runnable({
              run = function()
                dateTime.Text = weathercontent.reporttime.."更新"
                position.Text = weathercontent.city
                local air = tonumber(weathercontent.humidity)
                local temp = tonumber(weathercontent.temperature)
                local qualityText, color
                if air <= 50 then
                  qualityText, color = "优", "#00FF00"
                 elseif air <= 100 then
                  qualityText, color = "良", "#FFFF00"
                 elseif air <= 150 then
                  qualityText, color = "轻度污染", "#FFA500"
                 elseif air <= 200 then
                  qualityText, color = "中度污染", "#FF0000"
                 elseif air <= 300 then
                  qualityText, color = "重度污染", "#8B0000"
                 else
                  qualityText, color = "严重污染", "#800080"
                end
                airquality.Text = 颜色字体(qualityText..air, color)
                local color2
                if temp < 0 then
                  color2 = "#00BFFF"
                 elseif temp < 10 then
                  color2 = "#800000FF"
                 elseif temp <= 25 then
                  color2 = "#8000FF00"
                 elseif temp < 33 then
                  color2 = "#80FFFF00"
                 else
                  color2 = "#80FF0000"
                end
                if weathercontent.weather == "小雨" then
                  weathericon = 图标("weather/Lightrain")
                 elseif weathercontent.weather == "中雨" then
                  weathericon = 图标("weather/Moderaterain")
                 elseif weathercontent.weather == "大雨" then
                  weathericon = 图标("weather/Heavyrain")
                 elseif weathercontent.weather == "阵雨" then
                  weathericon = 图标("weather/Shower")
                 elseif weathercontent.weather == "暴雨" then
                  weathericon = 图标("weather/Torrentialrain")
                 elseif weathercontent.weather == "晴" then
                  weathericon = 图标("weather/Sunny")
                 elseif weathercontent.weather == "多云" then
                  weathericon = 图标("weather/Cloudy")
                 elseif weathercontent.weather == "阴" then
                  weathericon = 图标("weather/Overcast")
                 elseif weathercontent.weather == "小雪" then
                  weathericon = 图标("weather/Lightsnow")
                 elseif weathercontent.weather == "雾" then
                  weathericon = 图标("weather/Haze")
                 elseif weathercontent.weather == "霾" then
                  weathericon = 图标("weather/Haze")
                 else
                  weathericon = 图标("weather/Unknown")
                end
                weathericons.setImageBitmap(loadbitmap(weathericon))
                temperature.Text = 颜色字体(weathercontent.temperature.."℃", color2)
                weather.Text = weathercontent.weather
                card_view.setVisibility(View.VISIBLE)
              end
            }))
           else
            mainHandler.post(Runnable({
              run = function()
                提示("天气更新失败(可以手动开关飞行模式刷新ip)")
              end
            }))
          end
        end)
      end
    })).start()
  end

  -- 一卡通相关逻辑
  local 一卡通data = this.getSharedData("一卡通")
  if 一卡通data == "true" and username then
    -- 在主线程中执行 WebView 相关操作
    mainHandler.post(Runnable({
      run = function()
        -- 设置 WebView 客户端
        yktweb.setWebViewClient({
          onPageFinished = function(view, url)
            -- 如果 URL 是登录页面，则自动填写登录信息
            if url:match("login") then
              local jsLDAP = string.format([[
                            var ldapAccountInput = document.getElementById('ldap_account');
                            var ldapPasswordInput = document.getElementById('ldap_password');
                            var okButton = document.getElementById('btn_ok');
                            if (ldapAccountInput && ldapPasswordInput && okButton) {
                                ldapAccountInput.value = '%s';
                                ldapPasswordInput.value = '%s';
                                okButton.click();
                            }
                        ]], username, password1)
              view.evaluateJavascript(jsLDAP, function()
                isLoggingIn = true
                if isLoggingIn then
                  view.evaluateJavascript([[
                                    var loggedInElement = document.querySelector('.logged-in-element');
                                    if (loggedInElement) {
                                        return true;
                                    }
                                    return false;
                                ]], function(result)
                    if result then
                      isLoggingIn = false
                      -- 登录成功后重新加载一卡通页面
                      yktweb.loadUrl("http://wechat.stu.edu.cn/wechat/smartcard/Smartcard_cardbalance")
                     else
                      提示("登录超时或者失败，请检查账号密码等信息")
                    end
                  end)
                end
              end)
             else
              -- 如果页面加载完成，提取一卡通余额
              view.evaluateJavascript([[
                            document.documentElement.outerHTML;
                        ]], function(result)
                if result then
                  local balance = string.match(result, "一卡通余额是([%d%.]+)元")
                  if balance then
                    -- 在主线程中更新余额显示
                    mainHandler.post(Runnable({
                      run = function()
                        yktbalance.setText(balance)
                      end
                    }))
                  end
                end
              end)
            end
          end
        })

        -- 加载一卡通页面
        yktweb.loadUrl("http://wechat.stu.edu.cn/wechat/smartcard/Smartcard_cardbalance")
        -- 显示一卡通视图
        yktview.setVisibility(View.VISIBLE)

      end
    }))
  end

  -- 作业相关逻辑
  设置Cookie("https://my.stu.edu.cn/courses/campus/my/","")
  local 作业data = this.getSharedData("作业")
  if 作业data == "true" and username then
    --获取未完成作业列表
    function get_homework(cookie)
      Thread(Runnable({
        run = function()
          Http.get('https://my.stu.edu.cn/courses/campus/my', cookie, nil, nil, function(code, html)
            -- 匹配整个作业代码块
            local pattern = '(<div class="name">.-</div>%s-<div class="info">.-</div>%s-<div class="details">.-</div>)'
            local sumblock=""
            -- 使用循环提取所有作业代码块
            for block in html:gmatch(pattern) do
              if block:match("已提交") then
               else
                sumblock=sumblock..block.."\n————————————"
              end
            end
            mainHandler.post(Runnable({
              run = function()
                homework.loadMarkdown(sumblock)
                作业view.setVisibility(View.VISIBLE)
              end
            }))
          end)
        end
      })).start()

    end
    mystuweb.loadUrl("https://my.stu.edu.cn/courses/campus/my/")
    mystuweb.setWebViewClient{
      onPageFinished = function(view, url)
        if url:match("login") then
          local jsNormal = string.format([[
            var usernameInput = document.getElementById('username');
            var passwordInput = document.getElementById('password');
            var loginButton = document.getElementById('login');
            if (usernameInput && passwordInput && loginButton) {
                usernameInput.value = '%s';
                passwordInput.value = '%s';
                loginButton.click();
            }
          ]], username, password1)
          view.evaluateJavascript(jsNormal, nil)
        end
        local cookies = 获取Cookie(url)
        get_homework(cookies)
      end,
      shouldOverrideUrlLoading = function(view, url)
      end
    }
  end

  task(2000,function()
    -- 课表相关逻辑
    local 课表data = this.getSharedData("课表")
    if 课表data == "true" and username then
      -- 创建课表项布局
      kbitem = {
        LinearLayout;
        layout_height = this.getSharedData("课表格子高度");
        gravity = "center";
        {
          LinearLayout;
          layout_height = "fill";
          orientation = "vertical";
          layout_width = "fill";
          gravity = "center";
          {
            TextView;
            layout_height = "match";
            id = "class";
            textColor = "#ffffff";
            textSize = "8";
            layout_width = "fill";
            gravity = "center";
          };
        };
      }
      columns = {}
      zcnum = {"一", "二", "三", "四", "五", "六", "日"}
      data2 = {}
      if this.getSharedData("zcnumber") == nil then
        this.setSharedData("zcnumber", "7")
        this.setSharedData("jcnumber", "7")
      end
      zc = tonumber(this.getSharedData("jcnumber"))
      jc = tonumber(this.getSharedData("zcnumber"))
      dofile(activity.getLuaDir().."/mods/none.lua")
      -- 初始化课表适配器
      adpkb = LuaAdapter(activity, data2, kbitem)

      -- 加载课表数据的函数
      local function load(clsmap, zc, jc)
        local zcx = 0
        local zcrx = 1
        local zcr = 0
        -- 在主线程中设置列数
        mainHandler.post(Runnable({
          run = function()
            kbgrid.setNumColumns(jc + 1)
          end
        }))
        for n = 1, (zc + 1) * (jc + 1) do
          local xqc, tech, zcg, jcg
          if zcxt == zc then
            zcxt = 0
          end
          if n == 1 then -- 占位
            table.insert(data2, {
              class = {
                text = ""
              },
              tech = {
                bzc = nil,
                bjc = nil
              }
            })
            zcg = ""
            xqc = ""
            tech = ""
           elseif (n - 1) % (jc + 1) == 0 then -- 节次
            tech = ""
            zcx = zcx + 1
            if zcx > 5 then
              xqc = "无课表课程"
             else
              xqc = "第"..tostring(zcx).."大节"
            end
            jcr = zcx
            table.insert(data2, {
              class = {
                text = (xqc or "无")
              },
              tech = {
                bzc = nil,
                bjc = nil
              }
            })
           elseif n <= jc + 1 and n > 1 then -- 周次
            tech = ""
            xqc = "周"..(zcnum[n - 1] or "未知")
            table.insert(data2, {
              class = {
                text = ("周"..(zcnum[n - 1] or "未知") or "无")
              },
              tech = {
                bzc = nil,
                bjc = nil,
                zcg = n - 1
              }
            })
           else -- 课程
            zcr = zcr + 1
            if zcr > jc then
              zcrx = zcrx + 1
              zcr = 1
            end
            tech = tostring("")
            zcg = zcr
            jcg = jcr
            if zcr <= #clsmap and jcr <= 8 then
              xqc = tostring(clsmap[jcr][zcr] or "")
             else
              xqc = ""
            end
            table.insert(data2, {
              class = {
                text = (xqc or "")
              },
              tech = {
                bzc = zcg,
                bjc = jcr,
                zcg = zcg
              }
            })
          end
        end
        -- 在主线程中更新适配器
        mainHandler.post(Runnable({
          run = function()
            kbgrid.Adapter = adpkb
          end
        }))
        kbgrid.onItemClick = function(parent, v, pos, id)
          if data2[id].tech.bzc and data2[id].tech.bjc then
            InputLayout = {
              LinearLayout;
              Focusable = true;
              orientation = "horizontal";
              FocusableInTouchMode = true;
              gravity = "center";
              {
                EditText;
                hint = "请输入课程名称";
                layout_gravity = "center";
                singleLine = "true";
                layout_width = "45%w";
                layout_marginTop = "5dp";
                id = "edit";
              };
              {
                Button;
                text = "课程";
                id = "cls";
                layout_gravity = "center";
              };
            }
            AlertDialog.Builder(this)
            .setTitle("周"..zcnum[data2[id].tech.bzc].."的第 "..data2[id].tech.bjc.." 节课")
            .setView(loadlayout(InputLayout))
            .setPositiveButton("确定", {onClick = function()
                if edit.Text == "" then
                  Toast.makeText(activity, "不能为空•ᴗ•", Toast.LENGTH_SHORT).show()
                 else
                  clsmap[data2[id].tech.bjc][data2[id].tech.bzc] = edit.Text
                  load(clsmap, zc, jc)
                  save()
                end
              end})
            .show()
            import "android.graphics.PorterDuffColorFilter"
            import "android.graphics.PorterDuff"
            cls.getBackground().setColorFilter(PorterDuffColorFilter(0xFFFFFFFF, PorterDuff.Mode.SRC_ATOP))
            edit.getBackground().setColorFilter(PorterDuffColorFilter(0xFF0099ff, PorterDuff.Mode.SRC_ATOP))
            edit.Text = v.Tag.class.Text
            cls.onClick = function(v)
              pop = PopupMenu(activity, cls)
              menu = pop.Menu
              for k, v in ipairs(clslist) do
                menu.add(v).onMenuItemClick = function(a)
                  edit.setText(v)
                end
              end
              pop.show()
            end
          end
        end
        kbgrid.onItemLongClick = function(parent, v, pos, id)
          if data2[id].tech.zcg then
            提示("修改第"..zcnum[data2[id].tech.zcg].."周")
          end
          return true
        end
      end

      -- 保存课表数据的函数
      function save(columns)
        clsmap = {}
        adpkb.clear()
        for n = 1, 7 do -- 周次(列数)
          table.insert(clsmap, {})
          for k = 8 * (n - 1) + 2, 8 * n do -- (节次)
            table.insert(clsmap[n], columns[k])
          end
        end
        local mb = [[
clsmap=%s
]]
        -- 在子线程中写入文件
        io.open(activity.getLuaDir().."/mods/none.lua", "w"):write(string.format(mb, dump(clsmap))):close()
        -- 在新线程中加载课表数据
        Thread(Runnable({
          run = function()
            load(clsmap, zc, jc)
          end
        })).start()
      end

      -- 获取课表数据的函数
      function get_kb(localCookie)
        local kburl = "https://jw.stu.edu.cn/jsxsd/framework/mainV_index_loadkb.htmlx?rq="..os.date("%Y-%m-%d").."&sjmsValue=C3481BBB0FE2475787AF8AD9244760C7&xswk=false"
        Thread(Runnable({
          run = function()
            Http.get(kburl, localCookie, nil, nil, function(code, content, cookie, header)
              if string.match(content, [[color\">(第%d+周)]]) then
                mainHandler.post(Runnable({
                  run = function()
                    zhounow.Text = "教学周"..string.match(content, [[color\">(第%d+周)]])
                  end
                }))
              end
              local function parseHtml(html)
                local schedule = {}
                local headerRe = "<thead>(.-)</thead>"
                local headerMatch = string.match(html, headerRe)
                if headerMatch then
                  local headers = {}
                  for th in string.gmatch(headerMatch, "<th[^>]*>(.-)</th>") do
                    table.insert(headers, string.gsub(th, "<[^>]+>", ""):match("^%s*(.-)%s*$"))
                  end
                 else
                  -- 没登录
                end
                local rowsRe = "<tbody>(.-)</tbody>"
                local rowsMatch = string.match(html, rowsRe)
                if rowsMatch then
                  local columns = {}
                  local rowRe = "<tr[^>]*>(.-)</tr>"
                  for rowMatch in string.gmatch(rowsMatch, rowRe) do
                    local columnRe = "<td[^>]*>(.-)</td>"
                    for columnMatch in string.gmatch(rowMatch, columnRe) do
                      local cellContent1 = string.match(columnMatch, ">(.-)<")
                      if string.match(columnMatch, "box") then
                        local course, teacher, section, location = columnMatch:match(
                        "<div class='item%-box'%s*><p>([^<]+)</p>.-教师：([^<]+)</span>.-<span>(%d+~%d+节)</span>.-<span><img src='[^']+'>([^<]+)</span>"
                        )
                        if course and teacher and section and location then
                          if #course > 15 then
                            course = string.sub(course, 1, 15)
                          end
                          columnMatch = course.."\n"..teacher.."\n"..section.."\n"..location
                         else
                          local course = columnMatch:match("<div class='item%-box'%s*><p>([^<]+)</p>")
                          if #course > 15 then
                            course = string.sub(course, 1, 15)
                          end
                          local teacher = columnMatch:match("教师：([^<]+)")
                          local section = columnMatch:match("<span>([^<]+)</span>%s*</div>")
                          local location = columnMatch:match("上课地点：([^<]+)")
                          columnMatch = course.."\n"..teacher.."\n"..section.."\n"..location
                        end
                       else
                        if #columnMatch > 27 then
                          columnMatch = columnMatch:gsub("&nbsp;", " ")
                          columnMatch = string.sub(columnMatch, 1, 27)
                        end
                      end
                      local aaaa = "\13\
                                            \13\
                                        "
                      columnMatch = string.gsub(columnMatch, aaaa, " ")
                      table.insert(columns, columnMatch)
                    end
                  end
                  save(columns)
                  提示("课表刷新成功")
                end
              end
              parseHtml(content)
            end)
          end
        })).start()
      end

      kbweb.setWebViewClient{
        onPageFinished = function(view, url)
          if url:match("login") then
            local jsNormal = string.format([[
            var usernameInput = document.getElementById('username');
            var passwordInput = document.getElementById('password');
            var loginButton = document.getElementById('login');
            if (usernameInput && passwordInput && loginButton) {
                usernameInput.value = '%s';
                passwordInput.value = '%s';
                loginButton.click();
            }
          ]], username, password1)
            view.evaluateJavascript(jsNormal, nil)
          end
          local localCookie = 获取Cookie(url)
          get_kb(localCookie)
        end,
        shouldOverrideUrlLoading = function(view, url)
        end
      }
      kbweb.loadUrl("https://jw.stu.edu.cn")
      Thread(Runnable({
        run = function()
          load(clsmap, zc, jc)
        end
      })).start()
      课表view.setVisibility(View.VISIBLE)
      translation = TranslateAnimation(0, 0, 课表view.getY() - 300, 课表view.getY())
      translation.setDuration(200)
      translation.setRepeatCount(0)
      课表view.startAnimation(translation)
      课表view.setVisibility(View.VISIBLE)
    end
  end)


  -- OA系统相关逻辑
  local OAdata = this.getSharedData("OA")
  if OAdata == "true" then
    local item = {
      LinearLayout,
      layout_width = "match_parent",
      layout_height = "wrap_content",
      orientation = "vertical",
      {
        TextView,
        id = "text",
        layout_width = "match_parent",
        layout_height = "wrap_content",
        textSize = "12sp",
        textColor = "#FFFFFF",
        padding = "16dp"
      }
    }

    -- 获取文档详情的函数
    function get_doc_detail(DocID)
      local params = "token="..TokenOa.."&docid="..tostring(math.floor(DocID))
      Thread(Runnable({
        run = function()
          Http.post('http://wechat.stu.edu.cn/webservice_oa/oa_stu_/GetDOCDetailByID', params, nil, nil, nil,
          function(status, response)
            if status == 200 then
              local success, data = pcall(cjson.decode, response)
              if not success then
                提示("JSON decode error: "..data)
                return
              end
              if data and #data > 0 then
                local temp_doccontent = data[1].DOCCONTENT
                temp_doccontent = clean_doc_content(temp_doccontent)
                -- 清理HTML标签和特殊符号
                local cleanText = temp_doccontent:gsub("!@#$%^&*", "") -- 先去除开头的特殊符号
                :gsub("<.->", "") -- 去除所有HTML标签
                :gsub("%s+", " ") -- 合并多余空格
                :gsub(" ", " ") -- 处理HTML空格实体（如有）
                :gsub("^%s*(.-)%s*$", "%1") -- 去除首尾空白
                local 训练file = io.open(activity.getLuaDir() .. "/res/OATrainDoc.txt", "r")
                if 训练file ~= "" and 训练file then
                  训练文件 = 训练file:read("*a")
                  训练file:close()
                end
                local conversationHistory = {
                  {role = "system", content = "你是一个高效的信息筛选助手，用最简短的语句判断通知是否与学生相关。回复必须：1)不超过50字 2)使用HTML格式 3)相关年级用红色标记 4)无关内容直接说'无用'。"..训练文件},
                  {role = "user", content = "这是汕头大学OA通知，请快速判断哪些年级需要注意什么。记住：不总结、不解释、只说关键，像朋友聊天那样回复。"},
                  {role = "assistant", content = "Got it！我会像贴吧老哥一样直接甩重点，<span style='color:red'>年级</span>标红，没用的直接说'无用'。"},
                  {role = "user", content = "待处理通知："..cleanText}
                }
                ai(conversationHistory, function(success, response)
                  print(response)
                  if success then
                    niceresponse=response:gsub("```html", ""):gsub("```", ""):gsub("^%s+", ""):gsub("%s+$", "")
                    showOAMessage(niceresponse)
                  end
                end)
                mainHandler.post(Runnable({
                  run = function()
                    div_doc.loadData(temp_doccontent, "text/html", "UTF-8")
                    local int_accessorycount = tonumber(data[1].ACCESSORYCOUNT)
                    if int_accessorycount ~= 0 then
                      div_accessory.removeAllViews() -- 添加这行，清空旧附件
                      div_accessory.setVisibility(View.VISIBLE)
                      local params = "token="..TokenOa.."&docid="..tostring(math.floor(DocID))
                      Thread(Runnable({
                        run = function()
                          Http.post('http://wechat.stu.edu.cn/webservice_oa/oa_stu_/GetDOCAccessory', params, nil, nil, nil,
                          function(status, response)
                            if status == 200 then
                              local success, accessory_list = pcall(cjson.decode, response)
                              if not success then
                                提示("JSON decode error: "..accessory_list)
                                return
                              end
                              mainHandler.post(Runnable({
                                run = function()
                                  for i = 1, #accessory_list do
                                    local accessory = accessory_list[i]
                                    local temp_url = "http://oa.stu.edu.cn/weaver/weaver.file.FileDownload?fileid="..tostring(math.floor(accessory.IMAGEFILEID)).."&download=1&requestid=0"
                                    local temp_a = TextView(activity)
                                    temp_a.setText(Html.fromHtml('<a href="'..temp_url..'">'..accessory.IMAGEFILENAME..'</a>'))
                                    temp_a.onClick = function()
                                      下载文件(temp_url, accessory.IMAGEFILENAME)
                                    end
                                    div_accessory.addView(temp_a)
                                    local br = TextView(activity)
                                    br.setText("\n")
                                    div_accessory.addView(br)
                                  end
                                end
                              }))
                            end
                          end)
                        end
                      })).start()
                    end
                  end
                }))
              end
            end
          end)
        end
      })).start()
    end
    function clean_doc_content(content)
      -- 移除无用的 HTML 标签（如 <o:p>, <xml>, <![if gte mso 9]>, 等）
      content = content:gsub("<o:p>.-</o:p>", "")
      content = content:gsub("<xml>.-</xml>", "")
      content = content:gsub("<!%-%-.-%-%->", "") -- 移除注释
      content = content:gsub("%[if.-%[endif%]", "")
      content = content:gsub("<style>.-</style>", "")
      content = content:gsub("<script>.-</script>", "")
      content = content:gsub("<w:.->", "") -- 移除 Word 相关的标签

      -- 替换 HTML 实体
      content = content:gsub("&nbsp;", " ")
      content = content:gsub("&lt;", "<")
      content = content:gsub("&gt;", ">")
      content = content:gsub("&amp;", "&")
      content = content:gsub("&quot;", "\"")
      content = content:gsub("&apos;", "'")
      content = content:gsub("&ldquo;", "“")
      content = content:gsub("&rdquo;", "”")
      content = content:gsub("&lsquo;", "‘")
      content = content:gsub("&rsquo;", "’")
      content = content:gsub("&middot;", "·")

      -- 移除多余的空格和换行符
      content = content:gsub("%s+", " ") -- 多个空格替换为单个空格
      content = content:gsub("^%s*(.-)%s*$", "%1") -- 移除首尾空格


      return content
    end
    -- 获取文档列表的函数
    function get_doc(start, end_)
      local params = "token="..TokenOa..
      "&subcompany_id="..search_subcompany_id..
      "&keyword="..search_keyword..
      "&row_start="..tostring(start)..
      "&row_end="..tostring(end_)
      Thread(Runnable({
        run = function()
          Http.post('http://wechat.stu.edu.cn/webservice_oa/oa_stu_/GetDoc',
          params, nil, nil, nil,
          function(code, body)
            if code == 200 then
              local success, doclist = pcall(cjson.decode, body)
              if not success then
                提示("JSON decode error: "..doclist)
                return
              end
              local docItems = {}
              for i = 1, #doclist do
                local item = doclist[i]
                local listItem = item.DOCSUBJECT.." 发布时间："..item.DOCVALIDDATE.." "..item.DOCVALIDTIME.." 发布部门:"..item.SUBCOMPANYNAME
                table.insert(docItems, {text = listItem, id = item.ID})
              end
              mainHandler.post(Runnable({
                run = function()
                  local adapter = LuaAdapter(activity, docItems, item)
                  doc_ul.Adapter = adapter
                  doc_ul.onItemClick = function(parent, view, position, id)
                    local clickedItem = docItems[position + 1]
                    local url_oa_detail = string.format("OA_detail.html?TokenOa=%s&DocID=%s&CurrentPageNo=%d&PageContainsRecord=%d",
                    TokenOa, clickedItem.id, CurrentPageNo, PageContainsRecord)
                    get_doc_detail(clickedItem.id)
                    detailSpace.setVisibility(View.VISIBLE)
                    translation = TranslateAnimation(0, 0, 1500, 0)
                    translation.setDuration(300)
                    translation.setRepeatCount(0)
                    SpaceBottom.startAnimation(translation)
                  end
                  列表逐显动画(doc_ul, 0.1)
                end
              }))
            end
          end)
        end
      })).start()
    end

    -- 获取文档总数的函数
    function get_docnum()
      if TokenOa then
        local params = "token="..TokenOa.."&subcompany_id="..search_subcompany_id.."&keyword="..search_keyword
        Thread(Runnable({
          run = function()
            Http.post('http://wechat.stu.edu.cn/webservice_oa/oa_stu_/GetDocNum', params, nil, nil, nil,
            function(code, body)
              if code == 200 then
                DocNum = tonumber(body)
                mainHandler.post(Runnable({
                  run = function()
                  end
                }))
              end
            end)
          end
        })).start()
      end
    end

    -- 获取子公司列表的函数
    function get_subcompany()
      local params = "token="..TokenOa
      Thread(Runnable({
        run = function()
          Http.post('http://wechat.stu.edu.cn/webservice_oa/oa_stu_/GetSubcompany', params, nil, nil, nil,
          function(code, body)
            if code == 200 then
              local data = cjson.decode(body)
              mainHandler.post(Runnable({
                run = function()
                  local options = {"全部"}
                  subcompanyIds = {0}
                  for i = 1, #data do
                    table.insert(options, data[i].SUBCOMPANYNAME)
                    table.insert(subcompanyIds, data[i].ID)
                  end
                  local oachooseadapter = ArrayAdapter(activity, android.R.layout.simple_spinner_item, options)
                  select_subcompany.setAdapter(oachooseadapter)
                  select_subcompany.setSelection(0)
                end
              }))
            end
          end)
        end
      })).start()
    end

    -- 计算文档列表起始和结束行的函数
    function calculate_start_end()
      row_start = (CurrentPageNo - 1) * PageContainsRecord
      if row_start + PageContainsRecord < DocNum then
        row_end = row_start + PageContainsRecord
       else
        row_end = DocNum - 1
      end
      mainHandler.post(Runnable({
        run = function()
          label_current_pagenum.Text = "当前是第"..tostring(CurrentPageNo).."页"
        end
      }))
    end

    -- 执行搜索的函数
    function exec_search()
      DocNum = 100
      CurrentPageNo = 1
      PageContainsRecord = 10
      get_docnum()
      Thread(Runnable({
        run = function()
          while DocNum == nil do
            Thread.sleep(100)
          end
          mainHandler.post(Runnable({
            run = function()
              calculate_start_end()
              get_doc(row_start, row_end)
            end
          }))
        end
      })).start()
    end

    if TokenOa then
      exec_search() -- 调用刷新逻辑
    end

    -- 定义刷新函数
    local function refreshOA()
      if TokenOa then
        exec_search() -- 调用刷新逻辑
      end
    end

    -- 创建定时任务
    local refreshRunnable = Runnable({
      run = function()
        refreshOA() -- 执行刷新
        mainHandler.postDelayed(refreshRunnable, refreshIntervalMillis) -- 重新调度任务
      end
    })

    -- 启动定时任务
    mainHandler.postDelayed(refreshRunnable, refreshIntervalMillis)

    btn_previous.onClick = function()
      if CurrentPageNo > 1 then
        CurrentPageNo = CurrentPageNo - 1
        calculate_start_end()
        get_doc(row_start, row_end)
      end
    end

    btn_next.onClick = function()
      if CurrentPageNo < (DocNum / PageContainsRecord) then
        CurrentPageNo = CurrentPageNo + 1
        calculate_start_end()
        get_doc(row_start, row_end)
      end
    end

    btn_can_search.onClick = function()
      local current_text = btn_can_search.Text
      if current_text == "显示查询" then
        get_subcompany()
        btn_can_search.Text = "隐藏查询"
        div_search.Visibility = View.VISIBLE
       else
        btn_can_search.Text = "显示查询"
        div_search.Visibility = View.GONE
        search_subcompany_id = 0
        search_keyword = ""
        exec_search()
      end
    end

    select_subcompany.setOnItemSelectedListener({
      onItemSelected = function(parent, view, position, id)
        search_subcompany_id = tostring(math.floor((subcompanyIds[position + 1])))
      end
    })

    btn_search.onClick = function()
      --search_subcompany_id = select_subcompany.getSelectedItem()
      提示("查询中")
      search_keyword = textbox_keyword.Text
      exec_search()
    end

    setupNestedScrolling(doc_ul, fun1ScrollView)
    OAview.setVisibility(View.VISIBLE)
    translation = TranslateAnimation(0, 0, OAview.getY() - 300, OAview.getY())
    translation.setDuration(200)
    translation.setRepeatCount(0)
    OAview.startAnimation(translation)
    OAview.setVisibility(View.VISIBLE)
  end
end


-- 以下为各个链接点击后的跳转函数
function 学校官网()
  url = "http://www.stu.edu.cn/"
  web弹窗 = "汕头大学的主官网\n\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 本部本科生电子成绩单证明平台()
  url = "https://jwc.stu.edu.cn/"
  web弹窗 = "本部本科生电子成绩单证明平台\n在校生用户名为学号，初始密码为身份证后六位，毕业生账号为身份证\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 东校区官网()
  url = "https://stuecc.stu.edu.cn/"
  web弹窗 = "东海岸校区官网\n这是东校区的官网\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 图书馆()
  url = "https://www.lib.stu.edu.cn/"
  web弹窗 = "图书馆\n汕头大学图书馆官方网站\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function OA系统()
  url = "http://oa.stu.edu.cn/"
  activity.newActivity("webliulan", {nil, url})
end

function MYSTU()
  url = "https://my.stu.edu.cn/"
  web弹窗 = "MYSTU\n注意:进不去请连接校园网\n在这里可以查看自己选修的课程有没有发布什么，包括作业课件资料等等，记得要常看防止错过提示\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 教务系统()
  url = "https://jw.stu.edu.cn"
  web弹窗 = "汕大教务系统\n进行有关教务的一系列操作\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 测试论坛()
  activity.newActivity("Forum")
end

function 学工系统()
  url = "http://xg.stu.edu.cn/"
  web弹窗 = "学工系统\n包含学生事务，宿舍服务，心理服务，资助服务，奖惩服务五大块，可在这里申请奖学金和勤工俭学等等\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 本科教学质量保障平台()
  url = "https://quality.stu.edu.cn/home"
  web弹窗 = "本科教学质量保障平台\n网址：https://quality.stu.edu.cn\n暂无介绍\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 信息公开网()
  url = "https://info.stu.edu.cn/"
  web弹窗 = "信息公开网\n暂无"..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 网络信息中心()
  AlertDialog.Builder(this)
  .setTitle("结果")
  .setMessage("请关注汕头大学服务号，在服务号中上自行进入\nBy 言和")
  .setPositiveButton("知道了", function() end)
  .show()
end

function 东海岸报修()
  url = "https://r.stu.edu.cn/"
  web弹窗 = "东海岸报修\n暂无\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 本部报修()
  url = "http://repair.stu.edu.cn/"
  web弹窗 = "桑浦山报修\n暂无\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 教室预约()
  url = "http://classroom.stu.edu.cn/"
  web弹窗 = "暂无\n暂无\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function SLC()
  url = "https://slc.stu.edu.cn/"
  web弹窗 = "SLC学习互助中心\n暂无\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 水电系统()
  url = "http://power.stu.edu.cn/"
  web弹窗 = "水电系统\n可在这里进行水电费缴费\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 网络教学平台()
  url = "http://stu.fanya.chaoxing.com/portal"
  web弹窗 = "网络教学平台\n是汕大的网络课程平台\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 宿舍管理()
  url = "http://dorm.stu.edu.cn/"
  web弹窗 = "暂无\n暂无\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 活动预约()
  url = "https://booking.stu.edu.cn/MainFrame.aspx"
  web弹窗 = "活动预约中心\n在这里可以预约一些校内活动。\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 实验室安全考试系统()
  url = "http://sysaq.stu.edu.cn/"
  web弹窗 = "实验室安全考试系统\n学生入实验室前要通过实验室安全系统考核。初始密码一般为123456\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 毕业查成绩()
  url = "http://202.192.149.206/transcript_server/login"
  web弹窗 = [[毕业后查成绩/GPA/排名/四六级成绩单 免费下载电子版
·网址：http://202.192.149.206/transcript_server/login
·登录帐号和密码：
在校生登录方式：用户名为学号，初始密码为身份证后六位
毕业生：用户名为身份证号码，初始密码为身份证后六位]]..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 教务处()
  url = "https://jwc.stu.edu.cn/"
  web弹窗 = "教务处官网\n可查看相关教学安排和考试通知(虽然OA也有)\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 人事处()
  url = "https://rsc.stu.edu.cn"
  web弹窗 = "人事处官网\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 学生处()
  url = "https://xsc.stu.edu.cn/"
  web弹窗 = "学生处官网\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 文学院()
  url = "https://www.wxy.stu.edu.cn/"
  web弹窗 = "文学院官网\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 工学院()
  url = "https://eng.stu.edu.cn/"
  web弹窗 = "工学院官网\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 理学院()
  url = "https://sci.stu.edu.cn/"
  web弹窗 = "理学院官网\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 法学院()
  url = "https://law.stu.edu.cn/"
  web弹窗 = "法学院官网\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 商学院()
  url = "https://biz.stu.edu.cn/"
  web弹窗 = "商学院官网\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 医学院()
  url = "http://www.med.stu.edu.cn/"
  web弹窗 = "医学院官网\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 长江艺设学院()
  url = "https://ckad.stu.edu.cn/"
  web弹窗 = "长江艺设学院官网\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 长江新传学院()
  url = "https://media.stu.edu.cn/"
  web弹窗 = "长江新传学院官网\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 研究生学院()
  url = "http://gs.stu.edu.cn/"
  web弹窗 = "研究生院官网\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 继续教育学院()
  url = "https://sce.stu.edu.cn/"
  web弹窗 = "研究生院官网\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 校友会()
  url = "https://xyh.stu.edu.cn"
  web弹窗 = "校友会官网\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function NETMS()
  url = "https://netms.stu.edu.cn/"
  web弹窗 = "NETMS\n可购买校园网上网套餐等等\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 研究生管理系统()
  url = "http://192.168.48.143"
  web弹窗 = "研究生管理系统官网\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 物理实验虚拟仿真中心()
  url = "http://192.168.70.28/"
  web弹窗 = "NETMS\n包含物理实验虚拟仿真教学平台选排课系统等，登录用户名：学号，初始密码：学号\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 预约中心()
  url = "http://ehall.stu.edu.cn/"
  web弹窗 = "\n暂无\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function Booking()
  url = "https://my.stu.edu.cn/courses/elc/blocks/mrbs/web/day.php?_f=r/"
  web弹窗 = "\n暂无\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 大型仪器共享管理系统()
  url = "http://zxsys.stu.edu.cn/genee/"
  web弹窗 = "\n暂无\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 医学院OA()
  url = "http://int.med.stu.edu.cn/"
  web弹窗 = "暂无\n网址："..url.."\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 校内邮箱()
  web弹窗 = "邮箱\n暂无\n\nBy 言和"
  url = "m.stu.edu.cn"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 本周课表()
  url = "https://jw.stu.edu.cn/jsxsd/framework/mainV_index_loadkb.htmlx?rq=2024-06-03&sjmsValue=C3481BBB0FE2475787AF8AD9244760C7&xnxqid=2023-2024-2&xswk=true"
  web弹窗 = "课表\n注意：打开课表前先进一次教务系统再退出后进入，否则有时会卡住\n可以快速查看课表\n\nBy 言和"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 校历()
  弹窗 = {
    FrameLayout,
    layout_width = 'fill',
    {
      LinearLayout,
      orientation = 'vertical',
      layout_width = 'fill',
      {
        PhotoView;
        src = 'image/wallpaper/table2.jpg';
        layout_width = 'fill';
        layout_height = 'match_parent';
        layout_gravity = 'center';
      };
    };
  }
  xxx = AlertDialog.Builder(this)
  xxx.setTitle("双指放大")
  xxx.setView(loadlayout(弹窗))
  xxx.setPositiveButton("知道了", nil)
  xxx = xxx.show()
  import "android.graphics.drawable.ColorDrawable"
  xxx.getWindow().setBackgroundDrawable(ColorDrawable(0x00000000))
end

function 脑力奥运()
  web弹窗 = "需要Flash插件，目前软件内无法正常使用，请复制去电脑浏览器打开\n\nBy 言和"
  url = "http://io.stu.edu.cn/web/"
  activity.newActivity("webliulan", {web弹窗, url})
end

function 一卡通查询()
  io.open(activity.getLuaDir().."/set/message.txt", "a"):write(""):close()
  localMs = io.open(activity.getLuaDir().."/set/message.txt"):read("*a")
  if localMs == "" then
    提示("请先点右上角登录！")
   else
    url = "http://wechat.stu.edu.cn/wechat/smartcard/Smartcard_cardbalance"
    activity.newActivity("webliulan", {nil, url})
  end
end

function 一卡通挂失()

  web弹窗="暂无\n暂无\n\nBy 言和"
  url = "http://smartcard.stu.edu.cn/"
  activity.newActivity("webliulan",{web弹窗,url})
end


function 网络故障报修()

  web弹窗="网络故障报修\n暂无\n\nBy 言和"
  url = "http://its.stu.edu.cn/selfdesk/myportal"
  activity.newActivity("webliulan",{web弹窗,url})
end

function 金凤BT()

  web弹窗="桑浦山报修\n暂无\n\nBy 言和"
  url = "http://phoenix.stu.edu.cn/"
  activity.newActivity("webliulan",{web弹窗,url})
end

function 文献查找()

  web弹窗="文献查找\n是图书馆的免费已购资源\n\nBy 言和"
  url = "https://www.lib.stu.edu.cn/zy/database"
  activity.newActivity("webliulan",{web弹窗,url})
end

function 狐友树洞()
  url = "https://h5-ol.sns.sohu.com/hy-super-h5/share/circle/871443012725706368?subChannelId=share_871443012725706368_1029932943788934528&sf_hy_new=copylink"
  activity.newActivity("webliulan",{web弹窗,url})
end

function 微博树洞()
  web弹窗="汕大树洞\n发言遵守相关法规\n\nBy 言和"
  url = "http://www.openstu.com/m/"
  activity.newActivity("webliulan",{web弹窗,url})
end

function 东校区地图()
  url = "https://stuecc.stu.edu.cn/xqgl/xqdt.htm"
  跳转网页(url)
end

function 校内Office365下载()
  web弹窗="学校内提供的office365系列免流量下载\n\nBy 言和"
  url = "http://support.stu.edu.cn/office365/download.html"
  activity.newActivity("webliulan",{web弹窗,url})
end

function 校内直播()
  url = "http://itv.stu.edu.cn/PsMobile_Web/phone/Phone_Home.aspx"
  activity.newActivity("webliulan",{nil,url})
end

function 校内电话大全()
  url = "https://d.stulip.org/sp/tell.html"
  提示("致敬汕大郁金香\n网址："
  .. url
  .. "\n注：此表格由郁金香站STUlip.org整理\nBy 言和")
  activity.newActivity("webliulan",{web弹窗,url})
end

function 综测注解()
  url = "https://docs.qq.com/doc/DTll3ZFFOY3FtTXhL"
  提示("此为综测注解(工学院版)，剔除废话同时增加注解，摆脱迷茫，科学上分\n\nBy 言和")
  activity.newActivity("webliulan",{"否",url})
end

function 校招()
  url = "http://stdx.bczp.cn/"
  activity.newActivity("webliulan",{nil,url})
end