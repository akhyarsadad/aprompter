// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'Закрити';

  @override
  String get settings => 'Налаштування';

  @override
  String get prompterSettings => 'Налаштування суфлера';

  @override
  String get edit => 'Редагувати';

  @override
  String get delete => 'Видалити';

  @override
  String get undo => 'Скасувати';

  @override
  String get duplicate => 'Дублювати';

  @override
  String get share => 'Поділитися';

  @override
  String get copyAsCaption => 'Копіювати як підпис';

  @override
  String get captionCopied =>
      'Текст для озвучення скопійовано — вставте його в підпис до допису';

  @override
  String get copySuffix => '(копія)';

  @override
  String deletedScript(String title) {
    return '«$title» видалено';
  }

  @override
  String duplicatedScript(String title) {
    return 'Скопійовано як «$title»';
  }

  @override
  String get untitled => 'Без назви';

  @override
  String get newScript => 'Новий сценарій';

  @override
  String get searchScripts => 'Пошук сценаріїв';

  @override
  String get filterAll => 'Усі';

  @override
  String get statusDraft => 'Чернетка';

  @override
  String get statusReady => 'Готово';

  @override
  String get statusRecorded => 'Записано';

  @override
  String markAs(String status) {
    return 'Позначити: $status';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'Репетиція';

  @override
  String get float => 'Поверх';

  @override
  String get record => 'Запис';

  @override
  String words(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count слова',
      many: '$count слів',
      few: '$count слова',
      one: '$count слово',
    );
    return '$_temp0';
  }

  @override
  String takes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дубля',
      many: '$count дублів',
      few: '$count дублі',
      one: '$count дубль',
    );
    return '$_temp0';
  }

  @override
  String get noScriptsYet => 'Сценаріїв ще немає';

  @override
  String get noScriptsHint =>
      'Натисніть «Новий сценарій» і виберіть шаблон, щоб почати.';

  @override
  String get nothingHere => 'Тут порожньо';

  @override
  String get nothingHereHint => 'Спробуйте інший фільтр або запит.';

  @override
  String get startFromTemplate => 'Почати з шаблону';

  @override
  String get overlayPermissionNeeded =>
      'Дозвольте «Поверх інших додатків», щоб користуватися плаваючим суфлером.';

  @override
  String get floatingStarted =>
      'Суфлер поверх екрана. Відкрийте камеру й торкніться тексту, щоб почати.';

  @override
  String get floatingNotificationTitle => 'APrompter поверх екрана';

  @override
  String get openScriptInApp => 'Відкрийте сценарій в APrompter';

  @override
  String get script => 'Сценарій';

  @override
  String get title => 'Назва';

  @override
  String get status => 'Статус';

  @override
  String get noTarget => 'Без цілі';

  @override
  String get editorHint =>
      'Напишіть або вставте те, що хочете сказати…\n\nПорада: почніть рядок із # для розділу, із // для нотатки собі.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $spoken при $wpm сл/хв';
  }

  @override
  String get onTarget => 'У цілі';

  @override
  String overTarget(int seconds, int words) {
    return 'На $seconds с довше · скоротіть ~$words слів';
  }

  @override
  String underTarget(int seconds, int words) {
    return 'Залишилось $seconds с · ще ~$words слів';
  }

  @override
  String longSentences(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count довгого речення (25+ слів) — розбийте, щоб устигати дихати',
      many: '$count довгих речень (25+ слів) — розбийте, щоб устигати дихати',
      few: '$count довгі речення (25+ слів) — розбийте, щоб устигати дихати',
      one: '$count довге речення (25+ слів) — розбийте, щоб устигати дихати',
    );
    return '$_temp0';
  }

  @override
  String get toolSection => 'Розділ';

  @override
  String get toolEmphasis => 'Наголос';

  @override
  String get toolPause => 'Пауза';

  @override
  String get toolNote => 'Нотатка';

  @override
  String get toolPaste => 'Вставити';

  @override
  String get restart => 'Спочатку';

  @override
  String get sections => 'Розділи';

  @override
  String get slower => 'Повільніше';

  @override
  String get faster => 'Швидше';

  @override
  String get play => 'Пуск';

  @override
  String get pause => 'Пауза';

  @override
  String get wpmUnit => 'сл/хв';

  @override
  String get startOfScript => 'Початок сценарію';

  @override
  String sectionN(int n) {
    return 'Розділ $n';
  }

  @override
  String get noSectionsHint =>
      'Розділів ще немає. Додайте в редакторі рядки, що починаються з «#» (наприклад, «# Хук»), щоб переходити між частинами й перезнімати лише одну.';

  @override
  String get emptyScript => '(порожній сценарій)';

  @override
  String get preview => 'Попередній перегляд';

  @override
  String get setup => 'Сцена';

  @override
  String get pace => 'Темп';

  @override
  String get text => 'Текст';

  @override
  String get layout => 'Розташування';

  @override
  String get recording => 'Запис';

  @override
  String get wordsPerMinute => 'слів / хв';

  @override
  String fitTo(String time) {
    return 'Вкластися в $time';
  }

  @override
  String get paceCalm => 'Спокійно';

  @override
  String get paceNatural => 'Природно';

  @override
  String get paceEnergetic => 'Енергійно';

  @override
  String get countdown => 'Зворотний відлік перед стартом';

  @override
  String get off => 'Вимк.';

  @override
  String get size => 'Розмір';

  @override
  String get lineSpacing => 'Міжрядковий інтервал';

  @override
  String get textColor => 'Колір тексту';

  @override
  String get prompterHeight => 'Висота суфлера';

  @override
  String get background => 'Фон';

  @override
  String get readingGuide => 'Лінія читання';

  @override
  String get mirrorText => 'Дзеркальний текст';

  @override
  String get mirrorTextHint => 'Для скла телесуфлера / світлодільника';

  @override
  String get videoQuality => 'Якість відео';

  @override
  String get autoStop => 'Зупиняти запис наприкінці сценарію';

  @override
  String get autoStopHint => 'Чекає 2 секунди після останнього рядка';

  @override
  String get presetHandheld => 'Селфі з рук';

  @override
  String get presetHandheldHint => 'Середній текст біля об\'єктива';

  @override
  String get presetTripod => 'Штатив / на відстані';

  @override
  String get presetTripodHint => 'Великий текст, видно з 1–2 м';

  @override
  String get presetGlass => 'Скло телесуфлера';

  @override
  String get presetGlassHint => 'Дзеркально, на весь екран, суцільний фон';

  @override
  String get niceRun => 'Чудово!';

  @override
  String runSummary(String time, int words, int wpm) {
    return 'Ви витратили $time на $words слів → $wpm слів за хвилину.';
  }

  @override
  String runOver(int seconds, String target) {
    return 'Це на $seconds с більше за ціль $target — скоротіть сценарій або пришвидшіться.';
  }

  @override
  String runUnder(int seconds) {
    return 'У вас ще $seconds с до цілі.';
  }

  @override
  String get runOnTarget => 'Точно в цільову тривалість. 🎯';

  @override
  String get keepCurrent => 'Залишити';

  @override
  String useWpm(int wpm) {
    return 'Використати $wpm сл/хв';
  }

  @override
  String get switchCamera => 'Змінити камеру';

  @override
  String get startRecording => 'Почати запис';

  @override
  String get stopRecording => 'Зупинити запис';

  @override
  String get noCamera => 'На цьому пристрої не знайдено камери.';

  @override
  String get cameraDenied =>
      'Доступ до камери заборонено. Увімкніть його в налаштуваннях системи.';

  @override
  String cameraError(String message) {
    return 'Помилка камери: $message';
  }

  @override
  String takeSaved(int n) {
    return 'Дубль $n збережено в галерею';
  }

  @override
  String get templateBlank => 'Порожній';

  @override
  String get templateBlankHint => 'Почати з чистого аркуша';

  @override
  String get templateHvc => 'Хук → Цінність → CTA';

  @override
  String get templateHvcHint => 'Класична структура коротких відео';

  @override
  String get templateTutorial => 'Навчання';

  @override
  String get templateTutorialHint => 'Поясніть щось крок за кроком';

  @override
  String get templateReview => 'Огляд товару';

  @override
  String get templateReviewHint => 'UGC, реклама й чесні відгуки';

  @override
  String get templateStory => 'Історія';

  @override
  String get templateStoryHint => 'Особиста історія з висновком';

  @override
  String get secHook => 'Хук';

  @override
  String get secValue => 'Цінність';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'Крок $n';
  }

  @override
  String get secRecap => 'Підсумок і CTA';

  @override
  String get secWhatItIs => 'Що це';

  @override
  String get secLoved => 'Що сподобалося';

  @override
  String get secBetter => 'Що можна покращити';

  @override
  String get secVerdict => 'Вердикт і CTA';

  @override
  String get secSetup => 'Зав\'язка';

  @override
  String get secTurningPoint => 'Поворот';

  @override
  String get secLesson => 'Висновок';

  @override
  String get noteHook =>
      'Зачепіть увагу в перші 3 секунди: сміливе твердження або питання';

  @override
  String get noteValue => 'Дайте ту одну річ, яку пообіцяли';

  @override
  String get noteCta =>
      'Скажіть, що робити далі: підписатися, прокоментувати, посилання в профілі';

  @override
  String get noteTutorialHook => '«Ось як … менш ніж за хвилину»';

  @override
  String get noteRecap =>
      'Підсумуйте одним реченням і попросіть зберегти відео';

  @override
  String get noteReviewHook => 'Покажіть товар і проблему, яку він розв\'язує';

  @override
  String get noteVerdict =>
      'Кому варто купити — назвіть промокод або посилання';

  @override
  String get noteStoryHook => 'Почніть із середини дії';

  @override
  String get welcomeTitle => 'Ласкаво просимо до APrompter';

  @override
  String get welcomeBody =>
      '# Хук\nХочете знімати й не забувати текст? [pause]\n// дивіться прямо в об\'єктив\n\n# Як це працює\nНапишіть сценарій, виберіть *цільову тривалість*, і таймер підкаже, чи вкладаєтеся ви.\nПорепетируйте, щоб знайти свій темп у словах за хвилину.\nПотім натисніть «Запис». Текст прокручується просто під камерою, тож ви зберігаєте *зоровий контакт* із глядачами.\n\n# CTA\nТоркніться цієї картки, щоб змінити сценарій, або створіть свій кнопкою плюс. [pause] Приємної творчості!\n';

  @override
  String get expand => 'Розгорнути';

  @override
  String get minimize => 'Згорнути';

  @override
  String get nothingToSay =>
      'Спершу додайте текст для промовляння — розділи (#) і нотатки (//) не зачитуються.';

  @override
  String get openSettings => 'Відкрити налаштування';

  @override
  String get tryAgain => 'Спробувати ще';

  @override
  String get noMicBanner => 'Немає доступу до мікрофона — запис без звуку';

  @override
  String get saveFailedTitle => 'Не вдалося зберегти в галерею';

  @override
  String saveFailedBody(String reason) {
    return 'Ваш дубль поки в безпеці. Спробуйте ще раз або надішліть його у Файли, на Диск чи в чат, щоб не втратити. ($reason)';
  }

  @override
  String get shareVideo => 'Поділитися відео';

  @override
  String get discardTake => 'Видалити цей дубль';

  @override
  String takeShared(int n) {
    return 'Дубль $n надіслано';
  }

  @override
  String get movePrompter => 'Перетягніть, щоб перемістити суфлер';

  @override
  String get resizePrompter => 'Перетягніть, щоб змінити розмір суфлера';

  @override
  String get prompterWidth => 'Ширина суфлера';

  @override
  String get resetPosition => 'Скинути положення (угорі, на всю ширину)';

  @override
  String get positionHint =>
      'Перетягніть смужку зверху суфлера, щоб поставити його будь-де, і кут — щоб змінити розмір. На Android плаваюче вікно можна перетягнути будь-куди, і воно запам\'ятає місце.';

  @override
  String get app => 'Застосунок';

  @override
  String get appLanguage => 'Мова застосунку';

  @override
  String get systemDefault => 'Мова телефону';

  @override
  String secondsShort(int n) {
    return '$n с';
  }

  @override
  String minutesShort(int n) {
    return '$n хв';
  }
}
