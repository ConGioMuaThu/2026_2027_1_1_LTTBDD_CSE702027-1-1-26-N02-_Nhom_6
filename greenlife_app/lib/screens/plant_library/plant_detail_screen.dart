import 'package:flutter/material.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/models/plant.dart';
import 'package:greenlife_app/screens/care/add_task_screen.dart';

const Color _primary = Color(0xFF2F6A4F);
const Color _soft = Color(0xFFE2F4E4);
const Color _background = Color(0xFFF5F8F2);
const Color _textColor = Color(0xFF1D2A1F);
const Color _muted = Color(0xFF5F6F62);
const Color _danger = Color(0xFFE46D5F);

class PlantDetailScreen extends StatefulWidget {
  const PlantDetailScreen({
    super.key,
    required this.plant,
    this.onToggleFavorite,
    this.onAddTask,
    this.plantNames,
  });

  final Plant plant;
  final VoidCallback? onToggleFavorite;
  final void Function(CareTask task)? onAddTask;
  final List<String>? plantNames;

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  late bool _isFavorite = widget.plant.isFavorite;

  bool get _isEnglish => Localizations.localeOf(context).languageCode == 'en';

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    widget.onToggleFavorite?.call();
  }

  Future<void> _openAddTask() async {
    final task = await Navigator.push<CareTask>(
      context,
      MaterialPageRoute(
        builder: (_) => AddTaskScreen(
          plantNames: widget.plantNames,
          initialPlantName: widget.plant.name,
        ),
      ),
    );

    if (task == null || !mounted) return;

    widget.onAddTask?.call(task);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEnglish ? 'Care task added' : 'Đã thêm nhiệm vụ chăm sóc',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final isEnglish = _isEnglish;
    final plant = widget.plant;

    return Scaffold(
      backgroundColor: _background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            backgroundColor: _soft,
            automaticallyImplyLeading: false,
            leading: _CircleButton(
              icon: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (widget.onToggleFavorite != null)
                _CircleButton(
                  icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                  iconColor: _isFavorite ? _danger : _textColor,
                  onPressed: _toggleFavorite,
                ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _PlantImage(plant: plant),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plant.scientificName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: _muted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Chip(
                    avatar: const Icon(
                      Icons.category_outlined,
                      size: 18,
                      color: _primary,
                    ),
                    label: Text(plant.category),
                    labelStyle: const TextStyle(
                      color: _primary,
                      fontWeight: FontWeight.w700,
                    ),
                    backgroundColor: _soft,
                    side: BorderSide.none,
                  ),
                  const SizedBox(height: 16),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.spa_outlined,
                          label: strings.careLevel,
                          value: plant.careLevel,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.water_drop_outlined,
                          label: strings.water,
                          value: plant.waterNeed,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.wb_sunny_outlined,
                          label: strings.sunlight,
                          value: plant.sunlight,
                        ),
                      ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SectionTitle(isEnglish ? 'Description' : 'Mô tả'),
                  Text(
                    plant.description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Color(0xFF425246),
                    ),
                  ),
                  if (plant.tags.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _SectionTitle(isEnglish ? 'Highlights' : 'Đặc điểm'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final tag in plant.tags)
                          Chip(
                            label: Text(tag),
                            labelStyle: const TextStyle(
                              color: _textColor,
                              fontWeight: FontWeight.w600,
                            ),
                            backgroundColor: Colors.white,
                            side: BorderSide.none,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: widget.onAddTask == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: FilledButton.icon(
                  onPressed: _openAddTask,
                  icon: const Icon(Icons.event_available_outlined),
                  label: Text(
                    isEnglish ? 'Add care task' : 'Thêm nhiệm vụ chăm sóc',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _PlantImage extends StatelessWidget {
  const _PlantImage({required this.plant});

  final Plant plant;

  Widget _placeholder() {
    return Container(
      color: _soft,
      alignment: Alignment.center,
      child: Text(plant.imageAsset, style: const TextStyle(fontSize: 96)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (plant.imageUrl.isEmpty) return _placeholder();

    return Image.network(
      plant.imageUrl,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        return progress == null ? child : _placeholder();
      },
      errorBuilder: (context, error, stackTrace) => _placeholder(),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onPressed,
    this.iconColor = _textColor,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: CircleAvatar(
        backgroundColor: Colors.white.withAlpha(225),
        child: IconButton(
          icon: Icon(icon, color: iconColor),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: _primary),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: _muted),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: _textColor,
        ),
      ),
    );
  }
}