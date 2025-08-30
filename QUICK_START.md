# 🚀 快速开始 - GuruGuitar GitHub Pages 部署

## ⚡ 一分钟部署

```bash
# 1. 运行部署脚本
./deploy_github_pages.sh

# 2. 在GitHub创建仓库 'guruguitar-new' (Public)

# 3. 推送代码 (替换YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/guruguitar-new.git
git push -u origin main

# 4. 在GitHub仓库设置 → Pages → Source选择 "GitHub Actions"

# 5. 等待部署完成，访问：
# https://YOUR_USERNAME.github.io/guruguitar-new/
```

## 📱 微信小程序配置

### 域名白名单
```
https://YOUR_USERNAME.github.io
```

### 小程序代码
```javascript
// wechat_miniprogram/pages/index/index.js
webUrl: 'https://YOUR_USERNAME.github.io/guruguitar-new/'
```

## 🔧 重要文件

- `.github/workflows/deploy-prebuilt.yml` - 自动部署配置
- `guruguitar_app/web/index.html` - 已配置base href
- `deploy_github_pages.sh` - 一键部署脚本

## ✅ 检查清单

- [ ] GitHub仓库创建且为Public
- [ ] Pages设置选择GitHub Actions
- [ ] 代码推送到main分支
- [ ] Actions运行成功
- [ ] 网站可访问
- [ ] 微信域名白名单已配置

## 🎯 完成！

访问：`https://YOUR_USERNAME.github.io/guruguitar-new/`

---

📖 详细说明请查看：[GITHUB_PAGES_COMPLETE_GUIDE.md](./GITHUB_PAGES_COMPLETE_GUIDE.md)
