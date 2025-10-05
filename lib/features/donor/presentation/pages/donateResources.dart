import 'package:dhap_flutter_project/features/coordinator/presentation/widgets/LocationInputSection.dart';
import 'package:dhap_flutter_project/features/donor/bloc/donor_bloc.dart';
import 'package:dhap_flutter_project/features/donor/bloc/donor_state.dart';
import 'package:dhap_flutter_project/features/donor/bloc/donor_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF42A5F5);
const Color inputFillColor = Colors.white;

class DonateResourcesPage extends StatefulWidget {
  const DonateResourcesPage({super.key});
  @override
  State<DonateResourcesPage> createState() => _DonateResourcePageState();
}

class _DonateResourcePageState extends State<DonateResourcesPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _resourceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  late DonorBloc _donorBloc;

  LatLng? _Location;

  @override
  void initState() {
    super.initState();
    _donorBloc = DonorBloc();
  }

  @override
  void dispose() {
    _resourceController.dispose();
    _quantityController.dispose();
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
    return BlocProvider.value(
      value: _donorBloc,
      child: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: BlocConsumer<DonorBloc, DonorState>(
          bloc: _donorBloc,
          listener: (context, state) {
            if(state is DonorSuccess){
              _scaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: const Color(0xFF66BB6A),
                  duration: const Duration(seconds: 3),
                ),
              );
              _formKey.currentState?.reset();
              _resourceController.clear();
              _quantityController.clear();
              _addressController.clear();
              setState(() {
                _Location = null;
              });
            } else if(state is DonorFailure){
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
                    Icon(Icons.volunteer_activism, color: Colors.white,
                        size: 24),
                    SizedBox(width: 8),
                    Text(
                      "Donate Resources",
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
                            decoration: _getInputDecoration(label: 'Qunatity', icon: Icons.description),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) <= 0) {
                                return 'Must be a positive whole number';
                              }
                              return null;
                            },
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
                                state is DonorLoading ? "Creating Task..." : "Create Task",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                elevation: 5,
                              ),
                              onPressed: state is DonorLoading ? null : () {
                                if (_formKey.currentState!.validate() && _Location != null) {
                                  BlocProvider.of<DonorBloc>(context).add(
                                    AddResourceEvent(
                                      resource: _resourceController.text,
                                      quantity: int.parse(_quantityController.text),
                                      location: _Location!,
                                      address: _addressController.text,
                                      DonorName: "Donor Name",
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
      ),
    );
  }
}