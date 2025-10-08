import 'package:flutter/material.dart';
import 'package:scholarwheels/services/api_state.dart';

class ErrorWidgetWithRetry extends StatelessWidget {
  final ErrorState errorState;
  const ErrorWidgetWithRetry({super.key, required this.errorState});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            // Display a retry button
            IconButton(
              onPressed: () {
                errorState.retryFunction();
              },
              icon: const Icon(Icons.refresh, size: 32),
            ),
            const Text("Retry"),
          ],
        ),
      ),
    );
  }
}
