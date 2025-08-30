# 🎸 GuruGuitar - 吉他大师

专业的Flutter Web吉他学习应用，支持GitHub Pages免费部署和微信小程序使用。

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

### GitHub Pages 部署
```bash
# 一键部署脚本
./deploy_github_pages.sh

# 手动推送到GitHub
git push origin main
```

### 微信小程序
1. 配置域名白名单：`https://heijin-yuuby.github.io`
2. 使用 `wechat_miniprogram` 模板
3. 修改webUrl为您的GitHub Pages地址
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
│   └── build/web/           # 构建输出
├── wechat_miniprogram/      # 微信小程序
│   └── pages/
├── .github/workflows/       # GitHub Actions
└── README.md
```

## 🌐 在线访问

- **GitHub Pages**: https://heijin-yuuby.github.io/guru-guitar/
- **Vercel备用**: https://guru-guitar.vercel.app

## 🎮 微信小程序集成

### 域名配置
在微信小程序管理后台配置合法域名：
```
request合法域名: https://heijin-yuuby.github.io
业务域名: https://heijin-yuuby.github.io
```

### 小程序代码
```javascript
// pages/index/index.js
Page({
  data: {
    webUrl: 'https://heijin-yuuby.github.io/guru-guitar/'
  }
});
```

### WebView页面
```xml
<!-- pages/index/index.wxml -->
<web-view src="{{webUrl}}" wx:if="{{webLoaded}}"></web-view>
```

## 🛠 技术栈

- **前端框架**: Flutter 3.24.1
- **UI组件**: Material Design 3
- **动画**: flutter_staggered_animations
- **响应式**: responsive_framework
- **字体**: Google Fonts
- **国际化**: flutter_localizations
- **存储**: shared_preferences

## 🎯 核心功能详解

### 1. 指板练习器
- 真实的吉他指板模拟
- 支持不同调弦
- 音符位置高亮显示
- 交互式点击反馈

### 2. 音阶练习系统
- 主要音阶（大调、小调等）
- 模式音阶（Dorian、Phrygian等）
- 五声音阶
- 布鲁斯音阶
- 视觉化音阶形状

### 3. 五度圈学习工具
- 交互式五度圈
- 调性关系展示
- 相关调分析
- 和弦进行建议

### 4. CAGED系统
- 5种基本和弦形状
- 指板上的位置变化
- 音阶与和弦的关系
- 实用的练习模式

## 📱 响应式设计

应用支持多种设备：
- 📱 手机 (320px+)
- 📱 平板 (768px+)  
- 💻 桌面 (1024px+)
- 🖥 大屏 (1440px+)

## 🔧 部署说明

### GitHub Pages 部署
1. Fork此仓库
2. 在仓库设置中启用Pages
3. 选择GitHub Actions作为源
4. 自动部署完成

### Vercel 部署
1. 连接GitHub仓库
2. 自动检测Flutter项目
3. 一键部署完成

### 自定义域名
支持绑定您自己的域名：
- 在DNS中添加CNAME记录
- 在部署平台设置自定义域名
- 自动获取SSL证书

## 🎨 自定义主题

支持自定义应用主题：
```dart
// lib/utils/app_theme.dart
ThemeData customTheme = ThemeData(
  primarySwatch: Colors.amber,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
```

## 🌍 国际化支持

目前支持：
- 🇨🇳 简体中文 (默认)
- 🇺🇸 English (计划中)

添加新语言：
```dart
// lib/utils/app_localizations.dart
class AppLocalizations {
  // 添加新的翻译文本
}
```

## 🚀 性能优化

- ✅ 懒加载组件
- ✅ 图片预加载
- ✅ 代码分割
- ✅ 缓存策略
- ✅ PWA支持

## 📈 功能路线图

- [ ] 🎤 音频录制功能
- [ ] 🎼 MIDI文件支持
- [ ] 👥 用户系统
- [ ] 📊 练习统计
- [ ] 🎯 个性化练习计划
- [ ] 🔊 节拍器功能
- [ ] 📱 iOS/Android App

## 🤝 贡献指南

欢迎贡献代码！

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## 📄 开源协议

此项目采用 MIT 协议 - 查看 [LICENSE](LICENSE) 了解详情

## 🙏 致谢

- Flutter团队提供优秀的框架
- Material Design提供设计规范
- 开源社区的无私贡献

## 💖 支持项目

如果这个项目对您有帮助：

- ⭐ 给项目点个Star
- 🐛 报告Bug和建议
- 🔀 提交Pull Request
- 📢 分享给朋友

## 📞 联系方式

- 📧 Email: your-email@example.com
- 🐙 GitHub: @heijin-yuuby
- 💬 微信: your-wechat-id

---

🎸 **让我们一起让吉他学习变得更简单！**

如果这个项目对您有帮助，请给个⭐️支持一下！