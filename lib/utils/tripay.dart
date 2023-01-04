import 'package:http/http.dart' as http;

Future<String> getPaymentChannel(String code,
    {String apiKey = 'DEV-Y805NiFNNbdnyN03MM3s3clRZx1EhPVilXm8iWi1'}) async {
  final payload = {'code': code};
  final response = await http.get(
    Uri.https(
      'tripay.co.id',
      '/api-sandbox/merchant/payment-channel',
      payload,
    ),
    headers: {'Authorization': 'Bearer $apiKey'},
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    return 'Error: ${response.statusCode}: ${response.reasonPhrase}';
  }
}
