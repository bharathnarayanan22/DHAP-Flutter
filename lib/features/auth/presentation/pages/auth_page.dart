import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';
import '../widgets/login_form.dart';
import '../widgets/signup_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2744),
      body: BlocProvider(
        create: (_) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (previous, current) => current is AuthModeState,
          builder: (context, state) {
            bool isLogin = true;
            if (state is AuthModeState) {
              debugPrint("AuthModeState: ${state.isLogin}");
              isLogin = state.isLogin;
            }

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Card(
                    key: ValueKey<bool>(isLogin),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      constraints: BoxConstraints(
                        maxWidth: 400,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isLogin ? 'Welcome Back' : 'Join Us',
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0A2744),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                isLogin ? Icons.waving_hand: Icons.handshake,
                                color: const Color(0xFF0A2744),
                                size: 40,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            isLogin
                                ? 'Login to your account'
                                : 'Create a new account',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 24),
                          isLogin ?  LoginForm() :  SignupForm(),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {

                              debugPrint("Toggle Auth Mode");
                              context.read<AuthBloc>().add(ToggleAuthMode());
                            },
                            child: Text(
                              isLogin
                                  ? "Don't have an account? Sign Up"
                                  : "Already have an account? Login",
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF4A90E2),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}