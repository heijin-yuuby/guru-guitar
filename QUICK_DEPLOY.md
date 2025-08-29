# 🚀 GuruGuitar 快速部署指南

## 📦 项目概述
- **项目名称**: GuruGuitar - 吉他大师
- **技术栈**: Flutter Web + Vercel + 微信小程序
- **功能**: 指板练习、音阶练习、五度圈学习等吉他教学工具

## ⚡ 快速部署（5分钟上线）

### 1️⃣ 准备工作
```bash
# 确保已安装 Flutter SDK
flutter --version

# 确保已安装 Node.js 和 npm
node --version
npm --version
```

### 2️⃣ 构建项目
```bash
cd guruguitar_app
./build_for_vercel.sh
```

### 3️⃣ 部署到 Vercel

#### 方式A: 使用 Vercel CLI（推荐）
```bash
# 安装 Vercel CLI
npm i -g vercel

# 登录 Vercel
vercel login

# 部署项目
vercel --prod
```

#### 方式B: 通过 GitHub + Vercel 网站
1. 将代码推送到 GitHub
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/your-username/guruguitar.git
git push -u origin main
```

2. 在 [vercel.com](https://vercel.com) 导入 GitHub 项目
3. Vercel 自动检测配置并部署

### 4️⃣ 微信小程序配置

#### 域名白名单设置
1. 登录 [微信小程序管理后台](https://mp.weixin.qq.com)
2. 开发 → 开发管理 → 开发设置 → 服务器域名
3. 添加您的 Vercel 域名：
   - **request合法域名**: `https://your-app.vercel.app`
   - **业务域名**: `https://your-app.vercel.app`

#### 小程序代码部署
1. 使用提供的 `wechat_miniprogram` 模板
2. 修改 `pages/index/index.js` 中的 `webUrl`
3. 在微信开发者工具中导入项目
4. 预览测试后上传代码

## 📁 项目结构
```
guruguitar-new/
├── guruguitar_app/          # Flutter Web 应用
│   ├── lib/                 # Dart 源代码
│   ├── web/                 # Web 配置文件
│   ├── build/web/           # 构建输出
│   ├── vercel.json          # Vercel 配置
│   └── build_for_vercel.sh  # 构建脚本
└── wechat_miniprogram/      # 微信小程序模板
    ├── app.json
    ├── pages/index/
    └── sitemap.json
```

## 🔧 关键配置文件

### vercel.json
- 构建命令和输出目录配置
- CORS 和缓存策略设置
- 路由重定向规则

### web/index.html
- 微信小程序兼容性优化
- 加载动画和性能优化
- 响应式设计支持

### web/manifest.json
- PWA 应用配置
- 图标和主题色设置
- 离线支持配置

## 🎯 部署后检查清单

### ✅ Web 应用检查
- [ ] 访问 Vercel 域名确认页面正常加载
- [ ] 检查移动端响应式效果
- [ ] 测试核心功能（指板、音阶、五度圈）
- [ ] 确认 HTTPS 证书有效

### ✅ 微信小程序检查
- [ ] 域名已添加到白名单
- [ ] 小程序预览正常显示
- [ ] web-view 加载速度可接受
- [ ] 分享功能正常工作

## 🐛 常见问题解决

### Q: Flutter 构建失败
```bash
# 清理缓存重新构建
flutter clean
flutter pub get
flutter build web --release
```

### Q: Vercel 部署失败
- 检查 vercel.json 语法
- 确认 Flutter SDK 在 Vercel 环境中可用
- 查看 Vercel 部署日志

### Q: 微信小程序白屏
- 确认域名白名单配置
- 检查 HTTPS 证书
- 测试域名是否可访问

### Q: 加载速度慢
- 启用 Gzip 压缩
- 优化图片资源
- 使用 CDN 加速

## 📊 性能优化建议

### 前端优化
- 使用 Web Workers 处理复杂计算
- 实现懒加载和代码分割
- 优化图片格式（WebP）

### 部署优化
- 启用 Vercel Edge Network
- 配置适当的缓存策略
- 监控性能指标

## 🔄 更新流程

### 代码更新
```bash
# 修改代码后
./build_for_vercel.sh
git add .
git commit -m "update: 功能改进"
git push
# Vercel 自动重新部署
```

### 小程序更新
1. 修改小程序代码
2. 微信开发者工具预览测试
3. 上传新版本到微信后台
4. 提交审核并发布

## 📞 支持与反馈

### 技术支持
- GitHub Issues: 报告 Bug 和功能请求
- 开发文档: 详细的 API 和配置说明
- 社区论坛: 经验分享和问题讨论

### 监控和分析
- Vercel Analytics: 网站访问统计
- 微信小程序数据助手: 用户行为分析
- 错误日志监控: 及时发现和修复问题

---

🎸 **部署完成！现在您的吉他学习应用已经可以在微信小程序中使用了！**

记得定期备份代码和数据，保持依赖库的更新。
