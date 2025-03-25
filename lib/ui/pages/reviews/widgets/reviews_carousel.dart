import 'package:conference_app/ui/pages/reviews/widgets/reviews_card.dart';
import 'package:flutter/material.dart';

class ReviewsCarousel extends StatefulWidget {
  const ReviewsCarousel({super.key});

  @override
  State<ReviewsCarousel> createState() => _ReviewsCarouselState();
}

class _ReviewsCarouselState extends State<ReviewsCarousel> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> reviews = [
    {
      "review":
          "Excelente evento, todo estuvo muy bien organizado. Volvería sin duda.",
      "date": "Jun 4"
    },
    {
      "review": "La música fue increíble, pero la comida podría mejorar.",
      "date": "Jun 5"
    },
    {
      "review":
          "Gran experiencia, conocí a mucha gente y los ponentes fueron top.",
      "date": "Jun 6"
    },
    {
      "review":
          "Me encantó el lugar, pero la organización de las charlas fue un poco caótica.",
      "date": "Jun 7"
    },
    {
      "review":
          "Excelente evento, todo estuvo muy bien organizado. Volvería sin duda.",
      "date": "Jun 4"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: _controller,
            itemCount: reviews.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: ReviewCard(
                  review: review["review"]!,
                  date: review["date"]!,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(reviews.length, (index) => _buildDots(index)),
        ),
      ],
    );
  }

  AnimatedContainer _buildDots(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: _currentPage == index
            ? Theme.of(context).colorScheme.primary
            : Colors.grey,
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: _currentPage == index ? 16 : 8,
    );
  }
}
