import 'package:flutter/material.dart';

List<Map<String, String>> greenTipsFor(Locale locale) {
  final isEnglish = locale.languageCode == 'en';

  return [
    {
      'title': isEnglish ? 'Water correctly' : 'Tưới nước đúng cách',
      'content': isEnglish
          ? 'Check soil moisture before watering to prevent root rot. Water evenly and avoid prolonged waterlogging.'
          : 'Để tránh úng rễ, hãy kiểm tra độ ẩm đất trước khi tưới. Nước nên được hấp thu đều và không ngập lâu.',
    },
    {
      'title': isEnglish ? 'Choose suitable soil' : 'Chọn đất phù hợp',
      'content': isEnglish
          ? 'Use loose, well-draining soil with good aeration and organic compost to keep plants healthy.'
          : 'Hỗn hợp đất tơi xốp, thoát nước tốt và có thể bổ sung phân hữu cơ để cây phát triển khỏe mạnh.',
    },
    {
      'title': isEnglish ? 'Light for indoor plants' : 'Ánh sáng cho cây trong nhà',
      'content': isEnglish
          ? 'Place indoor plants in indirect light and keep them away from fans, heaters, and direct drafts.'
          : 'Cây trong nhà nên được đặt nơi có ánh sáng gián tiếp và tránh xa quạt gió, máy sưởi trực tiếp.',
    },
    {
      'title': isEnglish ? 'Feed in moderation' : 'Bón phân vừa phải',
      'content': isEnglish
          ? 'Fertilize lightly during the growing season and pause when growth slows down.'
          : 'Bón phân nhẹ trong mùa sinh trưởng và giảm lại khi cây chậm lớn.',
    },
    {
      'title': isEnglish ? 'Repot when roots feel crowded' : 'Thay chậu khi rễ chật',
      'content': isEnglish
          ? 'Move to a slightly larger pot when roots circle the bottom or poke out of the drainage holes.'
          : 'Chuyển sang chậu lớn hơn một chút khi rễ quấn đáy chậu hoặc chui ra lỗ thoát nước.',
    },
    {
      'title': isEnglish ? 'Spot pests early' : 'Phát hiện sâu bệnh sớm',
      'content': isEnglish
          ? 'Check the underside of leaves every week. Wipe pests off early or use mild soapy water.'
          : 'Kiểm tra mặt dưới lá mỗi tuần. Lau sạch sâu bệnh sớm hoặc dùng nước xà phòng loãng.',
    },
    {
      'title': isEnglish ? 'Prune regularly' : 'Tỉa cành định kỳ',
      'content': isEnglish
          ? 'Remove yellow or dry leaves so the plant can focus its energy on healthy growth.'
          : 'Cắt bỏ lá vàng, lá khô để cây dồn sức cho phần khỏe mạnh.',
    },
    {
      'title': isEnglish ? 'Keep humidity balanced' : 'Giữ độ ẩm cân bằng',
      'content': isEnglish
          ? 'Group plants together or mist lightly in dry rooms, but avoid leaving leaves wet overnight.'
          : 'Đặt cây gần nhau hoặc phun sương nhẹ khi phòng khô, tránh để lá ướt qua đêm.',
    },
  ];
}