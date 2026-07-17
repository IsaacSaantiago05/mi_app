import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'database_helper.dart';
import 'widgets/custom_controls.dart';
import 'file_service.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  final TextEditingController _controladorNombreUsuario = TextEditingController();
  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorContrasena = TextEditingController();
  bool _aceptaTerminos = false;
  bool _mostrarContrasena = false;

  final List<String> _dominiosPermitidos = [
    'gmail.com',
    'yahoo.com',
    'outlook.com',
    'hotmail.com',
    'live.com',
  ];

  bool get _nombreValido {
    final nombre = _controladorNombreUsuario.text.trim();
    return nombre.isNotEmpty && nombre.length >= 3;
  }

  bool get _emailValido {
    final email = _controladorEmail.text.trim();
    if (email.isEmpty) return false;

    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(email)) return false;

    final dominio = email.split('@').last.toLowerCase();
    return _dominiosPermitidos.contains(dominio);
  }

  bool get _contrasenaValida {
    final contrasena = _controladorContrasena.text;
    return contrasena.length >= 6;
  }

  String _encriptarContrasena(String contrasena) {
    return sha256.convert(utf8.encode(contrasena)).toString();
  }

  void _mostrarAlerta(String titulo, String mensaje) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarTerminos() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 12),
                Text('1.'),
                SizedBox(height: 8),
                Text('2. '),
                SizedBox(height: 8),
                Text('3. '),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onRegistrarPressed() async {
    final nombre = _controladorNombreUsuario.text.trim();
    final email = _controladorEmail.text.trim();
    final contrasena = _controladorContrasena.text;

    if (nombre.isEmpty) {
      _mostrarAlerta('Error', 'El nombre de usuario no puede estar vacío.');
      return;
    }

    if (nombre.length < 3) {
      _mostrarAlerta('Error', 'El nombre de usuario debe tener al menos 3 caracteres.');
      return;
    }

    if (email.isEmpty) {
      _mostrarAlerta('Error', 'El correo no puede estar vacío.');
      return;
    }

    if (!_emailValido) {
      _mostrarAlerta(
        'Error',
        'El correo no es válido. Dominios aceptados: gmail.com, yahoo.com, outlook.com, hotmail.com, live.com.',
      );
      return;
    }

    if (contrasena.isEmpty) {
      _mostrarAlerta('Error', 'La contraseña no puede estar vacía.');
      return;
    }

    if (contrasena.length < 6) {
      _mostrarAlerta('Error', 'La contraseña debe tener al menos 6 caracteres.');
      return;
    }

    if (!_aceptaTerminos) {
      _mostrarAlerta('Error', 'Debes aceptar los términos legales antes de continuar.');
      return;
    }

    final contrasenaEncriptada = _encriptarContrasena(contrasena);
    final usuario = {
      'nombre': nombre,
      'email': email,
      'contrasena': contrasenaEncriptada,
    };

    bool registroExitoso = false;
    String mensaje = 'No se pudo guardar el usuario. Verifica que el correo no exista.';

    try {
      await DatabaseHelper.instance.insertUsuario(usuario);
      registroExitoso = true;
      mensaje = 'Usuario registrado correctamente.';
    } catch (e) {
      if (e.toString().contains('duplicado') || e.toString().contains('email')) {
        mensaje = 'Ese correo ya está registrado.';
      }
    }

    if (!mounted) return;

    _mostrarAlerta(registroExitoso ? 'Éxito' : 'Error', mensaje);

    if (registroExitoso) {
      Navigator.of(context).pushNamed('/siguiente');
    }
  }

  Future<void> _guardarEnArchivo() async {
    final nombre = _controladorNombreUsuario.text.trim();
    final email = _controladorEmail.text.trim();
    final contrasena = _controladorContrasena.text;
    final contrasenaEncriptada = _encriptarContrasena(contrasena);
    final contenido = 'nombre: $nombre\nemail: $email\ncontrasena: $contrasenaEncriptada\n';

    try {
      await FileService.writeText('usuario.txt', contenido);
      if (!mounted) return;
      _mostrarAlerta('Archivo', 'Datos guardados en usuario.txt');
    } catch (e) {
      if (!mounted) return;
      _mostrarAlerta('Error', 'No se pudo guardar el archivo: $e');
    }
  }

  Future<void> _leerArchivo() async {
    try {
      final contenido = await FileService.readText('usuario.txt');
      if (!mounted) return;
      _mostrarAlerta('Contenido de usuario.txt', contenido.isEmpty ? 'Archivo vacío' : contenido);
    } catch (e) {
      if (!mounted) return;
      _mostrarAlerta('Error', 'No se pudo leer el archivo: $e');
    }
  }

  @override
  void dispose() {
    _controladorNombreUsuario.dispose();
    _controladorEmail.dispose();
    _controladorContrasena.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de usuario'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'perfil') {
                _mostrarAlerta('Perfil', 'Aquí iría la información del perfil.');
              } else if (value == 'ajustes') {
                Navigator.of(context).pushNamed('/siguiente');
              } else if (value == 'cerrar') {
                _mostrarAlerta('Sesión', 'Has cerrado sesión.');
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'perfil', child: Text('Perfil')),
              PopupMenuItem(value: 'ajustes', child: Text('Ajustes')),
              PopupMenuItem(value: 'cerrar', child: Text('Cerrar sesión')),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: const Text('Mi App', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () => Navigator.of(context).pushReplacementNamed('/'),
            ),
            ListTile(
              leading: const Icon(Icons.arrow_forward),
              title: const Text('Siguiente'),
              onTap: () => Navigator.of(context).pushNamed('/siguiente'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cerrar sesión'),
              onTap: () {
                Navigator.of(context).pop();
                _mostrarAlerta('Sesión', 'Has cerrado sesión.');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Crear cuenta',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _controladorNombreUsuario,
                label: 'Nombre de usuario',
                keyboardType: TextInputType.text,
                hintText: 'Mínimo 3 caracteres',
                onChanged: (_) => setState(() {}),
                suffix: _controladorNombreUsuario.text.isEmpty
                    ? null
                    : Icon(
                        _nombreValido ? Icons.check_circle : Icons.error,
                        color: _nombreValido ? Colors.green : Colors.red,
                      ),
                validator: (_) => _nombreValido,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _controladorEmail,
                label: 'Correo electrónico',
                keyboardType: TextInputType.emailAddress,
                hintText: 'ejemplo@dominio.com',
                onChanged: (_) => setState(() {}),
                suffix: _controladorEmail.text.isEmpty
                    ? null
                    : Icon(
                        _emailValido ? Icons.check_circle : Icons.error,
                        color: _emailValido ? Colors.green : Colors.red,
                      ),
                validator: (_) => _emailValido,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _controladorContrasena,
                label: 'Contraseña',
                obscureText: !_mostrarContrasena,
                hintText: 'Mínimo 6 caracteres',
                onChanged: (_) => setState(() {}),
                suffix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _mostrarContrasena ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => _mostrarContrasena = !_mostrarContrasena),
                    ),
                    if (_controladorContrasena.text.isNotEmpty)
                      Icon(
                        _contrasenaValida ? Icons.check_circle : Icons.error,
                        color: _contrasenaValida ? Colors.green : Colors.red,
                      ),
                  ],
                ),
                validator: (_) => _contrasenaValida,
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _aceptaTerminos,
                    onChanged: (valor) {
                      setState(() {
                        _aceptaTerminos = valor ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: _mostrarTerminos,
                      child: const Text(
                        'Acepto los términos y condiciones',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _mostrarTerminos,
                    child: const Text('Leer'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: CustomPrimaryButton(
                  onPressed: _onRegistrarPressed,
                  label: 'Registrarse',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _guardarEnArchivo,
                      child: const Text('Guardar local'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _leerArchivo,
                      child: const Text('Leer archivo'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
