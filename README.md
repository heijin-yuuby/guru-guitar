# 🎸 GuruGuitar - 电吉他练习助手

一个功能强大的电吉他学习与练习应用，基于Flutter开发，支持多平台运行。通过交互式五度圈、CAGED系统和指板训练等模块，帮助吉他手系统掌握音乐理论和演奏技巧。

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=flat-square&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat-square&logo=dart)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web%20%7C%20Desktop-lightgrey?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

## ✨ 核心功能

### 🎯 交互式五度圈
- **可旋转操作**: 手势拖动旋转五度圈，直观选择调性
- **调性详情**: 点击任意调性查看详细的音阶分析和和弦信息
- **视觉设计**: 现代化多层次深蓝色环形设计，支持大小调切换

### 🎸 CAGED系统
- **五种指型**: 完整的C-A-G-E-D和弦指型系统
- **竖向指板**: 真实还原吉他指板布局，竖向显示更直观
- **位置标记**: 根音、三度音、五度音颜色编码，清晰易懂
- **简洁界面**: 2列网格布局，直接显示和弦按法

### 📚 指板训练器
- **动态显示**: 实时显示音阶或和弦在指板上的位置
- **练习模式**: 
  - 显示音符，用户点击对应指板位置
  - 指定调性，限时标记所有调内音
- **可定制**: 自定义起始品格和练习范围

### 🎵 音阶练习
- **多种模式**: 大调、小调、各种调式练习
- **记忆测试**: 打乱音符顺序，测试音阶记忆
- **视觉辅助**: 指板高亮显示，加深理解

### 🎼 和弦进行
- **经典进行**: 内置常见和弦进行模板（I-V-vi-IV等）
- **可视化**: 在五度圈和指板上同步显示和弦位置
- **自定义**: 支持创建个人和弦进行

## 🚀 快速开始

### 环境要求

- Flutter 3.0+
- Dart 3.0+
- iOS 12.0+ / Android API 21+

### 安装运行

```bash
# 克隆项目
git clone git@github.com:heijin-yuuby/guru-guitar.git
cd guru-guitar

# 进入Flutter项目目录
cd guruguitar_app

# 获取依赖
flutter pub get

# 运行应用
flutter run
```

### 构建发布

```bash
# iOS
flutter build ios --release

# Android
flutter build apk --release

# Web
flutter build web --release
```

## 📱 界面预览

### 主要界面
- **首页导航**: 底部导航栏，快速切换功能模块
- **五度圈**: 中心为C调，顺时针/逆时针排列12个调性
- **调性详情**: 5个标签页 - 音阶分析、和弦进行、指板图谱、CAGED、练习

### 交互体验
- **流畅动画**: 丰富的过渡动画和交互反馈
- **响应式设计**: 适配不同屏幕尺寸和方向
- **Material Design**: 遵循Material Design设计规范

## 🏗️ 技术架构

### 项目结构
```
guruguitar_app/
├── lib/
│   ├── models/          # 数据模型
│   │   ├── music_theory.dart     # 音乐理论
│   │   ├── guitar.dart           # 吉他相关
│   │   ├── caged_system.dart     # CAGED系统
│   │   └── scale_practice.dart   # 音阶练习
│   ├── screens/         # 页面UI
│   │   ├── home_screen.dart
│   │   ├── circle_of_fifths_screen.dart
│   │   ├── scale_practice_screen.dart
│   │   └── fretboard_trainer_screen.dart
│   ├── widgets/         # 组件
│   │   ├── circle_of_fifths_widget.dart
│   │   ├── fretboard_widget.dart
│   │   └── enhanced_key_detail_dialog.dart
│   └── main.dart        # 入口文件
```

### 核心技术
- **状态管理**: StatefulWidget + setState
- **自定义绘制**: CustomPainter绘制复杂图形
- **动画系统**: AnimationController + Tween
- **手势识别**: GestureDetector处理用户交互
- **布局系统**: Flex布局 + 响应式设计

## 🎯 使用说明

### 1. 五度圈操作
1. 拖动五度圈进行旋转
2. 点击任意调性环打开详情界面
3. 在详情中查看音阶、和弦、指板等信息

### 2. CAGED学习
1. 进入调性详情，选择"CAGED"标签页
2. 查看5种和弦指型的指板位置
3. 根音用金色边框标记，其他音程用不同颜色

### 3. 指板训练
1. 选择练习模式和调性
2. 根据提示在指板上点击正确位置
3. 查看得分和正确率统计

### 4. 音阶练习  
1. 选择大调或小调模式
2. 进行音阶记忆测试
3. 在指板上查看音阶位置

## 📋 TODO列表

### 🔧 技术优化
- [ ] **代码优化**: 替换已弃用的`withOpacity`为`withValues`
- [ ] **布局修复**: 解决部分页面的RenderFlex溢出问题
- [ ] **性能优化**: 优化CustomPainter重绘频率
- [ ] **内存管理**: 修复潜在的内存泄漏问题
- [ ] **异步处理**: 添加proper的异步操作处理

### 🎵 功能增强
- [ ] **音频播放**: 
  - [ ] 集成音频引擎（flutter_sound/just_audio）
  - [ ] 音阶和和弦试听功能
  - [ ] 节拍器功能
  - [ ] 录音对比功能
- [ ] **CAGED系统完善**:
  - [ ] 完善和弦按法计算逻辑
  - [ ] 添加更多和弦类型（sus4, 7th, 9th等）
  - [ ] 横按指法优化显示
- [ ] **指板训练升级**:
  - [ ] 添加难度等级设置
  - [ ] 速度训练模式
  - [ ] 成绩统计和进度跟踪
  - [ ] 错误分析和建议

### 🎸 新功能模块
- [ ] **调式练习**: 
  - [ ] Dorian, Phrygian, Lydian等调式
  - [ ] 调式特征音程练习
  - [ ] 调式和弦进行
- [ ] **即兴练习**:
  - [ ] 背景和弦播放
  - [ ] 推荐音阶选择
  - [ ] 即兴录制和回放
- [ ] **曲谱功能**:
  - [ ] 简化的TAB显示
  - [ ] 常用练习曲谱库
  - [ ] 自定义练习片段

### 📱 用户体验
- [ ] **个性化设置**:
  - [ ] 主题切换（深色/浅色）
  - [ ] 左手吉他支持
  - [ ] 字体大小调节
- [ ] **数据管理**:
  - [ ] 练习进度本地存储
  - [ ] 设置云端同步
  - [ ] 数据导出功能
- [ ] **多语言支持**:
  - [ ] 英文界面
  - [ ] 音乐术语本地化

### 🔄 架构改进
- [ ] **状态管理升级**: 考虑引入Provider或Riverpod
- [ ] **测试覆盖**: 添加单元测试和集成测试
- [ ] **CI/CD**: 设置GitHub Actions自动构建
- [ ] **文档完善**: API文档和贡献指南

### 🌐 平台适配
- [ ] **Web优化**: 提升Web端性能和体验
- [ ] **桌面端**: 适配macOS/Windows桌面应用
- [ ] **平板适配**: 大屏设备UI优化
- [ ] **无障碍**: 支持无障碍访问功能

## 🤝 贡献指南

欢迎提交Issue和Pull Request！

### 开发规范
1. 遵循Dart官方代码规范
2. 提交前运行`flutter analyze`检查代码质量
3. 确保所有平台构建通过
4. 添加必要的测试用例

### 提交流程
1. Fork项目
2. 创建功能分支
3. 提交更改
4. 发起Pull Request

## 📄 开源协议

本项目采用 [MIT License](LICENSE) 开源协议。

## 📞 联系方式

- **项目地址**: https://github.com/heijin-yuuby/guru-guitar
- **Issues**: https://github.com/heijin-yuuby/guru-guitar/issues

---

⭐ 如果这个项目对你有帮助，请给个Star支持一下！