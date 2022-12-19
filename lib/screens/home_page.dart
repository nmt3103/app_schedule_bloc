import 'package:app_schedule_bloc/blocs/workout_cubit.dart';
import 'package:app_schedule_bloc/blocs/workouts_cubit.dart';
import 'package:app_schedule_bloc/helpers.dart';
import 'package:app_schedule_bloc/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Time!'),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.event_available)),
          IconButton(onPressed: null, icon: Icon(Icons.settings)),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<WorkoutsCubit, List<Workout>>(
          builder: (context, workouts) => ExpansionPanelList.radio(
            children: workouts
                .map((workout) => ExpansionPanelRadio(
                      value: workout,
                      headerBuilder: (context, isExpanded) => ListTile(
                        visualDensity: const VisualDensity(
                            horizontal: 0,
                            vertical: VisualDensity.maximumDensity),
                        leading: IconButton(
                            onPressed: () {
                              BlocProvider.of<WorkoutCubit>(context)
                                  .editWorkout(
                                      workout, workouts.indexOf(workout));
                            },
                            icon: const Icon(Icons.edit)),
                        title: Text(workout.title!),
                        trailing: Text(formatTime(workout.getTotal(), true)),
                        onTap: () => !isExpanded
                            ? BlocProvider.of<WorkoutCubit>(context)
                                .startWorkout(workout)
                            : null,
                      ),
                      body: ListView.builder(
                        shrinkWrap: true,
                        itemCount: workout.exercises.length,
                        itemBuilder: (context, index) => ListTile(
                          onTap: null,
                          visualDensity: const VisualDensity(
                              horizontal: 0,
                              vertical: VisualDensity.maximumDensity),
                          leading: Text(formatTime(
                              workout.exercises[index].prelude!, true)),
                          title: Text(workout.exercises[index].title!),
                          trailing: Text(formatTime(
                              workout.exercises[index].duration!, true)),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
