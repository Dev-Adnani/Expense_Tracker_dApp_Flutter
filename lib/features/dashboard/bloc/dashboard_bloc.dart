

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardFetchInitialEvent>(dashboardFetchInitialEvent);
  }

  FutureOr<void> dashboardFetchInitialEvent(DashboardFetchInitialEvent event, Emitter<DashboardState> emit) 
  {
    emit(DashboardLoading());
    
  }
}
