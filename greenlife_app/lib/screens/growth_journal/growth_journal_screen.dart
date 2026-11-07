import 'package:flutter/material.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/growth_note.dart';
import 'package:greenlife_app/screens/growth_journal/add_note_screen.dart';
import 'package:greenlife_app/screens/growth_journal/note_detail_screen.dart';
import 'package:greenlife_app/widgets/growth_note_card.dart';

class GrowthJournalScreen extends StatefulWidget {
  final List<GrowthNote> notes;
  final void Function(GrowthNote note) onAddNote;
  final void Function(String id)? onDeleteNote;
  final List<String>? plantNames;

  const GrowthJournalScreen({
    super.key,
    required this.notes,
    required this.onAddNote,
    this.onDeleteNote,
    this.plantNames,
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

  Future<void> _openAddNote() async {
    final newNote = await Navigator.push<GrowthNote>(
      context,
      MaterialPageRoute(
        builder: (_) => AddNoteScreen(plantNames: widget.plantNames),
      ),
    );
    if (newNote == null || !mounted) return;

    widget.onAddNote(newNote);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).noteAdded)),
    );
  }

  void _openNoteDetail(GrowthNote note) {
    final strings = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _selectedNoteId = note.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteDetailScreen(
          note: note,
          onDelete: widget.onDeleteNote == null
              ? null
              : () {
                  widget.onDeleteNote!(note.id);
                  if (mounted) setState(() => _selectedNoteId = null);
                  messenger.showSnackBar(
                    SnackBar(content: Text(strings.noteDeleted)),
                  );
                },
        ),
      ),
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
                              onTap: () => _openNoteDetail(note),
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
              onPressed: _openAddNote,
              backgroundColor: const Color(0xFF2F6A4F),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}