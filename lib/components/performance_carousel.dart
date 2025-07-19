import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:classbridge/model/student_performance.dart';
import 'package:classbridge/components/performance_graph_card.dart';

class PerformanceCarousel extends StatefulWidget {
  final List<SubjectPerformance> performances;

  const PerformanceCarousel({
    Key? key,
    required this.performances,
  }) : super(key: key);

  @override
  State<PerformanceCarousel> createState() => _PerformanceCarouselState();
}

class _PerformanceCarouselState extends State<PerformanceCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 350,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.performances.map((performance) {
            return PerformanceGraphCard(performance: performance);
          }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.performances.asMap().entries.map((entry) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade300,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}