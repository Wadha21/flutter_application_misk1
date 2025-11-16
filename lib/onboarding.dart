import 'package:flutter/material.dart';
import 'package:flutter_application_1/navigation_root.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final introKey = GlobalKey<IntroductionScreenState>();
  int currentPageIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "image": "assets/screen1.png",
      "title": "أهلاً بك في وجهة مسك",
      "subtitle": "تطبيقك المثالي للتنقل داخل مدينة مسك"
    },
    {
      "image": "assets/screen2.png",
      "title": "اكتشف حضارة الفاو \n العريقة",
      "subtitle": "عش رحلة عبر الزمن واستكشف تاريخ حضارة الفاو أثناء تنقلك"
    },
    {
      "image": "assets/screen3.png",
      "title": "تجربة غامرة بالواقع المعزز",
      "subtitle":
          "استمتع بتجربة AR تفاعلية واستمع للبودكاست التقائي المخصص لكل موقع تزوره"
    },
  ];

  void goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const NavigationRoot()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.black,
      pages: pages.map((page) {
        return PageViewModel(
          titleWidget: const SizedBox.shrink(),
          bodyWidget: const SizedBox.shrink(),
          decoration: const PageDecoration(
            fullScreen: true,
            imageFlex: 1,
            bodyFlex: 0,
          ),
          image: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(page["image"]!, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.05),
                      Colors.black.withOpacity(0.75),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 55,
                right: 25,
                child: GestureDetector(
                  onTap: goToHome,
                  child: const Text(
                    "تخطي",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 170,
                right: 25,
                left: 25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      page["title"]!,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      page["subtitle"]!,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 18,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChange: (index) => setState(() => currentPageIndex = index),
      dotsDecorator: DotsDecorator(
        size: const Size(7, 7),
        activeSize: const Size(18, 7),
        activeColor: Colors.white,
        color: Colors.white54,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      showNextButton: false,
      showSkipButton: false,
      showDoneButton: false,
      globalFooter: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.9),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (currentPageIndex == pages.length - 1) {
                goToHome(); 
              } else {
                introKey.currentState?.next(); 
              }
            },
            child: Text(
              currentPageIndex == pages.length - 1 ? "ابدأ الآن" : "التالي",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA07856),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
