// pages/circle/circle.js
const app = getApp()

Page({
  data: {
    selectedKey: null,
    relatedKeys: [],
    canvasWidth: 300,
    canvasHeight: 300,
    centerX: 150,
    centerY: 150,
    radius: 120
  },

  onLoad() {
    this.initCanvas()
    this.drawCircle()
  },

  onShow() {
    // 页面显示时重新绘制（可能有设置变化）
    this.drawCircle()
  },

  // 初始化画布
  initCanvas() {
    const query = wx.createSelectorQuery()
    query.select('.circle-canvas').boundingClientRect()
    query.exec((res) => {
      if (res[0]) {
        const rect = res[0]
        const size = Math.min(rect.width, rect.height) - 40
        this.setData({
          canvasWidth: size,
          canvasHeight: size,
          centerX: size / 2,
          centerY: size / 2,
          radius: size * 0.4
        })
        this.drawCircle()
      }
    })
  },

  // 绘制五度圈
  drawCircle() {
    const ctx = wx.createCanvasContext('circleCanvas')
    const { canvasWidth, canvasHeight, centerX, centerY, radius } = this.data
    
    // 清空画布
    ctx.clearRect(0, 0, canvasWidth, canvasHeight)
    
    // 绘制背景圆
    ctx.setFillStyle('#FFFFFF')
    ctx.setStrokeStyle('#E0E0E0')
    ctx.setLineWidth(2)
    ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI)
    ctx.fill()
    ctx.stroke()
    
    // 绘制内圆
    ctx.setStrokeStyle('#F0F0F0')
    ctx.setLineWidth(1)
    ctx.arc(centerX, centerY, radius * 0.7, 0, 2 * Math.PI)
    ctx.stroke()
    
    // 绘制调性
    app.globalData.circleOfFifths.forEach((key, index) => {
      this.drawKey(ctx, key, index)
    })
    
    // 绘制中心标题
    ctx.setFillStyle('#1A1A1A')
    ctx.setFontSize(16)
    ctx.setTextAlign('center')
    ctx.fillText('五度圈', centerX, centerY - 5)
    ctx.setFontSize(12)
    ctx.setFillStyle('#666')
    ctx.fillText('Circle of Fifths', centerX, centerY + 10)
    
    ctx.draw()
  },

  // 绘制单个调性
  drawKey(ctx, key, index) {
    const { centerX, centerY, radius } = this.data
    const angle = (key.angle - 90) * Math.PI / 180 // 转换为画布角度
    const keyRadius = 25
    
    // 计算位置
    const x = centerX + radius * 0.85 * Math.cos(angle)
    const y = centerY + radius * 0.85 * Math.sin(angle)
    
    // 绘制调性圆圈
    const isSelected = this.data.selectedKey && this.data.selectedKey.name === key.name
    ctx.setFillStyle(isSelected ? '#1A1A1A' : '#FFFFFF')
    ctx.setStrokeStyle(isSelected ? '#1A1A1A' : '#CCCCCC')
    ctx.setLineWidth(2)
    ctx.arc(x, y, keyRadius, 0, 2 * Math.PI)
    ctx.fill()
    ctx.stroke()
    
    // 绘制调性文字
    ctx.setFillStyle(isSelected ? '#FFFFFF' : '#1A1A1A')
    ctx.setFontSize(14)
    ctx.setTextAlign('center')
    ctx.fillText(key.note, x, y - 5)
    
    // 绘制大/小调标识
    ctx.setFontSize(10)
    ctx.setFillStyle(isSelected ? '#CCCCCC' : '#666')
    ctx.fillText('大调', x, y + 8)
    
    // 存储点击区域信息
    if (!this.keyClickAreas) {
      this.keyClickAreas = []
    }
    this.keyClickAreas[index] = {
      x: x,
      y: y,
      radius: keyRadius,
      key: key
    }
  },

  // 画布触摸事件
  onCanvasTouch(e) {
    const touch = e.touches[0]
    const rect = e.currentTarget
    
    // 转换坐标
    const canvasX = touch.x - rect.left
    const canvasY = touch.y - rect.top
    
    // 检查是否点击了某个调性
    if (this.keyClickAreas) {
      this.keyClickAreas.forEach(area => {
        const distance = Math.sqrt(
          Math.pow(canvasX - area.x, 2) + Math.pow(canvasY - area.y, 2)
        )
        
        if (distance <= area.radius) {
          this.selectKey({ currentTarget: { dataset: { key: area.key } } })
        }
      })
    }
  },

  onCanvasTouchEnd() {
    // 触摸结束处理
  },

  // 选择调性
  selectKey(e) {
    const key = e.currentTarget.dataset.key
    
    // 计算相关调性
    const relatedKeys = this.getRelatedKeys(key)
    
    this.setData({
      selectedKey: key,
      relatedKeys: relatedKeys
    })
    
    // 重新绘制五度圈以显示选中状态
    this.drawCircle()
    
    // 保存到全局设置
    app.globalData.userSettings.selectedKey = key.name
    app.saveUserSettings()
    
    // 触觉反馈
    wx.vibrateShort()
  },

  // 获取相关调性
  getRelatedKeys(selectedKey) {
    const keys = app.globalData.circleOfFifths
    const selectedIndex = keys.findIndex(k => k.name === selectedKey.name)
    const related = []
    
    // 属调（五度上行）
    const dominantIndex = (selectedIndex + 1) % keys.length
    related.push({
      ...keys[dominantIndex],
      relation: '属调 (V)'
    })
    
    // 下属调（五度下行）
    const subdominantIndex = (selectedIndex - 1 + keys.length) % keys.length
    related.push({
      ...keys[subdominantIndex],
      relation: '下属调 (IV)'
    })
    
    // 相对小调（暂时用简化处理）
    const relativeMinorNote = this.getRelativeMinor(selectedKey.note)
    related.push({
      name: relativeMinorNote + '小调',
      note: relativeMinorNote,
      relation: '相对小调'
    })
    
    return related
  },

  // 获取相对小调
  getRelativeMinor(majorNote) {
    const notes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
    const majorIndex = notes.indexOf(majorNote)
    const minorIndex = (majorIndex - 3 + notes.length) % notes.length
    return notes[minorIndex]
  },

  // 播放和弦（模拟）
  playChord(e) {
    const chord = e.currentTarget.dataset.chord
    
    // 显示和弦信息
    wx.showToast({
      title: `播放 ${chord} 和弦`,
      icon: 'none',
      duration: 1000
    })
    
    // 触觉反馈
    wx.vibrateShort()
  },

  // 跳转到音阶练习
  goToScales() {
    wx.switchTab({
      url: '/pages/scales/scales'
    })
  },

  // 练习和弦
  practiceChords() {
    const { selectedKey } = this.data
    if (!selectedKey) return
    
    wx.showModal({
      title: `${selectedKey.name}和弦进行`,
      content: `尝试弹奏：${selectedKey.chords[0]} - ${selectedKey.chords[5]} - ${selectedKey.chords[3]} - ${selectedKey.chords[4]}`,
      showCancel: false,
      confirmText: '知道了'
    })
  },

  // 跳转到指板练习
  goToFretboard() {
    // 设置当前调性到全局数据
    if (this.data.selectedKey) {
      app.globalData.userSettings.selectedKey = this.data.selectedKey.name
      app.saveUserSettings()
    }
    
    wx.switchTab({
      url: '/pages/fretboard/fretboard'
    })
  },

  // 页面分享
  onShareAppMessage() {
    return {
      title: '吉他大师 - 五度圈学习工具',
      path: '/pages/circle/circle',
      imageUrl: '/images/share-circle.jpg'
    }
  }
})
