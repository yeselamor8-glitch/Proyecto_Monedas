import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/moneda.dart';
import '../models/cambio.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class ConsultaScreen extends StatefulWidget {
  final String token;
  ConsultaScreen({required this.token});

  @override
  _ConsultaScreenState createState() => _ConsultaScreenState();
}

class _ConsultaScreenState extends State<ConsultaScreen> {
  final ApiService _apiService = ApiService();
  
  List<Moneda> _monedas = [];
  Moneda? _monedaSeleccionada;
  DateTime _fechaDesde = DateTime.now().subtract(Duration(days: 30));
  DateTime _fechaHasta = DateTime.now();
  List<Cambio> _cambios = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarMonedas();
  }

  void _cargarMonedas() async {
    setState(() => _isLoading = true);
    List<Moneda> monedas = await _apiService.listarMonedas(widget.token);
    setState(() {
      _monedas = monedas;
      _isLoading = false;
    });
  }

  Future<void> _seleccionarFecha(bool esDesde) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: esDesde ? _fechaDesde : _fechaHasta,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (esDesde) {
          _fechaDesde = picked;
        } else {
          _fechaHasta = picked;
        }
      });
    }
  }

  void _consultarCambios() async {
    if (_monedaSeleccionada == null) return;
    
    setState(() => _isLoading = true);
    String desdeStr = DateFormat('yyyy-MM-dd').format(_fechaDesde);
    String hastaStr = DateFormat('yyyy-MM-dd').format(_fechaHasta);

    List<Cambio> cambios = await _apiService.listarCambiosPorPeriodo(
      widget.token,
      _monedaSeleccionada!.id,
      desdeStr,
      hastaStr,
    );

    setState(() {
      _cambios = cambios;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta de Cambios'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown de Monedas
            DropdownButtonFormField<Moneda>(
              decoration: InputDecoration(labelText: 'Seleccione una moneda'),
              value: _monedaSeleccionada,
              items: _monedas.map((Moneda m) {
                return DropdownMenuItem<Moneda>(
                  value: m,
                  child: Text('${m.sigla} - ${m.moneda}'),
                );
              }).toList(),
              onChanged: (Moneda? nuevaMoneda) {
                setState(() {
                  _monedaSeleccionada = nuevaMoneda;
                });
              },
            ),
            SizedBox(height: 16),
            
            // Fechas
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text('Desde: ${DateFormat('yyyy-MM-dd').format(_fechaDesde)}'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () => _seleccionarFecha(true),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text('Hasta: ${DateFormat('yyyy-MM-dd').format(_fechaHasta)}'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () => _seleccionarFecha(false),
                  ),
                ),
              ],
            ),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _consultarCambios,
              child: Text('Consultar Cambios'),
            ),
            SizedBox(height: 16),
            
            // Resultados
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _cambios.length,
                      itemBuilder: (context, index) {
                        final cambio = _cambios[index];
                        return Card(
                          child: ListTile(
                            title: Text('Fecha: ${cambio.fecha}'),
                            subtitle: Text('Valor: ${cambio.valor}'),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}