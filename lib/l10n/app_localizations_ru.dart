// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'Закрыть';

  @override
  String get settings => 'Настройки';

  @override
  String get prompterSettings => 'Настройки суфлёра';

  @override
  String get edit => 'Изменить';

  @override
  String get delete => 'Удалить';

  @override
  String get undo => 'Отменить';

  @override
  String get duplicate => 'Дублировать';

  @override
  String get share => 'Поделиться';

  @override
  String get copyAsCaption => 'Копировать как подпись';

  @override
  String get captionCopied =>
      'Текст для озвучки скопирован — вставьте его в подпись к посту';

  @override
  String get copySuffix => '(копия)';

  @override
  String deletedScript(String title) {
    return '«$title» удалён';
  }

  @override
  String duplicatedScript(String title) {
    return 'Скопировано как «$title»';
  }

  @override
  String get untitled => 'Без названия';

  @override
  String get newScript => 'Новый сценарий';

  @override
  String get searchScripts => 'Поиск сценариев';

  @override
  String get filterAll => 'Все';

  @override
  String get statusDraft => 'Черновик';

  @override
  String get statusReady => 'Готов';

  @override
  String get statusRecorded => 'Записан';

  @override
  String markAs(String status) {
    return 'Отметить: $status';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'Репетиция';

  @override
  String get float => 'Поверх';

  @override
  String get record => 'Запись';

  @override
  String words(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count слова',
      many: '$count слов',
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
      many: '$count дублей',
      few: '$count дубля',
      one: '$count дубль',
    );
    return '$_temp0';
  }

  @override
  String get noScriptsYet => 'Сценариев пока нет';

  @override
  String get noScriptsHint =>
      'Нажмите «Новый сценарий» и выберите шаблон, чтобы начать.';

  @override
  String get nothingHere => 'Здесь пусто';

  @override
  String get nothingHereHint => 'Попробуйте другой фильтр или запрос.';

  @override
  String get startFromTemplate => 'Начать с шаблона';

  @override
  String get overlayPermissionNeeded =>
      'Разрешите «Поверх других приложений», чтобы пользоваться плавающим суфлёром.';

  @override
  String get floatingStarted =>
      'Суфлёр поверх экрана. Откройте камеру и коснитесь текста, чтобы начать.';

  @override
  String get floatingNotificationTitle => 'APrompter поверх экрана';

  @override
  String get openScriptInApp => 'Откройте сценарий в APrompter';

  @override
  String get script => 'Сценарий';

  @override
  String get title => 'Название';

  @override
  String get status => 'Статус';

  @override
  String get noTarget => 'Без цели';

  @override
  String get editorHint =>
      'Напишите или вставьте то, что хотите сказать…\n\nСовет: начните строку с # для раздела, с // для заметки себе.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $spoken при $wpm сл/мин';
  }

  @override
  String get onTarget => 'В цели';

  @override
  String overTarget(int seconds, int words) {
    return 'На $seconds с дольше · сократите ~$words слов';
  }

  @override
  String underTarget(int seconds, int words) {
    return 'Осталось $seconds с · ещё ~$words слов';
  }

  @override
  String longSentences(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count длинного предложения (25+ слов) — разбейте, чтобы успевать дышать',
      many:
          '$count длинных предложений (25+ слов) — разбейте, чтобы успевать дышать',
      few:
          '$count длинных предложения (25+ слов) — разбейте, чтобы успевать дышать',
      one:
          '$count длинное предложение (25+ слов) — разбейте, чтобы успевать дышать',
    );
    return '$_temp0';
  }

  @override
  String get toolSection => 'Раздел';

  @override
  String get toolEmphasis => 'Акцент';

  @override
  String get toolPause => 'Пауза';

  @override
  String get toolNote => 'Заметка';

  @override
  String get toolPaste => 'Вставить';

  @override
  String get restart => 'Сначала';

  @override
  String get sections => 'Разделы';

  @override
  String get slower => 'Медленнее';

  @override
  String get faster => 'Быстрее';

  @override
  String get play => 'Пуск';

  @override
  String get pause => 'Пауза';

  @override
  String get wpmUnit => 'сл/мин';

  @override
  String get startOfScript => 'Начало сценария';

  @override
  String sectionN(int n) {
    return 'Раздел $n';
  }

  @override
  String get noSectionsHint =>
      'Разделов пока нет. Добавьте в редакторе строки, начинающиеся с «#» (например, «# Хук»), чтобы переходить между частями и переснимать только одну.';

  @override
  String get emptyScript => '(пустой сценарий)';

  @override
  String get preview => 'Предпросмотр';

  @override
  String get setup => 'Сцена';

  @override
  String get pace => 'Темп';

  @override
  String get text => 'Текст';

  @override
  String get layout => 'Расположение';

  @override
  String get recording => 'Запись';

  @override
  String get wordsPerMinute => 'слов / мин';

  @override
  String fitTo(String time) {
    return 'Уложить в $time';
  }

  @override
  String get paceCalm => 'Спокойно';

  @override
  String get paceNatural => 'Естественно';

  @override
  String get paceEnergetic => 'Энергично';

  @override
  String get countdown => 'Обратный отсчёт перед стартом';

  @override
  String get off => 'Выкл.';

  @override
  String get size => 'Размер';

  @override
  String get lineSpacing => 'Межстрочный интервал';

  @override
  String get textColor => 'Цвет текста';

  @override
  String get prompterHeight => 'Высота суфлёра';

  @override
  String get background => 'Фон';

  @override
  String get readingGuide => 'Линия чтения';

  @override
  String get mirrorText => 'Зеркальный текст';

  @override
  String get mirrorTextHint => 'Для стекла телесуфлёра / светоделителя';

  @override
  String get videoQuality => 'Качество видео';

  @override
  String get autoStop => 'Останавливать запись в конце сценария';

  @override
  String get autoStopHint => 'Ждёт 2 секунды после последней строки';

  @override
  String get presetHandheld => 'Селфи с рук';

  @override
  String get presetHandheldHint => 'Средний текст рядом с объективом';

  @override
  String get presetTripod => 'Штатив / на расстоянии';

  @override
  String get presetTripodHint => 'Крупный текст, читаемый с 1–2 м';

  @override
  String get presetGlass => 'Стекло телесуфлёра';

  @override
  String get presetGlassHint => 'Зеркально, на весь экран, сплошной фон';

  @override
  String get niceRun => 'Отлично!';

  @override
  String runSummary(String time, int words, int wpm) {
    return 'Вы потратили $time на $words слов → $wpm слов в минуту.';
  }

  @override
  String runOver(int seconds, String target) {
    return 'Это на $seconds с больше цели $target — сократите сценарий или ускорьтесь.';
  }

  @override
  String runUnder(int seconds) {
    return 'У вас ещё $seconds с до цели.';
  }

  @override
  String get runOnTarget => 'Точно в целевую длительность. 🎯';

  @override
  String get keepCurrent => 'Оставить';

  @override
  String useWpm(int wpm) {
    return 'Использовать $wpm сл/мин';
  }

  @override
  String get switchCamera => 'Сменить камеру';

  @override
  String get startRecording => 'Начать запись';

  @override
  String get stopRecording => 'Остановить запись';

  @override
  String get noCamera => 'На этом устройстве не найдена камера.';

  @override
  String get cameraDenied =>
      'Доступ к камере запрещён. Разрешите его в настройках системы.';

  @override
  String cameraError(String message) {
    return 'Ошибка камеры: $message';
  }

  @override
  String takeSaved(int n) {
    return 'Дубль $n сохранён в галерею';
  }

  @override
  String get templateBlank => 'Пустой';

  @override
  String get templateBlankHint => 'Начать с чистого листа';

  @override
  String get templateHvc => 'Хук → Польза → CTA';

  @override
  String get templateHvcHint => 'Классическая структура коротких видео';

  @override
  String get templateTutorial => 'Обучение';

  @override
  String get templateTutorialHint => 'Объясните что-то шаг за шагом';

  @override
  String get templateReview => 'Обзор товара';

  @override
  String get templateReviewHint => 'UGC, реклама и честные отзывы';

  @override
  String get templateStory => 'История';

  @override
  String get templateStoryHint => 'Личная история с выводом';

  @override
  String get secHook => 'Хук';

  @override
  String get secValue => 'Польза';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'Шаг $n';
  }

  @override
  String get secRecap => 'Итог и CTA';

  @override
  String get secWhatItIs => 'Что это';

  @override
  String get secLoved => 'Что понравилось';

  @override
  String get secBetter => 'Что можно улучшить';

  @override
  String get secVerdict => 'Вердикт и CTA';

  @override
  String get secSetup => 'Завязка';

  @override
  String get secTurningPoint => 'Поворот';

  @override
  String get secLesson => 'Вывод';

  @override
  String get noteHook =>
      'Зацепите внимание в первые 3 секунды: смелое утверждение или вопрос';

  @override
  String get noteValue => 'Дайте ту самую одну вещь, которую обещали';

  @override
  String get noteCta =>
      'Скажите, что делать дальше: подписаться, прокомментировать, ссылка в профиле';

  @override
  String get noteTutorialHook => '«Вот как … меньше чем за минуту»';

  @override
  String get noteRecap =>
      'Подведите итог одной фразой и попросите сохранить видео';

  @override
  String get noteReviewHook => 'Покажите товар и проблему, которую он решает';

  @override
  String get noteVerdict => 'Кому стоит купить — назовите промокод или ссылку';

  @override
  String get noteStoryHook => 'Начните с середины действия';

  @override
  String get welcomeTitle => 'Добро пожаловать в APrompter';

  @override
  String get welcomeBody =>
      '# Хук\nХотите снимать и не забывать текст? [pause]\n// смотрите прямо в объектив\n\n# Как это работает\nНапишите сценарий, выберите *целевую длительность*, и таймер подскажет, укладываетесь ли вы.\nПорепетируйте, чтобы найти свой темп в словах в минуту.\nПотом нажмите «Запись». Текст прокручивается прямо под камерой, так что вы сохраняете *зрительный контакт* со зрителями.\n\n# CTA\nНажмите на эту карточку, чтобы изменить сценарий, или создайте свой кнопкой плюс. [pause] Приятного творчества!\n';

  @override
  String get expand => 'Развернуть';

  @override
  String get minimize => 'Свернуть';

  @override
  String get nothingToSay =>
      'Сначала добавьте текст для произнесения — разделы (#) и заметки (//) не зачитываются.';

  @override
  String get openSettings => 'Открыть настройки';

  @override
  String get tryAgain => 'Повторить';

  @override
  String get noMicBanner => 'Нет доступа к микрофону — запись без звука';

  @override
  String get saveFailedTitle => 'Не удалось сохранить в галерею';

  @override
  String saveFailedBody(String reason) {
    return 'Ваш дубль пока в безопасности. Повторите попытку или отправьте его в Файлы, на Диск или в чат, чтобы не потерять. ($reason)';
  }

  @override
  String get shareVideo => 'Поделиться видео';

  @override
  String get discardTake => 'Удалить этот дубль';

  @override
  String takeShared(int n) {
    return 'Дубль $n отправлен';
  }

  @override
  String get movePrompter => 'Перетащите, чтобы переместить суфлёр';

  @override
  String get resizePrompter => 'Перетащите, чтобы изменить размер суфлёра';

  @override
  String get prompterWidth => 'Ширина суфлёра';

  @override
  String get resetPosition => 'Сбросить положение (вверху, во всю ширину)';

  @override
  String get positionHint =>
      'Перетащите полоску сверху суфлёра, чтобы поставить его куда угодно, и угол — чтобы изменить размер. На Android плавающее окно можно перетащить в любое место, и оно запомнит его.';

  @override
  String get app => 'Приложение';

  @override
  String get appLanguage => 'Язык приложения';

  @override
  String get systemDefault => 'Язык телефона';

  @override
  String secondsShort(int n) {
    return '$n с';
  }

  @override
  String minutesShort(int n) {
    return '$n мин';
  }

  @override
  String get storageSaveFailed =>
      'Не удалось сохранить — возможно, в телефоне закончилось место. Работа сохранится, пока приложение открыто.';

  @override
  String get versionHistory => 'История версий';

  @override
  String get noVersions =>
      'Прежних версий пока нет. Они сохраняются автоматически, пока вы пишете.';

  @override
  String get restore => 'Восстановить';

  @override
  String get versionRestored => 'Прежняя версия восстановлена';

  @override
  String get recentlyDeleted => 'Недавно удалённые';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Удалённые сценарии хранятся здесь $days дня.',
      many: 'Удалённые сценарии хранятся здесь $days дней.',
      few: 'Удалённые сценарии хранятся здесь $days дня.',
      one: 'Удалённые сценарии хранятся здесь $days день.',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => 'Удалить навсегда';

  @override
  String deletedOn(String date) {
    return 'Удалено $date';
  }

  @override
  String restoredScript(String title) {
    return '«$title» восстановлен';
  }

  @override
  String get backUpScripts => 'Резервная копия всех сценариев';

  @override
  String get restoreBackup => 'Восстановить из копии';

  @override
  String get backupShareTitle => 'Резервная копия APrompter';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Восстановлено $count сценария',
      many: 'Восстановлено $count сценариев',
      few: 'Восстановлено $count сценария',
      one: 'Восстановлен $count сценарий',
      zero: 'Всё из этой копии уже здесь',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'Этот файл не является резервной копией APrompter.';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return 'Даже при $wpm сл/мин не уложиться в $target — сократите примерно на $words сл.';
  }

  @override
  String get cameraNotReady =>
      'Камера не была готова, запись не началась. Попробуйте ещё раз.';

  @override
  String get previousSection => 'Предыдущий раздел';

  @override
  String get nextSection => 'Следующий раздел';

  @override
  String get floatingNotificationBody => 'Нажмите, чтобы открыть APrompter';

  @override
  String get customTarget => 'Своё…';

  @override
  String get customTargetTitle => 'Целевая длительность';

  @override
  String get customTargetHint => 'Минуты и секунды, напр. 5:00';

  @override
  String get saved => 'Сохранено';

  @override
  String get floatNotOnIos =>
      'На iPhone приложения не могут отображаться поверх других. Используйте «Запись», чтобы снимать со сценарием под камерой.';

  @override
  String get hashtagHint =>
      'Строки с хештегами (#fyp #ad) приглушены и не учитываются по времени. Для раздела используйте «# » с пробелом.';
}
