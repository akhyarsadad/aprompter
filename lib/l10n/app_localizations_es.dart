// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'Cerrar';

  @override
  String get settings => 'Ajustes';

  @override
  String get prompterSettings => 'Ajustes del prompter';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Eliminar';

  @override
  String get undo => 'Deshacer';

  @override
  String get duplicate => 'Duplicar';

  @override
  String get share => 'Compartir';

  @override
  String get copyAsCaption => 'Copiar como descripción';

  @override
  String get captionCopied => 'Texto hablado copiado: pégalo como descripción';

  @override
  String get copySuffix => '(copia)';

  @override
  String deletedScript(String title) {
    return '«$title» eliminado';
  }

  @override
  String duplicatedScript(String title) {
    return 'Duplicado como «$title»';
  }

  @override
  String get untitled => 'Sin título';

  @override
  String get newScript => 'Nuevo guion';

  @override
  String get searchScripts => 'Buscar guiones';

  @override
  String get filterAll => 'Todos';

  @override
  String get statusDraft => 'Borrador';

  @override
  String get statusReady => 'Listo';

  @override
  String get statusRecorded => 'Grabado';

  @override
  String markAs(String status) {
    return 'Marcar como $status';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'Ensayar';

  @override
  String get float => 'Flotante';

  @override
  String get record => 'Grabar';

  @override
  String words(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count palabras',
      one: '1 palabra',
    );
    return '$_temp0';
  }

  @override
  String takes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tomas',
      one: '1 toma',
    );
    return '$_temp0';
  }

  @override
  String get noScriptsYet => 'Aún no hay guiones';

  @override
  String get noScriptsHint =>
      'Toca «Nuevo guion» y elige una plantilla para empezar.';

  @override
  String get nothingHere => 'No hay nada aquí';

  @override
  String get nothingHereHint => 'Prueba otro filtro o búsqueda.';

  @override
  String get startFromTemplate => 'Empieza con una plantilla';

  @override
  String get overlayPermissionNeeded =>
      'Permite «Mostrar sobre otras apps» para usar el prompter flotante.';

  @override
  String get floatingStarted =>
      'El prompter está flotando. Abre tu app de cámara y toca el texto para empezar.';

  @override
  String get floatingNotificationTitle => 'APrompter está flotando';

  @override
  String get openScriptInApp => 'Abre un guion en APrompter';

  @override
  String get script => 'Guion';

  @override
  String get title => 'Título';

  @override
  String get status => 'Estado';

  @override
  String get noTarget => 'Sin objetivo';

  @override
  String get editorHint =>
      'Escribe o pega lo que quieres decir…\n\nConsejo: empieza una línea con # para una sección, // para una nota para ti.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $spoken a $wpm ppm';
  }

  @override
  String get onTarget => 'En el objetivo';

  @override
  String overTarget(int seconds, int words) {
    return '$seconds s de más · recorta ~$words palabras';
  }

  @override
  String underTarget(int seconds, int words) {
    return 'Quedan $seconds s · ~$words palabras más';
  }

  @override
  String longSentences(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count frases largas (25+ palabras): divídelas para poder respirar',
      one: '1 frase larga (25+ palabras): divídela para poder respirar',
    );
    return '$_temp0';
  }

  @override
  String get toolSection => 'Sección';

  @override
  String get toolEmphasis => 'Énfasis';

  @override
  String get toolPause => 'Pausa';

  @override
  String get toolNote => 'Nota';

  @override
  String get toolPaste => 'Pegar';

  @override
  String get restart => 'Reiniciar';

  @override
  String get sections => 'Secciones';

  @override
  String get slower => 'Más lento';

  @override
  String get faster => 'Más rápido';

  @override
  String get play => 'Reproducir';

  @override
  String get pause => 'Pausa';

  @override
  String get wpmUnit => 'ppm';

  @override
  String get startOfScript => 'Inicio del guion';

  @override
  String sectionN(int n) {
    return 'Sección $n';
  }

  @override
  String get noSectionsHint =>
      'Aún no hay secciones. Añade líneas que empiecen con «#» en el editor (p. ej. «# Gancho») para saltar entre partes y repetir solo una.';

  @override
  String get emptyScript => '(guion vacío)';

  @override
  String get preview => 'Vista previa';

  @override
  String get setup => 'Configuración';

  @override
  String get pace => 'Ritmo';

  @override
  String get text => 'Texto';

  @override
  String get layout => 'Diseño';

  @override
  String get recording => 'Grabación';

  @override
  String get wordsPerMinute => 'palabras / min';

  @override
  String fitTo(String time) {
    return 'Ajustar a $time';
  }

  @override
  String get paceCalm => 'Tranquilo';

  @override
  String get paceNatural => 'Natural';

  @override
  String get paceEnergetic => 'Enérgico';

  @override
  String get countdown => 'Cuenta atrás antes de empezar';

  @override
  String get off => 'No';

  @override
  String get size => 'Tamaño';

  @override
  String get lineSpacing => 'Interlineado';

  @override
  String get textColor => 'Color del texto';

  @override
  String get prompterHeight => 'Altura del prompter';

  @override
  String get background => 'Fondo';

  @override
  String get readingGuide => 'Línea guía de lectura';

  @override
  String get mirrorText => 'Texto en espejo';

  @override
  String get mirrorTextHint => 'Para cristal de teleprompter / beam splitter';

  @override
  String get videoQuality => 'Calidad de vídeo';

  @override
  String get autoStop => 'Detener la grabación al terminar el guion';

  @override
  String get autoStopHint => 'Espera 2 segundos después de la última línea';

  @override
  String get presetHandheld => 'Selfie en mano';

  @override
  String get presetHandheldHint => 'Texto mediano cerca del objetivo';

  @override
  String get presetTripod => 'Trípode / a distancia';

  @override
  String get presetTripodHint => 'Texto grande legible a 1–2 m';

  @override
  String get presetGlass => 'Cristal de teleprompter';

  @override
  String get presetGlassHint => 'En espejo, pantalla completa, fondo sólido';

  @override
  String get niceRun => '¡Muy bien!';

  @override
  String runSummary(String time, int words, int wpm) {
    return 'Tardaste $time en $words palabras → $wpm palabras por minuto.';
  }

  @override
  String runOver(int seconds, String target) {
    return 'Son $seconds s más que tu objetivo de $target: recorta el guion o acelera.';
  }

  @override
  String runUnder(int seconds) {
    return 'Te quedan $seconds s antes de tu objetivo.';
  }

  @override
  String get runOnTarget => 'Justo en tu duración objetivo. 🎯';

  @override
  String get keepCurrent => 'Mantener';

  @override
  String useWpm(int wpm) {
    return 'Usar $wpm ppm';
  }

  @override
  String get switchCamera => 'Cambiar cámara';

  @override
  String get startRecording => 'Empezar a grabar';

  @override
  String get stopRecording => 'Detener grabación';

  @override
  String get noCamera => 'No se encontró ninguna cámara en este dispositivo.';

  @override
  String get cameraDenied =>
      'Se denegó el acceso a la cámara. Actívalo en los ajustes del sistema.';

  @override
  String cameraError(String message) {
    return 'Error de cámara: $message';
  }

  @override
  String takeSaved(int n) {
    return 'Toma $n guardada en tu galería';
  }

  @override
  String get templateBlank => 'En blanco';

  @override
  String get templateBlankHint => 'Empieza con una página vacía';

  @override
  String get templateHvc => 'Gancho → Valor → CTA';

  @override
  String get templateHvcHint => 'La estructura clásica de vídeo corto';

  @override
  String get templateTutorial => 'Tutorial';

  @override
  String get templateTutorialHint => 'Enseña algo paso a paso';

  @override
  String get templateReview => 'Reseña de producto';

  @override
  String get templateReviewHint => 'UGC, anuncios y reseñas honestas';

  @override
  String get templateStory => 'Storytime';

  @override
  String get templateStoryHint => 'Historia personal con una lección';

  @override
  String get secHook => 'Gancho';

  @override
  String get secValue => 'Valor';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'Paso $n';
  }

  @override
  String get secRecap => 'Resumen y CTA';

  @override
  String get secWhatItIs => 'Qué es';

  @override
  String get secLoved => 'Lo que me encantó';

  @override
  String get secBetter => 'Lo que podría mejorar';

  @override
  String get secVerdict => 'Veredicto y CTA';

  @override
  String get secSetup => 'Contexto';

  @override
  String get secTurningPoint => 'Punto de giro';

  @override
  String get secLesson => 'Lección';

  @override
  String get noteHook =>
      'Capta la atención en los primeros 3 segundos: una afirmación audaz o una pregunta';

  @override
  String get noteValue => 'Entrega lo único que prometiste';

  @override
  String get noteCta =>
      'Diles qué hacer después: seguir, comentar, enlace en la bio';

  @override
  String get noteTutorialHook => '«Así se hace … en menos de un minuto»';

  @override
  String get noteRecap => 'Resume en una frase y pide que guarden el vídeo';

  @override
  String get noteReviewHook => 'Muestra el producto y el problema que resuelve';

  @override
  String get noteVerdict => 'Para quién es: menciona el código o el enlace';

  @override
  String get noteStoryHook => 'Empieza en mitad de la acción';

  @override
  String get welcomeTitle => 'Bienvenido a APrompter';

  @override
  String get welcomeBody =>
      '# Gancho\n¿Quieres grabar sin olvidar tus líneas? [pause]\n// mira directamente al objetivo\n\n# Cómo funciona\nEscribe tu guion, elige una *duración objetivo* y el temporizador te dirá si encaja.\nEnsaya para encontrar tu ritmo en palabras por minuto.\nLuego pulsa Grabar. El texto se desplaza justo debajo de la cámara, así mantienes el *contacto visual* con tu audiencia.\n\n# CTA\nToca esta tarjeta para editar el guion o crea el tuyo con el botón más. [pause] ¡Diviértete creando!\n';

  @override
  String get expand => 'Ampliar';

  @override
  String get minimize => 'Minimizar';

  @override
  String get nothingToSay =>
      'Primero añade algo que decir: las secciones (#) y las notas (//) no se leen.';

  @override
  String get openSettings => 'Abrir ajustes';

  @override
  String get tryAgain => 'Reintentar';

  @override
  String get noMicBanner => 'Sin acceso al micrófono: grabando sin sonido';

  @override
  String get saveFailedTitle => 'No se pudo guardar en tu galería';

  @override
  String saveFailedBody(String reason) {
    return 'Tu toma está a salvo por ahora. Reinténtalo o compártela a Archivos, Drive o un chat para no perderla. ($reason)';
  }

  @override
  String get shareVideo => 'Compartir vídeo';

  @override
  String get discardTake => 'Descartar esta toma';

  @override
  String takeShared(int n) {
    return 'Toma $n compartida';
  }

  @override
  String get movePrompter => 'Arrastra para mover el prompter';

  @override
  String get resizePrompter => 'Arrastra para cambiar el tamaño del prompter';

  @override
  String get prompterWidth => 'Ancho del prompter';

  @override
  String get resetPosition => 'Restablecer posición (arriba, ancho completo)';

  @override
  String get positionHint =>
      'Arrastra la barra superior del prompter para moverlo a cualquier sitio y la esquina para cambiar su tamaño. En Android, la ventana flotante se puede arrastrar a cualquier lugar y recuerda su posición.';

  @override
  String get app => 'App';

  @override
  String get appLanguage => 'Idioma de la app';

  @override
  String get systemDefault => 'Idioma del teléfono';

  @override
  String secondsShort(int n) {
    return '$n s';
  }

  @override
  String minutesShort(int n) {
    return '$n min';
  }

  @override
  String get storageSaveFailed =>
      'No se pudo guardar: puede que tu teléfono no tenga espacio. Tu trabajo se conserva mientras la app siga abierta.';

  @override
  String get versionHistory => 'Historial de versiones';

  @override
  String get noVersions =>
      'Aún no hay versiones anteriores. Se guardan automáticamente mientras escribes.';

  @override
  String get restore => 'Restaurar';

  @override
  String get versionRestored => 'Versión anterior restaurada';

  @override
  String get recentlyDeleted => 'Eliminados recientemente';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Los guiones eliminados se quedan aquí $days días.',
      one: 'Los guiones eliminados se quedan aquí 1 día.',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => 'Eliminar para siempre';

  @override
  String deletedOn(String date) {
    return 'Eliminado el $date';
  }

  @override
  String restoredScript(String title) {
    return '«$title» restaurado';
  }

  @override
  String get backUpScripts => 'Copia de seguridad de todos los guiones';

  @override
  String get restoreBackup => 'Restaurar desde una copia';

  @override
  String get backupShareTitle => 'Copia de seguridad de APrompter';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count guiones restaurados',
      one: '1 guion restaurado',
      zero: 'Todo lo de esta copia ya está aquí',
    );
    return '$_temp0';
  }

  @override
  String get notABackup =>
      'Ese archivo no es una copia de seguridad de APrompter.';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return 'Ni a $wpm ppm cabe en $target: recorta unas $words palabras.';
  }

  @override
  String get cameraNotReady =>
      'La cámara no estaba lista y no empezó la grabación. Inténtalo de nuevo.';

  @override
  String get previousSection => 'Sección anterior';

  @override
  String get nextSection => 'Sección siguiente';

  @override
  String get floatingNotificationBody => 'Toca para abrir APrompter';

  @override
  String get customTarget => 'Personalizado…';

  @override
  String get customTargetTitle => 'Duración objetivo';

  @override
  String get customTargetHint => 'Minutos y segundos, p. ej. 5:00';

  @override
  String get saved => 'Guardado';

  @override
  String get floatNotOnIos =>
      'El iPhone no permite que las apps floten sobre otras. Usa Grabar para filmar con el guion bajo la cámara.';

  @override
  String get hashtagHint =>
      'Las líneas de hashtags (#fyp #ad) se ven atenuadas y no se cronometran. Usa «# » con un espacio para una sección.';

  @override
  String get appLock => 'Bloqueo de la app';

  @override
  String get appLockHint =>
      'Pide huella, rostro o PIN del teléfono para abrir APrompter';

  @override
  String get appLockUnavailable =>
      'Primero configura un bloqueo de pantalla en este teléfono.';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get unlockReason => 'Desbloquea APrompter para ver tus guiones';

  @override
  String get autoStopWait => 'Espera tras la última línea';

  @override
  String get beforeYouRecord => 'Antes de grabar';

  @override
  String get recordAnyway => 'Grabar igualmente';

  @override
  String lowStorageWarning(int minutes) {
    return 'Solo caben unos $minutes min de vídeo en tu espacio libre. Libera espacio o baja la calidad de vídeo.';
  }

  @override
  String lowBatteryWarning(int level) {
    return 'Batería al $level %: una toma larga podría cortarse. Conecta el cargador si puedes.';
  }

  @override
  String get brightScreen => 'Brillo máximo al usar el prompter';

  @override
  String get brightScreenHint => 'Más fácil de leer al aire libre';

  @override
  String get cameraBusy =>
      'Otra app está usando la cámara. Ciérrala y vuelve a intentarlo.';

  @override
  String get cameraIntroTitle => 'Cámara y micrófono';

  @override
  String get cameraIntroBody =>
      'Para grabarte con el guion en pantalla, APrompter necesita tu cámara y micrófono. Tu teléfono te lo pedirá ahora. Los vídeos se quedan en tu teléfono.';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get notNow => 'Ahora no';

  @override
  String get colorWhite => 'Blanco';

  @override
  String get colorYellow => 'Amarillo';

  @override
  String get colorGreen => 'Verde';

  @override
  String get colorBlue => 'Azul';

  @override
  String get colorPink => 'Rosa';

  @override
  String get colorBlack => 'Negro';

  @override
  String get damagedData => 'Datos ilegibles';

  @override
  String damagedDataHint(String date, int size) {
    return 'Apartado el $date · $size caracteres';
  }

  @override
  String get tryToRecover => 'Intentar recuperar';

  @override
  String get nothingRecovered => 'No se pudo leer ningún guion.';

  @override
  String get floatLowRam =>
      'Este teléfono no puede mostrar apps sobre otras apps (poca memoria o Android Go). Usa Grabar en su lugar.';

  @override
  String get oemTipsTitle => 'Mantén activo el prompter flotante';

  @override
  String oemTipsBody(String brand) {
    return 'Los teléfonos $brand pueden cerrar ventanas flotantes para ahorrar batería. En Ajustes → Aplicaciones → APrompter: permite mostrar sobre otras apps (y ventanas emergentes), pon la batería en «Sin restricciones» y permite las notificaciones.';
  }

  @override
  String get focusLine => 'Resaltar la línea actual';

  @override
  String get focusLineHint => 'Atenúa las demás líneas';

  @override
  String get stepByLine => 'Línea a línea';

  @override
  String get stepByLineHint =>
      'Cada toque o pulsación del mando avanza una línea, sin desplazamiento automático';

  @override
  String get reduceEffects => 'Reducir efectos';

  @override
  String get reduceEffectsHint =>
      'Sin fundidos ni sombras: más fluido en teléfonos antiguos y ahorra batería';

  @override
  String get letterSpacing => 'Espaciado de letras';

  @override
  String get importTextFile => 'Importar archivo de texto';

  @override
  String get importTextFileHint =>
      'Un guion .txt o .md desde Archivos, Drive o el correo';

  @override
  String get importTextFailed =>
      'No se pudo leer el archivo. Elige un archivo de texto plano (.txt).';

  @override
  String get mySetup => 'Mi configuración';

  @override
  String get mySetupHint => 'La configuración que guardaste';

  @override
  String get saveMySetup => 'Guardar como mi configuración';

  @override
  String get resetAllSettings => 'Restablecer todos los ajustes';

  @override
  String get runHadJumps =>
      'Saltaste partes en esta pasada, así que no puede sugerir un ritmo.';

  @override
  String get keepTake => 'Conservar';

  @override
  String get retake => 'Repetir';

  @override
  String get reviewTakes => 'Revisar cada toma';

  @override
  String get reviewTakesHint => 'Mírala y luego consérvala o repítela';

  @override
  String get takesToGallery => 'Guardar tomas en la galería';

  @override
  String get takesToGalleryHint =>
      'Desactivado: las tomas se quedan en la app, fuera de Google Photos e iCloud';

  @override
  String get takesTitle => 'Tomas';

  @override
  String get takesEmpty =>
      'Aquí aparecen las tomas guardadas en la app. Desactiva «Guardar tomas en la galería» en los ajustes para guardarlas aquí.';

  @override
  String get saveToGallery => 'Guardar en la galería';

  @override
  String get savedToGallery => 'Guardado en tu galería';

  @override
  String get deleteTake => 'Eliminar toma';

  @override
  String takeKeptInApp(int n) {
    return 'Toma $n guardada en la app';
  }
}
