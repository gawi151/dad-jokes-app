import 'package:arturs_app_joke/dad_jokes_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:loading_indicator/loading_indicator.dart';

final dio = Dio();
final dadJokesApi = DadJokesApi(dio);

class JokesPage extends HookWidget {
  const JokesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reloadKey = useState(UniqueKey());

    final jokeRequest = useMemoized(
      () => dadJokesApi.getRandomJoke(),
      [reloadKey.value],
    );
    final snapshot = useFuture(jokeRequest);

    return Scaffold(
      appBar: AppBar(title: const Text("Dad Joke Generator")),
      body: Center(
        child: Column(
          children: [
            Builder(
              builder: (context) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const ErrorContent();
                  }

                  final joke = snapshot.data;
                  if (joke == null || joke.isEmpty) {
                    return const NoJokeFound();
                  }

                  return Text(
                    joke,
                    style: const TextStyle(fontSize: 24, height: 1.5),
                    textAlign: TextAlign.center,
                  );
                } else {
                  return const LoadingIndicator(
                    indicatorType: Indicator.pacman,
                  );
                }
              },
            ),
            const Gap(16),
            ElevatedButton(
              onPressed: () => reloadKey.value = UniqueKey(),
              child: const Text('Get another joke'),
            ),
          ],
        ),
      ),
    );
  }
}

class NoJokeFound extends StatelessWidget {
  const NoJokeFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('assets/images/no_joke_found.webp'),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No joke found. Please try again later.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}

class ErrorContent extends StatelessWidget {
  const ErrorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('assets/images/error.webp'),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Oops! Something went wrong. Please try again later.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}
