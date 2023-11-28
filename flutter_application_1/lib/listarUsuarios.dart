import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/insertarUsuarios.dart';
import 'package:http/http.dart' as http;

class ListarUsuarios extends StatefulWidget {
  const ListarUsuarios({Key? key}) : super(key: key);

  @override
  State<ListarUsuarios> createState() => _ListarUsuariosState();
}

class _ListarUsuariosState extends State<ListarUsuarios> {
  List<dynamic> data = [];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    getcategoria();
  }

  Future<void> getcategoria() async {
    try {
      final response = await http
          .get(Uri.parse('https://proyectoapi-ffib.onrender.com/api/categoria'));

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);

        setState(() {
          if (decodedData is List) {
            data = decodedData;
          } else if (decodedData is Map<String, dynamic> &&
              decodedData.containsKey('categoria')) {
            data = decodedData['categoria'] ?? [];
          } else {
            print('La estructura de la respuesta no es la esperada:');
            print(decodedData);
            data = [];
          }
        });
      } else {
        print(
            'Error al cargar datos. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> eliminarcategoria(String id) async {
    try {
      final response = await http.delete(
          Uri.parse('https://proyectoapi-ffib.onrender.com/api/categoria/$id'));

      if (response.statusCode == 200) {
        print('Categoria eliminado con ID: $id');
        getcategoria();
      } else {
        print(
            'Error al eliminar la categoria. Código de estado: ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
    }
  }

  Future<void> actualizarcategoria (
      String id, Map<String, dynamic> nuevosValores) async {
    try {
      final response = await http.put(
        Uri.parse('https://proyectoapi-ffib.onrender.com/api/categoria/$id'),
        headers: {
          'Content-Type':
              'application/json', // Asegurarse de que se envíen datos JSON
        },
        body: jsonEncode(nuevosValores),
      );

      if (response.statusCode == 200) {
        print('Categoria actualizado con ID: $id');
        getcategoria();
      } else {
        print(
            'Error al actualizar la categoria. Código de estado: ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
    }
  }
  Future<void> mostrarMensaje(String mensaje) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Actualización Exitosa'),
        content: Text(mensaje),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}

Future<void> mostrarDialogoEditar(Map<String, dynamic> categoria) async {
  Map<String, dynamic> nuevosValores = {
    'categoria': categoria['categoria'],
    'descripcion': categoria['descripcion'],
  };

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Editar categoria'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller:
                    TextEditingController(text: categoria['categoria']),
                decoration: const InputDecoration(labelText: 'Categoría'),
                onChanged: (value) {
                  nuevosValores['categoria'] = value;
                },
              ),
              TextField(
                controller:
                    TextEditingController(text: categoria['descripcion']),
                decoration: const InputDecoration(labelText: 'Descripción'),
                onChanged: (value) {
                  nuevosValores['descripcion'] = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              await actualizarcategoria(categoria['_id'], nuevosValores);
              Navigator.of(context).pop();

              // Muestra la validación de actualización exitosa
              mostrarMensaje('Actualización exitosa');
            },
            child: const Text('Guardar cambios'),
            style: ElevatedButton.styleFrom(primary: Colors.blue),
          ),
        ],
      );
    },
  );
}
   List<dynamic> get filteredData {
    return searchText.isEmpty
        ? data
        : data
            .where((item) => (item['categoria'] ?? '')
                .toLowerCase()
                .contains(searchText.toLowerCase()))
            .toList();
  }

  Future<void> mostrarDialogoEliminar(String id) async {
    bool confirmacion = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de eliminar esta categoria?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );

    if (confirmacion == true) {
      await eliminarcategoria(id);
      mostrarMensajeEliminacion();
    }
  }

  Future<void> mostrarMensajeEliminacion() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminación Exitosa'),
          content: Text('Categoria eliminada correctamente'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
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
        title: const Text('Listar categoria'),
        backgroundColor: Color.fromARGB(255, 240, 110, 190),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InsertarUsuarios(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar categoría',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.all(8),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Icon(Icons.supervised_user_circle_outlined,
                            color: Color.fromARGB(255, 240, 110, 190)),
                        SizedBox(width: 8),
                        Text('Categoria: ${filteredData[index]['categoria'] ?? 'categoria no disponible'}'),
                      ],
                    ),
                    children: [
                      ListTile(
                        title: Text(
                            'ID: ${filteredData[index]['id'] ?? 'ID no disponible'}'),
                      ),
                      ListTile(
                        title: Text(
                            'Categoría: ${filteredData[index]['categoria'] ?? 'No disponible'}'),
                      ),
                      ListTile(
                        title: Text(
                            'Descripción: ${filteredData[index]['descripcion'] ?? 'No disponible'}'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ElevatedButton(
                              onPressed: () {
                                mostrarDialogoEditar(filteredData[index]);
                              },
                              child: const Text('Actualizar categoria'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                minimumSize: const Size(150, 40),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ElevatedButton(
                              onPressed: () {
                                mostrarDialogoEliminar(filteredData[index]['_id']);
                              },
                              child: const Text('Eliminar categoria'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                minimumSize: const Size(150, 40),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
