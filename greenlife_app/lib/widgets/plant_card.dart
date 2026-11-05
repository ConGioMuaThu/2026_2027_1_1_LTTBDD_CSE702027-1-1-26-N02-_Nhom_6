import 'package:flutter/material.dart';
import 'package:greenlife_app/models/plant.dart';

const Color _primary = Color(0xFF2F6A4F);
const Color _soft = Color(0xFFE2F4E4);
const Color _textColor = Color(0xFF1D2A1F);
const Color _muted = Color(0xFF5F6F62);
const Color _danger = Color(0xFFE46D5F);

class PlantCard extends StatelessWidget {
  const PlantCard({
    super.key,
    required this.plant,
    required this.onTap,
    this.isSelected = false,
  });

  final Plant plant;
  final VoidCallback onTap;
  final bool isSelected;

  Widget _placeholder() {
    return Container(
      color: _soft,
      alignment: Alignment.center,
      child: Text(plant.imageAsset, style: const TextStyle(fontSize: 44)),
    );
  }

  Widget _buildImage() {
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.hasBoundedWidth ? constraints.maxWidth : 160.0;

        return SizedBox(
          width: width,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? _primary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            _buildImage(),
                            if (plant.isFavorite)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.white,
                                  child: const Icon(
                                    Icons.favorite,
                                    size: 16,
                                    color: _danger,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plant.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: _textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            plant.scientificName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: _muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}