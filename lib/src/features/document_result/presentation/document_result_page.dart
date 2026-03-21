import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:flutter/material.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import 'controllers/document_result_controller.dart';
import 'widgets/car_info_container.dart';

class DocumentResultPage extends StatefulWidget {
  const DocumentResultPage({super.key});

  @override
  State<DocumentResultPage> createState() => _DocumentResultPageState();
}

class _DocumentResultPageState extends State<DocumentResultPage> {
  late final DocumentResultController _controller;
  @override
  void initState() {
    super.initState();
    _controller = DocumentResultController(sl.getVehicleInfoUseCase);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        title: Text(
          AppStrings.documentResultTitle,
          style: AppTextStyles.heading2,
        ),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),

                /// Thông tin xe
                CarInfoContainer(vehicleInfo: _controller.vehicleInfo),
                SizedBox(height: 4.h),

                /// Thống kê vết hỏng
              ],
            ),
          );
        },
      ),
    );
  }
}
