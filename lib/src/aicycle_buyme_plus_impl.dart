import 'package:aicycle_buyme_plus/src/core/utils/screen_utils.dart';
import 'package:aicycle_buyme_plus/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../aicycle_buyme_plus.dart';
import 'features/aicycle_buy_me/presentation/buy_me_page.dart';
import 'features/aicycle_buy_me/presentation/controllers/buy_me_controller.dart';

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
  final Function(dynamic data)? onComplete;

  const AiCycleBuyMe({
    super.key,
    required this.aiCycleConfig,
    this.onError,
    this.onComplete,
  });

  static AiCycleConfig? configInternal;

  /// Get the current configuration. Throws if not initialized.
  static AiCycleConfig get config {
    if (configInternal == null) {
      throw StateError(
        'AiCycleBuyMe has not been initialized. Ensure AiCycleBuyMe widget is in the tree.',
      );
    }
    return configInternal!;
  }

  @override
  State<AiCycleBuyMe> createState() => _AiCycleBuyMeState();
}

class _AiCycleBuyMeState extends State<AiCycleBuyMe> {
  late final BuyMeController _controller;

  @override
  void initState() {
    super.initState();
    // Lock orientation to portrait when using the package
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controller = BuyMeController();
    _controller.addListener(_onStatusChanged);
    _controller.init(widget.aiCycleConfig);
  }

  void _onStatusChanged() {
    if (_controller.status == BuyMeStatus.error) {
      if (widget.onError != null) {
        widget.onError!(_controller.errorMessage);
      }
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    // Reset orientation to allow all when leaving the package
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _controller.removeListener(_onStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          if (_controller.status == BuyMeStatus.loading ||
              _controller.status == BuyMeStatus.initial) {
            return widget.aiCycleConfig.displayConfig.loadingWidget ??
                const Center(child: CircularProgressIndicator());
          }

          if (_controller.status == BuyMeStatus.success) {
            return BuyMePage(
              controller: _controller,
              config: widget.aiCycleConfig,
              onComplete: widget.onComplete,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
