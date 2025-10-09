abstract class volunteerEvent {}

class FetchPendingTasksEvent extends volunteerEvent{}

class FetchMyTasksEvent extends volunteerEvent{
  final List<int> taskIds;

  FetchMyTasksEvent({required this.taskIds});

}

class SubmitProofEvent extends volunteerEvent {
  final int taskId;
  final String message;
  final List<String> files;

  SubmitProofEvent({
    required this.taskId,
    required this.message,
    required this.files,
  });
}

class AcceptTaskEvent extends volunteerEvent {
  final int taskId;
  final String userEmail;

  AcceptTaskEvent({required this.taskId, required this.userEmail});
}


