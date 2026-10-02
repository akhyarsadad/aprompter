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

  @override
  String get storageSaveFailed =>
      'Не вдалося зберегти — можливо, у телефоні закінчилося місце. Роботу збережено, доки застосунок відкритий.';

  @override
  String get versionHistory => 'Історія версій';

  @override
  String get noVersions =>
      'Попередніх версій ще немає. Вони зберігаються автоматично, поки ви пишете.';

  @override
  String get restore => 'Відновити';

  @override
  String get versionRestored => 'Попередню версію відновлено';

  @override
  String get recentlyDeleted => 'Нещодавно видалені';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Видалені сценарії зберігаються тут $days дня.',
      many: 'Видалені сценарії зберігаються тут $days днів.',
      few: 'Видалені сценарії зберігаються тут $days дні.',
      one: 'Видалені сценарії зберігаються тут $days день.',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => 'Видалити назавжди';

  @override
  String deletedOn(String date) {
    return 'Видалено $date';
  }

  @override
  String restoredScript(String title) {
    return '«$title» відновлено';
  }

  @override
  String get backUpScripts => 'Резервна копія всіх сценаріїв';

  @override
  String get restoreBackup => 'Відновити з копії';

  @override
  String get backupShareTitle => 'Резервна копія APrompter';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Відновлено $count сценарію',
      many: 'Відновлено $count сценаріїв',
      few: 'Відновлено $count сценарії',
      one: 'Відновлено $count сценарій',
      zero: 'Усе з цієї копії вже тут',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'Цей файл не є резервною копією APrompter.';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return 'Навіть при $wpm сл/хв не вміститься в $target — скоротіть приблизно на $words сл.';
  }

  @override
  String get cameraNotReady =>
      'Камера не була готова, запис не почався. Спробуйте ще раз.';

  @override
  String get previousSection => 'Попередній розділ';

  @override
  String get nextSection => 'Наступний розділ';

  @override
  String get floatingNotificationBody => 'Торкніться, щоб відкрити APrompter';

  @override
  String get customTarget => 'Своя…';

  @override
  String get customTargetTitle => 'Цільова тривалість';

  @override
  String get customTargetHint => 'Хвилини й секунди, напр. 5:00';

  @override
  String get saved => 'Збережено';

  @override
  String get floatNotOnIos =>
      'На iPhone застосунки не можуть бути поверх інших. Використовуйте «Запис», щоб знімати зі сценарієм під камерою.';

  @override
  String get hashtagHint =>
      'Рядки з хештегами (#fyp #ad) приглушені й не враховуються в часі. Для розділу використовуйте «# » із пробілом.';

  @override
  String get appLock => 'Блокування застосунку';

  @override
  String get appLockHint =>
      'Запитувати відбиток, обличчя або PIN телефона для відкриття APrompter';

  @override
  String get appLockUnavailable =>
      'Спершу налаштуйте блокування екрана на цьому телефоні.';

  @override
  String get unlock => 'Розблокувати';

  @override
  String get unlockReason => 'Розблокуйте APrompter, щоб побачити сценарії';

  @override
  String get autoStopWait => 'Пауза після останнього рядка';

  @override
  String get beforeYouRecord => 'Перед записом';

  @override
  String get recordAnyway => 'Все одно записати';

  @override
  String lowStorageWarning(int minutes) {
    return 'Вільного місця вистачить лише приблизно на $minutes хв відео. Звільніть місце або знизьте якість відео.';
  }

  @override
  String lowBatteryWarning(int level) {
    return 'Заряд $level% — довгий дубль може обірватися. Підключіть зарядку, якщо можете.';
  }

  @override
  String get brightScreen => 'Повна яскравість під час суфлера';

  @override
  String get brightScreenHint => 'Легше читати надворі';

  @override
  String get cameraBusy =>
      'Камеру використовує інший застосунок. Закрийте його й спробуйте ще.';

  @override
  String get cameraIntroTitle => 'Камера й мікрофон';

  @override
  String get cameraIntroBody =>
      'Щоб знімати вас зі сценарієм на екрані, APrompter потрібні камера й мікрофон. Зараз телефон попросить дозвіл. Відео залишаються на вашому телефоні.';

  @override
  String get continueLabel => 'Продовжити';

  @override
  String get notNow => 'Не зараз';

  @override
  String get colorWhite => 'Білий';

  @override
  String get colorYellow => 'Жовтий';

  @override
  String get colorGreen => 'Зелений';

  @override
  String get colorBlue => 'Синій';

  @override
  String get colorPink => 'Рожевий';

  @override
  String get colorBlack => 'Чорний';

  @override
  String get damagedData => 'Нечитабельні дані';

  @override
  String damagedDataHint(String date, int size) {
    return 'Відкладено $date · $size символів';
  }

  @override
  String get tryToRecover => 'Спробувати відновити';

  @override
  String get nothingRecovered => 'Не вдалося прочитати жодного сценарію.';

  @override
  String get floatLowRam =>
      'Цей телефон не може показувати застосунки поверх інших (мало пам\'яті або Android Go). Використовуйте Запис.';

  @override
  String get oemTipsTitle => 'Щоб плаваючий суфлер не закривався';

  @override
  String oemTipsBody(String brand) {
    return 'Телефони $brand можуть закривати плаваючі вікна, щоб заощадити заряд. У Налаштування → Додатки → APrompter: дозвольте показ поверх інших додатків (і спливні вікна), для батареї виберіть «Без обмежень» і дозвольте сповіщення.';
  }

  @override
  String get focusLine => 'Фокус на поточному рядку';

  @override
  String get focusLineHint => 'Затемнює інші рядки';

  @override
  String get stepByLine => 'По рядку';

  @override
  String get stepByLineHint =>
      'Кожен дотик або натискання пульта — один рядок, без автопрокручування';

  @override
  String get reduceEffects => 'Менше ефектів';

  @override
  String get reduceEffectsHint =>
      'Без згасань і тіней: плавніше на старих телефонах, економить заряд';

  @override
  String get letterSpacing => 'Міжлітерний інтервал';

  @override
  String get importTextFile => 'Імпорт текстового файлу';

  @override
  String get importTextFileHint =>
      'Сценарій .txt або .md з Файлів, Диска чи пошти';

  @override
  String get importTextFailed =>
      'Не вдалося прочитати файл. Виберіть звичайний текстовий файл (.txt).';

  @override
  String get mySetup => 'Мої налаштування';

  @override
  String get mySetupHint => 'Збережений вами набір налаштувань';

  @override
  String get saveMySetup => 'Зберегти як мої налаштування';

  @override
  String get resetAllSettings => 'Скинути всі налаштування';

  @override
  String get runHadJumps =>
      'У цьому прогоні були переходи текстом, тож темп не запропонувати.';

  @override
  String get keepTake => 'Залишити';

  @override
  String get retake => 'Перезняти';

  @override
  String get reviewTakes => 'Переглядати кожен дубль';

  @override
  String get reviewTakesHint => 'Перегляньте, потім залиште або перезніміть';

  @override
  String get takesToGallery => 'Зберігати дублі в галерею';

  @override
  String get takesToGalleryHint =>
      'Вимк.: дублі залишаються в застосунку, поза Google Photos та iCloud';

  @override
  String get takesTitle => 'Дублі';

  @override
  String get takesEmpty =>
      'Тут з\'являються дублі, збережені в застосунку. Вимкніть «Зберігати дублі в галерею» в налаштуваннях, щоб тримати їх тут.';

  @override
  String get saveToGallery => 'Зберегти в галерею';

  @override
  String get savedToGallery => 'Збережено в галерею';

  @override
  String get deleteTake => 'Видалити дубль';

  @override
  String takeKeptInApp(int n) {
    return 'Дубль $n збережено в застосунку';
  }

  @override
  String get signInTitle => 'Sign in to continue';

  @override
  String get signInBody =>
      'This only identifies your purchase across your devices — it does not sync your scripts.';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get signInFailed => 'Sign in failed. Try again.';

  @override
  String get upgradeTitle => 'Go unlimited';

  @override
  String get upgradeBody =>
      'Unlock unlimited scripts and length with a subscription or a one-time purchase.';

  @override
  String get offeringsLoadFailed =>
      'Couldn\'t load plans. Check your connection and try again.';

  @override
  String get purchaseFailed => 'Purchase failed. Try again.';

  @override
  String get restoreFailed => 'Couldn\'t restore purchases. Try again.';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String wordCapBannerText(int count) {
    return 'Free scripts are capped at $count words.';
  }

  @override
  String get upgrade => 'Upgrade';
}
