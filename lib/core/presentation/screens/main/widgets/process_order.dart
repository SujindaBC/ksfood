import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ksfood/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:timelines/timelines.dart';

const completeColor = Color(0xFF5DB329);
const inProgressColor = Color(0xFF5DB329);
const todoColor = Color(0xffd1d2d7);

class ProcessOrder extends StatefulWidget {
  const ProcessOrder({super.key});

  @override
  State<ProcessOrder> createState() => _ProcessOrderState();
}

class _ProcessOrderState extends State<ProcessOrder> {
  
  final int _processIndex = 0;

  Color getColor(int index) {
    if (index == _processIndex) {
      return inProgressColor;
    } else if (index < _processIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("userId", isEqualTo: authBloc.state.user!.uid)
            .where("status", isEqualTo: "paid")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CupertinoActivityIndicator(); // Or any loading indicator
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const SizedBox();
          }
          return Column(
            children: [
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Processing orders",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var order = snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.black.withAlpha(50),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order #${order.id}",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    fontSize: 10.0,
                                  ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              child: Center(
                                child: Timeline.tileBuilder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  theme: TimelineThemeData(
                                    direction: Axis.horizontal,
                                    connectorTheme: const ConnectorThemeData(
                                      space: 4.0,
                                      thickness: 4.0,
                                    ),
                                  ),
                                  builder: TimelineTileBuilder.connected(
                                    connectionDirection:
                                        ConnectionDirection.before,
                                    itemExtentBuilder: (_, __) =>
                                        MediaQuery.of(context).size.width /
                                        (_processes.length * 1.2),
                                    contentsBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        child: Text(
                                          _processes[index],
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                fontSize: 8,
                                                color: getColor(index),
                                              ),
                                        ),
                                      );
                                    },
                                    indicatorBuilder: (_, index) {
                                      Color color;
                                      Widget? child;
                                      if (index == _processIndex) {
                                        color = inProgressColor;
                                        child = Center(
                                          child: FaIcon(
                                            _processIcons[_processIndex],
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        );
                                      } else if (index < _processIndex) {
                                        color = completeColor;
                                        child = const Center(
                                          child: FaIcon(
                                            FontAwesomeIcons.check,
                                            color: Colors.white,
                                            size: 15.0,
                                          ),
                                        );
                                      } else {
                                        color = todoColor;
                                      }

                                      if (index <= _processIndex) {
                                        return Stack(
                                          children: [
                                            CustomPaint(
                                              painter: _BezierPainter(
                                                color: color,
                                                drawStart: index > 0,
                                                drawEnd: index < _processIndex,
                                              ),
                                            ),
                                            DotIndicator(
                                              size: 25.0,
                                              color: color,
                                              child: child,
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Stack(
                                          children: [
                                            CustomPaint(
                                              painter: _BezierPainter(
                                                color: color,
                                                drawEnd: index <
                                                    _processes.length - 1,
                                              ),
                                            ),
                                            OutlinedDotIndicator(
                                              borderWidth: 4.0,
                                              color: color,
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                    connectorBuilder: (_, index, type) {
                                      if (index > 0) {
                                        if (index == _processIndex) {
                                          final prevColor = getColor(index - 1);
                                          final color = getColor(index);
                                          List<Color> gradientColors;
                                          if (type == ConnectorType.start) {
                                            gradientColors = [
                                              Color.lerp(
                                                  prevColor, color, 0.5)!,
                                              color
                                            ];
                                          } else {
                                            gradientColors = [
                                              prevColor,
                                              Color.lerp(prevColor, color, 0.5)!
                                            ];
                                          }
                                          return DecoratedLineConnector(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: gradientColors,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return SolidLineConnector(
                                            color: getColor(index),
                                          );
                                        }
                                      } else {
                                        return null;
                                      }
                                    },
                                    itemCount: _processes.length,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },
              ),
            ],
          );
        });
  }
}

class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    required this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    double angle;
    Offset offset1;
    Offset offset2;

    Path path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius, radius)
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(
            size.width, size.height / 2, size.width + radius, radius)
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawStart != drawStart ||
        oldDelegate.drawEnd != drawEnd;
  }
}

final _processes = [
  "Wait for Accept",
  "Prepairing",
  "Picking up",
  "Delivering",
  "Delivered"
];

final _processIcons = [
  FontAwesomeIcons.cashRegister,
  FontAwesomeIcons.utensils,
  FontAwesomeIcons.bagShopping,
  FontAwesomeIcons.personBiking,
  FontAwesomeIcons.houseCircleCheck,
];
