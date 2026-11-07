import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  static const supportedLocales = [
    Locale('vi'),
    Locale('en'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _values = {
    'vi': {
      'greeting': 'Chào bạn,',
      'appName': 'GreenLife',
      'searchHint': 'Tìm cây, nhiệm vụ hoặc mẹo',
      'plantCareAssistant': 'Plant Care Assistant',
      'careMessage': 'Hôm nay là ngày tốt để chăm sóc cây của bạn.',
      'viewCareSchedule': 'Xem lịch chăm sóc',
      'initMessage': 'Khởi tạo vườn xanh cho bạn...',
      'language': 'Ngôn ngữ',
      'english': 'English',
      'vietnamese': 'Tiếng Việt',
      'home': 'Trang chủ',
      'library': 'Thư viện',
      'garden': 'Vườn',
      'care': 'Chăm sóc',
      'journal': 'Nhật ký',
      'tips': 'Mẹo',
      'about': 'Giới thiệu',
      'teamInfo': 'Thông tin nhóm',
      'teamDescription': 'Trợ lý chăm sóc cây xanh thông minh',
      'searchMembers': 'Tìm thành viên',
      'noMembersFound': 'Không tìm thấy thành viên nào.',
      'treeLibrary': 'Thư viện cây xanh',
      'searchTrees': 'Tìm cây theo tên hoặc mô tả',
      'noTreesFound': 'Không tìm thấy cây nào phù hợp.',
      'myGarden': 'Vườn cây của tôi',
      'addPlant': 'Thêm cây mới',
      'cancel': 'Hủy',
      'save': 'Lưu',
      'add': 'Thêm',
      'plantName': 'Tên cây',
      'plantType': 'Loại cây',
      'waterNeed': 'Nhu cầu nước',
      'searchGarden': 'Tìm cây trong vườn',
      'noGardenMatch': 'Không có cây nào phù hợp.',
      'careSchedule': 'Lịch chăm sóc',
      'thisWeek': 'Tuần này',
      'tasks': 'nhiệm vụ',
      'completed': 'Hoàn thành',
      'searchTasks': 'Tìm nhiệm vụ theo cây hoặc loại',
      'noTasksFound': 'Không tìm thấy nhiệm vụ nào.',
      'growthJournal': 'Nhật ký phát triển',
      'searchNotes': 'Tìm ghi chú hoặc cây',
      'noNotesFound': 'Không có ghi chú phù hợp.',
      'newNote': 'Thêm ghi chú mới',
      'title': 'Tiêu đề',
      'descriptionGrowth': 'Mô tả phát triển',
      'tipsTitle': 'Mẹo sống xanh',
      'searchTips': 'Tìm mẹo chăm sóc',
      'noTipsFound': 'Không có mẹo nào phù hợp.',
      'plantSummary': 'Cây hiện có',
      'taskSummary': 'Nhiệm vụ',
      'health': 'Sức khỏe',
      'newTips': 'Mẹo mới',
      'todayTasks': 'Công việc hôm nay',
      'noTodayTasks': 'Không có nhiệm vụ nào cần thực hiện.',
      'favoritePlants': 'Cây yêu thích',
      'noFavoritePlants': 'Không có cây yêu thích nào phù hợp.',
      'highlightTips': 'Mẹo chăm sóc nổi bật',
      'plantLibraryTitle': 'Thư viện cây xanh',
      'searchPlants': 'Tìm cây theo tên hoặc mô tả',
      'noPlantsFound': 'Không tìm thấy cây nào phù hợp.',
      'myGardenTitle': 'Vườn cây của tôi',
      'addPlantTitle': 'Thêm cây mới',
      'indoorPlantDefault': 'Trong nhà',
      'waterNeedDefault': '2-3 lần/tuần',
      'newPlantDescription': 'Cây mới được thêm vào vườn chăm sóc cá nhân.',
      'easyCareLevel': 'Dễ',
      'indirectSunlight': 'Ánh sáng gián tiếp',
      'careScheduleTitle': 'Lịch chăm sóc',
      'thisWeekLabel': 'Tuần này',
      'tasksCount': 'nhiệm vụ',
      'completedLabel': 'Hoàn thành',
      'searchTasksHint': 'Tìm nhiệm vụ theo cây hoặc loại',
      'noTasksFoundDetail': 'Không tìm thấy nhiệm vụ nào.',
      'teamInfoTitle': 'Thông tin nhóm',
      'teamSubtitle': 'Trợ lý chăm sóc cây xanh thông minh',
      'searchMembersHint': 'Tìm thành viên',
      'noMembersFoundDetail': 'Không tìm thấy thành viên nào.',
      'tipsTitlePage': 'Mẹo sống xanh',
      'searchTipsHint': 'Tìm mẹo chăm sóc',
      'noTipsMatch': 'Không có mẹo nào phù hợp.',
      'growthJournalTitle': 'Nhật ký phát triển',
      'searchNotesHint': 'Tìm ghi chú hoặc cây',
      'noNotesMatch': 'Không có ghi chú phù hợp.',
      'newNoteTitle': 'Thêm ghi chú mới',
      'notePlantDefault': 'Trầu bà',
      'myPlantDefault': 'Cây của tôi',
      'category': 'Phân loại',
      'careLevel': 'Mức độ chăm sóc',
      'water': 'Nước',
      'sunlight': 'Ánh sáng',
      'status': 'Trạng thái',
      'taskType': 'Loại',
      'dueDate': 'Hạn chót',
      'plant': 'Cây',
      'completedStatus': 'Đã hoàn thành',
      'pendingStatus': 'Chưa hoàn thành',
      'toggleDone': 'Đánh dấu hoàn thành',
      'togglePending': 'Đánh dấu chưa xong',
      'role': 'Vai trò',
      'assignment': 'Phân công',
      'notFound': 'Không tìm thấy',
      'addTaskTitle': 'Thêm nhiệm vụ',
      'taskTitleLabel': 'Tên nhiệm vụ',
      'taskTitleRequired': 'Vui lòng nhập tiêu đề',
      'taskTitleTooShort': 'Tiêu đề tối thiểu 3 ký tự',
      'choosePlantRequired': 'Vui lòng chọn cây',
      'dateLabel': 'Ngày',
      'timeLabel': 'Giờ',
      'dueTimeInPast': 'Thời gian thực hiện phải sau thời điểm hiện tại.',
      'taskDetailsTitle': 'Chi tiết nhiệm vụ',
      'deleteTask': 'Xóa nhiệm vụ',
      'deleteTaskQuestion': 'Xóa nhiệm vụ?',
      'deleteAction': 'Xóa',
      'taskDeleted': 'Đã xóa nhiệm vụ',
      'deleteTaskMessage': 'Nhiệm vụ "{task}" của {plant} sẽ bị xóa.',
      'careTaskAdded': 'Đã thêm nhiệm vụ chăm sóc',
      'addCareTask': 'Thêm nhiệm vụ chăm sóc',
      'descriptionLabel': 'Mô tả',
      'highlightsLabel': 'Đặc điểm',
      'noteDate': 'Ngày ghi',
      'noteDetailsTitle': 'Chi tiết ghi chú',
      'noteTitleRequired': 'Vui lòng nhập tiêu đề',
      'noteTitleTooShort': 'Tiêu đề tối thiểu 3 ký tự',
      'noteContentHint': 'Cây thay đổi thế nào? (lá mới, nụ hoa...)',
      'noteContentRequired': 'Vui lòng nhập mô tả',
      'noteContentTooShort': 'Mô tả tối thiểu 10 ký tự',
      'noteAdded': 'Đã thêm ghi chú',
      'editNote': 'Sửa ghi chú',
      'noteUpdated': 'Đã cập nhật ghi chú',
      'discardChangesQuestion': 'Bỏ thay đổi?',
      'discardChangesMessage': 'Nội dung bạn vừa nhập sẽ không được lưu.',
      'keepEditing': 'Tiếp tục nhập',
      'discardAction': 'Bỏ',
      'emptyJournalTitle': 'Chưa có ghi chú nào',
      'emptyJournalMessage': 'Bấm nút + để ghi lại sự phát triển của cây.',
      'noteDeleted': 'Đã xóa ghi chú',
      'deleteNote': 'Xóa ghi chú',
      'deleteNoteQuestion': 'Xóa ghi chú?',
      'deleteNoteMessage': 'Ghi chú "{note}" của {plant} sẽ bị xóa.',
    },
    'en': {
      'greeting': 'Hello,',
      'appName': 'GreenLife',
      'searchHint': 'Search plants, tasks or tips',
      'plantCareAssistant': 'Plant Care Assistant',
      'careMessage': 'Today is a great day to care for your plants.',
      'viewCareSchedule': 'View care schedule',
      'initMessage': 'Growing your green space...',
      'language': 'Language',
      'english': 'English',
      'vietnamese': 'Tiếng Việt',
      'home': 'Home',
      'library': 'Library',
      'garden': 'Garden',
      'care': 'Care',
      'journal': 'Journal',
      'tips': 'Tips',
      'about': 'About',
      'teamInfo': 'Team information',
      'teamDescription': 'Smart plant care assistant',
      'searchMembers': 'Search members',
      'noMembersFound': 'No members found.',
      'treeLibrary': 'Plant library',
      'searchTrees': 'Search plants by name or description',
      'noTreesFound': 'No matching plants found.',
      'myGarden': 'My garden',
      'addPlant': 'Add new plant',
      'cancel': 'Cancel',
      'save': 'Save',
      'add': 'Add',
      'plantName': 'Plant name',
      'plantType': 'Plant type',
      'waterNeed': 'Water need',
      'searchGarden': 'Search plants in the garden',
      'noGardenMatch': 'No plants match your search.',
      'careSchedule': 'Care schedule',
      'thisWeek': 'This week',
      'tasks': 'tasks',
      'completed': 'Completed',
      'searchTasks': 'Search tasks by plant or type',
      'noTasksFound': 'No tasks found.',
      'growthJournal': 'Growth journal',
      'searchNotes': 'Search notes or plants',
      'noNotesFound': 'No matching notes found.',
      'newNote': 'Add new note',
      'title': 'Title',
      'descriptionGrowth': 'Growth description',
      'tipsTitle': 'Green living tips',
      'searchTips': 'Search care tips',
      'noTipsFound': 'No matching tips found.',
      'plantSummary': 'Plants',
      'taskSummary': 'Tasks',
      'health': 'Health',
      'newTips': 'New tips',
      'todayTasks': 'Today’s tasks',
      'noTodayTasks': 'No tasks are due today.',
      'favoritePlants': 'Favorite plants',
      'noFavoritePlants': 'No favorite plants match your search.',
      'highlightTips': 'Featured care tips',
      'plantLibraryTitle': 'Plant library',
      'searchPlants': 'Search plants by name or description',
      'noPlantsFound': 'No matching plants found.',
      'myGardenTitle': 'My garden',
      'addPlantTitle': 'Add new plant',
      'indoorPlantDefault': 'Indoor',
      'waterNeedDefault': '2-3 times/week',
      'newPlantDescription': 'A new plant added to your personal care garden.',
      'easyCareLevel': 'Easy',
      'indirectSunlight': 'Indirect sunlight',
      'careScheduleTitle': 'Care schedule',
      'thisWeekLabel': 'This week',
      'tasksCount': 'tasks',
      'completedLabel': 'Completed',
      'searchTasksHint': 'Search tasks by plant or type',
      'noTasksFoundDetail': 'No tasks found.',
      'teamInfoTitle': 'Team information',
      'teamSubtitle': 'Smart plant care assistant',
      'searchMembersHint': 'Search members',
      'noMembersFoundDetail': 'No members found.',
      'tipsTitlePage': 'Green living tips',
      'searchTipsHint': 'Search care tips',
      'noTipsMatch': 'No matching tips found.',
      'growthJournalTitle': 'Growth journal',
      'searchNotesHint': 'Search notes or plants',
      'noNotesMatch': 'No matching notes found.',
      'newNoteTitle': 'Add new note',
      'notePlantDefault': 'My plant',
      'myPlantDefault': 'My plant',
      'category': 'Category',
      'careLevel': 'Care level',
      'water': 'Water',
      'sunlight': 'Sunlight',
      'status': 'Status',
      'taskType': 'Type',
      'dueDate': 'Due date',
      'plant': 'Plant',
      'completedStatus': 'Completed',
      'pendingStatus': 'Not completed',
      'toggleDone': 'Mark as complete',
      'togglePending': 'Mark as incomplete',
      'role': 'Role',
      'assignment': 'Assignment',
      'notFound': 'Not found',
      'addTaskTitle': 'Add task',
      'taskTitleLabel': 'Task title',
      'taskTitleRequired': 'Please enter a title',
      'taskTitleTooShort': 'Title must be at least 3 characters',
      'choosePlantRequired': 'Please choose a plant',
      'dateLabel': 'Date',
      'timeLabel': 'Time',
      'dueTimeInPast': 'The due time must be in the future.',
      'taskDetailsTitle': 'Task details',
      'deleteTask': 'Delete task',
      'deleteTaskQuestion': 'Delete task?',
      'deleteAction': 'Delete',
      'taskDeleted': 'Task deleted',
      'deleteTaskMessage': '"{task}" for {plant} will be removed.',
      'careTaskAdded': 'Care task added',
      'addCareTask': 'Add care task',
      'descriptionLabel': 'Description',
      'highlightsLabel': 'Highlights',
      'noteDate': 'Date',
      'noteDetailsTitle': 'Note details',
      'noteTitleRequired': 'Please enter a title',
      'noteTitleTooShort': 'Title must be at least 3 characters',
      'noteContentHint': 'How did the plant change? (new leaves, buds...)',
      'noteContentRequired': 'Please enter a description',
      'noteContentTooShort': 'Description must be at least 10 characters',
      'noteAdded': 'Note added',
      'editNote': 'Edit note',
      'noteUpdated': 'Note updated',
      'discardChangesQuestion': 'Discard changes?',
      'discardChangesMessage': 'What you just entered will not be saved.',
      'keepEditing': 'Keep editing',
      'discardAction': 'Discard',
      'emptyJournalTitle': 'No notes yet',
      'emptyJournalMessage': 'Tap + to record how your plants are growing.',
      'noteDeleted': 'Note deleted',
      'deleteNote': 'Delete note',
      'deleteNoteQuestion': 'Delete note?',
      'deleteNoteMessage': '"{note}" for {plant} will be removed.',
    },
  };

  String get greeting => _val('greeting');
  String get appName => _val('appName');
  String get searchHint => _val('searchHint');
  String get plantCareAssistant => _val('plantCareAssistant');
  String get careMessage => _val('careMessage');
  String get viewCareSchedule => _val('viewCareSchedule');
  String get initMessage => _val('initMessage');
  String get language => _val('language');
  String get english => _val('english');
  String get vietnamese => _val('vietnamese');
  String get home => _val('home');
  String get library => _val('library');
  String get garden => _val('garden');
  String get care => _val('care');
  String get journal => _val('journal');
  String get tips => _val('tips');
  String get about => _val('about');
  String get teamInfo => _val('teamInfo');
  String get teamDescription => _val('teamDescription');
  String get searchMembers => _val('searchMembers');
  String get noMembersFound => _val('noMembersFound');
  String get treeLibrary => _val('treeLibrary');
  String get searchTrees => _val('searchTrees');
  String get noTreesFound => _val('noTreesFound');
  String get myGarden => _val('myGarden');
  String get addPlant => _val('addPlant');
  String get cancel => _val('cancel');
  String get save => _val('save');
  String get add => _val('add');
  String get plantName => _val('plantName');
  String get plantType => _val('plantType');
  String get waterNeed => _val('waterNeed');
  String get searchGarden => _val('searchGarden');
  String get noGardenMatch => _val('noGardenMatch');
  String get careSchedule => _val('careSchedule');
  String get thisWeek => _val('thisWeek');
  String get tasksLabel => _val('tasks');
  String get completed => _val('completed');
  String get searchTasks => _val('searchTasks');
  String get noTasksFound => _val('noTasksFound');
  String get growthJournal => _val('growthJournal');
  String get searchNotes => _val('searchNotes');
  String get noNotesFound => _val('noNotesFound');
  String get newNote => _val('newNote');
  String get title => _val('title');
  String get descriptionGrowth => _val('descriptionGrowth');
  String get tipsTitle => _val('tipsTitle');
  String get searchTips => _val('searchTips');
  String get noTipsFound => _val('noTipsFound');
  String get plantSummary => _val('plantSummary');
  String get taskSummary => _val('taskSummary');
  String get health => _val('health');
  String get newTips => _val('newTips');
  String get todayTasks => _val('todayTasks');
  String get noTodayTasks => _val('noTodayTasks');
  String get favoritePlants => _val('favoritePlants');
  String get noFavoritePlants => _val('noFavoritePlants');
  String get highlightTips => _val('highlightTips');
  String get plantLibraryTitle => _val('plantLibraryTitle');
  String get searchPlants => _val('searchPlants');
  String get noPlantsFound => _val('noPlantsFound');
  String get myGardenTitle => _val('myGardenTitle');
  String get addPlantTitle => _val('addPlantTitle');
  String get indoorPlantDefault => _val('indoorPlantDefault');
  String get waterNeedDefault => _val('waterNeedDefault');
  String get newPlantDescription => _val('newPlantDescription');
  String get easyCareLevel => _val('easyCareLevel');
  String get indirectSunlight => _val('indirectSunlight');
  String get careScheduleTitle => _val('careScheduleTitle');
  String get thisWeekLabel => _val('thisWeekLabel');
  String get tasksCount => _val('tasksCount');
  String get completedLabel => _val('completedLabel');
  String get searchTasksHint => _val('searchTasksHint');
  String get noTasksFoundDetail => _val('noTasksFoundDetail');
  String get teamInfoTitle => _val('teamInfoTitle');
  String get teamSubtitle => _val('teamSubtitle');
  String get searchMembersHint => _val('searchMembersHint');
  String get noMembersFoundDetail => _val('noMembersFoundDetail');
  String get tipsTitlePage => _val('tipsTitlePage');
  String get searchTipsHint => _val('searchTipsHint');
  String get noTipsMatch => _val('noTipsMatch');
  String get growthJournalTitle => _val('growthJournalTitle');
  String get searchNotesHint => _val('searchNotesHint');
  String get noNotesMatch => _val('noNotesMatch');
  String get newNoteTitle => _val('newNoteTitle');
  String get notePlantDefault => _val('notePlantDefault');
  String get myPlantDefault => _val('myPlantDefault');
  String get category => _val('category');
  String get careLevel => _val('careLevel');
  String get water => _val('water');
  String get sunlight => _val('sunlight');
  String get status => _val('status');
  String get taskType => _val('taskType');
  String get dueDate => _val('dueDate');
  String get plant => _val('plant');
  String get completedStatus => _val('completedStatus');
  String get pendingStatus => _val('pendingStatus');
  String get toggleDone => _val('toggleDone');
  String get togglePending => _val('togglePending');
  String get role => _val('role');
  String get assignment => _val('assignment');

  String get addTaskTitle => _val('addTaskTitle');
  String get taskTitleLabel => _val('taskTitleLabel');
  String get taskTitleRequired => _val('taskTitleRequired');
  String get taskTitleTooShort => _val('taskTitleTooShort');
  String get choosePlantRequired => _val('choosePlantRequired');
  String get dateLabel => _val('dateLabel');
  String get timeLabel => _val('timeLabel');
  String get dueTimeInPast => _val('dueTimeInPast');
  String get taskDetailsTitle => _val('taskDetailsTitle');
  String get deleteTask => _val('deleteTask');
  String get deleteTaskQuestion => _val('deleteTaskQuestion');
  String get deleteAction => _val('deleteAction');
  String get taskDeleted => _val('taskDeleted');
  String get careTaskAdded => _val('careTaskAdded');
  String get addCareTask => _val('addCareTask');
  String get descriptionLabel => _val('descriptionLabel');
  String get highlightsLabel => _val('highlightsLabel');
  String get noteDate => _val('noteDate');
  String get noteDetailsTitle => _val('noteDetailsTitle');
  String get noteTitleRequired => _val('noteTitleRequired');
  String get noteTitleTooShort => _val('noteTitleTooShort');
  String get noteContentHint => _val('noteContentHint');
  String get noteContentRequired => _val('noteContentRequired');
  String get noteContentTooShort => _val('noteContentTooShort');
  String get noteAdded => _val('noteAdded');
  String get editNote => _val('editNote');
  String get noteUpdated => _val('noteUpdated');
  String get discardChangesQuestion => _val('discardChangesQuestion');
  String get discardChangesMessage => _val('discardChangesMessage');
  String get keepEditing => _val('keepEditing');
  String get discardAction => _val('discardAction');
  String get emptyJournalTitle => _val('emptyJournalTitle');
  String get emptyJournalMessage => _val('emptyJournalMessage');
  String get noteDeleted => _val('noteDeleted');
  String get deleteNote => _val('deleteNote');
  String get deleteNoteQuestion => _val('deleteNoteQuestion');
  String deleteNoteMessage(String note, String plant) {
    return _val('deleteNoteMessage')
        .replaceAll('{note}', note)
        .replaceAll('{plant}', plant);
  }
  String deleteTaskMessage(String task, String plant) {
    return _val('deleteTaskMessage')
        .replaceAll('{task}', task)
        .replaceAll('{plant}', plant);
  }

  String _val(String key) => _values[locale.languageCode]?[key] ?? _values['vi']![key]!;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}