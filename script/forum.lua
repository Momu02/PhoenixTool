require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "page.forum_layout.forum"
import "http"
import "cjson"
import "com.narcissus.encrypt.*"

-- 显示加载对话框
local dialog = ProgressDialog.show(this, nil, "加载中..", false, true).hide()
dialog.show()

-- 设置主题和布局
activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
activity.setContentView(loadlayout(forum))

-- 设置标题和按钮的字体加粗
title.getPaint().setFakeBoldText(true)

-- 定义变量
url, admin, user, password, key, plateId, isEncrypt, secret = ...

-- 列表逐显动画
列表逐显动画(list, 0.1)

-- 返回按钮事件
exit.onClick = function()
  activity.finish()
end

-- 分页数，初始为0
local num = 0

-- 定义列表布局
local layoutList = {
  LinearLayout;
  layout_width = "fill";
  backgroundColor = grayc;
  layout_height = "fill";
  {
    LinearLayout;
    layout_width = "match_parent";
    orientation = "vertical";
    layout_marginTop = "3dp";
    {
      LinearLayout;
      gravity = "center";
      orientation = "horizontal";
      layout_margin = "10dp";
      {
        CardView;
        radius = "20dp";
        layout_width = "46dp";
        id = "帖主主页";
        CardElevation = "0dp";
        layout_height = "46dp";
        {
          ImageView;
          id = "head";
          layout_width = "match_parent";
          scaleType = "centerCrop";
          layout_height = "match_parent";
        };
      };
      {
        LinearLayout;
        layout_gravity = "left";
        orientation = "vertical";
        layout_margin = "match_parent";
        {
          TextView;
          id = "name";
          text = "name";
          Typeface = 字体("product");
          layout_marginLeft = "5dp";
          textColor = textc;
        };
        {
          TextView;
          id = "time";
          text = "time";
          textColor = textc;
          typeface = Typeface.DEFAULT_BOLD,
          layout_marginLeft = "6dp";
          textSize = "13sp";
        };
      };
      {
        TextView;
        layout_marginLeft = "10dp";
        textColor = "#FF0000";
        Typeface = 字体("product");
        id = "top";
      };
    };
    {
      TextView;
      id = "title";
      text = "title";
      Typeface = 字体("product");
      layout_marginLeft = "10dp";
      textColor = textc;
      textSize = "16sp";
    };
    {
      TextView;
      id = "content";
      text = "content";
      textColor = textc;
      layout_margin = "5dp";
    };
    {
      LinearLayout;
      layout_marginRight = "10dp";
      layout_marginLeft = "10dp";
      layout_width = "wrap_content";
      {
        CardView;
        CardElevation = "0dp";
        layout_height = "wrap_content";
        radius = "10dp";
        layout_width = "match_parent";
        layout_weight = "1";
        {
          ImageView;
          id = "img1";
          maxWidth = "100dp";
          scaleType = "centerCrop";
          layout_height = "match_parent";
          maxHeight = "100dp";
          layout_width = "match_parent";
          adjustViewBounds = "true";
        };
      };
      {
        CardView;
        CardElevation = "0dp";
        layout_height = "wrap_content";
        radius = "10dp";
        layout_width = "match_parent";
        layout_marginLeft = "10dp";
        layout_weight = "1";
        {
          ImageView;
          id = "img2";
          maxWidth = "100dp";
          scaleType = "centerCrop";
          layout_height = "match_parent";
          maxHeight = "100dp";
          layout_width = "match_parent";
          adjustViewBounds = "true";
        };
      };
      {
        CardView;
        CardElevation = "0dp";
        layout_height = "wrap_content";
        radius = "10dp";
        layout_width = "match_parent";
        layout_marginLeft = "10dp";
        layout_weight = "1";
        {
          ImageView;
          id = "img3";
          maxWidth = "100dp";
          scaleType = "centerCrop";
          layout_height = "match_parent";
          maxHeight = "100dp";
          layout_width = "match_parent";
          adjustViewBounds = "true";
        };
      };
    };
    {
      LinearLayout;
      layout_width = "match_parent";
      layout_margin = "10dp";
      {
        LinearLayout;
        layout_gravity = "center";
        layout_width = "100dp";
        layout_marginLeft = "20dp";
        layout_margin = "10dp";
        {
          ImageView;
          src = activity.getLuaDir() .. "/image/icon/views.png";
          layout_width = "18dp";
          colorFilter = textc;
          layout_height = "18dp";
        };
        {
          TextView;
          id = "watch";
          text = "watch";
          layout_marginLeft = "10dp";
          textColor = textc;
          textSize = "13sp";
        };
      };
      {
        LinearLayout;
        layout_gravity = "center";
        layout_width = "100dp";
        layout_margin = "10dp";
        {
          ImageView;
          src = activity.getLuaDir() .. "/image/icon/Comments.png";
          layout_width = "18dp";
          colorFilter = textc;
          layout_height = "18dp";
        };
        {
          TextView;
          id = "comment";
          layout_marginLeft = "10dp";
          text = "comment";
          textColor = textc;
          textSize = "13sp";
        };
      };
      {
        LinearLayout;
        layout_gravity = "center";
        layout_width = "100dp";
        layout_margin = "10dp";
        {
          ImageView;
          src = activity.getLuaDir() .. "/image/icon/LoveWrite.png";
          layout_width = "18dp";
          colorFilter = textc;
          layout_height = "18dp";
        };
        {
          TextView;
          id = "praise";
          layout_marginLeft = "10dp";
          text = "praise";
          textColor = textc;
        };
      };
    };
    {
      TextView;
      id = "forumId";
      visibility = 8;
    };
    {
      TextView;
      visibility = 8;
      id = "usersss";
    };
  };
};

local function loadList(num, new, isRefresh)
  if new == false then
    adp = LuaAdapter(activity, layoutList)
  end
  searchList.setVisibility(View.GONE)

  -- 声明接口
  local api = url .. "main/api/forum/forum_list.php"
  local codekey = isEncrypt and Narcissus.encrypt(key) or key

  -- 请求体
  local body = {
    admin = admin,
    user = user,
    password = password,
    num = tostring(num),
    plate_id = plateId,
    key = codekey
  }

  -- 发送 HTTP 请求
  Http.post(api, body, nil, nil, function(code, body)
    if code == 200 then
      local data = cjson.decode(body)
      if data.code == 1 then
        local data = data.data
        if #data ~= 0 then
          space.setVisibility(View.GONE)
          list.setVisibility(View.VISIBLE)

          if #data < 10 then
            newList = 0 -- 没有更多数据了
          end

          for i, v in ipairs(data) do
            local item = data[i]
            local forumContent = utf8.len(item.content) > 30 and utf8.sub(item.content, 0, 30) .. "…" or item.content
            local top = tointeger(item.top) == 1 and "置顶" or ""

            adp.add{
              head = item.head,
              name = item.name,
              title = item.title,
              content = forumContent,
              usersss = item.user,
              img1 = item.image_1,
              img2 = item.image_2,
              img3 = item.image_3,
              watch = item.watch,
              praise = tointeger(item.praise),
              comment = tointeger(item.comment),
              time = item.time,
              forumId = item.id,
              top = top
            }
          end

          dialog.dismiss()
          if new then
            adp.notifyDataSetChanged()
           else
            list.Adapter = adp
          end

          -- 根据 isRefresh 判断是下拉刷新还是上拉加载
          if isRefresh then
            Pulling.refreshFinish(0) -- 下拉刷新成功
           else
            Pulling.loadmoreFinish(0) -- 上拉加载成功
          end
         else
          newList = 0 -- 没有更多数据了
          if new == false then
            space.setVisibility(View.VISIBLE)
            list.setVisibility(View.GONE)
          end

          -- 根据 isRefresh 判断是下拉刷新还是上拉加载
          if isRefresh then
            Pulling.refreshFinish(0) -- 下拉刷新成功，但没有新数据
            提示("没有数据")
           else
            Pulling.loadmoreFinish(2) -- 上拉加载没有更多数据
          end
        end
       else
        提示("请求失败：" .. data.msg)
        -- 请求失败时，结束刷新或加载
        if isRefresh then
          Pulling.refreshFinish(1) -- 下拉刷新失败
         else
          Pulling.loadmoreFinish(1) -- 上拉加载失败
        end
      end
     else
      提示("HTTP 请求失败，错误码：" .. code)
      -- 请求失败时，结束刷新或加载
      if isRefresh then
        Pulling.refreshFinish(1) -- 下拉刷新失败
       else
        Pulling.loadmoreFinish(1) -- 上拉加载失败
      end
    end
  end)
end

-- 初始化加载列表
loadList(num, false, true)

list.setOnScrollListener{
  onScrollStateChanged = function(l, scrollState)
    -- 判断是否滑动到底部
    if scrollState == AbsListView.OnScrollListener.SCROLL_STATE_IDLE then
      if list.getLastVisiblePosition() == list.getCount() - 1 then
        -- 滑动到底部，触发上拉加载
        if newList == nil then
          Pulling.PullUpEnabled = true -- 启用上拉加载
        end
       else
        -- 如果不是底部，禁用上拉加载
        Pulling.PullUpEnabled = false
      end
    end
  end,

  onScroll = function(l, firstVisibleItem, visibleItemCount, totalItemCount)
    -- 判断是否滑动到顶部
    if firstVisibleItem == 0 then
      Pulling.PullDownEnabled = true -- 启用下拉刷新
     else
      Pulling.PullDownEnabled = false -- 禁用下拉刷新
    end
  end
}

refresh.onClick = function()
  dialog = ProgressDialog.show(this, nil, "加载中..", false, false).hide()
  dialog.show()
  adp.clear()
  loadList(num, false, true) -- 重新加载第一页数据，isRefresh = true
end

-- 设置 PullingLayout 的下拉刷新和上拉加载事件
Pulling.onRefresh = function(v)
  -- 下拉刷新逻辑
  num = 0 -- 重置分页数
  loadList(num, false, true) -- 重新加载第一页数据，isRefresh = true
end

Pulling.onLoadMore = function(v)
  -- 上拉加载更多逻辑
  if newList == nil then -- 如果还有更多数据
    Pulling.PullUpEnabled = false
    num = num + 1 -- 分页数加 1
    loadList(num, true, false) -- 加载下一页数据，isRefresh = false
   else
    v.loadmoreFinish(2) -- 没有更多数据，2 表示没有新内容
  end
end

-- 列表点击事件
list.onItemClick = function(parent, v, pos, id)
  local forumId = v.Tag.forumId.Text
  local usersss = v.Tag.usersss.Text
  activity.newActivity("script/forumQuery", {url, admin, user, password, key, forumId, isEncrypt, secret})

  v.Tag.帖主主页.onClick = function()
    activity.newActivity("script/otherhome", {url, admin, user, password, key, isEncrypt, secret, usersss})
  end
end

-- 搜索列表加载函数
local function loadSearchList(num, new)
  if new == false then
    searchAdp = LuaAdapter(activity, layoutList)
  end
  list.setVisibility(View.GONE)
  searchList.setVisibility(View.VISIBLE)

  local api = url .. "main/api/forum/forum_search.php"
  local codekey = isEncrypt and Narcissus.encrypt(key) or key

  local body = {
    admin = admin,
    user = user,
    password = password,
    num = tostring(num),
    plate_id = plateId,
    content = searchContent,
    key = codekey
  }

  Http.post(api, body, nil, nil, function(code, body)
    if code == 200 then
      local data = cjson.decode(body)
      if data.code == 1 then
        local data = data.data
        if #data ~= 0 then
          space.setVisibility(View.GONE)

          if #data == 10 then
            searchNewList = nil
          end

          for i, v in ipairs(data) do
            local item = data[i]
            local forumContent = utf8.len(item.content) > 30 and utf8.sub(item.content, 0, 30) .. "…" or item.content

            searchAdp.add{
              head = item.head,
              name = item.name,
              title = item.title,
              content = forumContent,
              img1 = item.image_1,
              img2 = item.image_2,
              img3 = item.image_3,
              watch = item.watch,
              praise = tointeger(item.praise),
              comment = tointeger(item.comment),
              time = item.time,
              forumId = item.id
            }
          end

          if new then
            searchAdp.notifyDataSetChanged()
           else
            searchList.Adapter = searchAdp
          end
         else
          searchNewList = 0
          if new == false then
            space.setVisibility(View.VISIBLE)
            searchList.setVisibility(View.GONE)
          end
        end
       else
        提示(data.msg)
      end
     else
      提示("HTTP请求失败，错误码：" .. code)
    end
  end)
end

-- 搜索列表点击事件
searchList.onItemClick = function(parent, v, pos, id)
  local forumId = v.Tag.forumId.Text
  activity.newActivity("script/forumQuery", {url, admin, user, password, key, forumId, isEncrypt, secret})
end

-- 搜索按钮事件
searchButton.onClick = function()
  searchContent = content.Text
  if searchContent ~= "" then
    searchNum = 0
    loadSearchList(searchNum, false)
  end
end

-- 搜索列表下滑到底事件，加载分页
searchList.setOnScrollListener{
  onScrollStateChanged = function(l, s)
    if searchList.getLastVisiblePosition() == searchList.getCount() - 1 then
      if searchNewList == nil then
        searchNewList = 1
        searchNum = searchNum + 1
        loadSearchList(searchNum, true)
      end
    end
  end
}

-- 编辑框监听事件
content.addTextChangedListener({
  onTextChanged = function()
    if content.Text == "" then
      list.setVisibility(View.VISIBLE)
      space.setVisibility(View.GONE)
      searchList.setVisibility(View.GONE)
    end
  end
})

-- 发表按钮事件
issue.onClick = function()
  activity.newActivity("script/issue", {url, admin, user, password, key, plateId, isEncrypt, secret})
end

-- 板块管理员按钮事件
plateAdmin.onClick = function()
  activity.newActivity("script/plateAdmin", {url, admin, user, password, key, plateId, isEncrypt, secret})
end

-- 板块审核按钮事件
check.onClick = function()
  activity.newActivity("script/forumCheck", {url, admin, user, password, key, plateId, isEncrypt, secret})
end

-- 回调事件
function onActivityResult(req, res, intent)
  if intent then
    if res == 1 then
      local pathstr = intent.getStringExtra("set")
      if pathstr then
        list.setVisibility(View.VISIBLE)
        space.setVisibility(View.GONE)
        searchList.setVisibility(View.GONE)
        num = 0
        loadList(num, false,false)
      end
    end
  end
end