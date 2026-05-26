import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';

class HomeScreenAdvertiseBanner extends StatelessWidget {
  const HomeScreenAdvertiseBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.sw(327),
      height: SizeConfig.sh(113),
      decoration: BoxDecoration(
        color: AppColors.greenStrong1,
        image: const DecorationImage(
          image: AssetImage(
            'assets/images/pets_screen_advertise_banner_background.png',
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "Vòng cổ mới !!!",
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  height: 22 / 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Theo dõi bé yêu mọi lúc",
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 18 / 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          // Hình ảnh bên phải (placeholder)
          Image.asset('assets/images/vong-co-moi.png'),
        ],
      ),
    );
  }
}
