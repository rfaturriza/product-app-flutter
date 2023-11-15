part of 'search_product_bloc.dart';

@freezed
class SearchProductEvent with _$SearchProductEvent {

  const factory SearchProductEvent.searchProduct({
    @Default(emptyString) String query,
    int? limit,
    int? skip,
  }) = _SearchProductEvent;

  const factory SearchProductEvent.checkIfNeedMoreData({
    @Default(0) int index,
  }) = _CheckIfNeedMoreDataEvent;
}
