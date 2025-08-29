# 🚀 GuruGuitar 快速部署命令

## 📋 复制粘贴命令清单

### 1️⃣ GitHub 部署命令

```bash
# 在 guruguitar_app 目录下执行

# 添加远程仓库（记得替换 YOUR_USERNAME）
git remote add origin https://github.com/YOUR_USERNAME/guruguitar.git

# 重命名分支为 main
git branch -M main

# 推送代码到 GitHub
git push -u origin main
```

### 2️⃣ 本地测试命令

```bash
# 本地预览 Web 版本
cd build/web
python3 -m http.server 8000
# 访问 http://localhost:8000

# 重新构建（如有修改）
cd ..
./build_for_vercel.sh
```

### 3️⃣ 项目目录导航

```bash
# Flutter 应用目录
cd /Users/wajilao/Documents/workspace/guruguitar-new/guruguitar_app

# 微信小程序模板目录  
cd /Users/wajilao/Documents/workspace/guruguitar-new/wechat_miniprogram

# 查看所有文档
cd /Users/wajilao/Documents/workspace/guruguitar-new
ls *.md
```

## 🔗 重要链接

### 部署平台
- **GitHub**: https://github.com
- **Vercel**: https://vercel.com  
- **微信小程序**: https://mp.weixin.qq.com

### 开发工具
- **微信开发者工具**: https://developers.weixin.qq.com/miniprogram/dev/devtools/download.html
- **VS Code**: https://code.visualstudio.com
- **Flutter**: https://flutter.dev

## 📝 配置检查清单

### GitHub 仓库设置
- [ ] 仓库名称: `guruguitar`
- [ ] 可见性: Public  
- [ ] 不勾选初始化选项
- [ ] 成功推送代码

### Vercel 部署设置
- [ ] 导入 GitHub 仓库
- [ ] Framework Preset: Other
- [ ] Build Command: `flutter build web --release`
- [ ] Output Directory: `build/web`
- [ ] 部署成功获得 URL

### 微信小程序配置
- [ ] 域名添加到白名单
- [ ] 修改 webUrl 为实际域名
- [ ] 导入开发者工具测试
- [ ] 预览功能正常

## 🎯 一键复制配置

### Vercel 环境变量
```
FLUTTER_WEB_USE_SKIA=true
FLUTTER_WEB_AUTO_DETECT=false
```

### 微信小程序 webUrl 修改
```javascript
// pages/index/index.js 第3行
webUrl: 'https://your-app-name.vercel.app'
```

### 域名白名单配置
```
request合法域名: https://your-app-name.vercel.app
业务域名: https://your-app-name.vercel.app  
```

## 🔧 故障排查命令

### Git 问题解决
```bash
# 如果推送失败，检查远程仓库
git remote -v

# 重新设置远程仓库
git remote set-url origin https://github.com/YOUR_USERNAME/guruguitar.git

# 强制推送（谨慎使用）
git push -f origin main
```

### Flutter 重新构建
```bash
# 清理缓存
flutter clean

# 获取依赖
flutter pub get

# 重新构建
flutter build web --release
```

### 查看构建文件
```bash
# 检查构建结果
ls -la build/web/

# 查看主要文件
ls -la build/web/*.{html,js,json}
```

## 📞 快速验证

### 本地验证
```bash
# 启动本地服务器
cd build/web && python3 -m http.server 8000

# 在浏览器打开
open http://localhost:8000
```

### 在线验证  
```bash
# 检查 Vercel 部署状态
curl -I https://your-app-name.vercel.app

# 检查主要资源
curl -I https://your-app-name.vercel.app/main.dart.js
```

## 🎸 成功标志

看到以下内容说明部署成功：

### Web 版本
- ✅ 页面正常加载
- ✅ 吉他指板显示正确
- ✅ 音阶练习功能可用
- ✅ 五度圈交互正常
- ✅ 移动端响应式正常

### 微信小程序
- ✅ WebView 正常加载
- ✅ 页面在小程序中显示
- ✅ 功能交互正常
- ✅ 分享功能可用

---

🎊 **一切准备就绪！开始您的部署之旅吧！**

💡 **提示**: 将这个文件加入书签，部署过程中随时参考。
