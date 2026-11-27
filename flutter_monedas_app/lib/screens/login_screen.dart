import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'consulta_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usuarioController = TextEditingController();
  final _claveController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _hacerLogin() async {
    setState(() => _isLoading = true);
    String? token = await _apiService.login(_usuarioController.text, _claveController.text);
    
    setState(() => _isLoading = false);

    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ConsultaScreen(token: token)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Credenciales incorrectas o error de red')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Monedas')),
      body: Center(
        child: Container(
          width: 400,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Usuario:', style: TextStyle(fontSize: 16)),
              TextField(
                controller: _usuarioController,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 15),
              Text('Clave:', style: TextStyle(fontSize: 16)),
              TextField(
                controller: _claveController,
                obscureText: true,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              _isLoading 
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _hacerLogin,
                    child: Text('Iniciar Sesión'),
                  )
            ],
          ),
        ),
      ),
    );
  }
}