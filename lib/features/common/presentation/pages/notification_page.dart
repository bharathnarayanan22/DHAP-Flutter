import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonBloc.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonState.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonEvent.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest News'),
        backgroundColor: const Color(0xFF0A2744),
        foregroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => commonBloc()..add(FetchNewsEvent()),
        child: BlocBuilder<commonBloc, commonState>(
          builder: (context, state) {
            if (state is FetchNewsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FetchNewsSuccess) {
              final newsList = state.newsList;
              return ListView.builder(
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  final news = newsList[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: news['image'] != null
                          ? SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.network(
                          news['image'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                        ),
                      )
                          : const Icon(Icons.image_not_supported),
                      title: Text(news['title'] ?? 'No Title'),
                      subtitle: Text(news['description'] ?? 'No Description'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(news['title'] ?? 'No Title'),
                            content: Text(news['content'] ?? 'No Content'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                              TextButton(
                                onPressed: () {
                                  final url = Uri.parse(news['url']);
                                },
                                child: const Text('Open'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (state is commonFailure) {
              return Center(
                child: Text(state.error, style: const TextStyle(color: Colors.red)),
              );
            } else {
              return const Center(child: Text('No data.'));
            }
          },
        ),
      ),
    );
  }
}
