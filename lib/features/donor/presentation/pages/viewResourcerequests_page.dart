import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:dhap_flutter_project/features/donor/bloc/donor_bloc.dart';
import 'package:dhap_flutter_project/features/donor/bloc/donor_event.dart';
import 'package:dhap_flutter_project/features/donor/bloc/donor_state.dart';
import 'package:dhap_flutter_project/features/donor/presentation/widgets/RequestsCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const Color primaryColor = Color(0xFF0A2744);

class ViewResourceRequestsPage extends StatefulWidget {
  final User userDetails;
  const ViewResourceRequestsPage({super.key, required this.userDetails});

  @override
  State<ViewResourceRequestsPage> createState() =>
      _ViewResourceRequestsPageState();
}

class _ViewResourceRequestsPageState extends State<ViewResourceRequestsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DonorBloc>().add(FetchRequestsEvent());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.request_page, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              "Resource Requests",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Color(0xFF0A2744),
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<DonorBloc, DonorState>(
        listener: (context, state) {
          if (state is FetchRequestSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.msg)));
          } else if (state is DonorFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
          }
        },
        builder: (context, state) {
          if (state is DonorLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FetchRequestSuccess) {
            if(state.requests.isEmpty) {
              return const Center(child: Text("No Requests available"));
            }
            final requests = state.requests;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Center(
                  child: ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, idx) {
                      final request = requests[idx];
                      return RequestsCard(request: request, user: widget.userDetails.name, email: widget.userDetails.email);
                    },
                  ),
                ),
              ),
            );
          }
          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }
}
