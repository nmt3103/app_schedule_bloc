import 'package:app_schedule_bloc/blocs/workouts_cubit.dart';
import 'package:app_schedule_bloc/models/workout.dart';
import 'package:app_schedule_bloc/screens/edit_workout_screen.dart';
import 'package:app_schedule_bloc/screens/home_page.dart';
import 'package:app_schedule_bloc/screens/workout_in_progress.dart';
import 'package:app_schedule_bloc/states/workout_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'blocs/workout_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  HydratedBlocOverrides.runZoned(() => runApp(const WorkoutTime()),
      storage: storage);
}

class WorkoutTime extends StatelessWidget {
  const WorkoutTime({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Workouts',
      theme: ThemeData(
          primaryColor: Colors.blue,
          textTheme: const TextTheme(
              bodyText2: TextStyle(color: Color.fromARGB(255, 66, 74, 96)))),
      home: MultiBlocProvider(
          providers: [
            BlocProvider<WorkoutsCubit>(
              create: (context) {
                WorkoutsCubit workoutsCubit = WorkoutsCubit();
                if (workoutsCubit.state.isEmpty) {
                  print("json is loanding .... ");
                  workoutsCubit.getWorkouts();
                }
                return workoutsCubit;
              },
            ),
            BlocProvider<WorkoutCubit>(create: (context) => WorkoutCubit()),
          ],
          child: BlocBuilder<WorkoutCubit, WorkoutState>(
            builder: (context, state) {
              if (state is WorkoutIntial) {
                return const HomePage();
              } else if (state is WorkoutEditing) {
                return EditWorkoutScreen();
              }
              return WorkoutInProgessScreen();
            },
          )),
    );
  }
}
