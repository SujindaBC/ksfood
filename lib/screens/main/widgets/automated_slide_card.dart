import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AutomatedSlideCard extends StatelessWidget {
  const AutomatedSlideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Featured Merchants",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        CarouselSlider(
          items: List.generate(
            10,
            (index) {
              return Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Badge(
                  label: const Text("Sale"),
                  offset: const Offset(-24, 8),
                  child: Container(
                    width: 125,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black.withAlpha(50),
                      ),
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ),
                    ),
                    child: AspectRatio(
                      aspectRatio: 2 / 2.5,
                      child: Center(
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 1 / 1,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(7.0),
                                  topRight: Radius.circular(7.0),
                                ),
                                child: Image.network(
                                  "https://i0.wp.com/goodlifeupdate.com/app/uploads/2021/04/image-132-edited-1.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                "Featured Merchantssss ${index += 1}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          options: CarouselOptions(
            padEnds: false,
            height: 175,
            initialPage: 0,
            viewportFraction: 0.38,
            autoPlay: true,
            autoPlayInterval: const Duration(
              seconds: 5,
            ),
          ),
        ),
      ],
    );
  }
}
