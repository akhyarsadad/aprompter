// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'Fechar';

  @override
  String get settings => 'Configurações';

  @override
  String get prompterSettings => 'Configurações do prompter';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Excluir';

  @override
  String get undo => 'Desfazer';

  @override
  String get duplicate => 'Duplicar';

  @override
  String get share => 'Compartilhar';

  @override
  String get copyAsCaption => 'Copiar como legenda';

  @override
  String get captionCopied =>
      'Texto falado copiado — cole como legenda do post';

  @override
  String get copySuffix => '(cópia)';

  @override
  String deletedScript(String title) {
    return '\"$title\" excluído';
  }

  @override
  String duplicatedScript(String title) {
    return 'Duplicado como \"$title\"';
  }

  @override
  String get untitled => 'Sem título';

  @override
  String get newScript => 'Novo roteiro';

  @override
  String get searchScripts => 'Buscar roteiros';

  @override
  String get filterAll => 'Todos';

  @override
  String get statusDraft => 'Rascunho';

  @override
  String get statusReady => 'Pronto';

  @override
  String get statusRecorded => 'Gravado';

  @override
  String markAs(String status) {
    return 'Marcar como $status';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'Ensaiar';

  @override
  String get float => 'Flutuar';

  @override
  String get record => 'Gravar';

  @override
  String words(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count palavras',
      one: '1 palavra',
    );
    return '$_temp0';
  }

  @override
  String takes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count takes',
      one: '1 take',
    );
    return '$_temp0';
  }

  @override
  String get noScriptsYet => 'Nenhum roteiro ainda';

  @override
  String get noScriptsHint =>
      'Toque em \"Novo roteiro\" e escolha um modelo para começar.';

  @override
  String get nothingHere => 'Nada por aqui';

  @override
  String get nothingHereHint => 'Tente outro filtro ou busca.';

  @override
  String get startFromTemplate => 'Começar com um modelo';

  @override
  String get overlayPermissionNeeded =>
      'Permita \"Sobrepor a outros apps\" para usar o prompter flutuante.';

  @override
  String get floatingStarted =>
      'O prompter está flutuando. Abra seu app de câmera e toque no texto para começar.';

  @override
  String get floatingNotificationTitle => 'APrompter está flutuando';

  @override
  String get openScriptInApp => 'Abra um roteiro no APrompter';

  @override
  String get script => 'Roteiro';

  @override
  String get title => 'Título';

  @override
  String get status => 'Status';

  @override
  String get noTarget => 'Sem meta';

  @override
  String get editorHint =>
      'Escreva ou cole o que você quer dizer…\n\nDica: comece uma linha com # para uma seção, // para uma anotação só para você.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $spoken a $wpm ppm';
  }

  @override
  String get onTarget => 'Na meta';

  @override
  String overTarget(int seconds, int words) {
    return '$seconds s a mais · corte ~$words palavras';
  }

  @override
  String underTarget(int seconds, int words) {
    return 'Faltam $seconds s · ~$words palavras a mais';
  }

  @override
  String longSentences(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count frases longas (25+ palavras) — divida para conseguir respirar',
      one: '1 frase longa (25+ palavras) — divida para conseguir respirar',
    );
    return '$_temp0';
  }

  @override
  String get toolSection => 'Seção';

  @override
  String get toolEmphasis => 'Ênfase';

  @override
  String get toolPause => 'Pausa';

  @override
  String get toolNote => 'Nota';

  @override
  String get toolPaste => 'Colar';

  @override
  String get restart => 'Reiniciar';

  @override
  String get sections => 'Seções';

  @override
  String get slower => 'Mais devagar';

  @override
  String get faster => 'Mais rápido';

  @override
  String get play => 'Reproduzir';

  @override
  String get pause => 'Pausar';

  @override
  String get wpmUnit => 'ppm';

  @override
  String get startOfScript => 'Início do roteiro';

  @override
  String sectionN(int n) {
    return 'Seção $n';
  }

  @override
  String get noSectionsHint =>
      'Ainda não há seções. Adicione linhas começando com \"#\" no editor (ex.: \"# Gancho\") para pular entre partes e regravar só uma.';

  @override
  String get emptyScript => '(roteiro vazio)';

  @override
  String get preview => 'Prévia';

  @override
  String get setup => 'Configuração';

  @override
  String get pace => 'Ritmo';

  @override
  String get text => 'Texto';

  @override
  String get layout => 'Layout';

  @override
  String get recording => 'Gravação';

  @override
  String get wordsPerMinute => 'palavras / min';

  @override
  String fitTo(String time) {
    return 'Ajustar a $time';
  }

  @override
  String get paceCalm => 'Calmo';

  @override
  String get paceNatural => 'Natural';

  @override
  String get paceEnergetic => 'Energético';

  @override
  String get countdown => 'Contagem regressiva antes de começar';

  @override
  String get off => 'Desligado';

  @override
  String get size => 'Tamanho';

  @override
  String get lineSpacing => 'Espaçamento entre linhas';

  @override
  String get textColor => 'Cor do texto';

  @override
  String get prompterHeight => 'Altura do prompter';

  @override
  String get background => 'Fundo';

  @override
  String get readingGuide => 'Linha-guia de leitura';

  @override
  String get mirrorText => 'Espelhar texto';

  @override
  String get mirrorTextHint => 'Para vidro de teleprompter / beam splitter';

  @override
  String get videoQuality => 'Qualidade do vídeo';

  @override
  String get autoStop => 'Parar a gravação quando o roteiro acabar';

  @override
  String get autoStopHint => 'Espera 2 segundos após a última linha';

  @override
  String get presetHandheld => 'Selfie na mão';

  @override
  String get presetHandheldHint => 'Texto médio perto da lente';

  @override
  String get presetTripod => 'Tripé / à distância';

  @override
  String get presetTripodHint => 'Texto grande legível a 1–2 m';

  @override
  String get presetGlass => 'Vidro de teleprompter';

  @override
  String get presetGlassHint => 'Espelhado, tela cheia, fundo sólido';

  @override
  String get niceRun => 'Mandou bem!';

  @override
  String runSummary(String time, int words, int wpm) {
    return 'Você levou $time para $words palavras → $wpm palavras por minuto.';
  }

  @override
  String runOver(int seconds, String target) {
    return 'Foram $seconds s acima da meta de $target — enxugue o roteiro ou acelere.';
  }

  @override
  String runUnder(int seconds) {
    return 'Você ainda tem $seconds s antes da meta.';
  }

  @override
  String get runOnTarget => 'Exatamente na duração da meta. 🎯';

  @override
  String get keepCurrent => 'Manter';

  @override
  String useWpm(int wpm) {
    return 'Usar $wpm ppm';
  }

  @override
  String get switchCamera => 'Trocar câmera';

  @override
  String get startRecording => 'Começar a gravar';

  @override
  String get stopRecording => 'Parar gravação';

  @override
  String get noCamera => 'Nenhuma câmera encontrada neste aparelho.';

  @override
  String get cameraDenied =>
      'O acesso à câmera foi negado. Ative nas configurações do sistema.';

  @override
  String cameraError(String message) {
    return 'Erro da câmera: $message';
  }

  @override
  String takeSaved(int n) {
    return 'Take $n salvo na galeria';
  }

  @override
  String get templateBlank => 'Em branco';

  @override
  String get templateBlankHint => 'Comece com uma página vazia';

  @override
  String get templateHvc => 'Gancho → Valor → CTA';

  @override
  String get templateHvcHint => 'A estrutura clássica de vídeo curto';

  @override
  String get templateTutorial => 'Tutorial';

  @override
  String get templateTutorialHint => 'Ensine algo passo a passo';

  @override
  String get templateReview => 'Review de produto';

  @override
  String get templateReviewHint => 'UGC, publis e reviews sinceros';

  @override
  String get templateStory => 'Storytime';

  @override
  String get templateStoryHint => 'História pessoal com uma lição';

  @override
  String get secHook => 'Gancho';

  @override
  String get secValue => 'Valor';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'Passo $n';
  }

  @override
  String get secRecap => 'Resumo e CTA';

  @override
  String get secWhatItIs => 'O que é';

  @override
  String get secLoved => 'O que eu amei';

  @override
  String get secBetter => 'O que poderia melhorar';

  @override
  String get secVerdict => 'Veredito e CTA';

  @override
  String get secSetup => 'Contexto';

  @override
  String get secTurningPoint => 'Virada';

  @override
  String get secLesson => 'Lição';

  @override
  String get noteHook =>
      'Prenda a atenção nos primeiros 3 segundos: uma afirmação ousada ou uma pergunta';

  @override
  String get noteValue => 'Entregue a única coisa que você prometeu';

  @override
  String get noteCta =>
      'Diga o que fazer em seguida: seguir, comentar, link na bio';

  @override
  String get noteTutorialHook => '\"Veja como … em menos de um minuto\"';

  @override
  String get noteRecap => 'Resuma em uma frase e peça para salvarem o vídeo';

  @override
  String get noteReviewHook => 'Mostre o produto e o problema que ele resolve';

  @override
  String get noteVerdict => 'Para quem vale a pena — cite o cupom ou o link';

  @override
  String get noteStoryHook => 'Comece no meio da ação';

  @override
  String get welcomeTitle => 'Boas-vindas ao APrompter';

  @override
  String get welcomeBody =>
      '# Gancho\nQuer gravar sem esquecer o texto? [pause]\n// olhe direto para a lente\n\n# Como funciona\nEscreva seu roteiro, escolha uma *duração meta* e veja o cronômetro dizer se cabe.\nEnsaie para descobrir seu ritmo em palavras por minuto.\nDepois toque em Gravar. O texto rola logo abaixo da câmera, então você mantém o *contato visual* com o público.\n\n# CTA\nToque neste cartão para editar o roteiro ou crie o seu com o botão de mais. [pause] Divirta-se criando!\n';

  @override
  String get expand => 'Expandir';

  @override
  String get minimize => 'Minimizar';

  @override
  String get nothingToSay =>
      'Adicione algo para falar primeiro — seções (#) e notas (//) não são lidas.';

  @override
  String get openSettings => 'Abrir configurações';

  @override
  String get tryAgain => 'Tentar de novo';

  @override
  String get noMicBanner => 'Sem acesso ao microfone — gravando sem som';

  @override
  String get saveFailedTitle => 'Não foi possível salvar na galeria';

  @override
  String saveFailedBody(String reason) {
    return 'Seu take está seguro por enquanto. Tente de novo ou compartilhe para Arquivos, Drive ou um chat para não perdê-lo. ($reason)';
  }

  @override
  String get shareVideo => 'Compartilhar vídeo';

  @override
  String get discardTake => 'Descartar este take';

  @override
  String takeShared(int n) {
    return 'Take $n compartilhado';
  }

  @override
  String get movePrompter => 'Arraste para mover o prompter';

  @override
  String get resizePrompter => 'Arraste para redimensionar o prompter';

  @override
  String get prompterWidth => 'Largura do prompter';

  @override
  String get resetPosition => 'Redefinir posição (topo, largura total)';

  @override
  String get positionHint =>
      'Arraste a barra no topo do prompter para movê-lo para qualquer lugar e o canto para redimensionar. No Android, a janela flutuante pode ser arrastada para qualquer lugar e lembra a posição.';

  @override
  String get app => 'App';

  @override
  String get appLanguage => 'Idioma do app';

  @override
  String get systemDefault => 'Idioma do celular';

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
      'Não foi possível salvar — o celular pode estar sem espaço. Seu trabalho fica guardado enquanto o app estiver aberto.';

  @override
  String get versionHistory => 'Histórico de versões';

  @override
  String get noVersions =>
      'Ainda não há versões anteriores. Elas são guardadas automaticamente enquanto você escreve.';

  @override
  String get restore => 'Restaurar';

  @override
  String get versionRestored => 'Versão anterior restaurada';

  @override
  String get recentlyDeleted => 'Excluídos recentemente';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Roteiros excluídos ficam aqui por $days dias.',
      one: 'Roteiros excluídos ficam aqui por 1 dia.',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => 'Excluir para sempre';

  @override
  String deletedOn(String date) {
    return 'Excluído em $date';
  }

  @override
  String restoredScript(String title) {
    return '\"$title\" restaurado';
  }

  @override
  String get backUpScripts => 'Fazer backup de todos os roteiros';

  @override
  String get restoreBackup => 'Restaurar de um backup';

  @override
  String get backupShareTitle => 'Backup do APrompter';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count roteiros restaurados',
      one: '1 roteiro restaurado',
      zero: 'Tudo deste backup já está aqui',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'Esse arquivo não é um backup do APrompter.';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return 'Mesmo a $wpm ppm não cabe em $target — corte cerca de $words palavras.';
  }

  @override
  String get cameraNotReady =>
      'A câmera não estava pronta, então a gravação não começou. Tente de novo.';

  @override
  String get previousSection => 'Seção anterior';

  @override
  String get nextSection => 'Próxima seção';

  @override
  String get floatingNotificationBody => 'Toque para abrir o APrompter';

  @override
  String get customTarget => 'Personalizado…';

  @override
  String get customTargetTitle => 'Duração alvo';

  @override
  String get customTargetHint => 'Minutos e segundos, ex.: 5:00';

  @override
  String get saved => 'Salvo';

  @override
  String get floatNotOnIos =>
      'O iPhone não deixa apps flutuarem sobre outros apps. Use Gravar para filmar com o roteiro sob a câmera.';

  @override
  String get hashtagHint =>
      'Linhas de hashtag (#fyp #ad) aparecem esmaecidas e não contam no tempo. Use \"# \" com espaço para uma seção.';

  @override
  String get appLock => 'Bloqueio do app';

  @override
  String get appLockHint =>
      'Pedir digital, rosto ou PIN do celular para abrir o APrompter';

  @override
  String get appLockUnavailable =>
      'Configure primeiro um bloqueio de tela neste celular.';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get unlockReason => 'Desbloqueie o APrompter para ver seus roteiros';

  @override
  String get autoStopWait => 'Espera após a última linha';

  @override
  String get beforeYouRecord => 'Antes de gravar';

  @override
  String get recordAnyway => 'Gravar mesmo assim';

  @override
  String lowStorageWarning(int minutes) {
    return 'Seu espaço livre comporta só uns $minutes min de vídeo. Libere espaço ou reduza a qualidade do vídeo.';
  }

  @override
  String lowBatteryWarning(int level) {
    return 'Bateria em $level% — um take longo pode ser interrompido. Conecte o carregador se puder.';
  }

  @override
  String get brightScreen => 'Brilho máximo durante o prompter';

  @override
  String get brightScreenHint => 'Mais fácil de ler ao ar livre';

  @override
  String get cameraBusy =>
      'Outro app está usando a câmera. Feche-o e tente de novo.';

  @override
  String get cameraIntroTitle => 'Câmera e microfone';

  @override
  String get cameraIntroBody =>
      'Para filmar você com o roteiro na tela, o APrompter precisa da câmera e do microfone. Seu celular vai pedir em seguida. Os vídeos ficam no seu celular.';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get notNow => 'Agora não';

  @override
  String get colorWhite => 'Branco';

  @override
  String get colorYellow => 'Amarelo';

  @override
  String get colorGreen => 'Verde';

  @override
  String get colorBlue => 'Azul';

  @override
  String get colorPink => 'Rosa';

  @override
  String get colorBlack => 'Preto';

  @override
  String get damagedData => 'Dados ilegíveis';

  @override
  String damagedDataHint(String date, int size) {
    return 'Separado em $date · $size caracteres';
  }

  @override
  String get tryToRecover => 'Tentar recuperar';

  @override
  String get nothingRecovered => 'Nenhum roteiro pôde ser lido.';

  @override
  String get floatLowRam =>
      'Este celular não consegue mostrar apps sobre outros apps (pouca memória ou Android Go). Use Gravar.';

  @override
  String get oemTipsTitle => 'Mantenha o prompter flutuante ativo';

  @override
  String oemTipsBody(String brand) {
    return 'Celulares $brand podem fechar janelas flutuantes para economizar bateria. Em Configurações → Apps → APrompter: permita sobrepor a outros apps (e janelas pop-up), defina a bateria como \"Sem restrições\" e permita notificações.';
  }

  @override
  String get focusLine => 'Destacar a linha atual';

  @override
  String get focusLineHint => 'Escurece as outras linhas';

  @override
  String get stepByLine => 'Linha por linha';

  @override
  String get stepByLineHint =>
      'Cada toque ou clique do controle avança uma linha — sem rolagem automática';

  @override
  String get reduceEffects => 'Reduzir efeitos';

  @override
  String get reduceEffectsHint =>
      'Sem transições ou sombras: mais fluido em celulares antigos, economiza bateria';

  @override
  String get letterSpacing => 'Espaçamento entre letras';

  @override
  String get importTextFile => 'Importar arquivo de texto';

  @override
  String get importTextFileHint =>
      'Um roteiro .txt ou .md de Arquivos, Drive ou e-mail';

  @override
  String get importTextFailed =>
      'Não foi possível ler o arquivo. Escolha um arquivo de texto simples (.txt).';

  @override
  String get mySetup => 'Minha configuração';

  @override
  String get mySetupHint => 'A configuração que você salvou';

  @override
  String get saveMySetup => 'Salvar como minha configuração';

  @override
  String get resetAllSettings => 'Redefinir todas as configurações';

  @override
  String get runHadJumps =>
      'Você pulou trechos nesta passada, então não dá para sugerir um ritmo.';

  @override
  String get keepTake => 'Manter';

  @override
  String get retake => 'Regravar';

  @override
  String get reviewTakes => 'Revisar cada take';

  @override
  String get reviewTakesHint => 'Assista e depois mantenha ou grave de novo';

  @override
  String get takesToGallery => 'Salvar takes na galeria';

  @override
  String get takesToGalleryHint =>
      'Desativado: os takes ficam no app, fora do Google Photos e do iCloud';

  @override
  String get takesTitle => 'Takes';

  @override
  String get takesEmpty =>
      'Takes mantidos no app aparecem aqui. Desative \"Salvar takes na galeria\" nas configurações para mantê-los aqui.';

  @override
  String get saveToGallery => 'Salvar na galeria';

  @override
  String get savedToGallery => 'Salvo na sua galeria';

  @override
  String get deleteTake => 'Excluir take';

  @override
  String takeKeptInApp(int n) {
    return 'Take $n mantido no app';
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
