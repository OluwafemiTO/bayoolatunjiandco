import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/core.dart';
import '../services/api_client.dart';
import 'brand_button.dart';

/// Loads something once, then shows a spinner, an error with "Try again", or the result.
///
/// [load] receives `true` when the person pressed "Try again" (skip the cache).
/// Give the widget a `key` that changes with whatever it loads (e.g. the slug).
class AsyncView<T> extends StatefulWidget {
  final Future<T> Function(bool refresh) load;
  final Widget Function(BuildContext context, T data) builder;
  final Widget Function(BuildContext context, ApiException error, VoidCallback retry)? errorBuilder;

  const AsyncView({super.key, required this.load, required this.builder, this.errorBuilder});

  @override
  State<AsyncView<T>> createState() => _AsyncViewState<T>();
}

class _AsyncViewState<T> extends State<AsyncView<T>> {
  late Future<T> _future = widget.load(false);

  void _retry() => setState(() => _future = widget.load(true));

  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) return const LoadingPanel();
          if (snap.hasError) {
            final err = snap.error;
            if (err is! ApiException) debugPrint('AsyncView error: $err');
            final e = err is ApiException
                ? err
                : const ApiException(0, 'UNKNOWN', 'Something went wrong. Please try again.');
            return widget.errorBuilder?.call(context, e, _retry) ?? ErrorPanel(message: e.message, onRetry: _retry);
          }
          return widget.builder(context, snap.data as T);
        },
      );
}

class LoadingPanel extends StatelessWidget {
  const LoadingPanel({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox(
        height: 240,
        child: Center(child: SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 3))),
      );
}

class ErrorPanel extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const ErrorPanel({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.cloud_off_outlined, size: 32, color: context.pal.heading),
          const SizedBox(height: 12),
          body(message),
          if (onRetry != null) ...[
            const SizedBox(height: 20),
            BrandButton('Try again', style: BrandButtonStyle.primary, compact: true, onPressed: onRetry),
          ],
        ]),
      );
}