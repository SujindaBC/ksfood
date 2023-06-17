import 'package:flutter/material.dart';

class NearbyMerchants extends StatelessWidget {
  const NearbyMerchants({super.key});

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
                "Nearby Merchants",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
            10,
            (index) {
              return Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12.0, bottom: 12.0),
                child: Badge(
                  backgroundColor: Colors.white.withAlpha(99),
                  textColor: Colors.black,
                  label: const Text("2.5km away"),
                  offset: const Offset(-65, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black.withAlpha(50),
                      ),
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 2.35 / 1,
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
                          const SizedBox(height: 8.0),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
