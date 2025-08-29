#!/bin/bash

# GuruGuitar Flutter Web 构建脚本 - 针对Vercel部署优化

echo "🎸 开始构建 GuruGuitar Web 版本..."

# 检查Flutter是否安装
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter 未安装或未在PATH中"
    exit 1
fi

# 检查是否在项目根目录
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ 请在Flutter项目根目录运行此脚本"
    exit 1
fi

echo "📦 获取依赖..."
flutter pub get

echo "🧹 清理之前的构建..."
flutter clean

echo "🔧 启用Web支持..."
flutter config --enable-web

echo "🚀 构建Web版本（针对微信小程序优化）..."
flutter build web \
  --release \
  --base-href "/" \
  --dart-define=FLUTTER_WEB_USE_SKIA=true \
  --dart-define=FLUTTER_WEB_AUTO_DETECT=false

echo "✅ 构建完成！"
echo "📁 构建文件位置: build/web/"
echo ""
echo "🔄 接下来的步骤："
echo "1. 确保项目根目录有 vercel.json 配置文件"
echo "2. 推送代码到 Git 仓库"
echo "3. 在 Vercel 中导入项目"
echo "4. 部署完成后即可在微信小程序中使用"
echo ""
echo "🎯 微信小程序配置提示："
echo "- 在小程序管理后台添加域名到服务器域名白名单"
echo "- 使用 web-view 组件加载您的 Vercel 域名"
echo ""
echo "🎸 GuruGuitar 准备就绪！"
