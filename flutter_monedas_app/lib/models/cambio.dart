class Cambio {
  final int id;
  final int idMoneda;
  final String fecha;
  final double valor;

  Cambio({required this.id, required this.idMoneda, required this.fecha, required this.valor});

  factory Cambio.fromJson(Map<String, dynamic> json) {
    return Cambio(
      id: json['id'] ?? 0,
      idMoneda: json['idMoneda'] ?? 0,
      fecha: json['fecha'] ?? '',
      valor: (json['valor'] as num).toDouble(),
    );
  }
}