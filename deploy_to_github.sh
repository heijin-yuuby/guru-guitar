#!/bin/bash

# GuruGuitar GitHub 部署脚本

echo "🎸 准备部署 GuruGuitar 到 GitHub..."

# 检查是否在正确的目录
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ 请在 guruguitar_app 目录运行此脚本"
    exit 1
fi

# 检查是否已构建
if [ ! -d "build/web" ]; then
    echo "📦 先构建项目..."
    ./build_for_vercel.sh
fi

# 初始化 Git（如果还没有）
if [ ! -d ".git" ]; then
    echo "🔧 初始化 Git 仓库..."
    git init
    git config --global init.defaultBranch main
fi

# 添加 .gitignore（如果没有的话）
if [ ! -f ".gitignore" ]; then
    echo "📝 创建 .gitignore..."
    cat > .gitignore << EOF
# Flutter
.dart_tool/
.packages
.pub/
build/
!build/web/

# IDE
.vscode/
.idea/

# macOS
.DS_Store

# Local
*.local
EOF
fi

echo "📁 添加文件到 Git..."
git add .

echo "💾 提交更改..."
git commit -m "🎸 GuruGuitar Flutter Web App

✨ 功能：
- 吉他指板练习
- 音阶训练系统
- 五度圈学习工具
- CAGED 和弦系统

🚀 部署配置：
- Vercel 自动部署
- 微信小程序支持
- 响应式设计
- PWA 支持"

echo "✅ Git 提交完成！"
echo ""
echo "🔄 接下来的步骤："
echo "1. 在 GitHub 创建新仓库 'guruguitar'"
echo "2. 运行以下命令推送代码："
echo "   git remote add origin https://github.com/您的用户名/guruguitar.git"
echo "   git push -u origin main"
echo "3. 在 Vercel.com 导入 GitHub 仓库"
echo "4. 自动部署完成！"
echo ""
echo "🎸 GuruGuitar 即将上线！"
