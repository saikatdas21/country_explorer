import 'package:flutter/material.dart';
import 'services/country_service.dart';

void main() {
  runApp(const ApiTestApp());
}

class ApiTestApp extends StatelessWidget {
  const ApiTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ApiTestScreen(),
    );
  }
}

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final CountryService countryService = CountryService();

  late Future<List> countries;

  @override
  void initState() {
    super.initState();
    countries = countryService.fetchCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country API Test'),
      ),
      body: FutureBuilder(
        future: countries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No countries found'),
            );
          }

          final countryList = snapshot.data!;

          return ListView.builder(
            itemCount: countryList.length,
            itemBuilder: (context, index) {
              final country = countryList[index];

              return ListTile(
                leading: Text(
                  country.flagEmoji,
                  style: const TextStyle(fontSize: 30),
                ),
                title: Text(country.name),
                subtitle: Text(
                  '${country.capital} • ${country.region}',
                ),
                trailing: Text(
                  country.countryCode,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
