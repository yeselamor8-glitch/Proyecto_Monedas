class Moneda {
  final int id;
  final String sigla;
  final String moneda;

  Moneda({required this.id, required this.sigla, required this.moneda});

  factory Moneda.fromJson(Map<String, dynamic> json) {
    return Moneda(
      id: json['id'],
      sigla: json['sigla'] ?? '',
      moneda: json['moneda'] ?? '',
    );
  }
}