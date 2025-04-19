class Quake {
  final double magnitude;
  final String place;
  final int time;
  final String url;
  final double latitude;
  final double longitude;
  final double depth;

  Quake({
    required this.magnitude,
    required this.place,
    required this.time,
    required this.url,
    required this.latitude,
    required this.longitude,
    required this.depth,
  });

  // Método para criar uma instância de Quake a partir de um Map (JSON)
  factory Quake.fromJson(Map<String, dynamic> json) {
    return Quake(
      magnitude: (json['properties']['mag'] as num).toDouble(), // Assegura que o valor seja um double
      place: json['properties']['place'] as String,
      time: json['properties']['time'] as int,
      url: json['properties']['url'] as String,
      latitude: (json['geometry']['coordinates'][1] as num).toDouble(),
      longitude: (json['geometry']['coordinates'][0] as num).toDouble(),
      depth: (json['geometry']['coordinates'][2] as num).toDouble(),
    );
  }
}
