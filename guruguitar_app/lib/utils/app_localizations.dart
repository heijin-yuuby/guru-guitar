import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'zh': {
      // 主页
      'app_title': '吉他大师',
      'fretboard_trainer': '指板训练器',
      'circle_of_fifths': '五度圈',
      'scale_practice': '音阶练习',
      'settings': '设置',
      
      // 指板训练器
      'note_identification': '音符识别',
      'interval_training': '音程训练',
      'easy': '简单',
      'medium': '中等',
      'hard': '困难',
      'start_training': '开始练习',
      'stop_training': '停止练习',
      'score': '得分',
      'total': '总数',
      'accuracy': '准确率',
      'find_notes': '找到 {count} 个 {note} 音符',
      'click_correct_position': '点击指板上的正确位置',
      'found_count': '已找到: {found}/{target}',
      'correct': '正确',
      'error': '错误',
      'already_clicked': '已点击过',
      'root_correct': '根音正确！找{interval}',
      'complete': '完成！',
      'practice_result': '练习结果',
      'try_again': '再试一次',
      'done': '完成',
      'time_left': '{time}s',
      
      // 五度圈
      'major': '大调',
      'minor': '小调',
      'natural_minor_scale': '自然小调',
      'major_scale': '自然大调',
      
      // 音阶练习
      'scale_practice_title': '音阶练习',
      'select_key': '选择调性',
      'practice_mode': '练习模式',
      
      // 设置
      'language': '语言',
      'chinese': '中文',
      'english': 'English',
      'french': 'Français',
      'japanese': '日本語',
      'theme': '主题',
      'light': '浅色',
      'dark': '深色',
      'system': '跟随系统',
      'about': '关于',
      'version': '版本',
      'developer': '开发者',
      'feedback': '反馈',
      
      // 通用
      'cancel': '取消',
      'confirm': '确认',
      'save': '保存',
      'reset': '重置',
      'close': '关闭',
      'back': '返回',
      'next': '下一步',
      'previous': '上一步',
    },
    'en': {
      // Home
      'app_title': 'Guitar Master',
      'fretboard_trainer': 'Fretboard Trainer',
      'circle_of_fifths': 'Circle of Fifths',
      'scale_practice': 'Scale Practice',
      'settings': 'Settings',
      
      // Fretboard Trainer
      'note_identification': 'Note Identification',
      'interval_training': 'Interval Training',
      'easy': 'Easy',
      'medium': 'Medium',
      'hard': 'Hard',
      'start_training': 'Start Training',
      'stop_training': 'Stop Training',
      'score': 'Score',
      'total': 'Total',
      'accuracy': 'Accuracy',
      'find_notes': 'Find {count} {note} notes',
      'click_correct_position': 'Click the correct positions on the fretboard',
      'found_count': 'Found: {found}/{target}',
      'correct': 'Correct',
      'error': 'Error',
      'already_clicked': 'Already clicked',
      'root_correct': 'Root correct! Find {interval}',
      'complete': 'Complete!',
      'practice_result': 'Practice Result',
      'try_again': 'Try Again',
      'done': 'Done',
      'time_left': '{time}s',
      
      // Circle of Fifths
      'major': 'Major',
      'minor': 'Minor',
      'natural_minor_scale': 'Natural Minor Scale',
      'major_scale': 'Major Scale',
      
      // Scale Practice
      'scale_practice_title': 'Scale Practice',
      'select_key': 'Select Key',
      'practice_mode': 'Practice Mode',
      
      // Settings
      'language': 'Language',
      'chinese': '中文',
      'english': 'English',
      'french': 'Français',
      'japanese': '日本語',
      'theme': 'Theme',
      'light': 'Light',
      'dark': 'Dark',
      'system': 'System',
      'about': 'About',
      'version': 'Version',
      'developer': 'Developer',
      'feedback': 'Feedback',
      
      // Common
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'save': 'Save',
      'reset': 'Reset',
      'close': 'Close',
      'back': 'Back',
      'next': 'Next',
      'previous': 'Previous',
    },
    'fr': {
      // Accueil
      'app_title': 'Maître de Guitare',
      'fretboard_trainer': 'Entraîneur de Manche',
      'circle_of_fifths': 'Cercle des Quintes',
      'scale_practice': 'Pratique des Gammes',
      'settings': 'Paramètres',
      
      // Entraîneur de Manche
      'note_identification': 'Identification des Notes',
      'interval_training': 'Entraînement des Intervalles',
      'easy': 'Facile',
      'medium': 'Moyen',
      'hard': 'Difficile',
      'start_training': 'Commencer l\'Entraînement',
      'stop_training': 'Arrêter l\'Entraînement',
      'score': 'Score',
      'total': 'Total',
      'accuracy': 'Précision',
      'find_notes': 'Trouver {count} notes {note}',
      'click_correct_position': 'Cliquez sur les bonnes positions sur le manche',
      'found_count': 'Trouvé: {found}/{target}',
      'correct': 'Correct',
      'error': 'Erreur',
      'already_clicked': 'Déjà cliqué',
      'root_correct': 'Racine correcte! Trouvez {interval}',
      'complete': 'Terminé!',
      'practice_result': 'Résultat de l\'Entraînement',
      'try_again': 'Réessayer',
      'done': 'Terminé',
      'time_left': '{time}s',
      
      // Cercle des Quintes
      'major': 'Majeur',
      'minor': 'Mineur',
      'natural_minor_scale': 'Gamme Mineure Naturelle',
      'major_scale': 'Gamme Majeure',
      
      // Pratique des Gammes
      'scale_practice_title': 'Pratique des Gammes',
      'select_key': 'Sélectionner la Clé',
      'practice_mode': 'Mode d\'Entraînement',
      
      // Paramètres
      'language': 'Langue',
      'chinese': '中文',
      'english': 'English',
      'french': 'Français',
      'japanese': '日本語',
      'theme': 'Thème',
      'light': 'Clair',
      'dark': 'Sombre',
      'system': 'Système',
      'about': 'À Propos',
      'version': 'Version',
      'developer': 'Développeur',
      'feedback': 'Retour',
      
      // Commun
      'cancel': 'Annuler',
      'confirm': 'Confirmer',
      'save': 'Enregistrer',
      'reset': 'Réinitialiser',
      'close': 'Fermer',
      'back': 'Retour',
      'next': 'Suivant',
      'previous': 'Précédent',
    },
    'ja': {
      // ホーム
      'app_title': 'ギターマスター',
      'fretboard_trainer': 'フレットボードトレーナー',
      'circle_of_fifths': '五度圏',
      'scale_practice': 'スケール練習',
      'settings': '設定',
      
      // フレットボードトレーナー
      'note_identification': '音符識別',
      'interval_training': '音程トレーニング',
      'easy': '簡単',
      'medium': '普通',
      'hard': '困難',
      'start_training': '練習開始',
      'stop_training': '練習停止',
      'score': 'スコア',
      'total': '合計',
      'accuracy': '正確率',
      'find_notes': '{note}音符を{count}個見つける',
      'click_correct_position': 'フレットボードの正しい位置をクリック',
      'found_count': '見つけた: {found}/{target}',
      'correct': '正解',
      'error': '間違い',
      'already_clicked': '既にクリック済み',
      'root_correct': 'ルート正解！{interval}を見つける',
      'complete': '完了！',
      'practice_result': '練習結果',
      'try_again': '再試行',
      'done': '完了',
      'time_left': '{time}秒',
      
      // 五度圏
      'major': '長調',
      'minor': '短調',
      'natural_minor_scale': '自然短音階',
      'major_scale': '長音階',
      
      // スケール練習
      'scale_practice_title': 'スケール練習',
      'select_key': '調を選択',
      'practice_mode': '練習モード',
      
      // 設定
      'language': '言語',
      'chinese': '中文',
      'english': 'English',
      'french': 'Français',
      'japanese': '日本語',
      'theme': 'テーマ',
      'light': 'ライト',
      'dark': 'ダーク',
      'system': 'システム',
      'about': 'アプリについて',
      'version': 'バージョン',
      'developer': '開発者',
      'feedback': 'フィードバック',
      
      // 共通
      'cancel': 'キャンセル',
      'confirm': '確認',
      'save': '保存',
      'reset': 'リセット',
      'close': '閉じる',
      'back': '戻る',
      'next': '次へ',
      'previous': '前へ',
    },
  };

  String get(String key, [Map<String, String>? args]) {
    print('Getting key: $key for locale: ${locale.languageCode}'); // 调试信息
    String value = _localizedValues[locale.languageCode]?[key] ?? 
                   _localizedValues['en']![key] ?? 
                   key;
    
    if (args != null) {
      args.forEach((k, v) {
        value = value.replaceAll('{$k}', v);
      });
    }
    
    return value;
  }

  static const List<Locale> supportedLocales = [
    Locale('zh', 'CN'),
    Locale('en', 'US'),
    Locale('fr', 'FR'),
    Locale('ja', 'JP'),
  ];
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['zh', 'en', 'fr', 'ja'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
} 