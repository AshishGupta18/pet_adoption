import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/pet_entity.dart';

class PetfinderService {
  static const String _baseUrl = 'https://api.petfinder.com/v2';
  static const String _clientId =
      'W53hlHMTmUPQC7wbM1cxjcUHk1SutdLefWBCSIEkE45NwgW9Ng';
  static const String _clientSecret =
      'gkdVQOkWOVvPW51IZRqRxrE4qEJQTMEXxADDk3Tv';
  String? _accessToken;
  DateTime? _tokenExpiry;

  Future<String> _getAccessToken() async {
    if (_accessToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      return _accessToken!;
    }

    final response = await http.post(
      Uri.parse('https://api.petfinder.com/v2/oauth2/token'),
      body: {
        'grant_type': 'client_credentials',
        'client_id': _clientId,
        'client_secret': _clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _accessToken = data['access_token'];
      _tokenExpiry = DateTime.now().add(Duration(seconds: data['expires_in']));
      return _accessToken!;
    } else {
      throw Exception('Failed to get access token');
    }
  }

  Future<List<PetEntity>> getPets({int page = 1, int limit = 20}) async {
    final token = await _getAccessToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/animals?page=$page&limit=$limit'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final animals = data['animals'] as List;

      return animals.map((animal) {
        final photos = animal['photos'] as List;
        final primaryPhoto = photos.isNotEmpty ? photos[0]['medium'] : null;

        return PetEntity(
          id: animal['id'].toString(),
          name: animal['name'] ?? 'Unknown',
          age: _calculateAge(animal['age']).toInt(),
          price: _calculatePrice(animal['type']),
          imageUrl: primaryPhoto ?? 'https://via.placeholder.com/300',
          isAdopted: false,
          isFavorited: false,
        );
      }).toList();
    } else {
      throw Exception('Failed to load pets');
    }
  }

  double _calculateAge(String? age) {
    if (age == null) return 1.0;

    final ageMap = {'Baby': 0.5, 'Young': 1.0, 'Adult': 3.0, 'Senior': 7.0};

    return ageMap[age] ?? 1.0;
  }

  double _calculatePrice(String? type) {
    if (type == null) return 1000.0;

    final priceMap = {
      'Dog': 2000.0,
      'Cat': 1500.0,
      'Bird': 1000.0,
      'Small & Furry': 800.0,
      'Scales, Fins & Other': 500.0,
    };

    return priceMap[type] ?? 1000.0;
  }
}
