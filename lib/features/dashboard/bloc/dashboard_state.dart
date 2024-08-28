part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardError extends DashboardState {
  final String message;

  DashboardError({required this.message});
}

class DashboardSuccess extends DashboardState {
  final int balance;
  final List<TransactionModel> transactions;

  DashboardSuccess({required this.balance, required this.transactions});
}

