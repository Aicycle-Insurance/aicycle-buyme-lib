import '../error/failures.dart';
import '../utils/result.dart';

/// Base UseCase interface for all use cases.
/// [T] is the return type of the use case.
/// [Params] is the parameter required for the use case.
abstract class UseCase<T, Params> {
  Future<Result<T, Failure>> call(Params params);
}

/// A class representing no parameters for use cases that don't need any.
class NoParams {
  const NoParams();
}
