import "package:flutter/material.dart";
import "package:flutter_image_slideshow/flutter_image_slideshow.dart";

class AdsSlide extends StatelessWidget {
  const AdsSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: ImageSlideshow(
          initialPage: 0,
          indicatorColor: Theme.of(context).primaryColor,
          autoPlayInterval: 7000,
          isLoop: true,
          children: [
            Image.network(
              "https://freshcart.codescandy.com/assets/images/slider/slide-1.jpg",
              fit: BoxFit.cover,
            ),
            Image.network(
              "https://freshcart.codescandy.com/assets/images/slider/slider-2.jpg",
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
