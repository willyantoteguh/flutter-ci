import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../data/models/nav_item_model.dart';
import '../../data/models/rive_model.dart';
import '../../utils/app_color.dart';

class BottomNavWithAnimatedIcons extends StatefulWidget {
  const BottomNavWithAnimatedIcons({super.key});

  @override
  State<BottomNavWithAnimatedIcons> createState() =>
      _BottomNavWithAnimatedIconsState();
}

class _BottomNavWithAnimatedIconsState
    extends State<BottomNavWithAnimatedIcons> {
  List<SMIBool> riveIconInputs = [];
  List<StateMachineController?> stateMachineControllers = [];
  int selectedNavIndex = 0;

  void selectedRiveIcon(int index) {
    riveIconInputs[index].change(true);
    Future.delayed(const Duration(seconds: 1), () {
      riveIconInputs[index].change(false);
    });
  }

  void onInitRiveIcons(Artboard artboard, {required String stateMachineName}) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, stateMachineName);

    artboard.addController(controller!);
    stateMachineControllers.add(controller);

    riveIconInputs.add(controller.findInput<bool>("active") as SMIBool);
  }

  @override
  void dispose() {
    for (var itemController in stateMachineControllers) {
      itemController?.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(pages[selectedNavIndex])),
      bottomNavigationBar: SafeArea(
        child: Container(
          // height: 56,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
              color: bottomNavBgColor.withOpacity(0.8),
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                    color: bottomNavBgColor.withOpacity(0.3),
                    offset: const Offset(0, 20),
                    blurRadius: 20)
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(bottomNavItems.length, (index) {
              final riveIcon = bottomNavItems[index].rive;

              return GestureDetector(
                onTap: () {
                  selectedRiveIcon(index);
                  setState(() {
                    selectedNavIndex = index;
                    log(selectedNavIndex.toString());
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedTapBar(isActive: selectedNavIndex == index),
                    SizedBox(
                      height: 36,
                      width: 36,
                      child: Opacity(
                        opacity: selectedNavIndex == index ? 1 : 0.5,
                        child: RiveAnimation.asset(
                          riveIcon.path,
                          artboard: riveIcon.artboard,
                          onInit: (artboard) {
                            onInitRiveIcons(artboard,
                                stateMachineName: riveIcon.stateMachineName);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class AnimatedTapBar extends StatelessWidget {
  const AnimatedTapBar({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 2),
      height: 4,
      width: (isActive) ? 20 : 0,
      decoration: BoxDecoration(
          color: borderBarColor, borderRadius: BorderRadius.circular(12)),
    );
  }
}
