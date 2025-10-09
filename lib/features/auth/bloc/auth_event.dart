abstract class AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});
}

class SignupSubmitted extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String mobile;
  final String addressLine;
  final String city;
  final String country;
  final String pincode;
  final String role;

  SignupSubmitted({
    required this.name,
    required this.email,
    required this.password,
    required this.mobile,
    required this.addressLine,
    required this.city,
    required this.country,
    required this.pincode,
    required this.role,
  });
}

// class LogoutSubmitted extends AuthEvent {}



class ToggleAuthMode extends AuthEvent {}
