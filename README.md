# 🎸 GuruGuitar - 吉他大师

专业的Flutter Web吉他学习应用，支持微信小程序部署。

## ✨ 功能特色

- 🎯 **指板练习** - 交互式吉他指板训练
- 🎵 **音阶练习** - 全面的音阶学习系统  
- ⭕ **五度圈** - 音乐理论可视化工具
- 🎪 **CAGED系统** - 和弦形状学习
- 📱 **响应式设计** - 完美适配移动端
- 🎮 **微信小程序** - 一键在微信中使用

## 🚀 快速开始

### 本地开发
```bash
cd guruguitar_app
flutter pub get
flutter run -d chrome
```

### 构建部署
```bash
# 构建Web版本
./build_for_vercel.sh

# 部署到Vercel
vercel --prod
```

### 微信小程序
1. 配置域名白名单
2. 使用 `wechat_miniprogram` 模板
3. 修改webUrl为您的Vercel域名
4. 在微信开发者工具中导入

## 📦 项目结构

```
guruguitar-new/
├── guruguitar_app/          # 主应用
│   ├── lib/                 # Flutter源码
│   │   ├── models/          # 数据模型
│   │   ├── screens/         # 页面组件
│   │   ├── widgets/         # UI组件
│   │   └── utils/           # 工具类
│   ├── web/                 # Web配置
│   ├── vercel.json          # Vercel部署配置
│   └── build_for_vercel.sh  # 构建脚本
├── wechat_miniprogram/      # 微信小程序模板
└── docs/                    # 文档说明
```

## 🛠 技术栈

- **前端框架**: Flutter 3.8+
- **UI组件**: Material Design
- **响应式**: Responsive Framework
- **字体**: Google Fonts
- **动画**: Flutter Staggered Animations
- **存储**: Shared Preferences
- **部署**: Vercel
- **小程序**: 微信 Web-view

## 📖 详细文档

- [🚀 快速部署指南](./QUICK_DEPLOY.md)
- [📋 详细部署说明](./guruguitar_app/DEPLOYMENT_GUIDE.md)
- [🔧 开发文档](./docs/)

## 🎯 核心功能

### 指板练习器
- 交互式指板显示
- 音符识别训练
- 自定义练习模式
- 进度跟踪

### 音阶系统
- 主要音阶和调式
- 可视化指法显示
- 播放功能
- 练习模式

### 五度圈
- 交互式五度圈
- 调性关系展示
- 和弦进行提示
- 理论学习

### CAGED系统
- 五种基本和弦形状
- 指板全覆盖
- 形状变换
- 实用练习

## 🔧 配置说明

### Vercel配置 (vercel.json)
- 自动构建Flutter Web
- CORS跨域支持
- 缓存策略优化
- 路由重定向

### 微信小程序适配
- 禁用右键菜单
- 优化加载速度
- 错误处理机制
- 分享功能支持

## 📱 微信小程序集成

### 1. 域名配置
在微信小程序后台添加您的Vercel域名到服务器域名白名单

### 2. 代码集成
```javascript
// pages/index/index.js
Page({
  data: {
    webUrl: 'https://your-app.vercel.app'
  }
});
```

### 3. 页面结构
```html
<!-- pages/index/index.wxml -->
<web-view src="{{webUrl}}" bindload="onLoad" binderror="onError"></web-view>
```

## 🎨 自定义主题

项目支持自定义主题色彩：

```dart
// lib/main.dart
theme: ThemeData(
  primarySwatch: Colors.orange,
  visualDensity: VisualDensity.adaptivePlatformDensity,
),
```

## 🔄 更新部署

### 代码更新
```bash
git add .
git commit -m "功能更新"
git push
# Vercel自动重新部署
```

### 依赖更新
```bash
flutter pub upgrade
./build_for_vercel.sh
```

## 🐛 问题排查

### 常见问题
1. **构建失败**: 检查Flutter版本兼容性
2. **部署错误**: 验证vercel.json配置
3. **微信加载失败**: 确认域名白名单
4. **性能问题**: 启用缓存和压缩

### 调试模式
```bash
flutter run -d chrome --debug
flutter build web --profile
```

## 📊 性能优化

- Tree-shaking减少包大小
- 图片和字体优化
- 懒加载实现
- CDN加速
- Gzip压缩

## 🤝 贡献指南

1. Fork项目
2. 创建功能分支
3. 提交更改
4. 发起Pull Request

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 🙏 致谢

感谢Flutter团队和开源社区的贡献

---

🎸 **让我们一起让吉他学习变得更简单！**

如果这个项目对您有帮助，请给个⭐️支持一下！