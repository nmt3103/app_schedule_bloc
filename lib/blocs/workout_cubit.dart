import 'dart:async';

import 'package:app_schedule_bloc/models/workout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock/wakelock.dart';

import '../states/workout_states.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  WorkoutCubit() : super(const WorkoutIntial());

  Timer? _timer;

  editWorkout(Workout workout, int index) {
    return emit(WorkoutEditing(workout, index, null));
  }

  editExercise(int? exIndex) {
    return emit(WorkoutEditing(
        state.workout, (state as WorkoutEditing).index, exIndex));
  }

  pauseWorkout() {
    emit(WorkoutPaused(state.workout, state.elapsed));
  }

  resumeWorkout() {
    emit(WorkoutInProgress(state.workout, state.elapsed));
  }

  skipExercise(int? startTime) {
    emit(WorkoutInProgress(state.workout, startTime));
  }

  goHome() {
    emit(const WorkoutIntial());
  }

  onTick(Timer timer) {
    if (state is WorkoutInProgress) {
      WorkoutInProgress wips = state as WorkoutInProgress;
      if (wips.elapsed! < wips.workout!.getTotal()) {
        emit(WorkoutInProgress(wips.workout!, wips.elapsed! + 1));
      } else {
        _timer!.cancel();
        _timer = null;
        Wakelock.disable();
        emit(const WorkoutIntial());
      }
    }
  }

  startWorkout(Workout workout, [int? index]) {
    Wakelock.enable();
    if (index != null) {
    } else {
      emit(WorkoutInProgress(workout, 0));
      // _timer = Timer.periodic(const Duration(seconds: 1), onTick);
    }
    if (_timer == null) {
      _timer = Timer.periodic(const Duration(seconds: 1), onTick);
    } else {
      print("timer alredy have");
    }
  }
}
