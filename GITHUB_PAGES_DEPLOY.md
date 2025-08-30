# 🚀 GitHub Pages 部署指南

## 🎯 GitHub Pages 部署的优势

- ✅ **完全免费** - 无需付费服务
- ✅ **自动部署** - 推送代码即自动更新
- ✅ **稳定可靠** - GitHub 官方服务
- ✅ **HTTPS 支持** - 自动SSL证书
- ✅ **自定义域名** - 可绑定自己的域名

## 📋 部署步骤

### 方法1：使用预构建文件（推荐，最简单）

1. **启用 GitHub Pages**
   - 访问您的 GitHub 仓库页面
   - 点击 "Settings" 标签
   - 向下滚动到 "Pages" 部分
   - Source 选择 "GitHub Actions"

2. **推送配置文件**
```bash
git add .github/
git commit -m "Add GitHub Pages deployment workflow"
git push origin main
```

3. **访问部署的网站**
   - 在 GitHub 仓库的 Actions 标签查看部署进度
   - 部署完成后访问：`https://heijin-yuuby.github.io/guru-guitar/`

### 方法2：完整构建部署

如果您想要 GitHub Actions 重新构建 Flutter 项目：

1. 使用 `deploy.yml` 工作流（已包含Flutter构建步骤）
2. 删除 `build-only.yml`
3. 推送代码触发自动部署

## 🔧 快速部署命令

```bash
# 添加 GitHub Actions 配置
git add .github/
git commit -m "feat: Add GitHub Pages deployment"
git push origin main

# 查看部署状态
echo "访问 https://github.com/heijin-yuuby/guru-guitar/actions 查看部署进度"
echo "部署完成后访问：https://heijin-yuuby.github.io/guru-guitar/"
```

## ⚙️ GitHub 仓库设置

### 1. 启用 GitHub Pages
1. 进入仓库设置：`https://github.com/heijin-yuuby/guru-guitar/settings`
2. 找到 "Pages" 部分
3. Source 选择：**GitHub Actions**
4. 保存设置

### 2. 设置仓库权限
确保 Actions 有写入权限：
1. 设置 → Actions → General
2. Workflow permissions → Read and write permissions
3. 保存

## 🌐 访问地址

部署成功后，您的应用将在以下地址可用：

**主要地址**: `https://heijin-yuuby.github.io/guru-guitar/`

## 📱 微信小程序配置

GitHub Pages 部署后，在微信小程序中使用：

1. **域名白名单配置**
```
request合法域名: https://heijin-yuuby.github.io
业务域名: https://heijin-yuuby.github.io
```

2. **小程序代码修改**
```javascript
// pages/index/index.js
data: {
  webUrl: 'https://heijin-yuuby.github.io/guru-guitar/'
}
```

## 🔄 自动部署流程

推送代码后：
1. **GitHub Actions 自动触发**
2. **使用预构建的 build/web 文件**
3. **部署到 GitHub Pages**
4. **约2-3分钟完成**

## 📊 对比 Vercel vs GitHub Pages

| 特性 | GitHub Pages | Vercel |
|------|-------------|---------|
| **价格** | 完全免费 | 免费+付费计划 |
| **自定义域名** | ✅ 支持 | ✅ 支持 |
| **HTTPS** | ✅ 自动 | ✅ 自动 |
| **构建速度** | 中等 | 较快 |
| **部署速度** | 2-5分钟 | 1-3分钟 |
| **CDN** | GitHub CDN | Vercel Edge |
| **适用场景** | 静态网站 | 全栈应用 |

## 🎯 选择建议

### 选择 GitHub Pages 如果：
- ✅ 想要完全免费的解决方案
- ✅ 不需要服务端功能
- ✅ 项目是开源的
- ✅ 对部署速度要求不高

### 选择 Vercel 如果：
- ✅ 需要更快的部署速度
- ✅ 需要高级CDN功能
- ✅ 计划扩展为全栈应用
- ✅ 需要预览分支功能

## 🛠 故障排查

### 1. 部署失败
- 检查 Actions 日志：`https://github.com/heijin-yuuby/guru-guitar/actions`
- 确认 build/web 文件存在
- 检查工作流文件语法

### 2. 页面无法访问
- 确认 Pages 设置正确
- 检查仓库是否公开
- 等待DNS传播（最多24小时）

### 3. 功能异常
- 检查浏览器控制台错误
- 确认路径配置正确
- 验证HTTPS证书

## 🎸 完成！

GitHub Pages 部署更简单，而且完全免费！

---

💡 **提示**: 两种部署方式都可以同时使用，GitHub Pages 作为主要访问地址，Vercel 作为备用。

