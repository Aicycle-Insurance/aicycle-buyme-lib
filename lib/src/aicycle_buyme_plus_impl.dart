import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../../aicycle_buyme_plus.dart';
import 'core/di/injection.dart';
import 'features/aicycle_buy_me/domain/use_cases/create_buyme_folder_use_case.dart';
import 'features/aicycle_buy_me/presentation/buy_me_page.dart';

/// The main entry point for the SDK as a Widget.
///
/// This widget handles SDK initialization and shows a loading state.
/// Once initialized, it navigates to the main flow or calls [onSuccess].
class AiCycleBuyMe extends StatefulWidget {
  /// Cấu hình SDK
  final AiCycleConfig aiCycleConfig;

  /// Callback when initialization fails
  final Function(String error)? onError;

  /// Callback when initialization succeeds.
  /// If provided, the widget will not automatically navigate to the default flow.
  final VoidCallback? onSuccess;

  /// Custom loading widget to show during initialization
  final Widget? loadingWidget;

  const AiCycleBuyMe({
    super.key,
    required this.aiCycleConfig,
    this.onError,
    this.onSuccess,
    this.loadingWidget,
  });

  static AiCycleConfig? _config;

  /// Get the current configuration. Throws if not initialized.
  static AiCycleConfig get config {
    if (_config == null) {
      throw StateError(
        'AiCycleBuyMe has not been initialized. Ensure AiCycleBuyMe widget is in the tree.',
      );
    }
    return _config!;
  }

  @override
  State<AiCycleBuyMe> createState() => _AiCycleBuyMeState();
}

class _AiCycleBuyMeState extends State<AiCycleBuyMe> {
  final ValueNotifier<bool> _loadingNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _initSDK();
  }

  @override
  void dispose() {
    _loadingNotifier.dispose();
    super.dispose();
  }

  Future<void> _initSDK() async {
    try {
      _loadingNotifier.value = true;
      // 1. Set global configuration
      AiCycleBuyMe._config = widget.aiCycleConfig;

      // 2. Simulate or perform any async initialization
      // 2. Create the document in the backend
      await sl.createBuyMeFolderUseCase(
        CreateBuyMeFolderParams(
          externalClaimId: widget.aiCycleConfig.documentId,
          claimName:
              widget.aiCycleConfig.documentName ??
              widget.aiCycleConfig.documentId,
          vehicleBrandId: '5',
          priceTypeId: 10,
          isClaim: false,
          brand: widget.aiCycleConfig.carInformation.brand,
          model: widget.aiCycleConfig.carInformation.model,
          vehicleYear: widget.aiCycleConfig.carInformation.vehicleYear,
          vehicleSpec: widget.aiCycleConfig.carInformation.vehicleSpec,
          licensePlate: widget.aiCycleConfig.carInformation.licensePlate,
          vehicleType:
              widget.aiCycleConfig.carInformation.vehicleType ?? 'truck',
          hasLicensePlate:
              widget.aiCycleConfig.carInformation.licensePlate?.isNotEmpty ==
              true,
        ),
      );

      if (!mounted) return;
      _loadingNotifier.value = false;
    } catch (e) {
      if (!mounted) return;
      _loadingNotifier.value = false;
      if (widget.onError != null) {
        widget.onError!(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ValueListenableBuilder<bool>(
        valueListenable: _loadingNotifier,
        builder: (context, isLoading, child) {
          if (isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return const BuyMePage();
        },
      ),
    );
  }
}
