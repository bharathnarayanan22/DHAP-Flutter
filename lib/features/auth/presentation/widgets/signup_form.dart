import 'package:dhap_flutter_project/features/auth/presentation/widgets/customTextField.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonBloc.dart';
import 'package:dhap_flutter_project/features/common/presentation/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 1;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressLineController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  String? _selectedRole;

  String? _validateName(String? val) {
    if (val == null || val.isEmpty) return "Enter Name";
    if (val.length < 3) return "Name must be at least 3 characters";
    return null;
  }

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

  String? _validateMobile(String? val) {
    if (val == null || val.isEmpty) return "Enter Mobile Number";
    if (val.length != 10) return "Mobile number must be 10 digits";
    return null;
  }

  String? _validateField(String? val, String fieldName) {
    if (val == null || val.isEmpty) return "Enter $fieldName";
    return null;
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _currentStep = 2;
      });
    }
  }

  void _previousStep() {
    setState(() {
      _currentStep = 1;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    _addressLineController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _currentStep == 1 ? _buildStep1() : _buildStep2(),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      key: const ValueKey<int>(1),
      children: [
        CustomTextField(
          controller: _nameController,
          labelText: "Name",
          icon: Icons.person,
          validator: _validateName,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _emailController,
          labelText: "Email",
          icon: Icons.email,
          validator: _validateEmail,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _passwordController,
          labelText: "Password",
          icon: Icons.lock,
          validator: _validatePassword,
          obscureText: true,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: "Select Role",
            labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[100],
            prefixIcon: const Icon(Icons.work, color: Color(0xFF0A2744)),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF0A2744), width: 3),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
          ),
          value: _selectedRole,
          items: ["Coordinator", "Volunteer", "Donor"]
              .map((role) => DropdownMenuItem(
            value: role,
            child: Text(
              role,
              style: GoogleFonts.poppins(),
            ),
          ))
              .toList(),
          onChanged: (val) {
            setState(() {
              _selectedRole = val;
            });
          },
          validator: (val) => val == null ? "Please select a role" : null,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _mobileController,
          labelText: "Mobile Number",
          icon: Icons.phone,
          validator: _validateMobile,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _nextStep,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A2744),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0A2744), Color(0xFF4A90E2)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "Next",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      key: const ValueKey<int>(2),
      children: [
        //const SizedBox(height: 16),
        CustomTextField(
          controller: _addressLineController,
          labelText: "Address Line",
          icon: Icons.home,
          validator: (val) => _validateField(val, "Address Line"),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _cityController,
          labelText: "City",
          icon: Icons.location_city,
          validator: (val) => _validateField(val, "City"),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _countryController,
          labelText: "Country",
          icon: Icons.public,
          validator: (val) => _validateField(val, "Country"),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _pincodeController,
          labelText: "Pincode",
          icon: Icons.pin_drop,
          validator: (val) => _validateField(val, "Pincode"),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
            onPressed: _previousStep,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A2744),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0A2744), Color(0xFF4A90E2)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 7),
                Text(
                  "Back",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message, style: GoogleFonts.poppins()),
                  backgroundColor: const Color(0xFF4A90E2),
                ),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => commonBloc(),
                    child: DashboardPage(userDetails: state.user),
                  ),
                ),
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error, style: GoogleFonts.poppins()),
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
                  context.read<AuthBloc>().add(SignupSubmitted(
                    name: _nameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                    mobile: _mobileController.text,
                    addressLine: _addressLineController.text,
                    city: _cityController.text,
                    country: _countryController.text,
                    pincode: _pincodeController.text,
                    role: _selectedRole!,
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A2744),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0A2744), Color(0xFF4A90E2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
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
                    const SizedBox(width: 7),
                    Text(
                      "Sign Up",
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
    );
  }
}