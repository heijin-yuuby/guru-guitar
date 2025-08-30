# 🎸 GuruGuitar - 吉他大师

专业的 Flutter 跨平台吉他学习应用，支持 Web、Android、iOS 等多平台运行。

## ✨ 功能特色

- 🎯 **指板练习** - 交互式吉他指板训练
- 🎵 **音阶练习** - 全面的音阶学习系统  
- ⭕ **五度圈** - 音乐理论可视化工具
- 🎪 **CAGED系统** - 和弦形状学习
- 📱 **响应式设计** - 完美适配所有设备

## 🚀 快速开始

### 环境要求
- Flutter SDK（最新稳定版本）
- Dart SDK（Flutter 自带）
- Android Studio 或 VS Code（安装 Flutter 扩展）

### 本地开发
```bash
cd guruguitar_app
flutter pub get
flutter run
```

### Web 版本
```bash
cd guruguitar_app
flutter run -d chrome
```

## 📦 项目结构

```
guruguitar_app/
├── lib/
│   ├── models/          # 数据模型
│   ├── screens/         # 页面组件
│   ├── widgets/         # UI组件
│   └── utils/           # 工具类
├── android/             # Android 平台配置
├── ios/                 # iOS 平台配置
├── web/                 # Web 平台配置
└── pubspec.yaml         # 项目依赖配置
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

## 📦 构建发布

### Web 版本
```bash
cd guruguitar_app
flutter build web
```

### Android APK
```bash
cd guruguitar_app
flutter build apk
```

### iOS 应用
```bash
cd guruguitar_app
flutter build ios
```

## 🌍 国际化支持

目前支持：
- 🇨🇳 简体中文 (默认)
- 🇺🇸 English (计划中)

## 🚀 性能优化

- ✅ 懒加载组件
- ✅ 代码分割
- ✅ 缓存策略
- ✅ 响应式设计

## 📈 功能路线图

- [ ] 🎤 音频录制功能
- [ ] 🎼 MIDI文件支持
- [ ] 👥 用户系统
- [ ] 📊 练习统计
- [ ] 🎯 个性化练习计划
- [ ] 🔊 节拍器功能

## 🤝 贡献指南

欢迎贡献代码！

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## 📄 开源协议

此项目采用 MIT 协议 - 查看 [LICENSE](LICENSE) 了解详情

## 💖 支持项目

如果这个项目对您有帮助：

- ⭐ 给项目点个Star
- 🐛 报告Bug和建议
- 🔀 提交Pull Request
- 📢 分享给朋友

---

🎸 **让我们一起让吉他学习变得更简单！**

如果这个项目对您有帮助，请给个⭐️支持一下！