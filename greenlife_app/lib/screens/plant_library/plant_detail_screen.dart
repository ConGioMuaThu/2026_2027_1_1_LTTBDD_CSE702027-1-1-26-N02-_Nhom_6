import 'package:flutter/material.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/plant.dart';

const Color _primary = Color(0xFF2F6A4F);
const Color _soft = Color(0xFFE2F4E4);
const Color _background = Color(0xFFF5F8F2);
const Color _textColor = Color(0xFF1D2A1F);
const Color _muted = Color(0xFF5F6F62);

class PlantDetailScreen extends StatefulWidget {
  const PlantDetailScreen({
    super.key,
    required this.plant,
  });

  final Plant plant;

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  bool get _isEnglish => Localizations.localeOf(context).languageCode == 'en';

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
                  Row(
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