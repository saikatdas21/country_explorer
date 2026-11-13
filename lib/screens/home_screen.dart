import 'package:flutter/material.dart';
import '../models/country.dart';
import '../services/country_service.dart';
import 'country_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CountryService _service = CountryService();
  final TextEditingController _searchController =
  TextEditingController();

  late Future<List<Country>> _countries;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  void _loadCountries() {
    _countries = _service.fetchCountries();
  }

  Future<void> _refreshCountries() async {
    setState(() {
      _loadCountries();
    });

    await _countries;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatPopulation(int population) {
    return population.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ',',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF172B4D),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Country Explorer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Header section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 25),
            decoration: const BoxDecoration(
              color: Color(0xFF172B4D),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Explore the World',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Discover countries and learn about them.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 22),

                // Search bar
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search countries...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Country list
          Expanded(
            child: FutureBuilder<List<Country>>(
              future: _countries,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cloud_off,
                            size: 55,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 12),
                          const Text('Unable to load countries'),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _loadCountries();
                              });
                            },
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final allCountries = snapshot.data ?? [];

                final filteredCountries = allCountries.where(
                      (country) {
                    return country.name.toLowerCase().contains(
                      _searchQuery,
                    ) ||
                        country.region.toLowerCase().contains(
                          _searchQuery,
                        ) ||
                        country.capital.toLowerCase().contains(
                          _searchQuery,
                        );
                  },
                ).toList();

                if (filteredCountries.isEmpty) {
                  return const Center(
                    child: Text('No countries found.'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refreshCountries,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = filteredCountries[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 13),
                        elevation: 1,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CountryDetailsScreen(
                                      country: country,
                                    ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                  child: country.flagUrl.isNotEmpty
                                      ? Image.network(
                                    country.flagUrl,
                                    width: 76,
                                    height: 55,
                                    fit: BoxFit.cover,
                                    errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                        ) {
                                      return _flagFallback(
                                        country,
                                      );
                                    },
                                  )
                                      : _flagFallback(country),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        country.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF172B4D),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Capital: ${country.capital}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        country.region,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Population: ${_formatPopulation(country.population)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _flagFallback(Country country) {
    return Container(
      width: 76,
      height: 55,
      alignment: Alignment.center,
      color: const Color(0xFFE9EEF5),
      child: Text(
        country.flagEmoji.isNotEmpty
            ? country.flagEmoji
            : '🌍',
        style: const TextStyle(fontSize: 32),
      ),
    );
  }
}
