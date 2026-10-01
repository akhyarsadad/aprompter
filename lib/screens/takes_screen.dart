import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../l10n/l10n.dart';
import '../models/script.dart';
import '../services/app_state.dart';
import '../services/storage.dart';

/// What the creator decided after watching a take.
enum TakeDecision { keep, retake }

/// C3: watch a take right after recording, then keep it or retake.
class TakeReviewScreen extends StatelessWidget {
  const TakeReviewScreen({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: TakePlayer(path: path)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () =>
                          Navigator.pop(context, TakeDecision.retake),
                      icon: const Icon(Icons.replay),
                      label: Text(l.retake),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () =>
                          Navigator.pop(context, TakeDecision.keep),
                      icon: const Icon(Icons.check),
                      label: Text(l.keepTake),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Plays a video file; tap to pause or play.
class TakePlayer extends StatefulWidget {
  const TakePlayer({super.key, required this.path});

  final String path;

  @override
  State<TakePlayer> createState() => _TakePlayerState();
}

class _TakePlayerState extends State<TakePlayer> {
  late final _video = VideoPlayerController.file(File(widget.path));
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _video
        .initialize()
        .then((_) {
          if (!mounted) return;
          setState(() {});
          _video
            ..setLooping(true)
            ..play();
        })
        .catchError((Object _) {
          if (mounted) setState(() => _failed = true);
        });
  }

  @override
  void dispose() {
    _video.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return const Center(
        child: Icon(Icons.videocam_off, color: Colors.white54, size: 48),
      );
    }
    if (!_video.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return GestureDetector(
      onTap: () => setState(
        () => _video.value.isPlaying ? _video.pause() : _video.play(),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _video.value.aspectRatio,
            child: VideoPlayer(_video),
          ),
          if (!_video.value.isPlaying)
            const Icon(Icons.play_circle, color: Colors.white70, size: 64),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: VideoProgressIndicator(_video, allowScrubbing: true),
          ),
        ],
      ),
    );
  }
}

/// C4 / Y3: takes of one script kept inside the app.
class TakesScreen extends StatelessWidget {
  const TakesScreen({super.key, required this.script});

  final Script script;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = AppScope.of(context);
    final takes = state.takesOf(script.id);
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${l.takesTitle} · ${script.title.isEmpty ? l.untitled : script.title}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: takes.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(l.takesEmpty, textAlign: TextAlign.center),
              ),
            )
          : ListView(
              children: [
                for (final (i, t) in takes.indexed)
                  ListTile(
                    leading: CircleAvatar(child: Text('${takes.length - i}')),
                    title: Text(
                      DateFormat.yMMMd(locale).add_jm().format(t.recordedAt),
                    ),
                    subtitle: Text(
                      formatDuration(Duration(seconds: t.seconds)),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => _SavedTakeScreen(take: t),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _SavedTakeScreen extends StatelessWidget {
  const _SavedTakeScreen({required this.take});

  final Take take;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = AppScope.read(context);
    final messenger = ScaffoldMessenger.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: l.share,
            icon: const Icon(Icons.ios_share),
            onPressed: () {
              final box = context.findRenderObject() as RenderBox?;
              SharePlus.instance.share(
                ShareParams(
                  files: [XFile(take.path)],
                  sharePositionOrigin: box == null
                      ? null
                      : box.localToGlobal(Offset.zero) & box.size,
                ),
              );
            },
          ),
          IconButton(
            tooltip: l.saveToGallery,
            icon: const Icon(Icons.photo_library_outlined),
            onPressed: () async {
              try {
                if (!await Gal.hasAccess(toAlbum: true)) {
                  await Gal.requestAccess(toAlbum: true);
                }
                await Gal.putVideo(take.path, album: 'APrompter');
                messenger.showSnackBar(
                  SnackBar(content: Text(l.savedToGallery)),
                );
              } on GalException catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text(l.saveFailedBody(e.type.message))),
                );
              }
            },
          ),
          IconButton(
            tooltip: l.deleteTake,
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              await state.removeTake(take);
              try {
                await File(take.path).delete();
              } catch (_) {
                // Already gone.
              }
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: TakePlayer(path: take.path),
    );
  }
}
