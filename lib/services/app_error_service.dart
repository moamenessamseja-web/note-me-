import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// خطأ تخزين — يُرمى لو فشلت كتابة البيانات فعليًا، عشان مفيش مسار يعرض
/// «نجاح» من غير ما يكون الحفظ اتأكد.
class StorageException implements Exception {
  final String message;
  final Object? cause;

  StorageException(this.message, [this.cause]);

  @override
  String toString() => 'StorageException: $message';
}

/// فئة الخطأ المفهومة — بنصنّف الخطأ بدل ما نعرض نص الاستثناء الخام للمستخدم.
enum AppErrorKind { storage, network, notification, input, unexpected }

/// طبقة موحّدة لمعالجة الأخطاء.
///
/// مسؤولياتها:
/// - تسجيل التفاصيل التقنية في سجل تشخيص محلي (بدون أي مفاتيح أو بيانات حساسة).
/// - تصنيف الخطأ إلى فئة مفهومة.
/// - إرجاع رسالة عربية مناسبة للمستخدم النهائي.
///
/// **قاعدة صريحة:** مفيش أي دالة هنا ترجّع نجاحًا. الخطأ يفضل خطأً، ومش بيتحوّل
/// لرسالة نجاح ولا لرسالة «لم أفهم» عامة.
class AppErrorService {
  AppErrorService._();

  static SharedPreferences? _p;
  static const String _kLog = 'diagnostics_log';
  static const int _maxEntries = 60;
  static final List<String> _buffer = <String>[];

  static Future<void> init() async {
    try {
      _p ??= await SharedPreferences.getInstance();
    } catch (_) {
      _p = null;
    }
    if (_buffer.isEmpty) {
      final raw = _p?.getString(_kLog);
      if (raw != null && raw.isNotEmpty) {
        try {
          final decoded = jsonDecode(raw);
          if (decoded is List) {
            _buffer.addAll(decoded.map((e) => e.toString()));
          }
        } catch (_) {
          // سجل تالف لا يمنع تشغيل التطبيق — نبدأ سجلًا جديدًا.
        }
      }
    }
  }

  /// يسجّل تفاصيل تقنية **محليًا فقط** — بعد إخفاء أي مفتاح أو رمز سري.
  ///
  /// [stack] اختياري: لو كان الخطأ استثناءً وراه stack trace يبقى مفيدًا
  /// للتشخيص، بيتسجّل مع sanitization.
  static void log(String context, Object? error, [dynamic stack]) {
    final entry =
        '${DateTime.now().toIso8601String()} | $context | ${_sanitize(error)}';
    _buffer.add(entry);
    while (_buffer.length > _maxEntries) {
      _buffer.removeAt(0);
    }
    if (stack != null) {
      final s = stack.toString();
      _buffer.add('    stack: ${s.length > 400 ? '${s.substring(0, 400)}…' : s}');
      while (_buffer.length > _maxEntries) {
        _buffer.removeAt(0);
      }
    }
    _persist();
  }

  /// أحدث الإدخالات أولاً — للعرض في شاشة التشخيص فقط.
  static List<String> entries() => List.unmodifiable(_buffer.reversed.toList());

  static Future<void> clear() async {
    _buffer.clear();
    await _p?.remove(_kLog);
  }

  static Future<void> _persist() async {
    try {
      await _p?.setString(_kLog, jsonEncode(_buffer));
    } catch (_) {
      // لو حتى السجل فشل، ممنوع نكسر التطبيق.
    }
  }

  /// إخفاء أي شيء يشبه مفتاحًا أو رمزًا سريًا قبل التسجيل.
  static String _sanitize(Object? error) {
    var s = error?.toString() ?? 'null';
    s = s.replaceAll(RegExp(r'AIza[0-9A-Za-z_\-]{10,}'), '[redacted]');
    s = s.replaceAll(
      RegExp(
          r'(api[_-]?key|apikey|key|token|authorization|bearer|password)["\s:=]+[^\s",}]+',
          caseSensitive: false),
      r'$1=[redacted]',
    );
    return s.length > 300 ? '${s.substring(0, 300)}…' : s;
  }

  static AppErrorKind classify(Object? error) {
    if (error is StorageException) return AppErrorKind.storage;
    final s = (error?.toString() ?? '').toLowerCase();
    if (s.contains('socket') ||
        s.contains('timeout') ||
        s.contains('connection') ||
        s.contains('network') ||
        s.contains('http') ||
        s.contains('unreachable')) {
      return AppErrorKind.network;
    }
    if (s.contains('notification') || s.contains('schedule')) {
      return AppErrorKind.notification;
    }
    if (s.contains('format') ||
        s.contains('parse') ||
        s.contains('invalid')) {
      return AppErrorKind.input;
    }
    return AppErrorKind.unexpected;
  }

  /// رسالة عربية مناسبة للمستخدم — بدون أي تفاصيل تقنية أو أسماء داخلية.
  static String userMessage(Object? error) {
    switch (classify(error)) {
      case AppErrorKind.storage:
        return 'لم نتمكن من حفظ العملية. لم يتم تأكيد تسجيلها. حاول مرة أخرى.';
      case AppErrorKind.network:
        return 'تعذر الاتصال بالخدمة حاليًا، لكن كل العمليات المحلية شغالة من غيرها.';
      case AppErrorKind.notification:
        return 'تم تسجيل العملية بنجاح، لكن تعذر ضبط التذكير.';
      case AppErrorKind.input:
        return 'البيانات المدخلة ناقصة أو غير صحيحة. جرّب صياغتها بشكل أوضح.';
      case AppErrorKind.unexpected:
        return 'حصلت مشكلة غير متوقعة. حاول مرة أخرى.';
    }
  }
}
