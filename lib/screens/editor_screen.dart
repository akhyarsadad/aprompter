import 'package:flutter/material.dart';

import '../models/script.dart';
import '../services/app_state.dart';

/// Create or edit a script. Changes are saved automatically on exit.
class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key, required this.script});

  final Script script;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late final _title = TextEditingController(text: widget.script.title);
  late final _body = TextEditingController(text: widget.script.body);

  Script get _current =>
      widget.script.copyWith(title: _title.text.trim(), body: _body.text);

  bool get _changed =>
      _title.text.trim() != widget.script.title ||
      _body.text != widget.script.body;

  Future<void> _save() async {
    final script = _current;
    if (script.title.isEmpty && script.body.trim().isEmpty) return;
    if (!_changed && AppScope.read(context).byId(script.id) != null) return;
    await AppScope.read(context).upsert(
      script.title.isEmpty ? script.copyWith(title: 'Untitled') : script,
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _save();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit script'),
          actions: [
            ListenableBuilder(
              listenable: _body,
              builder: (context, _) {
                final s = _current;
                final d = s.estimatedDuration;
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      '${s.wordCount} words · '
                      '~${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              TextField(
                controller: _title,
                textCapitalization: TextCapitalization.sentences,
                style: Theme.of(context).textTheme.titleLarge,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: TextField(
                  controller: _body,
                  autofocus: widget.script.body.isEmpty,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(fontSize: 18, height: 1.5),
                  decoration: const InputDecoration(
                    hintText: 'Write or paste your script here…',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
