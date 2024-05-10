import '../../enum/app_state.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../network/api_error.dart';

class BaseStatus {
  final String? message;
  final AppState state;

  BaseStatus({
    required this.message,
    this.state = AppState.init,
  });
}

abstract class BuyMeBaseController extends FullLifeCycleController {
  final RxBool isLoading = true.obs;
  final Rx<BaseStatus> status = Rx<BaseStatus>(BaseStatus(message: null));

  @override
  void onInit() {
    isLoading(false);
    super.onInit();
  }

  void onRefresh() async {}

  void onLoading() async {}

  void processUsecaseResult<T>({
    required Either<APIErrors, T> result,
    Function(T)? onSuccess,
    Function(APIErrors)? onFail,
    bool? shouldShowError,
    bool? isRefreshing,
    // RefreshController? controller,
  }) {
    result.fold((error) {
      isLoading(false);
      if (shouldShowError ?? true && error is! NoMessageError) {
        if (error is NoInternetError) {
          // Utils.instance.showError(
          //   error: error,
          //   message: 'No internet',
          // );
          status.value = BaseStatus(
            message: 'No internet',
            state: AppState.failed,
          );
        } else {
          // Utils.instance.showError(
          //   error: error,
          //   message: error.details.toString(),
          // );
          if (error.details.toString().toLowerCase().contains('connection') ||
              error.details
                  .toString()
                  .toLowerCase()
                  .contains('can\'t assign requested address')) {
            status.value = BaseStatus(
              message: 'Connection aborted',
              state: AppState.failed,
            );
          } else {
            status.value = BaseStatus(
              message: error.details.toString(),
              state: AppState.failed,
            );
          }
        }
      }
      if (onFail != null) {
        onFail(error);
      }
      // if ((controller ?? refreshController) != null && isRefreshing != null) {
      //   isRefreshing
      //       ? (controller ?? refreshController)!.refreshFailed()
      //       : (controller ?? refreshController)!.loadFailed();
      // }
    }, (data) {
      isLoading(false);
      if (onSuccess != null) {
        onSuccess(data);
      }
      // if ((controller ?? refreshController) != null && isRefreshing != null) {
      //   if (isRefreshing) {
      //     (controller ?? refreshController)!
      //         .refreshCompleted(resetFooterState: true);
      //   } else {
      //     if (data is List && data.isEmpty) {
      //       (controller ?? refreshController)!.loadNoData();
      //     } else {
      //       (controller ?? refreshController)!.loadComplete();
      //     }
      //   }
      // }
    });
  }
}
