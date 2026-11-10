import 'package:flutter/material.dart';

List<Map<String, String>> greenTipsFor(Locale locale) {
  final isEnglish = locale.languageCode == 'en';

  return [
    {
      'image': 'assets/images/tips/tip-1.png',
      'title': isEnglish ? 'Water correctly' : 'Tưới nước đúng cách',
      'content': isEnglish
          ? 'Check soil moisture before watering to prevent root rot. Water evenly and avoid prolonged waterlogging.'
          : 'Để tránh úng rễ, hãy kiểm tra độ ẩm đất trước khi tưới. Nước nên được hấp thu đều và không ngập lâu.',
    },
    {
      'image': 'assets/images/tips/tip-2.png',
      'title': isEnglish ? 'Choose suitable soil' : 'Chọn đất phù hợp',
      'content': isEnglish
          ? 'Use loose, well-draining soil with good aeration and organic compost to keep plants healthy.'
          : 'Hỗn hợp đất tơi xốp, thoát nước tốt và có thể bổ sung phân hữu cơ để cây phát triển khỏe mạnh.',
    },
    {
      'image': 'assets/images/tips/tip-3.png',
      'title': isEnglish ? 'Light for indoor plants' : 'Ánh sáng cho cây trong nhà',
      'content': isEnglish
          ? 'Place indoor plants in indirect light and keep them away from fans, heaters, and direct drafts.'
          : 'Cây trong nhà nên được đặt nơi có ánh sáng gián tiếp và tránh xa quạt gió, máy sưởi trực tiếp.',
    },
    {
      'image': 'assets/images/tips/tip-4.png',
      'title': isEnglish ? 'Feed in moderation' : 'Bón phân vừa phải',
      'content': isEnglish
          ? 'Fertilize lightly during the growing season and pause when growth slows down.'
          : 'Bón phân nhẹ trong mùa sinh trưởng và giảm lại khi cây chậm lớn.',
    },
    {
      'image': 'assets/images/tips/tip-5.png',
      'title': isEnglish ? 'Repot when roots feel crowded' : 'Thay chậu khi rễ chật',
      'content': isEnglish
          ? 'Move to a slightly larger pot when roots circle the bottom or poke out of the drainage holes.'
          : 'Chuyển sang chậu lớn hơn một chút khi rễ quấn đáy chậu hoặc chui ra lỗ thoát nước.',
    },
    {
      'image': 'assets/images/tips/tip-6.png',
      'title': isEnglish ? 'Spot pests early' : 'Phát hiện sâu bệnh sớm',
      'content': isEnglish
          ? 'Check the underside of leaves every week. Wipe pests off early or use mild soapy water.'
          : 'Kiểm tra mặt dưới lá mỗi tuần. Lau sạch sâu bệnh sớm hoặc dùng nước xà phòng loãng.',
    },
    {
      'image': 'assets/images/tips/tip-7.png',
      'title': isEnglish ? 'Prune regularly' : 'Tỉa cành định kỳ',
      'content': isEnglish
          ? 'Remove yellow or dry leaves so the plant can focus its energy on healthy growth.'
          : 'Cắt bỏ lá vàng, lá khô để cây dồn sức cho phần khỏe mạnh.',
    },
    {
      'image': 'assets/images/tips/tip-8.png',
      'title': isEnglish ? 'Keep humidity balanced' : 'Giữ độ ẩm cân bằng',
      'content': isEnglish
          ? 'Group plants together or mist lightly in dry rooms, but avoid leaving leaves wet overnight.'
          : 'Đặt cây gần nhau hoặc phun sương nhẹ khi phòng khô, tránh để lá ướt qua đêm.',
    },
    {
      'image': 'assets/images/tips/tip-9.png',
      'title': isEnglish ? 'Reuse rice-washing water' : 'Tái sử dụng nước vo gạo',
      'content': isEnglish
          ? 'Let plain rice-washing water settle and use it occasionally for plants. Avoid salted or seasoned water.'
          : 'Để nước vo gạo lắng rồi dùng tưới cây thỉnh thoảng. Không dùng nước có muối hoặc gia vị.',
    },
    {
      'image': 'assets/images/tips/tip-10.png',
      'title': isEnglish ? 'Make gentle compost' : 'Tận dụng vỏ trứng và bã cà phê',
      'content': isEnglish
          ? 'Crush clean, dried eggshells and add small amounts of used coffee grounds to compost. Do not overuse them.'
          : 'Rửa sạch, phơi khô rồi nghiền nhỏ vỏ trứng; trộn một lượng vừa phải bã cà phê vào phân ủ, tránh bón quá nhiều.',
    },
    {
      'image': 'assets/images/tips/tip-11.png',
      'title': isEnglish ? 'Water in the morning' : 'Tưới cây vào buổi sáng',
      'content': isEnglish
          ? 'Water in the cooler morning hours so plants can absorb moisture before the heat of the day.'
          : 'Tưới vào lúc sáng mát để cây kịp hấp thu nước trước khi trời nóng, hạn chế nước bốc hơi nhanh.',
    },
    {
      'image': 'assets/images/tips/tip-12.png',
      'title': isEnglish ? 'Reduce single-use plastic' : 'Hạn chế nhựa dùng một lần',
      'content': isEnglish
          ? 'Choose reusable bags, bottles, and durable pots to reduce plastic waste in everyday life.'
          : 'Ưu tiên túi vải, bình nước dùng lại và chậu bền thay cho đồ nhựa dùng một lần để giảm rác thải.',
    },
    {
      'image': 'assets/images/tips/tip-13.png',
      'title': isEnglish ? 'Grow air-friendly plants' : 'Trồng cây xanh trong nhà',
      'content': isEnglish
          ? 'Choose suitable indoor plants and care for them well to bring more greenery into your living space.'
          : 'Chọn các loại cây phù hợp với điều kiện trong nhà và chăm sóc đúng cách để không gian sống thêm xanh.',
    },
    {
      'image': 'assets/images/tips/tip-14.png',
      'title': isEnglish ? 'Sort and recycle waste' : 'Phân loại và tái chế rác',
      'content': isEnglish
          ? 'Separate recyclable materials such as paper, glass, and plastic so they can be processed properly.'
          : 'Phân loại giấy, thủy tinh và nhựa có thể tái chế để chúng được xử lý đúng cách, giảm lượng rác thải.',
    },
  ];
}
