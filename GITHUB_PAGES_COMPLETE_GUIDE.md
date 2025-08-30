# 🚀 GuruGuitar GitHub Pages 完整部署指南

## 📋 概述

本指南将帮助您将 GuruGuitar Flutter Web 应用部署到 GitHub Pages，完全免费且支持在微信小程序中使用。

## 🎯 GitHub Pages 的优势

- ✅ **完全免费** - 无需任何费用
- ✅ **自动部署** - 推送代码即自动更新  
- ✅ **稳定可靠** - GitHub 官方服务
- ✅ **HTTPS 支持** - 自动SSL证书
- ✅ **微信支持** - 微信小程序webview兼容
- ✅ **全球CDN** - 快速访问速度

## 🛠 预配置文件说明

项目已包含以下预配置文件：

### 1. GitHub Actions 工作流
- `.github/workflows/deploy.yml` - 完整构建+部署
- `.github/workflows/deploy-prebuilt.yml` - 使用预构建文件部署（推荐）

### 2. 已优化的配置
- `guruguitar_app/web/index.html` - 已配置正确的base href
- `guruguitar_app/build/web/index.html` - 构建文件已更新
- 微信小程序兼容性优化

## 🚀 快速部署步骤

### 第一步：运行部署脚本

```bash
# 在项目根目录执行
./deploy_github_pages.sh
```

### 第二步：创建GitHub仓库

1. 访问 [GitHub](https://github.com) 并登录
2. 点击右上角 "+" → "New repository"
3. 仓库名称：`guruguitar-new`
4. 设置为 **Public**（必须，GitHub Pages免费版需要）
5. 不要初始化README（因为本地已有文件）
6. 点击 "Create repository"

### 第三步：推送代码

```bash
# 添加远程仓库（替换为您的用户名）
git remote add origin https://github.com/YOUR_USERNAME/guruguitar-new.git

# 推送代码
git push -u origin main
```

### 第四步：启用GitHub Pages

1. 进入仓库设置：`https://github.com/YOUR_USERNAME/guruguitar-new/settings`
2. 在左侧菜单找到 "Pages"
3. **Source** 选择：`GitHub Actions`
4. 保存设置

### 第五步：等待自动部署

1. 进入仓库的 "Actions" 标签页
2. 观察部署进度（通常2-5分钟）
3. 部署成功后，访问：`https://YOUR_USERNAME.github.io/guruguitar-new/`

## 📱 微信小程序配置

### 1. 域名白名单配置

在微信小程序管理后台：

```
request合法域名: https://YOUR_USERNAME.github.io
业务域名: https://YOUR_USERNAME.github.io
```

### 2. 修改小程序代码

编辑 `wechat_miniprogram/pages/index/index.js`：

```javascript
data: {
  // 替换为您的实际GitHub Pages地址
  webUrl: 'https://YOUR_USERNAME.github.io/guruguitar-new/',
  webLoaded: false
},
```

## 🔧 仓库权限设置

确保GitHub Actions有正确权限：

1. 前往：仓库设置 → Actions → General
2. **Workflow permissions** 选择：`Read and write permissions`
3. 勾选 `Allow GitHub Actions to create and approve pull requests`
4. 保存设置

## 🎯 自动部署流程

每次推送代码到 `main` 分支时：

1. GitHub Actions 自动触发
2. 使用预构建的 `build/web` 文件
3. 修复 base href 路径
4. 部署到 GitHub Pages
5. 约2-3分钟完成

## 📊 部署方式对比

| 特性 | GitHub Pages | Vercel | Netlify |
|------|-------------|--------|---------|
| **价格** | 完全免费 | 免费+付费 | 免费+付费 |
| **自定义域名** | ✅ 支持 | ✅ 支持 | ✅ 支持 |
| **HTTPS** | ✅ 自动 | ✅ 自动 | ✅ 自动 |
| **构建速度** | 中等 | 快 | 快 |
| **部署速度** | 2-5分钟 | 1-3分钟 | 1-3分钟 |
| **微信支持** | ✅ 完美 | ✅ 完美 | ✅ 完美 |
| **适用场景** | 静态网站 | 全栈应用 | 静态网站 |

## 🎮 测试您的部署

### 1. 桌面浏览器测试
访问：`https://YOUR_USERNAME.github.io/guruguitar-new/`

### 2. 手机浏览器测试
- 使用手机浏览器访问相同地址
- 测试触摸交互
- 检查响应式布局

### 3. 微信内测试
- 在微信中打开链接
- 测试所有功能
- 检查加载速度

## 🛠 故障排查

### 1. 部署失败

**检查Actions日志：**
```
https://github.com/YOUR_USERNAME/guruguitar-new/actions
```

**常见问题：**
- 权限不足：检查Workflow permissions设置
- 文件路径错误：确认 `guruguitar_app/build/web` 存在
- 语法错误：检查 `.yml` 文件格式

### 2. 页面无法访问

**可能原因：**
- Pages设置错误：确认Source选择 "GitHub Actions"
- 仓库私有：必须设置为Public
- DNS传播：等待最多24小时

### 3. 功能异常

**调试方法：**
- 打开浏览器开发者工具
- 检查Console错误信息
- 确认所有资源加载正常
- 验证base href路径正确

### 4. 微信小程序问题

**检查项目：**
- 域名是否已添加到白名单
- webUrl是否配置正确
- 网络请求是否被拦截

## 🔄 更新和维护

### 更新应用
```bash
# 修改代码后
cd guruguitar_app
flutter build web --base-href "/guruguitar-new/" --release

# 回到根目录
cd ..
git add .
git commit -m "更新应用功能"
git push origin main
```

### 监控部署
- 定期检查 Actions 是否成功
- 监控应用访问速度
- 收集用户反馈

## 🎸 功能特性

您的 GuruGuitar 应用包含：

- 🎵 **五度圈学习** - 可视化音乐理论
- 🎸 **指板练习** - 互动式吉他指板
- 🎹 **音阶训练** - 各种音阶练习
- 🎯 **CAGED系统** - 和弦位置学习
- 📱 **响应式设计** - 支持所有设备
- 🔊 **微信优化** - 完美支持小程序

## 🌟 高级配置

### 自定义域名

如果您有自己的域名：

1. 在DNS设置中添加CNAME记录：
   ```
   www.yourdomain.com → YOUR_USERNAME.github.io
   ```

2. 在仓库根目录创建 `CNAME` 文件：
   ```
   www.yourdomain.com
   ```

3. 推送更改并等待生效

### SSL证书

GitHub Pages自动提供SSL证书，如果使用自定义域名：
- 等待24-48小时自动生成
- 确保DNS设置正确
- 检查证书状态

## 📈 性能优化

### 已包含的优化：
- 预加载关键资源
- 压缩的构建文件  
- 微信环境检测
- 加载动画
- 错误处理

### 进一步优化：
- 启用浏览器缓存
- 图片优化
- 代码分割
- CDN加速

## 🎉 完成！

恭喜！您的 GuruGuitar 应用现在已经：

✅ 部署到 GitHub Pages  
✅ 支持自动部署  
✅ 兼容微信小程序  
✅ 具备HTTPS安全访问  
✅ 全球CDN加速  

**访问地址：** `https://YOUR_USERNAME.github.io/guruguitar-new/`

## 🆘 获得帮助

如果遇到问题：

1. 检查 [GitHub Pages 文档](https://docs.github.com/en/pages)
2. 查看项目的 Issues 页面
3. 参考 [Flutter Web 部署指南](https://docs.flutter.dev/deployment/web)

---

💡 **提示：** 记住将所有 `YOUR_USERNAME` 替换为您实际的 GitHub 用户名！

🎸 **祝您的吉他学习应用部署成功！**
