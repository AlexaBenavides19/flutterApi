import 'package:flutter/material.dart';

class Editarcategoria extends StatefulWidget {
  final Map<String, dynamic> categoria;

  const Editarcategoria({Key? key, required this.categoria}) : super(key: key);

  @override
  _EditarcategoriaState createState() => _EditarcategoriaState();
}

class _EditarcategoriaState extends State<Editarcategoria> {
  late TextEditingController categoriaController;
  late TextEditingController descripcionController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    categoriaController = TextEditingController(text: widget.categoria['categoria']);
    descripcionController = TextEditingController(text: widget.categoria['descripcion']);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Categoria'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
            ],
          ),
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
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final nuevosValores = {
                'categoria': categoriaController.text,
                'descripcion': descripcionController.text,
              };
              Navigator.of(context).pop(nuevosValores);
            }
          },
          child: const Text('Guardar cambios'),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
          ),
        ),
      ],
    );
  }
}
