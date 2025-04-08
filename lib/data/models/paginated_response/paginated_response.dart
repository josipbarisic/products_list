import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_response.freezed.dart';

@freezed
class PaginatedResponse<T> with _$PaginatedResponse<T> {
  const factory PaginatedResponse({
    required List<T> items,
    required int loadedItems,
    required int totalItems,
    required int totalPages,
    required int currentPage,
  }) = _PaginatedResponse<T>;
}
