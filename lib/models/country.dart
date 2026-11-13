class Country {
  final String name;
  final String officialName;
  final String capital;
  final String region;
  final int population;
  final String flagUrl;
  final String flagEmoji;
  final String countryCode;

  Country({
    required this.name,
    required this.officialName,
    required this.capital,
    required this.region,
    required this.population,
    required this.flagUrl,
    required this.flagEmoji,
    required this.countryCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    final capitals = json['capitals'] as List? ?? [];

    return Country(
      name: json['names']?['common'] ?? 'Unknown',
      officialName: json['names']?['official'] ?? 'Unknown',
      capital: capitals.isNotEmpty
          ? capitals.first['name'] ?? 'No capital'
          : 'No capital',
      region: json['region'] ?? 'Unknown',
      population: (json['population'] as num?)?.toInt() ?? 0,
      flagUrl: json['flag']?['url_png'] ?? '',
      flagEmoji: json['flag']?['emoji'] ?? '',
      countryCode: json['codes']?['alpha_2'] ?? '',
    );
  }
}
