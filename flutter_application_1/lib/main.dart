import 'package:flutter/material.dart';
import 'package:flutter_application_1/insertarUsuarios.dart';
import 'package:flutter_application_1/ListarUsuarios.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    const String apiUrl = 'https://apiindividual.onrender.com/api/usuarios';
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> users = json.decode(response.body);

        final userFound = users.any((user) =>
            user['nombre'] == username && user['contraseña'] == password);

        if (userFound) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          _showErrorDialog('Nombre o contraseña incorrectos.');
        }
      } else {
        _showErrorDialog('Error en la solicitud HTTP.');
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 240, 110, 190),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de Sesión'),
        backgroundColor: const Color.fromARGB(255, 240, 110, 190),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Container(
              margin: EdgeInsets.only(bottom: 20), // Margen inferior para separar de los botones
              child: Image.asset(
                'assets/beuty.jpg', // Ruta de tu imagen de logo
                width: 5000, // Ancho del logo
                height: 100, // Alto del logo
              ),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                icon: Icon(Icons.person),
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                icon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Iniciar Sesión'),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 240, 110, 190),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  Future<void> _mostrarConfirmacionCerrarSesion(BuildContext context) async {
    bool confirmacion = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Estás seguro de cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );

    if (confirmacion == true) {
      // Realizar acción de cerrar sesión si se confirma
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias CRUD'),
        backgroundColor: Color.fromARGB(255, 240, 110, 190),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _mostrarConfirmacionCerrarSesion(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo en la parte superior
            Container(
              margin: EdgeInsets.only(bottom: 20), // Margen inferior para separar de los botones
              child: Image.asset(
                'assets/beuty.jpg', // Ruta de tu imagen de logo
                width: 5000, // Ancho del logo
                height: 100, // Alto del logo
              ),
            ),
          ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InsertarUsuarios(),
                  ),
                );
              },
              icon: Image.asset(
                'assets/insertar.png', // Ruta de la imagen
                width: 24, // Ancho de la imagen
                height: 24, // Alto de la imagen
              ),
              label: const Text('Insertar categoria'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 240, 110, 190),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListarUsuarios(),
                  ),
                );
              },
              icon: Image.asset(
                'assets/listar.png', // Ruta de la imagen
                width: 24, // Ancho de la imagen
                height: 24, // Alto de la imagen
              ),
              label: const Text('Listar categorias'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 240, 110, 190),
              ),
            ),
          ],
        ),
      ),
    );
  }
}