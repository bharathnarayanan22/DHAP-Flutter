import 'package:dhap_flutter_project/features/auth/presentation/widgets/customTextField.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonBloc.dart';
import 'package:dhap_flutter_project/features/common/presentation/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class LoginForm extends StatefulWidget {
  LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _validateEmail(String? val) {
    if (val == null || val.isEmpty) return "Enter Email";
    if (!val.contains('@')) return "Invalid Email";
    return null;
  }

  String? _validatePassword(String? val) {
    if (val == null || val.isEmpty) return "Enter Password";
    if (val.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailController,
            labelText: "Email",
            icon: Icons.email,
            validator: _validateEmail,
            keyboardType: TextInputType.emailAddress,
          ),

          SizedBox(height: 16),
          CustomTextField(
            controller: _passwordController,
            labelText: "Password",
            icon: Icons.lock,
            validator: _validatePassword,
            obscureText: true,
          ),
          const SizedBox(height: 24),
          BlocConsumer<AuthBloc, AuthState>(
            // listener: (context, state) {
            //   if (state is AuthSuccess) {
            //     // ScaffoldMessenger.of(context).showSnackBar(
            //     //   SnackBar(
            //     //     content: Text(
            //     //       state.message,
            //     //       style: GoogleFonts.poppins(),
            //     //     ),
            //     //     backgroundColor: const Color(0xFF4A90E2),
            //     //   ),
            //     // );
            //     Navigator.pushReplacement(
            //       context,
            //       MaterialPageRoute(
            //         builder: (_) => BlocProvider(
            //           create: (_) => commonBloc(),
            //           child: DashboardPage(userDetails: state.user),
            //         ),
            //       ),
            //     );
            //   } else if (state is AuthFailure) {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         content: Text(
            //           state.error,
            //           style: GoogleFonts.poppins(),
            //         ),
            //         backgroundColor: Colors.redAccent,
            //       ),
            //     );
            //   }
            // },

            listener: (context, state) async {
              if (state is AuthSuccess) {
                final user = state.user;
                print("user Role: ${user.isCoordinator}");
                if (user.isCoordinator) {
                  final selectedRole = await showDialog<String>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: const Text('Choose Dashboard'),
                      content: const Text('Select which dashboard you want to access:'),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.of(context).pop('Coordinator'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0A2744),
                                ),
                                child: const Text(
                                  'Coordinator',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.of(context).pop('Employee'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0A2744),
                                ),
                                child: const Text(
                                  'Participant',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );

                  if (selectedRole == 'Coordinator') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => commonBloc(),
                          child: DashboardPage(userDetails: user.copyWith(role: 'Coordinator')),
                        ),
                      ),
                    );
                  } else if (selectedRole == 'Employee' && user.role == 'Coordinator') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => commonBloc(),
                          child: DashboardPage(userDetails: user.copyWith(role:'Volunteer')),
                        ),
                      ),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => commonBloc(),
                          child: DashboardPage(userDetails: user),
                        ),
                      ),
                    );
                  }
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => commonBloc(),
                        child: DashboardPage(userDetails: user),
                      ),
                    ),
                  );
                }
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.error,
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A2744)),
                );
              }
              return ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<AuthBloc>().add(LoginSubmitted(
                      email: _emailController.text,
                      password: _passwordController.text,
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  // minimumSize: const Size(double.infinity, 10),
                  backgroundColor: const Color(0xFF0A2744),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation:2,
                ),
                child: Container(
                  // width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0A2744), Color(0xFF4A90E2)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(14),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.login,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 7,),
                      Text(
                        "Login",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      // const SizedBox(width: 7),
                      // const Icon(
                      //   Icons.login,
                      //   color: Colors.white,
                      //   size: 20,
                      // ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

}