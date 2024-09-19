// ignore_for_file: must_be_immutable

import 'package:aicycle_buyme_lib/aicycle_buyme_lib.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../enum/car_model.dart';
import '../../../../enum/car_part_direction.dart';

class GuideFrame extends StatelessWidget {
  final CarPartDirectionEnum carPartDirectionEnum;
  final CarModelEnum carModelEnum;

  GuideFrame({
    super.key,
    required this.carPartDirectionEnum,
    required this.carModelEnum,
  });

  var scaleImageValue = 1.0.obs;

  @override
  Widget build(BuildContext context) {
    final scrWidth = MediaQuery.of(context).size.width;
    return RotatedBox(
      quarterTurns: 1,
      child: Obx(
        () {
          return Stack(
            children: [
              Center(
                child: Transform.scale(
                  scale: scaleImageValue(),
                  child: carModelEnum.imagePath(carPartDirectionEnum).isNotEmpty
                      ? Image.asset(
                          carModelEnum.imagePath(carPartDirectionEnum),
                          fit: BoxFit.cover,
                          package: packageName,
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              if (carModelEnum != CarModelEnum.truck)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: RotatedBox(
                      quarterTurns: 0,
                      child: SizedBox(
                        height: 32,
                        width: scrWidth / 2,
                        child: Slider.adaptive(
                          min: 0.5,
                          max: 1,
                          activeColor: Colors.white,
                          inactiveColor: Colors.white38,
                          value: scaleImageValue(),
                          onChanged: scaleImageValue.call,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
