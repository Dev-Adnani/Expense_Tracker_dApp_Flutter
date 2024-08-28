part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

class DashboardFetchInitialEvent extends DashboardEvent {}

class DashboardDepositEvent extends DashboardEvent {
  final TransactionModel model;

  DashboardDepositEvent({required this.model});
}

class DashboardWithdrawEvent extends DashboardEvent {
  final TransactionModel model;

  DashboardWithdrawEvent({required this.model});
}

class DashboardErrorEvent extends DashboardEvent {
  final String message;

  DashboardErrorEvent({required this.message});
}