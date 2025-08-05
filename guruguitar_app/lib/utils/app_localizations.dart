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
      'click_key_for_details': '点击调性查看详情',
      'rotate_circle_instruction': '🔄 拖动旋转圆环，将调性对准箭头可查看详情',
      
      // 音阶分析
      'scale_analysis': '音阶分析',
      'fretboard_chart': '指板图谱',
      'caged_system': 'CAGED系统',
      'scale_constituent_notes': '音阶构成音',
      'degree_and_function_of_each_note': '每个音的度数和功能',
      'interval_relationships': '音程关系',
      'intervals_between_adjacent_notes': '相邻音之间的音程',
      'characteristic_notes': '特征音',
      'important_identifying_notes_of_key': '调性的重要标识音',
      'tonic': '主音',
      'supertonic': '上主音',
      'mediant': '中音',
      'subdominant': '下属音',
      'dominant': '属音',
      'submediant': '下中音',
      'leading_tone': '导音',
      
      // 指板训练器
      'notes_count': '{count}个音符',
      'find_interval_from_note': '找到距离 {note} 一个{interval}的音符',
      'click_root_then_interval': '先点击根音 {note}（第{string}弦第{fret}品），再点击目标音程',
      
      // 音程
      'minor_second': '小二度',
      'major_second': '大二度',
      'minor_third': '小三度',
      'major_third': '大三度',
      'perfect_fourth': '纯四度',
      'tritone': '三全音',
      'perfect_fifth': '纯五度',
      'minor_sixth': '小六度',
      'major_sixth': '大六度',
      'minor_seventh': '小七度',
      'major_seventh': '大七度',
      'octave': '八度',
      
      // 指板图谱
      'fretboard_scale_diagram': '指板音阶图谱',
      'display_scale_positions_on_fretboard': '在吉他指板上显示音阶位置',
      'landscape_view_full_scale_diagram': '横屏查看完整音阶指板图谱',
      'rotate_phone_for_better_view': '💡 旋转手机到横屏模式获得更好的查看体验',
      'landscape_mode_full_diagram': '🎸 横屏模式 - 完整指板图谱',
      
      // CAGED系统
      'minor_chord': '小调和弦',
      'major_chord': '大调和弦',
      'root_note': '根音',
      
      // 音阶挑战
      'scale_challenge': '音阶挑战',
      'play_scale_in_order': '按顺序演奏 {key} 音阶',
      'click_next_note': '点击下一个音符: {note}',
      'scale_completed': '音阶完成！',
      'wrong_note': '错误的音符',
      'show_scale_positions': '显示音阶位置',
      'hide_scale_positions': '隐藏音阶位置',
      
      // 难度选择
      'select_difficulty': '选择难度',
      'beginner': '初级',
      'intermediate': '中级',
      'advanced': '高级',
      'beginner_desc': '大小调音阶',
      'intermediate_desc': '中古调式音阶',
      'advanced_desc': '复杂调式音阶',
      
      // 练习模式
      'master_intervals': '掌握音程关系',
      'select_challenge_type': '选择挑战类型',
      'select_difficulty_first': '请先选择难度级别',
      'tap_difficulty_button': '点击难度按钮开始',
      'language_changed': '语言已切换为',
      'third_note': '三度音',
      'fifth_note': '五度音',
      'caged_system_description': 'CAGED系统基于C、A、G、E、D这五个开放和弦的形状，通过移调在整个指板上演奏{key}和弦。每种形状展示了和弦在不同把位的排列。',
      'all_fretboard_arrangements': '{key}的所有指板排列',
      'chord_components': '{key}和弦组成音',
      'based_on_c_chord_shape': '基于C和弦的指型，全指板位置',
      'fret_position': '第{fret}品位置',
      'expand': '展开',
      'landscape_view_full_fretboard': '横屏查看完整指板',
      'fingering_instructions': '指法说明',
      'complete_fretboard_view': '完整指板视图 - 第{fret}品位置',
      'detailed_fingering_info': '详细指法信息',
      'string_fret_position': '{string}弦-{fret}品',
      
      // 音阶练习
      'scale_practice_title': '指板练习',
      'select_key': '选择调性',
      'practice_mode': '练习模式',
      'select_practice_mode': '选择练习模式来提升你的吉他技能',
      'master_scales_modes': '掌握各种音阶和调式',
      'quick_note_identification': '快速识别指板上的音符',
      'quick_start': '快速开始',
      'random_challenge': '随机挑战',
      'random_challenge_desc': '随机生成练习题目，挑战你的极限',
      'start_challenge': '开始挑战',
      
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
      'click_key_for_details': 'Click key for details',
      'rotate_circle_instruction': '🔄 Drag to rotate circle, align key with arrow to view details',
      
      // Scale Analysis
      'scale_analysis': 'Scale Analysis',
      'fretboard_chart': 'Fretboard Chart',
      'caged_system': 'CAGED System',
      'caged_system_description': 'The CAGED system is based on the shapes of five open chords (C, A, G, E, D) and transposes them across the entire fretboard to play {key} chords. Each shape demonstrates the chord arrangement at different positions.',
      'all_fretboard_arrangements': 'All fretboard arrangements for {key}',
      'chord_components': '{key} chord components',
      'based_on_c_chord_shape': 'Based on C chord shape, full fretboard position',
      'scale_constituent_notes': 'Scale Constituent Notes',
      'degree_and_function_of_each_note': 'Degree and Function of Each Note',
      'interval_relationships': 'Interval Relationships',
      'intervals_between_adjacent_notes': 'Intervals Between Adjacent Notes',
      'characteristic_notes': 'Characteristic Notes',
      'important_identifying_notes_of_key': 'Important Identifying Notes of Key',
      'tonic': 'Tonic',
      'supertonic': 'Supertonic',
      'mediant': 'Mediant',
      'subdominant': 'Subdominant',
      'dominant': 'Dominant',
      'submediant': 'Submediant',
      'leading_tone': 'Leading Tone',
      
      // Fretboard Trainer
      'notes_count': '{count} notes',
      'find_interval_from_note': 'Find a {interval} from {note}',
      'click_root_then_interval': 'First click root note {note} (string {string}, fret {fret}), then click target interval',
      
      // Scale Challenge
      'scale_challenge': 'Scale Challenge',
      'play_scale_in_order': 'Play {key} scale in order',
      'click_next_note': 'Click next note: {note}',
      'scale_completed': 'Scale completed!',
      'wrong_note': 'Wrong note',
      'show_scale_positions': 'Show scale positions',
      'hide_scale_positions': 'Hide scale positions',
      
      // Difficulty Selection
      'select_difficulty': 'Select Difficulty',
      'beginner': 'Beginner',
      'intermediate': 'Intermediate',
      'advanced': 'Advanced',
      'beginner_desc': 'Major & Minor Scales',
      'intermediate_desc': 'Medieval Modes',
      'advanced_desc': 'Complex Modes',
      
      // Practice Modes
      'master_intervals': 'Master interval relationships',
      'select_challenge_type': 'Select challenge type',
      'select_difficulty_first': 'Please select difficulty level first',
      'tap_difficulty_button': 'Tap difficulty button to start',
      'language_changed': 'Language changed to',
      
      // Scale Practice
      'scale_practice_title': 'Fretboard Practice',
      'select_key': 'Select Key',
      'practice_mode': 'Practice Mode',
      'select_practice_mode': 'Choose practice modes to improve your guitar skills',
      'master_scales_modes': 'Master various scales and modes',
      'quick_note_identification': 'Quickly identify notes on the fretboard',
      'quick_start': 'Quick Start',
      'random_challenge': 'Random Challenge',
      'random_challenge_desc': 'Randomly generate practice questions to challenge your limits',
      'start_challenge': 'Start Challenge',
      
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
      'click_key_for_details': 'Cliquez sur la clé pour les détails',
      'rotate_circle_instruction': '🔄 Faites glisser pour faire tourner le cercle, alignez la clé avec la flèche pour voir les détails',
      
      // Analyse des Gammes
      'scale_analysis': 'Analyse des Gammes',
      'fretboard_chart': 'Diagramme du Manche',
      'caged_system': 'Système CAGED',
      'caged_system_description': 'Le système CAGED est basé sur les formes de cinq accords ouverts (C, A, G, E, D) et les transpose sur tout le manche pour jouer les accords {key}. Chaque forme démontre l\'arrangement d\'accord à différentes positions.',
      'all_fretboard_arrangements': 'Tous les arrangements de manche pour {key}',
      'chord_components': 'Composants d\'accord {key}',
      'based_on_c_chord_shape': 'Basé sur la forme d\'accord C, position complète du manche',
      
      // Défi des Gammes
      'scale_challenge': 'Défi des Gammes',
      'play_scale_in_order': 'Jouer la gamme {key} dans l\'ordre',
      'click_next_note': 'Cliquez sur la note suivante: {note}',
      'scale_completed': 'Gamme terminée!',
      'wrong_note': 'Mauvaise note',
      'show_scale_positions': 'Afficher les positions de la gamme',
      'hide_scale_positions': 'Masquer les positions de la gamme',
      
      // Sélection de Difficulté
      'select_difficulty': 'Sélectionner la Difficulté',
      'beginner': 'Débutant',
      'intermediate': 'Intermédiaire',
      'advanced': 'Avancé',
      'beginner_desc': 'Gammes Majeures et Mineures',
      'intermediate_desc': 'Modes Médiévaux',
      'advanced_desc': 'Modes Complexes',
      
      // Modes de Pratique
      'master_intervals': 'Maîtriser les relations d\'intervalles',
      'select_challenge_type': 'Sélectionner le type de défi',
      'select_difficulty_first': 'Veuillez d\'abord sélectionner le niveau de difficulté',
      'tap_difficulty_button': 'Appuyez sur le bouton de difficulté pour commencer',
      'language_changed': 'Langue changée vers',
      'scale_constituent_notes': 'Notes Constituantes de la Gamme',
      'degree_and_function_of_each_note': 'Degré et Fonction de Chaque Note',
      'interval_relationships': 'Relations d\'Intervalles',
      'intervals_between_adjacent_notes': 'Intervalles Entre Notes Adjacentes',
      'characteristic_notes': 'Notes Caractéristiques',
      'important_identifying_notes_of_key': 'Notes d\'Identification Importantes de la Clé',
      'tonic': 'Tonique',
      'supertonic': 'Sus-tonique',
      'mediant': 'Médiante',
      'subdominant': 'Sous-dominante',
      'dominant': 'Dominante',
      'submediant': 'Sous-médiante',
      'leading_tone': 'Sensible',
      
      // Entraîneur de Manche
      'notes_count': '{count} notes',
      'find_interval_from_note': 'Trouvez un {interval} depuis {note}',
      'click_root_then_interval': 'Cliquez d\'abord sur la note fondamentale {note} (corde {string}, case {fret}), puis sur l\'intervalle cible',
      
      // Pratique des Gammes
      'scale_practice_title': 'Pratique des Gammes',
      'select_key': 'Sélectionner la Clé',
      'practice_mode': 'Mode d\'Entraînement',
      'select_practice_mode': 'Choisissez des modes d\'entraînement pour améliorer vos compétences de guitare',
      'master_scales_modes': 'Maîtrisez diverses gammes et modes',
      'quick_note_identification': 'Identifiez rapidement les notes sur le manche',
      'quick_start': 'Démarrage Rapide',
      'random_challenge': 'Défi Aléatoire',
      'random_challenge_desc': 'Générez aléatoirement des questions d\'entraînement pour défier vos limites',
      'start_challenge': 'Commencer le Défi',
      
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
      'click_key_for_details': '調をクリックして詳細を表示',
      'rotate_circle_instruction': '🔄 ドラッグして円を回転させ、調を矢印に合わせて詳細を表示',
      
      // スケール分析
      'scale_analysis': 'スケール分析',
      'fretboard_chart': 'フレットボードチャート',
      'caged_system': 'CAGEDシステム',
      'caged_system_description': 'CAGEDシステムは5つのオープンコード（C、A、G、E、D）の形状に基づいており、{key}コードを演奏するためにフレットボード全体に転調します。各形状は異なる位置でのコード配置を示します。',
      'all_fretboard_arrangements': '{key}の全フレットボード配置',
      'chord_components': '{key}コード構成音',
      'based_on_c_chord_shape': 'Cコード形状に基づく、全フレットボード位置',
      'scale_constituent_notes': 'スケール構成音',
      'degree_and_function_of_each_note': '各音の度数と機能',
      'interval_relationships': '音程関係',
      'intervals_between_adjacent_notes': '隣接音間の音程',
      'characteristic_notes': '特徴音',
      'important_identifying_notes_of_key': '調の重要な識別音',
      'tonic': '主音',
      'supertonic': '上主音',
      'mediant': '中音',
      'subdominant': '下属音',
      'dominant': '属音',
      'submediant': '下中音',
      'leading_tone': '導音',
      
      // フレットボードトレーナー
      'notes_count': '{count}個の音符',
      'find_interval_from_note': '{note}から{interval}を見つける',
      'click_root_then_interval': 'まず根音{note}（{string}弦{fret}フレット）をクリックし、次に目標音程をクリック',
      
      // スケールチャレンジ
      'scale_challenge': 'スケールチャレンジ',
      'play_scale_in_order': '{key}スケールを順番に演奏',
      'click_next_note': '次の音符をクリック: {note}',
      'scale_completed': 'スケール完了！',
      'wrong_note': '間違った音符',
      'show_scale_positions': 'スケール位置を表示',
      'hide_scale_positions': 'スケール位置を隠す',
      
      // 難易度選択
      'select_difficulty': '難易度を選択',
      'beginner': '初級',
      'intermediate': '中級',
      'advanced': '上級',
      'beginner_desc': '長調・短調音階',
      'intermediate_desc': '中世調式音階',
      'advanced_desc': '複雑調式音階',
      
      // 練習モード
      'master_intervals': '音程関係をマスター',
      'select_challenge_type': 'チャレンジタイプを選択',
      'select_difficulty_first': 'まず難易度レベルを選択してください',
      'tap_difficulty_button': '難易度ボタンをタップして開始',
      'language_changed': '言語が変更されました',
      
      // スケール練習
      'scale_practice_title': 'スケール練習',
      'select_key': '調を選択',
      'practice_mode': '練習モード',
      'select_practice_mode': '練習モードを選択してギタースキルを向上させましょう',
      'master_scales_modes': '様々なスケールとモードをマスター',
      'quick_note_identification': 'フレットボード上の音符を素早く識別',
      'quick_start': 'クイックスタート',
      'random_challenge': 'ランダムチャレンジ',
      'random_challenge_desc': 'ランダムに練習問題を生成して限界に挑戦',
      'start_challenge': 'チャレンジ開始',
      
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