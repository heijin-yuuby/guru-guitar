// pages/index/index.js
Page({
  data: {
    // 替换为您的 Vercel 部署域名
    webUrl: 'https://your-guruguitar-app.vercel.app',
    webLoaded: false
  },

  onLoad: function(options) {
    console.log('小程序页面加载');
    
    // 检查网络状态
    wx.getNetworkType({
      success: (res) => {
        console.log('网络类型:', res.networkType);
        if (res.networkType === 'none') {
          this.showNetworkError();
          return;
        }
        
        // 显示加载中
        wx.showLoading({
          title: '加载中...',
          mask: true
        });
        
        // 3秒后显示web-view
        setTimeout(() => {
          this.setData({
            webLoaded: true
          });
          wx.hideLoading();
        }, 3000);
      }
    });
  },

  onShow: function() {
    console.log('小程序页面显示');
  },

  onLoad: function() {
    console.log('Web页面加载成功');
    wx.hideLoading();
    
    // 可以发送消息给web页面
    // this.sendMessageToWeb({ type: 'miniprogram_ready' });
  },

  onMessage: function(e) {
    console.log('收到Web页面消息:', e.detail.data);
    
    // 处理来自Flutter Web的消息
    const data = e.detail.data;
    if (data && data.length > 0) {
      const message = data[0];
      
      switch(message.type) {
        case 'share':
          this.handleShare(message.data);
          break;
        case 'navigate':
          this.handleNavigate(message.data);
          break;
        case 'feedback':
          this.handleFeedback(message.data);
          break;
        default:
          console.log('未知消息类型:', message.type);
      }
    }
  },

  onError: function(e) {
    console.error('Web页面加载失败:', e);
    wx.hideLoading();
    
    wx.showModal({
      title: '加载失败',
      content: '网页加载失败，请检查网络连接或稍后重试',
      showCancel: true,
      cancelText: '返回',
      confirmText: '重试',
      success: (res) => {
        if (res.confirm) {
          // 重新加载
          this.setData({
            webLoaded: false
          });
          setTimeout(() => {
            this.setData({
              webLoaded: true
            });
          }, 1000);
        } else {
          // 返回上一页或首页
          wx.navigateBack({
            fail: () => {
              wx.reLaunch({
                url: '/pages/index/index'
              });
            }
          });
        }
      }
    });
  },

  // 处理分享
  handleShare: function(data) {
    wx.showShareMenu({
      withShareTicket: true,
      menus: ['shareAppMessage', 'shareTimeline']
    });
  },

  // 处理导航
  handleNavigate: function(data) {
    if (data.url) {
      wx.navigateTo({
        url: data.url
      });
    }
  },

  // 处理反馈
  handleFeedback: function(data) {
    wx.showModal({
      title: '用户反馈',
      content: data.message || '感谢您的反馈！',
      showCancel: false
    });
  },

  // 显示网络错误
  showNetworkError: function() {
    wx.showModal({
      title: '网络异常',
      content: '请检查网络连接后重试',
      showCancel: false,
      confirmText: '重试',
      success: () => {
        // 重新检查网络
        this.onLoad();
      }
    });
  },

  // 发送消息给Web页面
  sendMessageToWeb: function(message) {
    // 注意：这个功能需要web页面配合监听
    console.log('发送消息给Web页面:', message);
  },

  // 分享配置
  onShareAppMessage: function() {
    return {
      title: '吉他大师 - 专业的吉他学习工具',
      desc: '指板练习、音阶训练、五度圈学习，让吉他学习更简单',
      path: '/pages/index/index',
      imageUrl: '/images/share.jpg' // 需要添加分享图片
    };
  },

  // 分享到朋友圈
  onShareTimeline: function() {
    return {
      title: '吉他大师 - 专业的吉他学习工具',
      imageUrl: '/images/share.jpg'
    };
  }
});
