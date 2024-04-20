import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dad_jokes/dad_jokes_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:loading_indicator/loading_indicator.dart';

final dio = Dio()..interceptors.add(LogInterceptor(responseBody: true));
final dadJokesApi = DadJokesApi(dio);

class JokesPage extends HookWidget {
  const JokesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reloadKey = useState(UniqueKey());

    final jokeRequest = useMemoized(
      () => Future.delayed(Durations.long1, dadJokesApi.getRandomJoke),
      [reloadKey.value],
    );
    final snapshot = useFuture(jokeRequest);

    Widget content;
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        content = const ErrorContent();
      } else {
        final joke = snapshot.data;
        if (joke == null || joke.isEmpty) {
          content = const NoJokeFound();
        } else {
          content = JokeText(joke: joke);
        }
      }
    } else {
      content = const SizedBox(
        width: 200,
        child: LoadingIndicator(
          indicatorType: Indicator.pacman,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Dad Joke Generator")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: Durations.extralong4,
                  child: content,
                ),
              ),
              const Gap(32),
              TextButton.icon(
                icon: const Icon(Icons.refresh),
                label: Text(
                  'Get new joke',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                onPressed: () => reloadKey.value = UniqueKey(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JokeText extends HookWidget {
  const JokeText({super.key, required this.joke});

  final String joke;

  @override
  Widget build(BuildContext context) {
    final animationFinished = useState(false);

    const textStyle = TextStyle(fontSize: 30, height: 1.5);

    // use selection area because selection text changes
    // size of the text widget (height is different from normal text)
    final selectableJoke = SelectionArea(
      child: Text(
        joke,
        textAlign: TextAlign.center,
        style: textStyle,
      ),
    );

    final animatingJoke = AnimatedTextKit(
      isRepeatingAnimation: false,
      animatedTexts: [
        TypewriterAnimatedText(
          joke,
          textAlign: TextAlign.center,
          textStyle: textStyle,
          cursor: '', // no cursor to avoid jumping text when switching
        ),
      ],
      onFinished: () {
        animationFinished.value = true;
      },
    );

    return animationFinished.value ? selectableJoke : animatingJoke;
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
