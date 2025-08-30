// pages/fretboard/fretboard.js
const app = getApp()

Page({
  data: {
    currentKey: null,
    selectedKeyIndex: 0,
    keyNames: [],
    showNotes: true,
    showIntervals: false,
    fretMarkers: [],
    scaleDegrees: ['1', '2', '3', '4', '5', '6', '7'],
    highlightedNote: null,
    canvasWidth: 350,
    canvasHeight: 200,
    fretPositions: []
  },

  onLoad() {
    this.initData()
    this.initCanvas()
  },

  onShow() {
    // 从全局数据加载当前选中的调性
    const selectedKeyName = app.globalData.userSettings.selectedKey
    if (selectedKeyName) {
      const keyIndex = app.globalData.circleOfFifths.findIndex(k => k.name === selectedKeyName)
      if (keyIndex !== -1) {
        this.setData({
          selectedKeyIndex: keyIndex,
          currentKey: app.globalData.circleOfFifths[keyIndex]
        })
      }
    }
    this.drawFretboard()
  },

  // 初始化数据
  initData() {
    const keyNames = app.globalData.circleOfFifths.map(key => key.name)
    const currentKey = app.globalData.circleOfFifths[0]
    
    // 生成品格标记
    const fretMarkers = []
    for (let i = 1; i <= 12; i++) {
      fretMarkers.push({
        fret: i,
        position: (i / 12) * 100
      })
    }
    
    this.setData({
      keyNames,
      currentKey,
      fretMarkers
    })
  },

  // 初始化画布
  initCanvas() {
    const query = wx.createSelectorQuery()
    query.select('.fretboard-canvas').boundingClientRect()
    query.exec((res) => {
      if (res[0]) {
        const rect = res[0]
        this.setData({
          canvasWidth: rect.width,
          canvasHeight: rect.height
        })
        this.drawFretboard()
      }
    })
  },

  // 绘制指板
  drawFretboard() {
    const ctx = wx.createCanvasContext('fretboardCanvas')
    const { canvasWidth, canvasHeight } = this.data
    
    // 清空画布
    ctx.clearRect(0, 0, canvasWidth, canvasHeight)
    
    // 绘制背景
    ctx.setFillStyle('#D2691E') // 木头颜色
    ctx.fillRect(0, 0, canvasWidth, canvasHeight)
    
    // 绘制品格线
    const fretSpacing = canvasWidth / 12
    for (let i = 1; i <= 12; i++) {
      const x = i * fretSpacing
      ctx.setStrokeStyle('#CCCCCC')
      ctx.setLineWidth(2)
      ctx.moveTo(x, 0)
      ctx.lineTo(x, canvasHeight)
      ctx.stroke()
    }
    
    // 绘制琴弦
    const stringSpacing = canvasHeight / 7
    for (let i = 1; i <= 6; i++) {
      const y = i * stringSpacing
      ctx.setStrokeStyle('#C0C0C0')
      ctx.setLineWidth(1 + i * 0.3) // 低音弦更粗
      ctx.moveTo(0, y)
      ctx.lineTo(canvasWidth, y)
      ctx.stroke()
    }
    
    // 绘制品格标记点
    const markerFrets = [3, 5, 7, 9, 12]
    markerFrets.forEach(fret => {
      const x = (fret - 0.5) * fretSpacing
      if (fret === 12) {
        // 12品两个点
        ctx.setFillStyle('#FFFFFF')
        ctx.arc(x, canvasHeight * 0.3, 6, 0, 2 * Math.PI)
        ctx.fill()
        ctx.arc(x, canvasHeight * 0.7, 6, 0, 2 * Math.PI)
        ctx.fill()
      } else {
        // 单个点
        ctx.setFillStyle('#FFFFFF')
        ctx.arc(x, canvasHeight * 0.5, 8, 0, 2 * Math.PI)
        ctx.fill()
      }
    })
    
    // 绘制音符位置
    this.drawNotePositions(ctx)
    
    ctx.draw()
  },

  // 绘制音符位置
  drawNotePositions(ctx) {
    const { currentKey, showNotes, showIntervals, highlightedNote } = this.data
    if (!currentKey) return
    
    const { canvasWidth, canvasHeight } = this.data
    const fretSpacing = canvasWidth / 12
    const stringSpacing = canvasHeight / 7
    
    // 计算每个音符在指板上的位置
    currentKey.scale.forEach((note, scaleIndex) => {
      const positions = this.getNotePositionsOnFretboard(note)
      
      positions.forEach(pos => {
        const x = (pos.fret === 0 ? 0.3 : pos.fret - 0.5) * fretSpacing
        const y = pos.stringNumber * stringSpacing
        
        // 判断是否高亮
        const isHighlighted = highlightedNote === note
        const isRoot = scaleIndex === 0
        
        // 绘制音符圆圈
        if (isRoot) {
          ctx.setFillStyle('#FF4444')
        } else if (isHighlighted) {
          ctx.setFillStyle('#1A1A1A')
        } else {
          ctx.setFillStyle('#FFFFFF')
        }
        
        ctx.setStrokeStyle('#333333')
        ctx.setLineWidth(2)
        ctx.arc(x, y, 15, 0, 2 * Math.PI)
        ctx.fill()
        ctx.stroke()
        
        // 绘制文字
        ctx.setFillStyle(isRoot || isHighlighted ? '#FFFFFF' : '#333333')
        ctx.setFontSize(12)
        ctx.setTextAlign('center')
        
        if (showNotes) {
          ctx.fillText(note, x, y + 4)
        } else if (showIntervals) {
          ctx.fillText(this.data.scaleDegrees[scaleIndex], x, y + 4)
        }
      })
    })
  },

  // 获取音符在指板上的位置
  getNotePositionsOnFretboard(note) {
    const noteNames = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
    const positions = []
    const targetNoteIndex = noteNames.indexOf(note)
    
    app.globalData.guitarStrings.forEach(string => {
      const openNoteIndex = noteNames.indexOf(string.openNote)
      for (let fret = 0; fret <= 12; fret++) {
        const currentNoteIndex = (openNoteIndex + fret) % 12
        if (currentNoteIndex === targetNoteIndex) {
          positions.push({
            stringNumber: string.stringNumber,
            fret: fret,
            note: note
          })
        }
      }
    })
    
    return positions
  },

  // 调性变化
  onKeyChange(e) {
    const index = parseInt(e.detail.value)
    const key = app.globalData.circleOfFifths[index]
    
    this.setData({
      selectedKeyIndex: index,
      currentKey: key,
      highlightedNote: null
    })
    
    // 保存到全局设置
    app.globalData.userSettings.selectedKey = key.name
    app.saveUserSettings()
    
    this.drawFretboard()
  },

  // 切换音符显示
  toggleNotes() {
    this.setData({
      showNotes: !this.data.showNotes,
      showIntervals: false
    })
    this.drawFretboard()
  },

  // 切换音程显示
  toggleIntervals() {
    this.setData({
      showIntervals: !this.data.showIntervals,
      showNotes: false
    })
    this.drawFretboard()
  },

  // 高亮音符
  highlightNote(e) {
    const note = e.currentTarget.dataset.note
    this.setData({
      highlightedNote: this.data.highlightedNote === note ? null : note
    })
    this.drawFretboard()
    
    // 触觉反馈
    wx.vibrateShort()
  },

  // 指板触摸事件
  onFretboardTouch(e) {
    const touch = e.touches[0]
    const { canvasWidth, canvasHeight } = this.data
    const fretSpacing = canvasWidth / 12
    const stringSpacing = canvasHeight / 7
    
    // 计算触摸位置对应的品格和琴弦
    const fret = Math.round(touch.x / fretSpacing)
    const string = Math.round(touch.y / stringSpacing)
    
    if (fret >= 0 && fret <= 12 && string >= 1 && string <= 6) {
      this.playNote(string, fret)
    }
  },

  onFretboardTouchEnd() {
    // 触摸结束处理
  },

  // 播放音符（模拟）
  playNote(string, fret) {
    // 计算音符名称
    const noteNames = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
    const stringInfo = app.globalData.guitarStrings.find(s => s.stringNumber === string)
    if (!stringInfo) return
    
    const openNoteIndex = noteNames.indexOf(stringInfo.openNote)
    const noteIndex = (openNoteIndex + fret) % 12
    const noteName = noteNames[noteIndex]
    
    // 显示音符信息
    wx.showToast({
      title: `${string}弦 ${fret}品: ${noteName}`,
      icon: 'none',
      duration: 1000
    })
    
    // 触觉反馈
    wx.vibrateShort()
  },

  // 开始音符定位练习
  startNoteFinding() {
    wx.showModal({
      title: '音符定位练习',
      content: '请在指板上找到所有的 ' + this.data.currentKey.scale[0] + ' 音符位置',
      showCancel: false,
      confirmText: '开始练习'
    })
  },

  // 开始音阶练习
  startScalePractice() {
    wx.showModal({
      title: '音阶练习',
      content: `练习${this.data.currentKey.name}音阶，按照 1-2-3-4-5-6-7-8 的顺序弹奏`,
      showCancel: false,
      confirmText: '开始练习'
    })
  },

  // 开始音程训练
  startIntervalTraining() {
    this.setData({
      showNotes: false,
      showIntervals: true
    })
    this.drawFretboard()
    
    wx.showToast({
      title: '已切换到音程显示模式',
      icon: 'success'
    })
  },

  // 页面分享
  onShareAppMessage() {
    return {
      title: '吉他大师 - 指板练习工具',
      path: '/pages/fretboard/fretboard',
      imageUrl: '/images/share-fretboard.jpg'
    }
  }
})
