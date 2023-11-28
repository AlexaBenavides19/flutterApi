import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InsertarUsuarios extends StatefulWidget {
  const InsertarUsuarios({Key? key}) : super(key: key);

  @override
  State<InsertarUsuarios> createState() => _InsertarUsuariosState();
}

class _InsertarUsuariosState extends State<InsertarUsuarios> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController categoriaController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

 Future<void> insertarcategoria() async {
    final nuevoProducto = {
      'id': idController.text,
      'categoria': categoriaController.text,
      'descripcion': descripcionController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('https://proyectoapi-ffib.onrender.com/api/categoria'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(nuevoProducto),
      );

      if (response.statusCode == 200) {
        // Producto insertado exitosamente
        print('Nuevo producto insertado: $nuevoProducto');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Categoría insertada correctamente'),
            backgroundColor: Color.fromARGB(255, 243, 9, 99),
          ),
        );
        // Puedes agregar aquí alguna acción adicional después de la inserción
      } else {
        // Manejar el caso en el que la inserción falla
        print('Error al insertar el producto. Código de estado: ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
        // Puedes agregar aquí alguna lógica de manejo de errores
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
      // Puedes agregar aquí alguna lógica de manejo de errores
    }

    // Limpiar los controladores después de la inserción
    idController.clear();
    categoriaController.clear();
    descripcionController.clear();
  }

  bool camposObligatoriosLlenos() {
    return idController.text.isNotEmpty &&
        categoriaController.text.isNotEmpty &&
        descripcionController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insertar nueva categoria'),
        backgroundColor: Color.fromARGB(255, 240, 110, 190),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: idController,
                decoration: const InputDecoration(labelText: 'ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: categoriaController,
                decoration: const InputDecoration(labelText: 'Categoría'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la categoría';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    insertarcategoria();
                  }
                },
                child: const Text('Insertar categoria'),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 240, 110, 190),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}