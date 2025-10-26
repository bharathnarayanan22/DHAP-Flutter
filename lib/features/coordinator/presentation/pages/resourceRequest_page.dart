import 'package:dhap_flutter_project/features/common/bloc/commonBloc.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonEvent.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonState.dart';
// import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_bloc.dart';
// import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_state.dart';
// import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_event.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/widgets/LocationInputSection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';


const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF42A5F5);
const Color inputFillColor = Colors.white;

class ResourceRequestPage extends StatefulWidget {
  const ResourceRequestPage({super.key});

  @override
  State<ResourceRequestPage> createState() => _ResourceRequestPageState();
}

class _ResourceRequestPageState extends State<ResourceRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _resourceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  late commonBloc _commonBloc;

  LatLng? _Location;

  @override
  void initState() {
    super.initState();
    _commonBloc = context.read<commonBloc>();
  }

  @override
  void dispose() {
    _resourceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  InputDecoration _getInputDecoration({required String label, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
      filled: true,
      fillColor: inputFillColor,
      prefixIcon: Icon(icon, color: primaryColor, size: 20),
      // border: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(10),
      //   borderSide: BorderSide.none,
      // ),
      // enabledBorder: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(10),
      //   borderSide: const BorderSide(color: Colors.white, width: 1.5),
      // ),
      // focusedBorder: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(10),
      //   borderSide: const BorderSide(color: accentColor, width: 2.0),
      // ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
    );
  }

  Future<void> _setLocationFromAddress(String address, bool isStart) async {
    if (address.isEmpty) return;
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        LatLng newLocation = LatLng(locations.first.latitude, locations.first.longitude);
        setState(() => _Location = newLocation);
        _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Address found! Location set for ${isStart ? 'Start Point' : 'Delivery Point'}')),
        );
      } else {
        _scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text('Address not found. Please tap on map to set.')),
        );
      }
    } catch (e) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Geocoding Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: BlocConsumer<commonBloc, commonState>(
        bloc: _commonBloc,
        listener: (context, state) {
          if(state is RequestSuccess){
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFF66BB6A),
                duration: const Duration(seconds: 3),
              ),
            );
            // Future.delayed(const Duration(seconds: 2), () {
            //   if (!mounted) return;
            //
            //   Navigator.pop(context, true);
            //   _formKey.currentState?.reset();
            //   _resourceController.clear();
            //   _quantityController.clear();
            //   _descriptionController.clear();
            //   _addressController.clear();
            //   setState(() {
            //     _Location = null;
            //   });
           // });
          } else if(state is commonFailure){
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                backgroundColor: const Color(0xFFE53935),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.request_page, color: Colors.white,
                      size: 24),
                  SizedBox(width: 8),
                  Text(
                    "Request Resources",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              backgroundColor: Color(0xFF0A2744),
              foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _resourceController,
                          decoration: _getInputDecoration(label: 'Resource', icon: Icons.title),
                          validator: (value) => value!.isEmpty ? 'Please enter a Resource needed' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _quantityController,
                          decoration: _getInputDecoration(label: 'Qunatity', icon: Icons.numbers),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) <= 0) {
                              return 'Must be a positive whole number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: _getInputDecoration(label: 'Description', icon: Icons.description),
                          maxLines: 3,
                          validator: (value) => value!.isEmpty ? 'Please enter a Description' : null,
                        ),
                        const SizedBox(height: 24),

                        LocationInputSection(
                          title: "Location (Resource Needed Point)",
                          icon: Icons.upload_file,
                          addressController: _addressController,
                          currentLocation: _Location,
                          onAddressSubmitted: (address) => _setLocationFromAddress(address, true),
                          onMapTap: (point) => setState(() => _Location = point),
                          mapColor: Colors.lightGreen,
                          mapIcon: Icons.location_on,
                        ),

                        const SizedBox(height: 30),

                        Center(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.send),
                            label: Text(
                              state is commonLoading ? "Requesting..." : "Send Request",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 5,
                            ),
                            onPressed: state is commonLoading ? null : () {
                              if (_formKey.currentState!.validate() && _Location != null) {
                                _commonBloc.add(
                                CreateResourceRequestEvent(
                                    resource: _resourceController.text,
                                    description: _descriptionController.text,
                                    quantity: int.parse(_quantityController.text),
                                    location: _Location!,
                                    address: _addressController.text,
                                  ),
                                );
                              } else if (_Location == null) {
                                _scaffoldMessengerKey.currentState?.showSnackBar(
                                  const SnackBar(
                                    content: Text('Please set both Start and Delivery locations.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
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
    );
  }
}