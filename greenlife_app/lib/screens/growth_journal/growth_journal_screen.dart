import 'package:flutter/material.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/growth_note.dart';
import 'package:greenlife_app/widgets/detail_sheet.dart';
import 'package:greenlife_app/widgets/growth_note_card.dart';

class GrowthJournalScreen extends StatefulWidget {
  final List<GrowthNote> notes;
  final void Function(GrowthNote note) onAddNote;

  const GrowthJournalScreen({
    super.key,
    required this.notes,
    required this.onAddNote,
  });

  @override
  State<GrowthJournalScreen> createState() => _GrowthJournalScreenState();
}

class _GrowthJournalScreenState extends State<GrowthJournalScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedNoteId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<GrowthNote> get _filteredNotes {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return widget.notes;
    }
    return widget.notes.where((note) {
      return note.title.toLowerCase().contains(query) ||
          note.plantName.toLowerCase().contains(query) ||
          note.summary.toLowerCase().contains(query);
    }).toList();
  }

  void _showAddNoteDialog(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final titleController = TextEditingController();
    final plantController = TextEditingController(text: strings.notePlantDefault);
    final summaryController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(strings.newNoteTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: strings.title),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: plantController,
                  decoration: InputDecoration(labelText: strings.plantName),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: summaryController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(labelText: strings.descriptionGrowth),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(strings.cancel),
            ),
            FilledButton(
              onPressed: () {
                final title = titleController.text.trim();
                final summary = summaryController.text.trim();
                if (title.isEmpty || summary.isEmpty) return;

                widget.onAddNote(
                  GrowthNote(
                    id: 'note-${DateTime.now().millisecondsSinceEpoch}',
                    plantName: plantController.text.trim().isEmpty
                        ? strings.myPlantDefault
                        : plantController.text.trim(),
                    title: title,
                    date: '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    summary: summary,
                  ),
                );
                Navigator.pop(dialogContext);
              },
              child: Text(strings.save),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final filteredNotes = _filteredNotes;

    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.growthJournalTitle,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: strings.searchNotesHint,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: filteredNotes.isEmpty
                      ? Center(
                          child: Text(strings.noNotesMatch),
                        )
                      : ListView.separated(
                          itemCount: filteredNotes.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final note = filteredNotes[index];
                            return GrowthNoteCard(
                              note: note,
                              isSelected: _selectedNoteId == note.id,
                              onTap: () {
                                setState(() => _selectedNoteId = note.id);
                                showGrowthNoteDetailSheet(context, note);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 22,
            bottom: 24,
            child: FloatingActionButton(
              onPressed: () => _showAddNoteDialog(context),
              backgroundColor: const Color(0xFF2F6A4F),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
