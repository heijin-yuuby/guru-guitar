# 🚀 微信小程序快速发布指南

## ⚡ 快速开始

你的GuruGuitar应用已经部署成功！现在可以在微信小程序中发布。

**应用地址**: https://heijin-yuuby.github.io/guru-guitar/

## 🔥 关键要求

⚠️ **重要**: 只有**企业主体**的小程序才能使用web-view组件！

## 📋 发布清单

### 第一步：配置业务域名 (5分钟)

1. 登录 [微信公众平台](https://mp.weixin.qq.com/)
2. **开发** → **开发管理** → **开发设置**
3. 在"业务域名"中添加：`heijin-yuuby.github.io`
4. 下载校验文件 `MP_verify_xxxxxx.txt`
5. 运行脚本添加校验文件：
   ```bash
   ./add_wechat_verification.sh MP_verify_xxxxxx.txt
   ```

### 第二步：重新部署 (3分钟)

```bash
# 重新构建
cd guruguitar_app
flutter build web --base-href "/guru-guitar/" --release
cd ..

# 提交推送
git add .
git commit -m "添加微信域名校验文件"
git push origin main
```

### 第三步：验证域名 (1分钟)

1. 等待GitHub Pages部署完成 (2-3分钟)
2. 访问: https://heijin-yuuby.github.io/guru-guitar/MP_verify_xxxxxx.txt
3. 确认文件可以访问
4. 在微信后台点击"校验"

### 第四步：导入小程序 (2分钟)

1. 打开微信开发者工具
2. 选择"小程序" → "导入项目"
3. 项目目录：`/Users/wajilao/Documents/workspace/guruguitar-new/wechat_miniprogram/`
4. 填入你的小程序AppID
5. 修改 `project.config.json` 中的appid

### 第五步：测试和上传 (5分钟)

1. 在开发者工具中点击"编译"
2. 测试web-view是否正常显示
3. 点击"预览"用手机测试
4. 点击"上传"提交代码

### 第六步：审核发布 (1-7天)

1. 在微信公众平台提交审核
2. 等待审核通过
3. 发布上线

## ✅ 检查清单

- [ ] 确认小程序主体是企业类型
- [ ] 业务域名配置完成
- [ ] 域名校验文件上传成功
- [ ] 小程序代码导入开发者工具
- [ ] 本地测试功能正常
- [ ] 真机预览测试通过
- [ ] 代码上传到微信服务器
- [ ] 提交审核申请

## 🎯 常见问题

### Q: 个人主体可以使用吗？
A: ❌ 不可以。微信小程序的web-view组件只支持企业主体。

### Q: 需要备案域名吗？
A: GitHub Pages域名无需备案，但如果使用自定义域名建议备案。

### Q: 审核需要多长时间？
A: 通常1-7个工作日，首次可能较慢。

### Q: 为什么web-view显示空白？
A: 检查域名是否配置正确，校验文件是否可访问。

## 🆘 获得帮助

如果遇到问题：
1. 查看微信开发者工具控制台错误
2. 确认网络请求是否被拦截
3. 检查域名配置是否正确

---

🎸 **祝你的吉他学习应用成功上线！**
