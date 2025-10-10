import 'package:dhap_flutter_project/data/model/task_model.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/widgets/LocationInputSection.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/coordinator_bloc.dart';
import '../../bloc/coordinator_event.dart';
import '../../bloc/coordinator_state.dart';
import 'package:geocoding/geocoding.dart';

const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF42A5F5);
const Color inputFillColor = Colors.white;

class CreateTasksPage extends StatefulWidget {
  final Task? existingTask;
  const CreateTasksPage({super.key, this.existingTask});

  @override
  State<CreateTasksPage> createState() => _CreateTasksPageState();
}

class _CreateTasksPageState extends State<CreateTasksPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _volunteerController = TextEditingController();

  final TextEditingController _startAddressController = TextEditingController();
  final TextEditingController _deliveryAddressController = TextEditingController();

  late CoordinatorBloc _coordinatorBloc;

  LatLng? _startLocation;
  LatLng? _deliveryLocation;

  @override
  void initState() {
    super.initState();
    _coordinatorBloc = CoordinatorBloc();
    final task = widget.existingTask;
    if (task != null) {
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _volunteerController.text = task.volunteer.toString();
      _startAddressController.text = task.StartAddress;
      _deliveryAddressController.text = task.EndAddress;
      _startLocation = LatLng(task.StartLocation.latitude, task.StartLocation.longitude);
      _deliveryLocation = LatLng(task.EndLocation.latitude, task.EndLocation.longitude);
    }
  }

  @override
  void dispose() {
    _coordinatorBloc.close();
    _titleController.dispose();
    _descriptionController.dispose();
    _volunteerController.dispose();
    _startAddressController.dispose();
    _deliveryAddressController.dispose();
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
        setState(() {
          if (isStart) {
            _startLocation = newLocation;
          } else {
            _deliveryLocation = newLocation;
          }
        });
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
    return BlocProvider(
      create: (_) => _coordinatorBloc,
      child: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: BlocConsumer<CoordinatorBloc, CoordinatorState>(
          bloc: _coordinatorBloc,
          listener: (context, state) {
            if (state is CoordinatorSuccess) {
              _scaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: const Color(0xFF66BB6A),
                  duration: const Duration(seconds: 3),
                ),
              );
              Future.delayed(const Duration(milliseconds: 800), () {
                if (widget.existingTask != null) {
                  Navigator.pop(context, true);
                } else {
                  _formKey.currentState?.reset();
                  _titleController.clear();
                  _descriptionController.clear();
                  _volunteerController.clear();
                  _startAddressController.clear();
                  _deliveryAddressController.clear();
                  setState(() {
                    _startLocation = null;
                    _deliveryLocation = null;
                  });
                }
              });
            } else if (state is CoordinatorFailure) {
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
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.existingTask != null ? Icons.edit : Icons.add_task, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      widget.existingTask != null ? "Edit Task" : "Create New Task",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                backgroundColor: primaryColor,
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
                            controller: _titleController,
                            decoration: _getInputDecoration(label: 'Task Title', icon: Icons.title),
                            validator: (value) => value!.isEmpty ? 'Please enter a task title' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: _getInputDecoration(label: 'Detailed Description', icon: Icons.description),
                            maxLines: 3,
                            validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _volunteerController,
                            decoration: _getInputDecoration(label: 'Volunteers Needed', icon: Icons.people_alt_outlined),
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
                            title: "1. Start Location (Pickup Point)",
                            icon: Icons.upload_file,
                            addressController: _startAddressController,
                            currentLocation: _startLocation,
                            onAddressSubmitted: (address) => _setLocationFromAddress(address, true),
                            onMapTap: (point) => setState(() => _startLocation = point),
                            mapColor: Colors.lightGreen,
                            mapIcon: Icons.location_on,
                          ),
                          const SizedBox(height: 24),

                          LocationInputSection(
                            title: "2. Delivery Location (Drop-off Point)",
                            icon: Icons.download_done,
                            addressController: _deliveryAddressController,
                            currentLocation: _deliveryLocation,
                            onAddressSubmitted: (address) => _setLocationFromAddress(address, false),
                            onMapTap: (point) => setState(() => _deliveryLocation = point),
                            mapColor: accentColor,
                            mapIcon: Icons.local_shipping,
                          ),

                          const SizedBox(height: 30),

                          Center(
                            child: ElevatedButton.icon(
                              icon: Icon(widget.existingTask != null ? Icons.update : Icons.send),
                              label: Text(
                                widget.existingTask != null
                                    ? (state is CoordinatorLoading ? "Updating Task..." : "Update Task")
                                    : (state is CoordinatorLoading ? "Creating Task..." : "Create Task"),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                elevation: 5,
                              ),
                              onPressed: state is CoordinatorLoading
                                  ? null
                                  : () {
                                if (_formKey.currentState!.validate() &&
                                    _startLocation != null &&
                                    _deliveryLocation != null) {
                                  if (widget.existingTask != null) {
                                    final updatedTask = Task(
                                      id: widget.existingTask!.id,
                                      title: _titleController.text,
                                      description: _descriptionController.text,
                                      volunteer: int.parse(_volunteerController.text),
                                      volunteersAccepted: widget.existingTask!.volunteersAccepted,
                                      StartAddress: _startAddressController.text,
                                      EndAddress: _deliveryAddressController.text,
                                      StartLocation: _startLocation!,
                                      EndLocation: _deliveryLocation!,
                                      Status: widget.existingTask!.Status,
                                    );
                                    BlocProvider.of<CoordinatorBloc>(context).add(
                                      UpdateTaskEvent(updatedTask: updatedTask),
                                    );
                                    // Navigator.pop(context, true);
                                  } else {
                                    BlocProvider.of<CoordinatorBloc>(context).add(
                                      CreateTaskEvent(
                                        title: _titleController.text,
                                        description: _descriptionController.text,
                                        volunteer: int.parse(_volunteerController.text),
                                        StartLocation: _startLocation!,
                                        EndLocation: _deliveryLocation!,
                                        StartAddress: _startAddressController.text,
                                        EndAddress: _deliveryAddressController.text,
                                      ),
                                    );
                                  }
                                } else {
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

