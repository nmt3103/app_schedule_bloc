import 'package:app_schedule_bloc/blocs/workout_cubit.dart';
import 'package:app_schedule_bloc/helpers.dart';
import 'package:app_schedule_bloc/models/exercise.dart';
import 'package:app_schedule_bloc/models/workout.dart';
import 'package:app_schedule_bloc/states/workout_states.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutInProgessScreen extends StatelessWidget {
  const WorkoutInProgessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _getStats(Workout workout, int workoutElapsed) {
      int workoutTotal = workout.getTotal();
      Exercise exercise = workout.getCurrentExercise(workoutElapsed);
      int exerciseElapsed = workoutElapsed - exercise.startTime!;
      int exerciseRemaining = exercise.prelude! - exerciseElapsed;
      bool isPrelude = exerciseElapsed < exercise.prelude!;
      bool isLast = (exercise.index == (workout.exercises.length - 1));
      String messageBottom = "Almost done! This is the last exercise";
      int timeNext = workoutTotal;
      if (!isLast) {
        Exercise nextExer = workout.exercises.elementAt(exercise.index! + 1);
        timeNext = nextExer.startTime!;
        messageBottom = workout.exercises.elementAt(exercise.index! + 1).title!;
      }
      int exerciseTotal = isPrelude ? exercise.prelude! : exercise.duration!;
      if (!isPrelude) {
        exerciseElapsed -= exercise.prelude!;
        exerciseRemaining += exercise.duration!;
      }
      return {
        "nextExerciseStartTime": timeNext,
        "nextExercise": messageBottom,
        "exerciseTitle": exercise.title,
        "workoutTitle": workout.title,
        "workoutProgess": workoutElapsed / workoutTotal,
        "workoutElasped": workoutElapsed,
        "totalExercises": workout.exercises.length,
        "currentExerciseIndex": exercise.index!.toDouble(),
        "workoutRemaining": workoutTotal - workoutElapsed,
        "exerciseRemaining": exerciseRemaining.toString(),
        "exerciseProgress": exerciseElapsed / exerciseTotal,
        "isPrelude": isPrelude,
        "isLast": isLast
      };
    }

    return BlocConsumer<WorkoutCubit, WorkoutState>(
      builder: (context, state) {
        final stats = _getStats(state.workout!, state.elapsed!);
        return Scaffold(
          appBar: AppBar(
            title: Text(state.workout!.title.toString()),
            leading: BackButton(
              onPressed: () => BlocProvider.of<WorkoutCubit>(context).goHome(),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LinearProgressIndicator(
                  backgroundColor: Colors.blue[100],
                  minHeight: 10,
                  value: stats['workoutProgess'],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatTime(stats['workoutElasped'], true)),
                      DotsIndicator(
                        dotsCount: stats['totalExercises'],
                        position: stats['currentExerciseIndex'],
                      ),
                      Text('-${formatTime(stats['workoutRemaining'], true)}')
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    stats['isPrelude']
                        ? "Get ready for\n${stats['exerciseTitle']}"
                        : " ${stats['exerciseTitle']}",
                    style: TextStyle(
                        color: stats['isPrelude'] ? Colors.red : Colors.blue,
                        fontSize: 25),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    if (state is WorkoutInProgress) {
                      BlocProvider.of<WorkoutCubit>(context).pauseWorkout();
                    } else if (state is WorkoutPaused) {
                      BlocProvider.of<WorkoutCubit>(context).resumeWorkout();
                    }
                  },
                  child: Stack(
                    alignment: const Alignment(0, 0),
                    children: [
                      Center(
                        child: SizedBox(
                          height: 220,
                          width: 220,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                stats['isPrelude'] ? Colors.red : Colors.blue),
                            strokeWidth: 25,
                            value: stats['exerciseProgress'],
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: 285,
                          height: 285,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Image.asset('stopwatch.png'),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            stats['exerciseRemaining'],
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    BlocProvider.of<WorkoutCubit>(context)
                        .skipExercise(stats['nextExerciseStartTime']);
                  },
                  child: Text(stats['isLast']
                      ? stats['nextExercise']
                      : "Next exercise : ${stats['nextExercise']}"),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
