import 'package:flutter/material.dart';
import 'favorite_place_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 14),
          _buildDiscoverCard(),
          const SizedBox(height: 20),
          _buildFavoriteTitle(),
          const SizedBox(height: 12),
          Expanded(child: _buildFavoriteList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFA07856),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const Spacer(),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مرحبًا بك',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'مدينة مسك',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE3C450),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.person, color: Colors.white, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن وجهتك...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoverCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage('assets/screen2.png'),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.bottomRight,
        padding: const EdgeInsets.all(20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اكتشف حضارة الفاو',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Text(
              'استكشف تاريخ حضارة الفاو أثناء تنقلك',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Text(
            'الوجهات المفضلة',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Spacer(),
          Text(
            'عرض الكل',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.brown.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: const [
        FavoritePlaceCard(
          imagePath: 'assets/city_hub.png',
          title: 'ملتقى المدينة',
          duration: '38 د',
          distance: '3.3 كـ',
          rating: '4.8',
        ),
        FavoritePlaceCard(
          imagePath: 'assets/ghaa_almalqi.png',
          title: 'قاعة الملتقى',
          duration: '15 د',
          distance: '3 كـ',
          rating: '4.5',
        ),
        FavoritePlaceCard(
          imagePath: 'assets/markaz_alaor.png',
          title: 'مركز الأور',
          duration: '31 د',
          distance: '3 كـ',
          rating: '4.7',
        ),
      ],
    );
  }
}
