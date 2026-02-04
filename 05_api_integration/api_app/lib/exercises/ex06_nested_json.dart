/// ===========================================
/// EXERCISE 06: NESTED JSON
/// ===========================================
/// 🎯 Mục tiêu:
/// - Parse JSON có object lồng nhau
/// - Tạo model cho nested objects
/// - Handle nullable nested fields
///
/// 📝 JSON Structure:
/// {
///   "id": 1,
///   "name": "John",
///   "address": {           ← Nested object
///     "street": "123 Main",
///     "city": "Hanoi",
///     "geo": {             ← Nested inside nested
///       "lat": "21.03",
///       "lng": "105.85"
///     }
///   },
///   "company": {           ← Another nested object
///     "name": "ABC Corp"
///   }
/// }

library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// ===========================================
/// NESTED MODELS
/// ===========================================

/// [Geo Model] - Vị trí địa lý
class Geo {
  final String lat;
  final String lng;

  const Geo({required this.lat, required this.lng});

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(lat: json['lat'] as String, lng: json['lng'] as String);
  }
}

/// [Address Model] - Địa chỉ (chứa Geo)
class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final Geo geo; // Nested object

  const Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] as String,
      suite: json['suite'] as String,
      city: json['city'] as String,
      zipcode: json['zipcode'] as String,

      /// [Parse nested object]
      /// 1. Lấy value từ parent map
      /// 2. Cast về Map<String, dynamic>
      /// 3. Gọi nested model's fromJson
      geo: Geo.fromJson(json['geo'] as Map<String, dynamic>),
    );
  }
}

/// [Company Model] - Công ty
class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  const Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'] as String,
      catchPhrase: json['catchPhrase'] as String,
      bs: json['bs'] as String,
    );
  }
}

/// [User Model] - User với nested objects
class UserFull {
  final int id;
  final String name;
  final String email;
  final Address address; // Nested
  final Company company; // Nested

  const UserFull({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.company,
  });

  factory UserFull.fromJson(Map<String, dynamic> json) {
    return UserFull(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,

      /// [Nested parsing]
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      company: Company.fromJson(json['company'] as Map<String, dynamic>),
    );
  }
}

/// ===========================================
/// UI WIDGET
/// ===========================================
class Ex06NestedJson extends StatefulWidget {
  const Ex06NestedJson({super.key});

  @override
  State<Ex06NestedJson> createState() => _Ex06NestedJsonState();
}

class _Ex06NestedJsonState extends State<Ex06NestedJson> {
  late Future<UserFull> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUser();
  }

  Future<UserFull> _fetchUser() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return UserFull.fromJson(json);
    }
    throw Exception('Failed to load user');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex06: Nested JSON')),
      body: FutureBuilder<UserFull>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Info
                Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${user.id}')),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                  ),
                ),

                const SizedBox(height: 16),

                // Address (Nested)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Address (Nested Object)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(),

                        /// [Access nested data]
                        /// user.address.street - Truy xuất qua chain
                        Text('Street: ${user.address.street}'),
                        Text('Suite: ${user.address.suite}'),
                        Text('City: ${user.address.city}'),
                        Text('Zipcode: ${user.address.zipcode}'),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Geo (Nested inside Address):',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),

                              /// [Deep nested access]
                              Text('Lat: ${user.address.geo.lat}'),
                              Text('Lng: ${user.address.geo.lng}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Company (Nested)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.business, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Company (Nested Object)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(),
                        Text('Name: ${user.company.name}'),
                        Text('Catch Phrase: "${user.company.catchPhrase}"'),
                        Text('Business: ${user.company.bs}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
