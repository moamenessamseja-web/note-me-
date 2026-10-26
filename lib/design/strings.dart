import 'package:flutter/material.dart';

/// طبقة نصوص بسيطة (عربي/إنجليزي) لتطبيق note-me.
/// التطبيق عربي أولاً — الترجمة تغطّي هيكل الواجهة (العناوين، التنقل،
/// الإعدادات، الأزرار العامة). نص بيانات المستخدم يفضل زي ما هو.
class L {
  L._();

  static String _lang = 'ar';

  static String get lang => _lang;
  static bool get isArabic => _lang != 'en';
  static TextDirection get direction =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;
  static Locale get locale => Locale(_lang);

  static void setLang(String code) => _lang = (code == 'en') ? 'en' : 'ar';

  static const Map<String, String> _ar = {
    'app_title': 'NoteMe',
    'app_tagline': 'دفتر ملاحظات ماركداون سريع ونظيف',
    'nav_home': 'الرئيسية',
    'nav_notes': 'الملاحظات',
    'nav_editor': 'محرر',
    'nav_reader': 'قارئ',
    'nav_search': 'بحث',
    'nav_categories': 'التصنيفات',
    'nav_themes': 'الثيمات',
    'nav_vault': 'الخزنة',
    'nav_settings': 'الإعدادات',
    'nav_about': 'حول التطبيق',
    'sec_settings': 'الإعدادات',
    'sec_about': 'حول',
    'settings': 'الإعدادات',
    'appearance': 'المظهر',
    'theme': 'الثيم',
    'theme_light': 'فاتح',
    'theme_dark': 'داكن',
    'theme_system': 'حسب النظام',
    'language': 'اللغة',
    'lang_arabic': 'العربية',
    'lang_english': 'English',
    'font_size': 'حجم الخط',
    'vault': 'الخزنة',
    'vault_locked': 'الخزنة مقفلة',
    'vault_unlocked': 'الخزنة مفتوحة',
    'vault_set_password': 'تعيين كلمة مرور',
    'vault_unlock': 'فتح الخزنة',
    'vault_lock': 'قفل الخزنة',
    'vault_password': 'كلمة المرور',
    'vault_confirm_password': 'تأكيد كلمة المرور',
    'vault_password_hint': 'كلمة مرور قوية لحماية ملاحظاتك المشفرة',
    'vault_wrong_password': 'كلمة المرور غير صحيحة',
    'vault_no_password': 'لا توجد كلمة مرور بعد. اضغط لتعيين واحدة.',
    'vault_empty': 'لا توجد ملاحظات في الخزنة.',
    'vault_add_note': 'إضافة ملاحظة للخزنة',
    'new_note': 'ملاحظة جديدة',
    'edit_note': 'تحرير الملاحظة',
    'save': 'حفظ',
    'cancel': 'إلغاء',
    'delete': 'حذف',
    'pin': 'تثبيت',
    'unpin': 'إلغاء التثبيت',
    'search': 'بحث',
    'search_hint': 'ابحث في العناوين والمحتوى والوسوم',
    'categories': 'التصنيفات',
    'category_name': 'اسم التصنيف',
    'category_color': 'اللون',
    'category_icon': 'الأيقونة',
    'add_category': 'إضافة تصنيف',
    'edit_category': 'تعديل التصنيف',
    'delete_category': 'حذف التصنيف',
    'no_notes': 'لا توجد ملاحظات بعد',
    'no_notes_sub': 'اضغط + لإنشاء أول ملاحظة',
    'note_title': 'العنوان',
    'note_content': 'المحتوى (ماركداون)',
    'note_category': 'التصنيف',
    'note_tags': 'الوسوم (مفصولة بفواصل)',
    'note_vault': 'خزنة (مشفرة)',
    'note_empty_title': 'العنوان مطلوب',
    'pinned_notes': 'مثبتة',
    'other_notes': 'أخرى',
    'sort': 'ترتيب',
    'sort_latest': 'الأحدث أولاً',
    'sort_oldest': 'الأقدم أولاً',
    'sort_title_asc': 'العنوان (أ-ي)',
    'sort_title_desc': 'العنوان (ي-أ)',
    'filter_all': 'الكل',
    'filter_pinned': 'المثبتة فقط',
    'filter_category': 'حسب التصنيف',
    'about_title': 'حول NoteMe',
    'about_version': 'الإصدار 1.0.0',
    'about_desc': 'تطبيق ملاحظات ماركداون سريع ونظيف، يعمل بدون إنترنت، مع دعم التشفير للخزنة.',
    'about_license': 'مرخص تحت MIT',
    'saved': 'تم الحفظ ✅',
    'deleted': 'تم الحذف',
    'error': 'خطأ',
    'confirm_delete': 'هل أنت متأكد من الحذف؟',
    'ok': 'موافق',
    'yes': 'نعم',
    'no': 'لا',
    'close': 'إغلاق',
    'done': 'تم',
    'general': 'عام',
    'backup_restore': 'نسخ احتياطي واستعادة',
    'export_notes': 'تصدير الملاحظات',
    'import_notes': 'استيراد الملاحظات',
    'reset_data': 'إعادة تعيين البيانات',
    'reset_data_confirm': 'سيؤدي هذا إلى حذف جميع الملاحظات والتصنيفات والإعدادات. هل أنت متأكد؟',
    'export_success': 'تم التصدير بنجاح',
    'import_success': 'تم الاستيراد بنجاح',
    'storage': 'التخزين',
    'used_space': 'المساحة المستخدمة',
    'free_space': 'المساحة المتاحة',
  };

  static const Map<String, String> _en = {
    'app_title': 'NoteMe',
    'app_tagline': 'Fast, clean markdown notebook',
    'nav_home': 'Home',
    'nav_notes': 'Notes',
    'nav_editor': 'Editor',
    'nav_reader': 'Reader',
    'nav_search': 'Search',
    'nav_categories': 'Categories',
    'nav_themes': 'Themes',
    'nav_vault': 'Vault',
    'nav_settings': 'Settings',
    'nav_about': 'About',
    'sec_settings': 'Settings',
    'sec_about': 'About',
    'settings': 'Settings',
    'appearance': 'Appearance',
    'theme': 'Theme',
    'theme_light': 'Light',
    'theme_dark': 'Dark',
    'theme_system': 'System',
    'language': 'Language',
    'lang_arabic': 'العربية',
    'lang_english': 'English',
    'font_size': 'Font Size',
    'vault': 'Vault',
    'vault_locked': 'Vault Locked',
    'vault_unlocked': 'Vault Unlocked',
    'vault_set_password': 'Set Password',
    'vault_unlock': 'Unlock Vault',
    'vault_lock': 'Lock Vault',
    'vault_password': 'Password',
    'vault_confirm_password': 'Confirm Password',
    'vault_password_hint': 'Strong password to protect your encrypted notes',
    'vault_wrong_password': 'Incorrect password',
    'vault_no_password': 'No password set yet. Tap to set one.',
    'vault_empty': 'No notes in vault.',
    'vault_add_note': 'Add Note to Vault',
    'new_note': 'New Note',
    'edit_note': 'Edit Note',
    'save': 'Save',
    'cancel': 'Cancel',
    'delete': 'Delete',
    'pin': 'Pin',
    'unpin': 'Unpin',
    'search': 'Search',
    'search_hint': 'Search titles, content, and tags',
    'categories': 'Categories',
    'category_name': 'Category Name',
    'category_color': 'Color',
    'category_icon': 'Icon',
    'add_category': 'Add Category',
    'edit_category': 'Edit Category',
    'delete_category': 'Delete Category',
    'no_notes': 'No notes yet',
    'no_notes_sub': 'Tap + to create your first note',
    'note_title': 'Title',
    'note_content': 'Content (Markdown)',
    'note_category': 'Category',
    'note_tags': 'Tags (comma separated)',
    'note_vault': 'Vault (Encrypted)',
    'note_empty_title': 'Title is required',
    'pinned_notes': 'Pinned',
    'other_notes': 'Other Notes',
    'sort': 'Sort',
    'sort_latest': 'Latest First',
    'sort_oldest': 'Oldest First',
    'sort_title_asc': 'Title (A-Z)',
    'sort_title_desc': 'Title (Z-A)',
    'filter_all': 'All',
    'filter_pinned': 'Pinned Only',
    'filter_category': 'By Category',
    'about_title': 'About NoteMe',
    'about_version': 'Version 1.0.0',
    'about_desc': 'Fast, clean markdown notebook that works offline with vault encryption.',
    'about_license': 'Licensed under MIT',
    'saved': 'Saved ✅',
    'deleted': 'Deleted',
    'error': 'Error',
    'confirm_delete': 'Are you sure you want to delete?',
    'ok': 'OK',
    'yes': 'Yes',
    'no': 'No',
    'close': 'Close',
    'done': 'Done',
    'general': 'General',
    'backup_restore': 'Backup & Restore',
    'export_notes': 'Export Notes',
    'import_notes': 'Import Notes',
    'reset_data': 'Reset All Data',
    'reset_data_confirm': 'This will delete all notes, categories, and settings. Are you sure?',
    'export_success': 'Exported successfully',
    'import_success': 'Imported successfully',
    'storage': 'Storage',
    'used_space': 'Used Space',
    'free_space': 'Free Space',
  };

  static String t(String key) => (isArabic ? _ar : _en)[key] ?? _ar[key] ?? key;

  // ── اختصارات مريحة لل Keys الأكثر استخدامًا ──────────────────
  static String get app_title => t('app_title');
  static String get app_tagline => t('app_tagline');
  static String get nav_home => t('nav_home');
  static String get nav_notes => t('nav_notes');
  static String get nav_editor => t('nav_editor');
  static String get nav_reader => t('nav_reader');
  static String get nav_search => t('nav_search');
  static String get nav_categories => t('nav_categories');
  static String get nav_themes => t('nav_themes');
  static String get nav_vault => t('nav_vault');
  static String get nav_settings => t('nav_settings');
  static String get nav_about => t('nav_about');
  static String get settings => t('settings');
  static String get save => t('save');
  static String get cancel => t('cancel');
  static String get delete => t('delete');
  static String get search => t('search');
  static String get search_hint => t('search_hint');
  static String get new_note => t('new_note');
  static String get edit_note => t('edit_note');
  static String get vault => t('vault');
  static String get done => t('done');
  static String get close => t('close');
  static String get ok => t('ok');
  static String get no_notes => t('no_notes');
  static String get no_notes_sub => t('no_notes_sub');
  static String get sort => t('sort');
  static String get sort_latest => t('sort_latest');
  static String get sort_oldest => t('sort_oldest');
  static String get sort_title_asc => t('sort_title_asc');
  static String get sort_title_desc => t('sort_title_desc');
  static String get filter_all => t('filter_all');
  static String get note_title => t('note_title');
  static String get note_content => t('note_content');
  static String get note_category => t('note_category');
  static String get note_tags => t('note_tags');
  static String get note_vault => t('note_vault');
  static String get note_empty_title => t('note_empty_title');
  static String get saved => t('saved');
  static String get category_name => t('category_name');
  static String get about_title => t('about_title');
  static String get about_version => t('about_version');
  static String get about_desc => t('about_desc');
  static String get about_license => t('about_license');
  static String get vault_set_password => t('vault_set_password');
  static String get vault_password => t('vault_password');
  static String get appearance => t('appearance');
  static String get language => t('language');
  static String get lang_arabic => t('lang_arabic');
  static String get lang_english => t('lang_english');
  static String get font_size => t('font_size');
  static String get backup_restore => t('backup_restore');
  static String get reset_data => t('reset_data');
  static String get reset_data_confirm => t('reset_data_confirm');
  static String get theme_light => t('theme_light');
  static String get theme_dark => t('theme_dark');
  static String get theme_system => t('theme_system');
}