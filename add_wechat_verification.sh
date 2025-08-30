#!/bin/bash

echo "🔧 微信小程序域名校验文件配置脚本"
echo "=================================="

# 检查当前目录
if [ ! -d "guruguitar_app" ]; then
    echo "❌ 请在项目根目录运行此脚本"
    exit 1
fi

echo "📋 使用说明："
echo "1. 在微信公众平台下载校验文件 (MP_verify_xxxxxxxxx.txt)"
echo "2. 将文件名作为参数传递给此脚本"
echo ""
echo "用法: ./add_wechat_verification.sh MP_verify_xxxxxxxxx.txt"
echo ""

# 检查是否提供了文件名参数
if [ $# -eq 0 ]; then
    echo "❌ 请提供校验文件名"
    echo "例如: ./add_wechat_verification.sh MP_verify_abc123.txt"
    exit 1
fi

VERIFY_FILE=$1

# 检查文件是否存在
if [ ! -f "$VERIFY_FILE" ]; then
    echo "❌ 找不到文件: $VERIFY_FILE"
    echo "请确保校验文件在当前目录中"
    exit 1
fi

echo "📁 复制校验文件到web目录..."
cp "$VERIFY_FILE" "guruguitar_app/web/"

echo "📁 复制校验文件到build/web目录..."
cp "$VERIFY_FILE" "guruguitar_app/build/web/"

echo "✅ 校验文件配置完成！"
echo ""
echo "📋 接下来的步骤："
echo "1. 运行以下命令重新构建项目："
echo "   cd guruguitar_app"
echo "   flutter build web --base-href \"/guru-guitar/\" --release"
echo "   cd .."
echo ""
echo "2. 提交并推送更改："
echo "   git add ."
echo "   git commit -m \"添加微信小程序域名校验文件\""
echo "   git push origin main"
echo ""
echo "3. 等待GitHub Pages部署完成 (约2-5分钟)"
echo ""
echo "4. 在微信公众平台验证域名："
echo "   访问: https://heijin-yuuby.github.io/guru-guitar/$VERIFY_FILE"
echo "   确认文件可以访问，然后在微信后台点击\"校验\""
echo ""
echo "🎉 完成后即可在小程序中使用web-view!"
