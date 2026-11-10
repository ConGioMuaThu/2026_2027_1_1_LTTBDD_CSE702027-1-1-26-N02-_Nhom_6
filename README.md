# 2026_2027_1_1_LTTBDD_CSE702027-1-1-26-N02-_Nhom_6
Nhóm 6: 

    Nguyễn Huy Kiên - 24100137
    
    Trịnh Xuân Hồng Phong - 24100279

# GreenLife – Plant Care Assistand

GreenLife là ứng dụng Flutter hỗ trợ người dùng quản lý cây trồng và duy trì thói quen chăm sóc cây. Ứng dụng cung cấp thư viện cây, khu vườn cá nhân, lịch chăm sóc, nhật ký phát triển và các mẹo sống xanh. Giao diện hỗ trợ tiếng Việt và tiếng Anh.

## Chức năng chính

- **Trang chủ:** tổng quan khu vườn, công việc chăm sóc và mẹo nổi bật.
- **Thư viện cây:** xem và tìm kiếm thông tin các loại cây.
- **Vườn của tôi:** thêm, chỉnh sửa, xóa cây; quản lý cây yêu thích và thông tin chăm sóc.
- **Lịch chăm sóc:** tạo, tìm kiếm, theo dõi và đánh dấu hoàn thành các công việc chăm sóc; hỗ trợ nhắc nhở.
- **Nhật ký phát triển:** ghi lại quá trình phát triển của cây bằng nội dung và hình ảnh.
- **Mẹo sống xanh:** tra cứu mẹo chăm sóc cây và lựa chọn lối sống thân thiện với môi trường; lọc theo nhóm nội dung.
- **Thông tin nhóm:** xem thông tin các thành viên thực hiện dự án.
- **Đa ngôn ngữ:** chuyển đổi giữa tiếng Việt và tiếng Anh.

## Công nghệ sử dụng

- Flutter và Dart
- Material Design 3
- `shared_preferences` để lưu dữ liệu cục bộ
- `image_picker` để chọn hình ảnh
- `flutter_local_notifications` và `timezone` cho thông báo nhắc việc

## Yêu cầu môi trường

- Flutter SDK tương thích với Dart SDK `^3.13.7` (theo `pubspec.yaml`)
- Android Studio hoặc Visual Studio Code
- Android SDK hoặc môi trường chạy Flutter phù hợp

Kiểm tra cài đặt Flutter:

```bash
flutter doctor
```

## Cài đặt và chạy ứng dụng

1. Mở terminal tại thư mục `greenlife_app`.
2. Cài đặt các package:

```bash
flutter pub get
```

3. Kiểm tra thiết bị hoặc máy ảo:

```bash
flutter devices
```

4. Chạy ứng dụng:

```bash
flutter run
```

## Kiểm tra mã nguồn

Định dạng mã Dart:

```bash
dart format lib test
```

Phân tích tĩnh:

```bash
flutter analyze
```

Chạy toàn bộ kiểm thử:

```bash
flutter test
```

## Cấu trúc thư mục

```text
lib/
├── config/          # Cấu hình ứng dụng và giao diện
├── data/            # Dữ liệu mẫu
├── l10n/            # Nội dung đa ngôn ngữ
├── models/          # Các lớp dữ liệu
├── providers/       # Quản lý trạng thái
├── repositories/    # Truy xuất và xử lý dữ liệu
├── screens/         # Các màn hình ứng dụng
├── services/        # Lưu trữ, thông báo, bản địa hóa
├── utils/           # Hàm tiện ích
└── widgets/         # Widget dùng chung

test/                # Các bài kiểm thử
assets/              # Hình ảnh và tài nguyên giao diện
```
