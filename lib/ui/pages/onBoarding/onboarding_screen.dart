import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:conference_app/ui/pages/home/home_screen.dart';

class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;

  final List<OnboardingContents> contents = [
    OnboardingContents(
      title: "Busca un evento",
      image: "assets/images/image1.png",
      desc: "Explora conferencias y eventos que se ajusten a tus intereses.",
    ),
    OnboardingContents(
      title: "Suscríbete fácil",
      image: "assets/images/image2.png",
      desc: "Regístrate y recibe notificaciones de tus eventos favoritos.",
    ),
    OnboardingContents(
      title: "Califica tus eventos",
      image: "assets/images/image3.png",
      desc: "Califica de manera anonima y segura tus eventos.",
    ),
  ];

  int _currentPage = 0;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  AnimatedContainer _buildDots({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: _currentPage == index
            ? Theme.of(context).colorScheme.primary
            : Colors.grey,
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      width: _currentPage == index ? 20 : 10,
    );
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: height * 0.35,
                          child: Image.asset(
                            contents[i].image,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          contents[i].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: (width <= 550) ? 22 : 26,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: width * 0.9,
                          child: Text(
                            contents[i].desc,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: (width <= 550) ? 14 : 18,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      contents.length,
                      (int index) => _buildDots(index: index),
                    ),
                  ),

                  // Botones
                  _currentPage + 1 == contents.length
                      ? Padding(
                          padding: const EdgeInsets.all(30),
                          child: ElevatedButton(
                            onPressed: _finishOnboarding,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: (width <= 550)
                                  ? const EdgeInsets.symmetric(
                                      horizontal: 60, vertical: 16)
                                  : EdgeInsets.symmetric(
                                      horizontal: width * 0.2, vertical: 25),
                              textStyle:
                                  TextStyle(fontSize: (width <= 550) ? 14 : 18),
                            ),
                            child: const Text("EMPEZAR"),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  _controller.jumpToPage(contents.length - 1);
                                },
                                style: TextButton.styleFrom(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: (width <= 550) ? 12 : 15,
                                  ),
                                ),
                                child: Text(
                                  "SALTAR",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding: (width <= 550)
                                      ? const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 16)
                                      : const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 25),
                                  textStyle: TextStyle(
                                    fontSize: (width <= 550) ? 12 : 15,
                                  ),
                                ),
                                child: const Text("SIGUIENTE"),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
