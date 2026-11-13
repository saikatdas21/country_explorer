import 'package:flutter/material.dart';
import '../models/country.dart';

class CountryDetailsScreen extends StatelessWidget {
  final Country country;

  const CountryDetailsScreen({
    super.key,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Country Details'),
        backgroundColor: const Color(0xFF172B4D),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 15),

            if (country.flagUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  country.flagUrl,
                  width: 190,
                  height: 125,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _emojiFlag();
                  },
                ),
              )
            else
              _emojiFlag(),

            const SizedBox(height: 22),

            Text(
              country.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172B4D),
              ),
            ),

            const SizedBox(height: 7),

            Text(
              country.officialName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 25),

            _detailCard(
              Icons.location_city,
              'Capital',
              country.capital,
            ),
            _detailCard(
              Icons.public,
              'Region',
              country.region,
            ),
            _detailCard(
              Icons.people,
              'Population',
              country.population.toString(),
            ),
            _detailCard(
              Icons.flag,
              'Country Code',
              country.countryCode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _emojiFlag() {
    return Container(
      width: 190,
      height: 125,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        country.flagEmoji.isNotEmpty
            ? country.flagEmoji
            : '🌍',
        style: const TextStyle(fontSize: 75),
      ),
    );
  }

  Widget _detailCard(
      IconData icon,
      String title,
      String value,
      ) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF345995),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF172B4D),
          ),
        ),
      ),
    );
  }
}
