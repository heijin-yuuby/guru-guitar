# 🎸 GuruGuitar Flutter Web 部署指南

## 📋 目录
1. [项目构建](#项目构建)
2. [Vercel 部署](#vercel-部署)
3. [微信小程序集成](#微信小程序集成)
4. [常见问题](#常见问题)

## 🛠 项目构建

### 自动构建（推荐）
运行构建脚本：
```bash
./build_for_vercel.sh
```

### 手动构建
```bash
# 1. 获取依赖
flutter pub get

# 2. 清理项目
flutter clean

# 3. 启用Web支持
flutter config --enable-web

# 4. 构建生产版本
flutter build web --release --web-renderer canvaskit --base-href "/"
```

## 🚀 Vercel 部署

### 方法1：通过 Vercel CLI（推荐）
1. 安装 Vercel CLI：
```bash
npm i -g vercel
```

2. 在项目根目录登录：
```bash
vercel login
```

3. 部署项目：
```bash
vercel --prod
```

### 方法2：通过 Vercel 网站
1. 访问 [vercel.com](https://vercel.com)
2. 点击 "New Project"
3. 导入您的 Git 仓库
4. Vercel 会自动检测到 `vercel.json` 配置
5. 点击 "Deploy"

### 环境变量配置
在 Vercel 项目设置中添加以下环境变量：
- `FLUTTER_WEB_USE_SKIA`: `true`
- `FLUTTER_WEB_AUTO_DETECT`: `false`

## 📱 微信小程序集成

### 1. 准备工作
- 注册微信小程序账号
- 获取 AppID
- 下载微信开发者工具

### 2. 域名配置
在微信小程序管理后台（mp.weixin.qq.com）：
1. 进入 "开发" → "开发管理" → "开发设置"
2. 在 "服务器域名" 中添加您的 Vercel 域名：
   - **request 合法域名**: `https://your-app.vercel.app`
   - **业务域名**: `https://your-app.vercel.app`

### 3. 小程序代码示例

#### app.json
\`\`\`json
{
  "pages": [
    "pages/index/index"
  ],
  "window": {
    "backgroundTextStyle": "light",
    "navigationBarBackgroundColor": "#1a1a1a",
    "navigationBarTitleText": "吉他大师",
    "navigationBarTextStyle": "white"
  },
  "sitemapLocation": "sitemap.json"
}
\`\`\`

#### pages/index/index.wxml
\`\`\`html
<web-view src="{{webUrl}}" bindmessage="onMessage" bindload="onLoad" binderror="onError"></web-view>
\`\`\`

#### pages/index/index.js
\`\`\`javascript
Page({
  data: {
    webUrl: 'https://your-app.vercel.app'
  },
  
  onLoad: function() {
    console.log('Web页面加载成功');
  },
  
  onMessage: function(e) {
    console.log('收到Web页面消息:', e.detail.data);
  },
  
  onError: function(e) {
    console.error('Web页面加载失败:', e);
    wx.showToast({
      title: '页面加载失败',
      icon: 'none'
    });
  }
});
\`\`\`

### 4. 发布流程
1. 在微信开发者工具中预览和调试
2. 上传代码到微信后台
3. 提交审核
4. 审核通过后发布

## 🔧 配置文件说明

### vercel.json
- 配置构建命令和输出目录
- 设置路由重定向
- 配置 CORS 头部信息
- 优化缓存策略

### web/index.html 优化
- 添加微信小程序兼容性元标签
- 禁用右键菜单和文本选择
- 添加加载动画
- 预加载关键资源

### web/manifest.json
- PWA 配置
- 应用图标和主题色
- 支持离线使用

## ❓ 常见问题

### Q1: 在微信小程序中显示空白页
**解决方案：**
- 检查域名是否已添加到白名单
- 确认 HTTPS 证书有效
- 检查 CSP 策略设置

### Q2: Flutter Web 加载慢
**解决方案：**
- 使用 CanvasKit 渲染器
- 启用资源预加载
- 优化图片和字体资源

### Q3: 部署后样式异常
**解决方案：**
- 检查 base href 设置
- 确认资源路径正确
- 清除浏览器缓存

### Q4: 微信小程序审核被拒
**常见原因：**
- 域名未备案
- 内容不符合规范
- 缺少必要的用户协议

## 🔄 更新部署
1. 修改代码后重新构建：
```bash
./build_for_vercel.sh
```

2. 推送到 Git 仓库：
```bash
git add .
git commit -m "更新内容"
git push
```

3. Vercel 会自动重新部署

## 🎯 性能优化建议
- 启用 Gzip 压缩
- 使用 CDN 加速
- 优化图片格式（WebP）
- 减少 JavaScript 包大小
- 使用浏览器缓存

## 📞 技术支持
如遇到问题，请检查：
1. Flutter 版本兼容性
2. 网络连接状况
3. 浏览器控制台错误信息
4. Vercel 部署日志

---
🎸 **GuruGuitar** - 让吉他学习更简单！
