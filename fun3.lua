require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "android.net.Uri"
import "android.content.Intent"

function 时间屏幕()
  activity.newActivity("page/TimeScreen")
end

function 翻译()
  activity.newActivity("mods/fanyi/main")
end

function 一键青年大学习()
  url = "https://mp.weixin.qq.com/s/6juTpYsNNQr93LuazZU4bQ"
  web弹窗="青年大学习工具\n认真观看教程操作，来源于公众号：i呀我去\n网址："
  .. url
  .. "\n\nBy 言和"
  activity.newActivity("webliulan",{web弹窗,url})
end

function 本部食堂点餐()
  url="https://h5.vedingv2.com/wx/template/defined/index.jhtml?id=54408&uid=216209&f=oXcCrt_EKabmL8v_6ziVBjhl5xX8216209a1S&fromWechatAuth=Y"
  跳转网页(url)
end

function 微信扫一扫()
  activity.startActivity(Intent("android.media.action.IMAGE_CAPTURE"))
end

function 界面3加载()
  -- 学习资源类
  local learningResources = {
    {"中国大学MOOC", "https://www.icourse163.org/"},
    {"网易公开课", "https://open.163.com/"},
    {"哔哩哔哩学习", "https://www.bilibili.com/"},
    {"中国知网", "https://www.cnki.net/"},
    {"Coursera", "https://www.coursera.org/"},
    {"edX", "https://www.edx.org/"},
    {"Udacity", "https://www.udacity.com/"},
    {"MOOC学院", "https://www.mooc.cn/"},
    {"中国教育图书进出口公司", "http://www.cteep.com/"},
    {"国家开放大学", "http://www.ouchn.cn/"},
    {"中国大学视频公开课", "https://www.icourses.cn/"},
    {"Z-Library", "https://singlelogin.site/"},
    {"知到", "https://www.zhihuishu.com/"},
    {"慕课网", "https://www.imooc.com/"},
    {"大学生学习网", "https://www.51zxw.net/"},
    {"果壳网", "https://www.guokr.com/"},
    {"学堂在线", "https://www.xuetangx.com/"},
    {"中国大学MOOC (手机版)", "https://mooc.chaoxing.com/"},
    {"人人讲", "https://www.renrenjiang.com/"},
    {"世界大学城", "http://www.gter.net/"},
    {"中国教育资源网", "http://www.erc.edu.cn/"},
    {"中国数字科技馆", "http://www.cdstm.cn/"},
    {"国家教育资源公共服务平台", "http://www.eduyun.cn/"},
    {"大学网课视频", "https://www.tmooc.cn/"},
    {"中国高等教育学会", "http://www.hi-china.org/"},
    {"教育部大学生在线", "https://www.zxdy.com/"},
    {"优学院", "https://www.youxueyuan.com/"},
    {"超星尔雅", "https://erya.chaoxing.com/"},
    {"网易云课堂", "https://study.163.com/"},
    {"大学MOOC", "https://www.xuetangx.com/"},
    {"中国教育电视台", "http://www.cetv.cn/"},
    {"大学英语四六级", "https://www.cet.edu.cn/"},
  }

  -- 工具类（合并了在线工具）
  local tools = {
    {"时间屏幕", "时间屏幕"},
    {"微信扫一扫", "微信扫一扫"},
    {"翻译", "翻译"},
    {"一键青年大学习", "一键青年大学习"},
    {"视频翻译", "https://www.transmonkey.ai/video-translator/translate"},
    {"文字转语音", "https://ttsmaker.cn/"},
    {"在线PDF编辑器", "https://www.ilovepdf.com/zh-cn"},
    {"在线图片压缩", "https://compressjpeg.com/zh/"},
    {"在线视频剪辑", "https://www.kapwing.com/"},
    {"在线音频转文字", "https://www.sonix.ai/"},
    {"在线文件转换", "https://convertio.co/zh/"},
    {"在线字幕制作", "https://subadub.com/"},
    {"在线PDF转换", "https://smallpdf.com/"},
    {"在线图表制作", "https://www.canva.com/"},
    {"在线PPT制作", "https://prezi.com/"},
    {"在线字体识别", "https://www.whatfontis.com/"},
    {"在线反馈调查", "https://www.surveymonkey.com/"},
    {"在线GIF制作", "https://giphy.com/create/gifmaker"},
    {"在线3D模型", "https://www.tinkercad.com/"},
    {"在线AI写作助手", "https://hemingwayapp.com/"},
    {"在线图像修复", "https://www.photopea.com/"},
    {"在线视频压缩", "https://www.clideo.com/"},
    {"在线名片制作", "https://www.canva.com/create/business-cards/"},
    {"在线表单创建", "https://www.jotform.com/"},
    {"在线文本翻译", "https://translate.google.com/"},
    {"在线音频编辑", "https://www.audacityteam.org/"},
    {"在线书籍制作", "https://www.blurb.com/"},
    {"在线语音合成", "https://ttsmp3.com/"},
    {"在线地理信息系统", "https://www.arcgis.com/"},
    {"在线图像色彩分析", "https://www.colorhexa.com/"},
    {"在线视频转换", "https://www.online-convert.com/"},
    {"在线电子签名", "https://www.docusign.com/"},
    {"在线视频字幕", "https://www.subadub.com/"},
    {"在线字体设计", "https://www.fontself.com/"},
    {"在线图片处理", "https://www.befunky.com/"},
    {"在线3D打印设计", "https://www.tinkercad.com/"},
    {"在线资料收集", "https://docs.google.com/forms/"},
  }

  -- 生活服务类
  local lifeServices = {
    {"本部食堂点餐", "https://h5.vedingv2.com/wx/template/defined/index.jhtml?id=54408&uid=216209&f=oXcCrt_EKabmL8v_6ziVBjhl5xX8216209a1S&fromWechatAuth=Y"},
    {"近邻宝", "https://wechat.zkfc.cn/HomePage"},
    {"公交查询", "https://d.stulip.org/sp/gongjiao.html"},
    {"支付宝红包", "支付宝红包"},
    {"天气查询", "https://www.weather.com.cn/"},
    {"周边便民服务", "https://www.meituan.com/"},
    {"订餐外卖", "https://www.meituan.com/meishi/"},
    {"快递查询", "https://www.kuaidi100.com/"},
    {"电影票购买", "https://www.maoyan.com/"},
    {"旅游攻略", "https://www.qunar.com/"},
    {"在线购物", "https://www.jd.com/"},
    {"手机充值", "https://www.10010.com/"},
    {"火车票预订", "https://www.12306.cn/"},
    {"机票预订", "https://www.ctrip.com/"},
    {"共享单车", "https://www.mobike.com/cn/"},
    {"停车服务", "https://www.dingxingche.com/"},
    {"酒店预订", "https://www.ctrip.com/"},
    {"在线医疗咨询", "https://www.haodf.com/"},
    {"租房信息", "https://zu.fang.com/"},
    {"水电缴费", "https://www.95598.cn/"},
    {"驾照考试预约", "https://www.122.gov.cn/"},
    {"医保服务", "https://www.12320.gov.cn/"},
    {"公积金查询", "https://www.12329.gov.cn/"},
    {"银行卡查询", "https://www.icbc.com.cn/"},
    {"在线银行服务", "https://www.cmbchina.com/"},
    {"保险查询", "https://www.cpic.com.cn/"},
    {"车辆违章查询", "https://www.122.gov.cn/"},
    {"在线预约挂号", "https://www.guahao.com/"},
    {"通讯费查询", "https://www.10010.com/"},
    {"电信业务办理", "https://www.10000.cn/"},
    {"二手交易平台", "https://2.taobao.com/"},
    {"家政服务", "https://www.58.com/"},
    {"房屋租赁", "https://www.58.com/"},
    {"家电维修", "https://www.58.com/"},
    {"在线英语学习", "https://www.51talk.com/"},
    {"在线会计服务", "https://www.51zhongkao.com/"},
    {"在线驾校报名", "https://www.58.com/jiaxiao/"},
  }

  -- 获取屏幕宽度
  local screenWidth = activity.getWidth() - 250
  local minCardsPerRow = 3
  local adaptiveWidth = math.min(math.floor(screenWidth / minCardsPerRow), screenWidth)

  -- 通用函数用于创建和添加卡片
  local function addCard(layout, items, onClickHandler)
    for k, v in ipairs(items) do
      local card =
      {
        LinearLayout;
        layout_width="-2";
        {
          CardView;
          radius="15dp";
          layout_height="55dp";
          layout_margin="10dp";
          onClick=function() onClickHandler(v) end;
          elevation="0dp";
          layout_marginTop="0dp";
          layout_width=tostring(adaptiveWidth).."px"; -- 设置自适应宽度
          CardBackgroundColor=viewshaderc;
          layout_gravity="center";
          {
            TextView;
            textColor=textc;
            gravity="center";
            textSize="14dp";
            layout_gravity="center";
            Typeface=字体("product");
            text=v[1];
          };
        };
      };

      layout.addView(loadlayout(card))
    end
  end

  -- 添加卡片到对应布局
  addCard(界面3f3, learningResources, function(item) 跳转网页(item[2]) end)
  列表逐显动画(界面3f3, 0.1)
  addCard(界面3f2, tools, function(item)
    if type(item[2]) == "string" and item[2]:sub(1,4) == "http" then
      跳转网页(item[2])
     else
      local func = _G[item[2]]
      if func then func() end
    end
  end)
  列表逐显动画(界面3f2, 0.1)
  addCard(界面3f1, lifeServices, function(item)
    if type(item[2]) == "string" and item[2]:sub(1,4) == "http" then
      跳转网页(item[2])
     else
      local func = _G[item[2]]
      if func then func() end
    end
  end)
  列表逐显动画(界面3f1, 0.1)

end

