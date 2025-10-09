abstract class commonEvent {}

class FetchUserData extends commonEvent {}

class LogoutSubmitted extends commonEvent {}

class SwitchRoleSubmitted extends commonEvent {
  final String email;
  final String newRole;
  SwitchRoleSubmitted({required this.email, required this.newRole});
}


