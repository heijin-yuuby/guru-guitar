// app.js
App({
  globalData: {
    // 音乐理论数据
    circleOfFifths: [
      {
        name: 'C大调',
        note: 'C',
        scale: ['C', 'D', 'E', 'F', 'G', 'A', 'B'],
        chords: ['C', 'Dm', 'Em', 'F', 'G', 'Am', 'Bdim'],
        sharps: 0,
        flats: 0,
        angle: 0
      },
      {
        name: 'G大调',
        note: 'G',
        scale: ['G', 'A', 'B', 'C', 'D', 'E', 'F#'],
        chords: ['G', 'Am', 'Bm', 'C', 'D', 'Em', 'F#dim'],
        sharps: 1,
        flats: 0,
        angle: 30
      },
      {
        name: 'D大调',
        note: 'D',
        scale: ['D', 'E', 'F#', 'G', 'A', 'B', 'C#'],
        chords: ['D', 'Em', 'F#m', 'G', 'A', 'Bm', 'C#dim'],
        sharps: 2,
        flats: 0,
        angle: 60
      },
      {
        name: 'A大调',
        note: 'A',
        scale: ['A', 'B', 'C#', 'D', 'E', 'F#', 'G#'],
        chords: ['A', 'Bm', 'C#m', 'D', 'E', 'F#m', 'G#dim'],
        sharps: 3,
        flats: 0,
        angle: 90
      },
      {
        name: 'E大调',
        note: 'E',
        scale: ['E', 'F#', 'G#', 'A', 'B', 'C#', 'D#'],
        chords: ['E', 'F#m', 'G#m', 'A', 'B', 'C#m', 'D#dim'],
        sharps: 4,
        flats: 0,
        angle: 120
      },
      {
        name: 'B大调',
        note: 'B',
        scale: ['B', 'C#', 'D#', 'E', 'F#', 'G#', 'A#'],
        chords: ['B', 'C#m', 'D#m', 'E', 'F#', 'G#m', 'A#dim'],
        sharps: 5,
        flats: 0,
        angle: 150
      },
      {
        name: 'F#大调',
        note: 'F#',
        scale: ['F#', 'G#', 'A#', 'B', 'C#', 'D#', 'E#'],
        chords: ['F#', 'G#m', 'A#m', 'B', 'C#', 'D#m', 'E#dim'],
        sharps: 6,
        flats: 0,
        angle: 180
      },
      {
        name: 'F大调',
        note: 'F',
        scale: ['F', 'G', 'A', 'Bb', 'C', 'D', 'E'],
        chords: ['F', 'Gm', 'Am', 'Bb', 'C', 'Dm', 'Edim'],
        sharps: 0,
        flats: 1,
        angle: 330
      },
      {
        name: 'Bb大调',
        note: 'Bb',
        scale: ['Bb', 'C', 'D', 'Eb', 'F', 'G', 'A'],
        chords: ['Bb', 'Cm', 'Dm', 'Eb', 'F', 'Gm', 'Adim'],
        sharps: 0,
        flats: 2,
        angle: 300
      },
      {
        name: 'Eb大调',
        note: 'Eb',
        scale: ['Eb', 'F', 'G', 'Ab', 'Bb', 'C', 'D'],
        chords: ['Eb', 'Fm', 'Gm', 'Ab', 'Bb', 'Cm', 'Ddim'],
        sharps: 0,
        flats: 3,
        angle: 270
      },
      {
        name: 'Ab大调',
        note: 'Ab',
        scale: ['Ab', 'Bb', 'C', 'Db', 'Eb', 'F', 'G'],
        chords: ['Ab', 'Bbm', 'Cm', 'Db', 'Eb', 'Fm', 'Gdim'],
        sharps: 0,
        flats: 4,
        angle: 240
      },
      {
        name: 'Db大调',
        note: 'Db',
        scale: ['Db', 'Eb', 'F', 'Gb', 'Ab', 'Bb', 'C'],
        chords: ['Db', 'Ebm', 'Fm', 'Gb', 'Ab', 'Bbm', 'Cdim'],
        sharps: 0,
        flats: 5,
        angle: 210
      }
    ],
    
    // 吉他相关数据
    guitarStrings: [
      { stringNumber: 1, openNote: 'E', baseFret: 64 },
      { stringNumber: 2, openNote: 'B', baseFret: 59 },
      { stringNumber: 3, openNote: 'G', baseFret: 55 },
      { stringNumber: 4, openNote: 'D', baseFret: 50 },
      { stringNumber: 5, openNote: 'A', baseFret: 45 },
      { stringNumber: 6, openNote: 'E', baseFret: 40 }
    ],
    
    // 用户设置
    userSettings: {
      selectedKey: 'C大调',
      selectedScale: 'major',
      showNoteNames: true,
      showIntervals: false,
      darkMode: false
    }
  },

  onLaunch() {
    // 小程序启动时执行
    console.log('吉他大师小程序启动');
    this.loadUserSettings();
  },

  onShow() {
    // 小程序切前台时执行
  },

  onHide() {
    // 小程序切后台时执行
  },

  onError(msg) {
    console.error('小程序错误:', msg);
  },

  // 加载用户设置
  loadUserSettings() {
    const settings = wx.getStorageSync('userSettings');
    if (settings) {
      this.globalData.userSettings = { ...this.globalData.userSettings, ...settings };
    }
  },

  // 保存用户设置
  saveUserSettings() {
    wx.setStorage({
      key: 'userSettings',
      data: this.globalData.userSettings
    });
  },

  // 获取指定调性的信息
  getKeyInfo(keyName) {
    return this.globalData.circleOfFifths.find(key => key.name === keyName);
  },

  // 计算音符在指板上的位置
  getNotePositions(note) {
    const positions = [];
    const noteNames = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    const targetNoteIndex = noteNames.indexOf(note);
    
    this.globalData.guitarStrings.forEach(string => {
      const openNoteIndex = noteNames.indexOf(string.openNote);
      for (let fret = 0; fret <= 12; fret++) {
        const currentNoteIndex = (openNoteIndex + fret) % 12;
        if (currentNoteIndex === targetNoteIndex) {
          positions.push({
            stringNumber: string.stringNumber,
            fret: fret,
            note: note
          });
        }
      }
    });
    
    return positions;
  }
});
