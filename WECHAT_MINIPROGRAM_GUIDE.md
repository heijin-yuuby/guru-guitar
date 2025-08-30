# 📱 微信小程序发布完整指南

## 🎯 概述

现在你的GuruGuitar应用已经成功部署到GitHub Pages，接下来将指导你如何在微信小程序中发布。

**你的GitHub Pages地址**: `https://heijin-yuuby.github.io/guru-guitar/`

## ⚠️ 重要前提条件

### 1. 小程序主体要求
- ✅ **企业主体** - 可以使用web-view组件
- ❌ **个人主体** - 无法使用web-view组件嵌入外部网页

### 2. 域名要求  
- ✅ HTTPS协议 (GitHub Pages自动提供)
- ✅ 需要在微信小程序后台配置业务域名
- ⚠️ 如果小程序主体在中国大陆，建议使用备案域名

## 🚀 发布步骤详解

### 第一步：登录微信公众平台

1. 访问 [微信公众平台](https://mp.weixin.qq.com/)
2. 使用你的小程序账号登录
3. 确认小程序主体类型（必须是企业主体）

### 第二步：配置业务域名

#### 2.1 进入开发设置
- 左侧菜单：**开发** → **开发管理** → **开发设置**

#### 2.2 添加业务域名
在"业务域名"部分：

1. 点击 **"修改"** 按钮
2. 添加域名：`heijin-yuuby.github.io`
3. 下载校验文件 `MP_verify_xxxxxxxxx.txt`

#### 2.3 上传校验文件到GitHub Pages

我来帮你创建校验文件的上传脚本：

```bash
# 创建校验文件目录
mkdir -p /Users/wajilao/Documents/workspace/guruguitar-new/guruguitar_app/web/
# 将下载的校验文件放到这个目录
# 然后重新构建和部署
```

### 第三步：修改小程序配置

#### 3.1 更新小程序中的URL
需要修改 `wechat_miniprogram/pages/index/index.js`：

```javascript
data: {
  // 更新为你的实际GitHub Pages地址
  webUrl: 'https://heijin-yuuby.github.io/guru-guitar/',
  webLoaded: false
},
```

### 第四步：微信开发者工具配置

#### 4.1 项目导入
1. 打开微信开发者工具
2. 选择 **"小程序"**
3. 点击 **"导入项目"**
4. 项目目录选择：`/Users/wajilao/Documents/workspace/guruguitar-new/wechat_miniprogram/`
5. 填入你的小程序AppID

#### 4.2 项目配置检查
确认 `project.config.json` 配置：

```json
{
  "description": "吉他大师微信小程序",
  "appid": "你的小程序AppID",
  "projectname": "guruguitar",
  "setting": {
    "urlCheck": true,
    "es6": true,
    "enhance": true,
    "postcss": true,
    "minified": true
  }
}
```

### 第五步：测试和调试

#### 5.1 本地测试
1. 在微信开发者工具中点击 **"编译"**
2. 检查web-view是否正常加载
3. 测试各项功能是否正常

#### 5.2 真机预览
1. 点击工具栏的 **"预览"**
2. 用手机微信扫码测试
3. 确认在手机上功能正常

### 第六步：上传代码

#### 6.1 上传到微信服务器
1. 在微信开发者工具中点击 **"上传"**
2. 填写版本号和项目备注
3. 上传成功后在微信公众平台查看

#### 6.2 提交审核
1. 登录微信公众平台
2. 进入 **版本管理**
3. 找到刚上传的版本
4. 点击 **"提交审核"**

### 第七步：审核和发布

#### 7.1 填写审核信息
- **功能页面**: 选择包含web-view的页面
- **测试账号**: 提供测试用的微信号
- **补充说明**: 详细说明功能和用途

#### 7.2 等待审核
- 审核时间：通常1-7个工作日
- 可能被拒原因：域名未备案、内容不符合规范等

#### 7.3 发布上线
审核通过后：
1. 在微信公众平台点击 **"发布"**
2. 小程序正式上线
3. 用户可以搜索和使用

## 🛠 域名校验文件配置

我来帮你配置域名校验：
