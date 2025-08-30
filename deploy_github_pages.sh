#!/bin/bash

echo "🎸 GuruGuitar GitHub Pages 部署脚本"
echo "======================================"

# 检查当前目录
if [ ! -d "guruguitar_app" ]; then
    echo "❌ 请在项目根目录运行此脚本"
    exit 1
fi

# 进入Flutter项目目录
cd guruguitar_app

echo "📦 检查构建文件..."
if [ ! -d "build/web" ]; then
    echo "🔨 正在构建Flutter Web项目..."
    flutter build web --base-href "/guruguitar-new/" --release
    if [ $? -ne 0 ]; then
        echo "❌ Flutter构建失败"
        exit 1
    fi
    echo "✅ Flutter构建完成"
else
    echo "✅ 发现已存在的构建文件"
fi

# 回到项目根目录
cd ..

echo "🔧 初始化Git仓库..."
if [ ! -d ".git" ]; then
    git init
    git branch -M main
    echo "✅ Git仓库初始化完成"
else
    echo "✅ Git仓库已存在"
fi

# 创建.gitignore文件
echo "📝 创建.gitignore文件..."
cat > .gitignore << 'EOF'
# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Local env files
.env.local
.env.development.local
.env.test.local
.env.production.local

# Logs
logs
*.log

# Temporary files
*.tmp
*.temp

# Flutter specific (保留构建好的web文件)
guruguitar_app/.dart_tool/
guruguitar_app/.packages
guruguitar_app/.pub/
guruguitar_app/android/
guruguitar_app/ios/
guruguitar_app/linux/
guruguitar_app/macos/
guruguitar_app/windows/
guruguitar_app/test/
!guruguitar_app/build/web/
EOF

echo "📁 添加文件到Git..."
git add .

echo "💾 提交更改..."
git commit -m "🎸 GuruGuitar - 吉他学习Flutter Web应用

✨ 功能特性:
- 🎵 五度圈可视化学习工具
- 🎸 吉他指板练习系统  
- 🎹 音阶训练和练习
- 🎯 CAGED和弦系统学习
- 📱 响应式设计，支持各种设备
- 🔊 微信小程序兼容优化

🚀 部署配置:
- GitHub Pages自动部署
- GitHub Actions CI/CD
- 微信小程序WebView支持
- PWA离线访问支持

🎸 让学习吉他变得更简单！"

echo ""
echo "🎉 Git提交完成！"
echo ""
echo "📋 接下来的步骤："
echo "1️⃣  在GitHub创建新仓库 'guruguitar-new'"
echo "2️⃣  运行以下命令推送代码:"
echo "    git remote add origin https://github.com/你的用户名/guruguitar-new.git"
echo "    git push -u origin main"
echo ""
echo "3️⃣  在GitHub仓库设置中启用Pages:"
echo "    - 前往: Settings → Pages"
echo "    - Source选择: GitHub Actions"
echo "    - 等待自动部署完成"
echo ""
echo "4️⃣  访问你的应用:"
echo "    https://你的用户名.github.io/guruguitar-new/"
echo ""
echo "5️⃣  在微信小程序中配置域名:"
echo "    request合法域名: https://你的用户名.github.io"
echo "    业务域名: https://你的用户名.github.io"
echo ""
echo "🎸 GuruGuitar 即将在GitHub Pages上线！"
