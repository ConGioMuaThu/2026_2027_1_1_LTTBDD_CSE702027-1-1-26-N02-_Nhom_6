import 'package:flutter/material.dart';
import 'package:greenlife_app/config/theme.dart';
import 'package:greenlife_app/data/sample_data.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/models/growth_note.dart';
import 'package:greenlife_app/models/plant.dart';
import 'package:greenlife_app/widgets/detail_sheet.dart';
import 'package:greenlife_app/widgets/plant_card.dart';
import 'package:greenlife_app/widgets/stat_card.dart';

class HomeScreen extends StatefulWidget {
  final List<Plant> plants;
  final List<CareTask> tasks;
  final List<GrowthNote> notes;
  final Locale locale;
  final ValueChanged<Locale>? onLocaleChanged;

  const HomeScreen({
    super.key,
    this.plants = const [],
    this.tasks = const [],
    this.notes = const [],
    this.locale = const Locale('vi'),
    this.onLocaleChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Plant> get _filteredFavoritePlants {
    final query = _searchController.text.trim().toLowerCase();
    final favoritePlants = widget.plants.where((plant) => plant.isFavorite).toList();
    if (query.isEmpty) {
      return favoritePlants.take(6).toList();
    }
    return favoritePlants
        .where((plant) =>
            plant.name.toLowerCase().contains(query) ||
            plant.scientificName.toLowerCase().contains(query) ||
            plant.description.toLowerCase().contains(query))
        .take(6)
        .toList();
  }

  List<CareTask> get _filteredTasks {
    final query = _searchController.text.trim().toLowerCase();
    final tasks = widget.tasks.where((task) => !task.isCompleted).toList();
    if (query.isEmpty) {
      return tasks.take(3).toList();
    }
    return tasks
        .where((task) =>
            task.title.toLowerCase().contains(query) ||
            task.plantName.toLowerCase().contains(query) ||
            task.type.toLowerCase().contains(query))
        .take(3)
        .toList();
  }

  List<Map<String, String>> get _filteredTips {
    final query = _searchController.text.trim().toLowerCase();
    final source = greenTipsFor(Localizations.localeOf(context));
    if (query.isEmpty) {
      return source;
    }
    return source
        .where((tip) =>
            (tip['title'] ?? '').toLowerCase().contains(query) ||
            (tip['content'] ?? '').toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final allTips = greenTipsFor(Localizations.localeOf(context));
    final todayTasks = _filteredTasks;
    final favoritePlants = _filteredFavoritePlants;
    final filteredTips = _filteredTips;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.greeting,
                        style: const TextStyle(color: AppTheme.muted, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        strings.appName,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<Locale>(
                  tooltip: strings.language,
                  onSelected: (nextLocale) {
                    widget.onLocaleChanged?.call(nextLocale);
                  },
                  itemBuilder: (context) => AppLocalizations.supportedLocales
                      .map(
                        (locale) => PopupMenuItem<Locale>(
                          value: locale,
                          child: Text(
                            locale.languageCode == 'vi'
                                ? strings.vietnamese
                                : strings.english,
                          ),
                        ),
                      )
                      .toList(),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.language,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: strings.searchHint,
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
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2F6A4F), Color(0xFF7BB06A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.plantCareAssistant,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          strings.careMessage,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(strings.viewCareSchedule),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('🌿', style: TextStyle(fontSize: 70)),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                StatCard(
                  label: strings.plantSummary,
                  value: '${widget.plants.length}',
                  icon: Icons.eco,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 12),
                StatCard(
                  label: strings.taskSummary,
                  value: '${widget.tasks.length}',
                  icon: Icons.task_alt,
                  color: AppTheme.warning,
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                StatCard(
                  label: strings.health,
                  value: '92%',
                  icon: Icons.favorite,
                  color: AppTheme.success,
                ),
                const SizedBox(width: 12),
                StatCard(
                  label: strings.newTips,
                  value: '${allTips.length}',
                  icon: Icons.lightbulb,
                  color: AppTheme.secondary,
                ),
              ],
            ),
            const SizedBox(height: 26),
            Text(
              strings.todayTasks,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            if (todayTasks.isEmpty)
              Text(strings.noTodayTasks, style: const TextStyle(color: AppTheme.muted))
            else
              ...todayTasks.map(
                (task) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => showTaskDetailSheet(context, task),
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDDF3E0),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.water_drop,
                                color: AppTheme.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${task.plantName} • ${task.dueDate}',
                                    style: const TextStyle(
                                      color: AppTheme.muted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: AppTheme.muted),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Text(
              strings.favoritePlants,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            if (favoritePlants.isEmpty)
              Text(strings.noFavoritePlants, style: const TextStyle(color: AppTheme.muted))
            else
              SizedBox(
                height: 230,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: favoritePlants.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (context, index) => PlantCard(
                    plant: favoritePlants[index],
                    onTap: () => showPlantDetailSheet(context, favoritePlants[index]),
                  ),
                ),
              ),
            const SizedBox(height: 26),
            Text(
              strings.highlightTips,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            if (filteredTips.isEmpty)
              Text(strings.noTipsFound, style: const TextStyle(color: AppTheme.muted))
            else
              ...filteredTips.map(
                (tip) => Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => showTipDetailSheet(context, tip),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tip['title'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tip['content'] ?? '',
                            style: const TextStyle(
                              height: 1.5,
                              color: AppTheme.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
