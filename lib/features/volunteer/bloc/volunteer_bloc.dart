import 'package:dhap_flutter_project/data/model/task_model.dart';
import 'package:dhap_flutter_project/data/repository/task_repository.dart';
import 'package:dhap_flutter_project/data/repository/user_repository.dart';
import 'package:dhap_flutter_project/features/volunteer/bloc/volunteer_event.dart';
import 'package:dhap_flutter_project/features/volunteer/bloc/volunteer_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final TaskRepository _taskRepository = TaskRepository();
final UserRepository _userRepository = UserRepository();


class volunteerBloc extends Bloc<volunteerEvent, volunteerState> {
  volunteerBloc() : super(volunteerInitial()) {
    on<FetchPendingTasksEvent>((event, emit) async {
      emit(volunteerLoading());
      try {
        final tasks = await _taskRepository.getAllTasks();
        final pendingTasks = tasks
            .where(
              (task) =>
                  task.Status == 'Pending' || task.Status == 'In Progress' && task.volunteer > task.volunteersAccepted,
            )
            .toList();
        emit(
          volunteerSuccess(
            message: 'Tasks fetched successfully',
            tasks: pendingTasks,
          ),
        );
      } catch (e) {
        emit(volunteerFailure(error: e.toString()));
      }
    });

    on<FetchMyTasksEvent>((event, emit) async {
      emit(volunteerLoading());
      try {
        final tasks = await _taskRepository.getAllTasks();
        print("All tasks: $tasks");
        print("Task ID: ${event.taskIds}");
        final myTasks = tasks
            .where(
              (task) => event.taskIds.contains(task.id),
            )
            .toList();
        print("My tasks: $myTasks");
        emit(
          volunteerSuccess(
            message: 'Tasks fetched successfully',
            tasks: myTasks,
          ),
        );
      } catch (e) {
        emit(volunteerFailure(error: e.toString()));
      }
    });

    on<SubmitProofEvent>((event, emit) async {
      try {
        final tasks = await _taskRepository.getAllTasks();

        debugPrint("Files: ${event.files}");

        final taskIndex = tasks.indexWhere((t) => t.id == event.taskId);
        if (taskIndex == -1) throw Exception("Task not found");

        final task = tasks[taskIndex];

        final newProof = Proof(
          message: event.message,
          mediaPaths: event.files,
        );

        task.proofs = [...task.proofs, newProof];

        task.Status = "In Verification";

        await _taskRepository.updateTask(task);

        print("task: ${newProof.mediaPaths}");

        emit(volunteerSuccess(
          message: "Proof submitted successfully",
          tasks: tasks,
        ));
      } catch (e) {
        emit(volunteerFailure(error: e.toString()));
      }
    });

    on<AcceptTaskEvent>((event, emit) async {
      try {
        emit(volunteerLoading());
        await _userRepository.acceptTask(event.taskId, event.userEmail);
        await _userRepository.getUserByEmail(event.userEmail);

        emit(AcceptSuccess(message: "Task accepted successfully"));
      } catch (e) {
        emit(volunteerFailure(error: e.toString()));
      }

    });
  }

}
