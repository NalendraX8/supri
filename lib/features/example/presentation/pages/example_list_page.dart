import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/example_bloc.dart';
import '../bloc/example_event.dart';
import '../bloc/example_state.dart';
import '../widgets/example_card.dart';

/// Page displaying the list of examples.
class ExampleListPage extends StatelessWidget {
  const ExampleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Examples'),
        centerTitle: true,
      ),
      body: BlocBuilder<ExampleBloc, ExampleState>(
        builder: (context, state) {
          if (state is ExampleLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ExampleError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ExampleBloc>().add(const GetExamplesEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ExamplesLoaded) {
            if (state.examples.isEmpty) {
              return const Center(
                child: Text('No examples found'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.examples.length,
              itemBuilder: (context, index) {
                final example = state.examples[index];
                return ExampleCard(example: example);
              },
            );
          }

          return const Center(
            child: Text('Pull to refresh'),
          );
        },
      ),
    );
  }
}
