part of 'rocket_details_bloc.dart';


abstract class RocketDetailsEvent extends Equatable {
  const RocketDetailsEvent();
  @override
  List<Object> get props => [];
}

class FetchRocketDetails extends RocketDetailsEvent {
  final String rocketId;
  const FetchRocketDetails(this.rocketId);
  @override
  List<Object> get props => [rocketId];
}
