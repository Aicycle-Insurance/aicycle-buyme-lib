import '../../core/network/dio_client.dart';
import '../../features/aicycle_buy_me/data/data_sources/buy_me_remote_data_source.dart';
import '../../features/aicycle_buy_me/data/repositories/buy_me_repository_impl.dart';
import '../../features/aicycle_buy_me/domain/repositories/buy_me_repository.dart';
import '../../features/aicycle_buy_me/domain/use_cases/create_buyme_folder_use_case.dart';
import '../../features/aicycle_buy_me/domain/use_cases/get_directional_image_use_case.dart';

import '../utils/logger.dart';

/// Centralized dependency injection for the AiCycle SDK.
/// This class manages the instantiation of all core components,
/// ensuring that implementation details are hidden from the presentation layer.
class AiCycleInjection {
  AiCycleInjection._();

  static final AiCycleInjection _instance = AiCycleInjection._();
  factory AiCycleInjection() => _instance;

  // --- Core ---
  late final LoggerService logger = LoggerService();
  late final DioClient _dioClient = DioClient(logger);

  // --- Data Sources ---
  late final BuyMeRemoteDataSource _buyMeRemoteDataSource =
      BuyMeRemoteDataSourceImpl(_dioClient);

  // --- Repositories ---
  late final BuyMeRepository _buyMeRepository = BuyMeRepositoryImpl(
    _buyMeRemoteDataSource,
  );

  // --- Use Cases ---
  late final CreateBuyMeFolderUseCase createBuyMeFolderUseCase =
      CreateBuyMeFolderUseCase(_buyMeRepository);

  late final GetDirectionalImagesUseCase getDirectionalImagesUseCase =
      GetDirectionalImagesUseCase(_buyMeRepository);
}

/// Global instance for accessing dependencies.
final sl = AiCycleInjection();
