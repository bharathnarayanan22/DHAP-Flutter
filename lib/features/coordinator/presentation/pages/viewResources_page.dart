import 'package:dhap_flutter_project/data/model/resource_model.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_bloc.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_event.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_state.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/widgets/ResourceCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF42A5F5);

class ViewResourcesPage extends StatefulWidget {
  const ViewResourcesPage({super.key});

  @override
  State<ViewResourcesPage> createState() => _ViewResourcesPageState();
}

class _ViewResourcesPageState extends State<ViewResourcesPage> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoordinatorBloc>().add(FetchResourcesEvent());
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

  List<ResourceModel> _filterResources(List<ResourceModel> resource) {
    final searchTerm = _searchController.text.toLowerCase();

    final resourceFiltered = resource
        .where((u) => u.resource.toLowerCase().contains(searchTerm))
        .toList();

    return resourceFiltered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.food_bank_rounded, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              "View Resources",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<CoordinatorBloc, CoordinatorState>(
        builder: (context, state) {
          if (state is CoordinatorLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ResourceSuccess) {
            final filteredResources = _filterResources(state.resources);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),

                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by Resource Name...',
                        prefixIcon: const Icon(Icons.search, color: primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                      ),
                    ),
                  ),
                Expanded(
                  child: filteredResources.isEmpty
                      ? Center(
                    child: Text(
                      _searchController.text.isEmpty
                          ? 'No resources available.'
                          : 'No resources found for "${_searchController.text}"',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                    itemCount: filteredResources.length,
                    itemBuilder: (context, index) {
                      final resource = filteredResources[index];
                      return ResourceCard(resource: resource);
                    },
                  ),
                ),
              ]
            );
          }

          return const Center(child: Text('No Resources found.'));
        },
      ),
    );
  }
}
