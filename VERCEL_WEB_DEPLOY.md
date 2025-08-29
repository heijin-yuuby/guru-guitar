# 🚀 Vercel 网页端部署指南

由于网络或环境问题，我们使用更简单的网页端部署方式。

## 📦 方法1：直接上传文件部署（最简单）

### 1. 准备文件
您的构建文件已经准备好了：
```
guruguitar_app/build/web/
├── index.html
├── main.dart.js  
├── flutter.js
├── assets/
├── icons/
└── ...
```

### 2. 部署步骤
1. 访问 [vercel.com](https://vercel.com)
2. 点击 "New Project"
3. 选择 "Upload" 或 "Import Third-Party Git Repository"
4. 拖拽整个 `build/web` 文件夹到页面
5. 点击 "Deploy"

## 📦 方法2：GitHub + Vercel（推荐）

### 1. 创建 GitHub 仓库
```bash
# 初始化 Git 仓库
git init
git add .
git commit -m "Initial commit: GuruGuitar Flutter Web App"
```

### 2. 推送到 GitHub
1. 在 GitHub 创建新仓库 `guruguitar`
2. 复制仓库 URL
3. 推送代码：
```bash
git remote add origin https://github.com/您的用户名/guruguitar.git
git branch -M main
git push -u origin main
```

### 3. Vercel 导入
1. 访问 [vercel.com](https://vercel.com) 并登录
2. 点击 "New Project"
3. 选择 "Import Git Repository"
4. 选择您的 GitHub 仓库
5. Vercel 会自动检测到 `vercel.json` 配置
6. 点击 "Deploy"

## 📦 方法3：本地临时服务器测试

如果您想先本地测试，可以使用 Python 的内置服务器：

```bash
# 进入构建目录
cd build/web

# 启动本地服务器
python3 -m http.server 8000

# 或者使用 Python 2
python -m SimpleHTTPServer 8000
```

然后访问 `http://localhost:8000` 查看效果。

## ⚡ 快速 Git 部署脚本

我为您创建了一个快速脚本：
