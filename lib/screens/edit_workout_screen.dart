import 'package:app_schedule_bloc/blocs/workout_cubit.dart';
import 'package:app_schedule_bloc/blocs/workouts_cubit.dart';
import 'package:app_schedule_bloc/helpers.dart';
import 'package:app_schedule_bloc/models/exercise.dart';
import 'package:app_schedule_bloc/models/workout.dart';
import 'package:app_schedule_bloc/states/workout_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'edit_exercise_screen.dart';

class EditWorkoutScreen extends StatelessWidget {
  const EditWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: BlocBuilder<WorkoutCubit, WorkoutState>(
          builder: (context, state) {
            WorkoutEditing we = state as WorkoutEditing;
            return Scaffold(
              appBar: AppBar(
                leading: BackButton(
                  onPressed: () =>
                      BlocProvider.of<WorkoutCubit>(context).goHome(),
                ),
                title: InkWell(
                  child: Text(we.workout!.title!),
                  onTap: () => showDialog(
                      context: context,
                      builder: (_) {
                        final controller =
                            TextEditingController(text: we.workout!.title);
                        return AlertDialog(
                          content: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                                labelText: "Workout title"),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  if (controller.text.isNotEmpty) {
                                    Navigator.pop(context);
                                    Workout renamed = we.workout!
                                        .copyWith(title: controller.text);
                                    BlocProvider.of<WorkoutsCubit>(context)
                                        .saveWorkout(renamed, we.index);
                                    BlocProvider.of<WorkoutCubit>(context)
                                        .editWorkout(renamed, we.index);
                                  }
                                },
                                child: const Text("Rename")),
                          ],
                        );
                      }),
                ),
              ),
              body: ListView.builder(
                itemCount: we.workout!.exercises.length,
                itemBuilder: (context, index) {
                  Exercise exercise = we.workout!.exercises[index];
                  if (we.exIndex == index) {
                    return EditExerciseScreen(
                      workout: we.workout,
                      index: we.index,
                      exIndex: we.exIndex,
                    );
                  } else {
                    return ListTile(
                      leading: Text(formatTime(exercise.prelude!, true)),
                      title: Text(exercise.title!),
                      trailing: Text(formatTime(exercise.duration!, true)),
                      onTap: () => BlocProvider.of<WorkoutCubit>(context)
                          .editExercise(index),
                    );
                  }
                },
              ),
            );
          },
        ),
        onWillPop: () => BlocProvider.of<WorkoutCubit>(context).goHome());
  }
}
