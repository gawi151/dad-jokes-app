import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

part 'dad_jokes_api.g.dart';

@RestApi(baseUrl: "https://icanhazdadjoke.com/")
abstract class DadJokesApi {
  factory DadJokesApi(Dio dio, {String baseUrl}) = _DadJokesApi;

  @GET('')
  @Headers(<String, dynamic>{
    'Accept': 'text/plain',
  })
  Future<String> getRandomJoke();
}
