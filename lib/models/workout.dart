import 'package:app_schedule_bloc/models/exercise.dart';
import 'package:equatable/equatable.dart';

class Workout extends Equatable {
  final String? title;
  final List<Exercise> exercises;
  const Workout({required this.title, required this.exercises});

  factory Workout.fromJson(Map<String, dynamic> json) {
    List<Exercise> exercises = [];
    int index = 0;
    int startTime = 0;
    for (var ex in (json['exercises'] as Iterable)) {
      exercises.add(Exercise.fromJson(ex, index, startTime));
      index++;
      startTime += exercises.last.prelude! + exercises.last.duration!;
    }
    return Workout(title: json['title'] as String?, exercises: exercises);
  }

  Map<String, dynamic> toJson() => {'title': title, 'exercises': exercises};

  Workout copyWith({String? title}) =>
      Workout(title: title ?? this.title, exercises: exercises);

  int getTotal() {
    int time = exercises.fold(
        0, (previousValue, ex) => previousValue + ex.duration! + ex.prelude!);
    return time;
  }

  Exercise getCurrentExercise(int? elapsed) {
    return exercises.lastWhere((element) => element.startTime! <= elapsed!);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [title, exercises];

  @override
  // TODO: implement stringify
  bool? get stringify => true;
}
