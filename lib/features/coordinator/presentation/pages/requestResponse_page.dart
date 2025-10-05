import 'package:dhap_flutter_project/data/model/request_model.dart';
import 'package:dhap_flutter_project/data/model/response_model.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_bloc.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_event.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_state.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/widgets/RequestCard.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/widgets/ResponsesListScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF42A5F5);

const List<String> statusFilters = [
  'All',
  'Pending',
  'Responded',
];

class ResourceResponsesPage extends StatefulWidget {
  const ResourceResponsesPage({super.key});

  @override
  State<ResourceResponsesPage> createState() => _ResourceResponsesPageState();
}

class _ResourceResponsesPageState extends State<ResourceResponsesPage> {
  String _selectedStatus = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoordinatorBloc>().add(FetchRequestsAndResponsesEvent());
      // context.read<CoordinatorBloc>().add(FetchResponsesEvent());
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  List<Request> _filterRequests(List<Request> requests) {
    String searchTerm = _searchController.text.toLowerCase();

    List<Request> statusFiltered = requests.where((request) {
      if (_selectedStatus == 'All') {
        return true;
      }
      return request.status == _selectedStatus;
    }).toList();

    if (searchTerm.isEmpty) {
      return statusFiltered;
    }

    return statusFiltered.where((request) {
      return request.resource.toLowerCase().contains(searchTerm);
    }).toList();
  }

  void _handleResponseTap(BuildContext context, Request request, List<ResponseModel> allResponses) {
    final requestResponses = allResponses
        .where((response) => request.responseIds.contains(response.id))
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResponsesListScreen(
          request: request,
          responses: requestResponses,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.question_answer_rounded, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              "Responses",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<CoordinatorBloc, CoordinatorState> (
        builder: (context, state) {
          if(state is CoordinatorLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FetchRequestResponseSuccess) {
            final allRequests = state.requests;
            final allResponses = state.responses;
            final filteredRequests = _filterRequests(allRequests as List<Request>);

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1000),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search by Resources...',
                                prefixIcon: const Icon(Icons.search, color: primaryColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              ),
                            ),
                          ),
                         // const SizedBox(width: 12),

                          // Container(
                          //   padding: const EdgeInsets.symmetric(horizontal: 12),
                          //   decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius: BorderRadius.circular(10),
                          //     border: Border.all(color: Colors.grey.shade300),
                          //   ),
                          //   child: DropdownButtonHideUnderline(
                          //     child: DropdownButton<String>(
                          //       value: _selectedStatus,
                          //       icon: const Icon(Icons.filter_list, color: primaryColor),
                          //       onChanged: (String? newValue) {
                          //         if (newValue != null) {
                          //           setState(() {
                          //             _selectedStatus = newValue;
                          //           });
                          //         }
                          //       },
                          //       items: statusFilters.map<DropdownMenuItem<String>>((String value) {
                          //         return DropdownMenuItem<String>(
                          //           value: value,
                          //           child: Text(value),
                          //         );
                          //       }).toList(),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: filteredRequests.isEmpty
                          ? Center(child: Text('No requests found for the current filter/search criteria.', style: TextStyle(color: primaryColor)))
                          : ListView.builder(
                        itemCount: filteredRequests.length,
                        itemBuilder: (context, index) {
                          final request = filteredRequests[index];
                          return RequestCard(
                            request: request,
                            onResponseTap: (requestId) => _handleResponseTap(
                              context,
                              request,
                              allResponses as List<ResponseModel>,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text('Something gone wrong'),);
        }
      )


    );
  }
}