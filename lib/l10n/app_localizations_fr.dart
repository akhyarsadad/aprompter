// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'Fermer';

  @override
  String get settings => 'Réglages';

  @override
  String get prompterSettings => 'Réglages du prompteur';

  @override
  String get edit => 'Modifier';

  @override
  String get delete => 'Supprimer';

  @override
  String get undo => 'Annuler';

  @override
  String get duplicate => 'Dupliquer';

  @override
  String get share => 'Partager';

  @override
  String get copyAsCaption => 'Copier comme légende';

  @override
  String get captionCopied => 'Texte parlé copié — collez-le comme légende';

  @override
  String get copySuffix => '(copie)';

  @override
  String deletedScript(String title) {
    return '« $title » supprimé';
  }

  @override
  String duplicatedScript(String title) {
    return 'Dupliqué sous « $title »';
  }

  @override
  String get untitled => 'Sans titre';

  @override
  String get newScript => 'Nouveau script';

  @override
  String get searchScripts => 'Rechercher des scripts';

  @override
  String get filterAll => 'Tous';

  @override
  String get statusDraft => 'Brouillon';

  @override
  String get statusReady => 'Prêt';

  @override
  String get statusRecorded => 'Enregistré';

  @override
  String markAs(String status) {
    return 'Marquer comme $status';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'Répéter';

  @override
  String get float => 'Flottant';

  @override
  String get record => 'Filmer';

  @override
  String words(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mots',
      one: '1 mot',
    );
    return '$_temp0';
  }

  @override
  String takes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prises',
      one: '1 prise',
    );
    return '$_temp0';
  }

  @override
  String get noScriptsYet => 'Aucun script pour l\'instant';

  @override
  String get noScriptsHint =>
      'Touchez « Nouveau script » et choisissez un modèle pour commencer.';

  @override
  String get nothingHere => 'Rien ici';

  @override
  String get nothingHereHint =>
      'Essayez un autre filtre ou une autre recherche.';

  @override
  String get startFromTemplate => 'Partir d\'un modèle';

  @override
  String get overlayPermissionNeeded =>
      'Autorisez « Afficher par-dessus les autres applis » pour utiliser le prompteur flottant.';

  @override
  String get floatingStarted =>
      'Le prompteur flotte. Ouvrez votre appli photo et touchez le texte pour démarrer.';

  @override
  String get floatingNotificationTitle => 'APrompter flotte à l\'écran';

  @override
  String get openScriptInApp => 'Ouvrez un script dans APrompter';

  @override
  String get script => 'Script';

  @override
  String get title => 'Titre';

  @override
  String get status => 'Statut';

  @override
  String get noTarget => 'Sans objectif';

  @override
  String get editorHint =>
      'Écrivez ou collez ce que vous voulez dire…\n\nAstuce : commencez une ligne par # pour une section, // pour une note pour vous.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $spoken à $wpm mpm';
  }

  @override
  String get onTarget => 'Dans l\'objectif';

  @override
  String overTarget(int seconds, int words) {
    return '$seconds s de trop · coupez ~$words mots';
  }

  @override
  String underTarget(int seconds, int words) {
    return 'Il reste $seconds s · ~$words mots de plus';
  }

  @override
  String longSentences(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count phrases longues (25+ mots) — coupez-les pour pouvoir respirer',
      one: '1 phrase longue (25+ mots) — coupez-la pour pouvoir respirer',
    );
    return '$_temp0';
  }

  @override
  String get toolSection => 'Section';

  @override
  String get toolEmphasis => 'Accent';

  @override
  String get toolPause => 'Pause';

  @override
  String get toolNote => 'Note';

  @override
  String get toolPaste => 'Coller';

  @override
  String get restart => 'Recommencer';

  @override
  String get sections => 'Sections';

  @override
  String get slower => 'Plus lent';

  @override
  String get faster => 'Plus vite';

  @override
  String get play => 'Lecture';

  @override
  String get pause => 'Pause';

  @override
  String get wpmUnit => 'mpm';

  @override
  String get startOfScript => 'Début du script';

  @override
  String sectionN(int n) {
    return 'Section $n';
  }

  @override
  String get noSectionsHint =>
      'Pas encore de sections. Ajoutez des lignes commençant par « # » dans l\'éditeur (ex. « # Accroche ») pour sauter d\'une partie à l\'autre et n\'en refaire qu\'une.';

  @override
  String get emptyScript => '(script vide)';

  @override
  String get preview => 'Aperçu';

  @override
  String get setup => 'Configuration';

  @override
  String get pace => 'Rythme';

  @override
  String get text => 'Texte';

  @override
  String get layout => 'Disposition';

  @override
  String get recording => 'Enregistrement';

  @override
  String get wordsPerMinute => 'mots / min';

  @override
  String fitTo(String time) {
    return 'Caler sur $time';
  }

  @override
  String get paceCalm => 'Calme';

  @override
  String get paceNatural => 'Naturel';

  @override
  String get paceEnergetic => 'Énergique';

  @override
  String get countdown => 'Compte à rebours avant de commencer';

  @override
  String get off => 'Désactivé';

  @override
  String get size => 'Taille';

  @override
  String get lineSpacing => 'Interligne';

  @override
  String get textColor => 'Couleur du texte';

  @override
  String get prompterHeight => 'Hauteur du prompteur';

  @override
  String get background => 'Fond';

  @override
  String get readingGuide => 'Ligne de lecture';

  @override
  String get mirrorText => 'Texte en miroir';

  @override
  String get mirrorTextHint => 'Pour vitre de téléprompteur / beam splitter';

  @override
  String get videoQuality => 'Qualité vidéo';

  @override
  String get autoStop => 'Arrêter l\'enregistrement à la fin du script';

  @override
  String get autoStopHint => 'Attend 2 secondes après la dernière ligne';

  @override
  String get presetHandheld => 'Selfie à la main';

  @override
  String get presetHandheldHint => 'Texte moyen près de l\'objectif';

  @override
  String get presetTripod => 'Trépied / à distance';

  @override
  String get presetTripodHint => 'Grand texte lisible à 1–2 m';

  @override
  String get presetGlass => 'Vitre de téléprompteur';

  @override
  String get presetGlassHint => 'En miroir, plein écran, fond opaque';

  @override
  String get niceRun => 'Bravo !';

  @override
  String runSummary(String time, int words, int wpm) {
    return 'Vous avez mis $time pour $words mots → $wpm mots par minute.';
  }

  @override
  String runOver(int seconds, String target) {
    return 'C\'est $seconds s de plus que votre objectif de $target — raccourcissez le script ou accélérez.';
  }

  @override
  String runUnder(int seconds) {
    return 'Il vous reste $seconds s avant votre objectif.';
  }

  @override
  String get runOnTarget => 'Pile dans la durée visée. 🎯';

  @override
  String get keepCurrent => 'Garder';

  @override
  String useWpm(int wpm) {
    return 'Utiliser $wpm mpm';
  }

  @override
  String get switchCamera => 'Changer de caméra';

  @override
  String get startRecording => 'Démarrer l\'enregistrement';

  @override
  String get stopRecording => 'Arrêter l\'enregistrement';

  @override
  String get noCamera => 'Aucune caméra trouvée sur cet appareil.';

  @override
  String get cameraDenied =>
      'L\'accès à la caméra a été refusé. Activez-le dans les réglages du système.';

  @override
  String cameraError(String message) {
    return 'Erreur de caméra : $message';
  }

  @override
  String takeSaved(int n) {
    return 'Prise $n enregistrée dans la galerie';
  }

  @override
  String get templateBlank => 'Vierge';

  @override
  String get templateBlankHint => 'Partir d\'une page blanche';

  @override
  String get templateHvc => 'Accroche → Valeur → CTA';

  @override
  String get templateHvcHint => 'La structure classique des vidéos courtes';

  @override
  String get templateTutorial => 'Tutoriel';

  @override
  String get templateTutorialHint => 'Expliquer quelque chose étape par étape';

  @override
  String get templateReview => 'Test produit';

  @override
  String get templateReviewHint => 'UGC, placements et avis honnêtes';

  @override
  String get templateStory => 'Storytime';

  @override
  String get templateStoryHint => 'Histoire personnelle avec une leçon';

  @override
  String get secHook => 'Accroche';

  @override
  String get secValue => 'Valeur';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'Étape $n';
  }

  @override
  String get secRecap => 'Récap et CTA';

  @override
  String get secWhatItIs => 'Ce que c\'est';

  @override
  String get secLoved => 'Ce que j\'ai adoré';

  @override
  String get secBetter => 'Ce qui pourrait être mieux';

  @override
  String get secVerdict => 'Verdict et CTA';

  @override
  String get secSetup => 'Mise en place';

  @override
  String get secTurningPoint => 'Tournant';

  @override
  String get secLesson => 'Leçon';

  @override
  String get noteHook =>
      'Captez l\'attention dans les 3 premières secondes : une affirmation forte ou une question';

  @override
  String get noteValue => 'Donnez la chose promise, et une seule';

  @override
  String get noteCta =>
      'Dites quoi faire ensuite : s\'abonner, commenter, lien en bio';

  @override
  String get noteTutorialHook => '« Voici comment … en moins d\'une minute »';

  @override
  String get noteRecap =>
      'Résumez en une phrase, puis demandez d\'enregistrer la vidéo';

  @override
  String get noteReviewHook =>
      'Montrez le produit et le problème qu\'il résout';

  @override
  String get noteVerdict =>
      'À qui il s\'adresse — mentionnez le code ou le lien';

  @override
  String get noteStoryHook => 'Commencez en pleine action';

  @override
  String get welcomeTitle => 'Bienvenue dans APrompter';

  @override
  String get welcomeBody =>
      '# Accroche\nEnvie de filmer sans oublier votre texte ? [pause]\n// regardez droit dans l\'objectif\n\n# Comment ça marche\nÉcrivez votre script, choisissez une *durée cible* et le minuteur vous dit si ça tient.\nRépétez pour trouver votre rythme en mots par minute.\nPuis touchez Filmer. Le texte défile juste sous la caméra, pour garder le *contact visuel* avec votre public.\n\n# CTA\nTouchez cette carte pour modifier le script, ou créez le vôtre avec le bouton plus. [pause] Amusez-vous bien !\n';

  @override
  String get expand => 'Agrandir';

  @override
  String get minimize => 'Réduire';

  @override
  String get nothingToSay =>
      'Ajoutez d\'abord des phrases à dire — les sections (#) et notes (//) ne sont pas lues.';

  @override
  String get openSettings => 'Ouvrir les réglages';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get noMicBanner => 'Pas d\'accès au micro — enregistrement sans son';

  @override
  String get saveFailedTitle => 'Impossible d\'enregistrer dans la galerie';

  @override
  String saveFailedBody(String reason) {
    return 'Votre prise est en sécurité pour l\'instant. Réessayez, ou partagez-la vers Fichiers, Drive ou une discussion pour ne pas la perdre. ($reason)';
  }

  @override
  String get shareVideo => 'Partager la vidéo';

  @override
  String get discardTake => 'Supprimer cette prise';

  @override
  String takeShared(int n) {
    return 'Prise $n partagée';
  }

  @override
  String get movePrompter => 'Faites glisser pour déplacer le prompteur';

  @override
  String get resizePrompter =>
      'Faites glisser pour redimensionner le prompteur';

  @override
  String get prompterWidth => 'Largeur du prompteur';

  @override
  String get resetPosition =>
      'Réinitialiser la position (en haut, pleine largeur)';

  @override
  String get positionHint =>
      'Faites glisser la barre en haut du prompteur pour le placer n\'importe où, et le coin pour le redimensionner. Sur Android, la fenêtre flottante se déplace partout et retient sa place.';

  @override
  String get app => 'Appli';

  @override
  String get appLanguage => 'Langue de l\'appli';

  @override
  String get systemDefault => 'Langue du téléphone';

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
      'Échec de l\'enregistrement — votre téléphone manque peut-être d\'espace. Votre travail est conservé tant que l\'app reste ouverte.';

  @override
  String get versionHistory => 'Historique des versions';

  @override
  String get noVersions =>
      'Aucune version antérieure pour l\'instant. Elles sont conservées automatiquement pendant que vous écrivez.';

  @override
  String get restore => 'Restaurer';

  @override
  String get versionRestored => 'Version antérieure restaurée';

  @override
  String get recentlyDeleted => 'Supprimés récemment';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Les scripts supprimés restent ici $days jours.',
      one: 'Les scripts supprimés restent ici 1 jour.',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => 'Supprimer définitivement';

  @override
  String deletedOn(String date) {
    return 'Supprimé le $date';
  }

  @override
  String restoredScript(String title) {
    return '« $title » restauré';
  }

  @override
  String get backUpScripts => 'Sauvegarder tous les scripts';

  @override
  String get restoreBackup => 'Restaurer une sauvegarde';

  @override
  String get backupShareTitle => 'Sauvegarde APrompter';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count scripts restaurés',
      one: '1 script restauré',
      zero: 'Tout le contenu de cette sauvegarde est déjà là',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'Ce fichier n\'est pas une sauvegarde APrompter.';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return 'Même à $wpm mpm, ça ne tiendra pas en $target — coupez environ $words mots.';
  }

  @override
  String get cameraNotReady =>
      'La caméra n\'était pas prête, l\'enregistrement n\'a pas démarré. Réessayez.';

  @override
  String get previousSection => 'Section précédente';

  @override
  String get nextSection => 'Section suivante';

  @override
  String get floatingNotificationBody => 'Touchez pour ouvrir APrompter';

  @override
  String get customTarget => 'Personnalisé…';

  @override
  String get customTargetTitle => 'Durée cible';

  @override
  String get customTargetHint => 'Minutes et secondes, ex. 5:00';

  @override
  String get saved => 'Enregistré';

  @override
  String get floatNotOnIos =>
      'L\'iPhone ne permet pas aux apps de flotter sur d\'autres apps. Utilisez Filmer pour tourner avec le script sous la caméra.';

  @override
  String get hashtagHint =>
      'Les lignes de hashtags (#fyp #ad) sont atténuées et non chronométrées. Pour une section, utilisez # suivi d\'une espace.';
}
