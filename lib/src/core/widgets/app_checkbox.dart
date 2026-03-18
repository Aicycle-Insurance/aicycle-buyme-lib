import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 16,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: value ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: value ? AppColors.primary : AppColors.borderGray,
            width: 1,
          ),
        ),
        child: value
            ? Center(
                child: Icon(
                  Icons.check_rounded,
                  size: size * 0.8,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }
}
