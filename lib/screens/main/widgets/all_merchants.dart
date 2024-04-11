import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/merchant.dart';

class AllMerchants extends StatelessWidget {
  const AllMerchants({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("merchants")
            .where("isAvailable", isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final merchantDocs = snapshot.data?.docs ?? [];

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "All merchants",
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
                  merchantDocs.length,
                  (index) {
                    final merchantData = merchantDocs[index].data();
                    final merchant = Merchant.fromMap(merchantData);

                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12.0, bottom: 12.0),
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
                                    merchant.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  merchant.name,
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
                    );
                  },
                ),
              )
            ],
          );
        });
  }
}
