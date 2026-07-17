import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgets/info_card.dart';
import 'api_service.dart';
import 'async_demo.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'notification_service.dart';

class CupertinoRadioTile<T> extends StatelessWidget {
  const CupertinoRadioTile({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final Widget title;
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final bool selected = value == groupValue;
    final borderColor = selected ? CupertinoColors.activeBlue : CupertinoColors.inactiveGray;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 2),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DefaultTextStyle(
                style: CupertinoTheme.of(context).textTheme.textStyle,
                child: title,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PantallaSiguiente extends StatefulWidget {
  const PantallaSiguiente({super.key});

  @override
  State<PantallaSiguiente> createState() => _PantallaSiguienteState();
}

class _PantallaSiguienteState extends State<PantallaSiguiente> {
  int _paginaActual = 0;
  String _tipoUsuario = '';
  bool _textoRojo = false;
  Future<String>? _futureOperacion;
  int _computeResult = 0;
  int _timerCount = 0;
  Timer? _timer;

  final TextEditingController _userIdController = TextEditingController(text: '1');
  final TextEditingController _userNameController = TextEditingController(text: 'Demo User');
  final TextEditingController _userEmailController = TextEditingController(text: 'demo@example.com');
  String _crudResult = '';

  static const List<Color> _coloresTexto = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.purple,
  ];

  void _cambiarPagina(int index) {
    setState(() {
      _paginaActual = index;
    });
  }

  void _mostrarMensaje(String titulo, String mensaje) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: SingleChildScrollView(child: Text(mensaje)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    NotificationService.init();
  }

  void _mostrarResultadoCrud(String titulo, String mensaje) {
    setState(() {
      _crudResult = '$titulo:\n$mensaje';
    });
  }

  Future<void> _cargarUsuarios() async {
    try {
      final users = await ApiService.fetchUsers();
      final nombres = users.map((u) => u['name']?.toString() ?? 'Sin nombre').take(10).join('\n');
      _mostrarResultadoCrud('Usuarios cargados', nombres);
    } catch (e) {
      _mostrarResultadoCrud('Error al cargar usuarios', e.toString());
    }
  }

  Future<void> _crearUsuarioDemo() async {
    final nombre = _userNameController.text.trim();
    final email = _userEmailController.text.trim();
    if (nombre.isEmpty || email.isEmpty) {
      _mostrarResultadoCrud('Error', 'Debe ingresar nombre y email para crear un usuario.');
      return;
    }

    try {
      final nuevo = await ApiService.createUser({'name': nombre, 'email': email});
      _mostrarResultadoCrud('Usuario creado', nuevo.toString());
      await NotificationService.showNotification(1, 'Usuario creado', 'Usuario $nombre creado correctamente');
    } catch (e) {
      _mostrarResultadoCrud('Error al crear usuario', e.toString());
    }
  }

  Future<void> _actualizarUsuarioDemo() async {
    final id = int.tryParse(_userIdController.text.trim());
    final nombre = _userNameController.text.trim();
    final email = _userEmailController.text.trim();
    if (id == null || id <= 0) {
      _mostrarResultadoCrud('Error', 'ID de usuario inválido para actualizar.');
      return;
    }
    if (nombre.isEmpty && email.isEmpty) {
      _mostrarResultadoCrud('Error', 'Ingresa al menos nombre o email para actualizar.');
      return;
    }

    final payload = <String, dynamic>{};
    if (nombre.isNotEmpty) payload['name'] = nombre;
    if (email.isNotEmpty) payload['email'] = email;

    try {
      final actualizado = await ApiService.updateUser(id, payload);
      _mostrarResultadoCrud('Usuario actualizado', actualizado.toString());
    } catch (e) {
      _mostrarResultadoCrud('Error al actualizar usuario', e.toString());
    }
  }

  Future<void> _eliminarUsuarioDemo() async {
    final id = int.tryParse(_userIdController.text.trim());
    if (id == null || id <= 0) {
      _mostrarResultadoCrud('Error', 'ID de usuario inválido para eliminar.');
      return;
    }

    try {
      await ApiService.deleteUser(id);
      _mostrarResultadoCrud('Usuario eliminado', 'El usuario con ID $id fue eliminado.');
    } catch (e) {
      _mostrarResultadoCrud('Error al eliminar usuario', e.toString());
    }
  }

  Future<void> _iniciarFutureBuilder() async {
    setState(() {
      _futureOperacion = simulateNetworkCall();
    });
  }

  Future<void> _ejemploAsyncAwait() async {
    try {
      final res = await simulateNetworkCall();
      _mostrarMensaje('async/await', res);
    } catch (e) {
      _mostrarMensaje('Error', e.toString());
    }
  }

  Future<void> _runComputeDemo() async {
    setState(() => _computeResult = 0);
    try {
      // usa compute para ejecutar fibonacci pesado en otro isolate
      final result = await compute(heavyFibonacci, 40);
      setState(() => _computeResult = result);
    } catch (e) {
      _mostrarMensaje('Error', e.toString());
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timerCount = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) => setState(() => _timerCount++));
    setState(() {});
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    _userIdController.dispose();
    _userNameController.dispose();
    _userEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Siguiente'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'toggle') {
                setState(() => _textoRojo = !_textoRojo);
              } else if (value == 'reset') {
                setState(() => _paginaActual = 0);
              } else if (value == 'about') {
                showDialog<void>(
                  context: context,
                  builder: (context) => const AlertDialog(
                    title: Text('Acerca de'),
                    content: Text('Pantalla de ejemplo.'),
                  ),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'toggle', child: Text('Alternar color')), 
              PopupMenuItem(value: 'reset', child: Text('Reiniciar slider')),
              PopupMenuItem(value: 'about', child: Text('Acerca de')),
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
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 180,
                alignment: Alignment.center,
                child: Text(
                  'HOLO',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: _textoRojo ? Colors.red : _coloresTexto[_paginaActual],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Slider(
                value: _paginaActual.toDouble(),
                min: 0,
                max: (_coloresTexto.length - 1).toDouble(),
                divisions: _coloresTexto.length - 1,
                label: _coloresTexto[_paginaActual].toString().split('.').last,
                onChanged: (double value) => _cambiarPagina(value.round()),
              ),
              const SizedBox(height: 24),

              // Sección: elección de tipo
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Que eres?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  CupertinoRadioTile<String>(
                    title: const Text('Hombre'),
                    value: 'hombre',
                    groupValue: _tipoUsuario,
                    onChanged: (value) {
                      if (value != null) setState(() => _tipoUsuario = value);
                    },
                  ),
                  CupertinoRadioTile<String>(
                    title: const Text('Mujer'),
                    value: 'mujer',
                    groupValue: _tipoUsuario,
                    onChanged: (value) {
                      if (value != null) setState(() => _tipoUsuario = value);
                    },
                  ),
                  CupertinoRadioTile<String>(
                    title: const Text('Helicoptero apache'),
                    value: 'helicoptero apache',
                    groupValue: _tipoUsuario,
                    onChanged: (value) {
                      if (value != null) setState(() => _tipoUsuario = value);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              InfoCard(
                title: 'Tipo de usuario',
                subtitle: _tipoUsuario.isEmpty ? 'No seleccionado' : _tipoUsuario,
                icon: Icons.person,
                onTap: () {},
              ),
              const SizedBox(height: 12),

              // Sección: color y switch
              Column(
                children: [
                  Text(
                    _textoRojo ? 'Rojo' : 'Azul',
                    style: TextStyle(
                      fontSize: 24,
                      color: _textoRojo ? Colors.red : Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoSwitch(
                    value: _textoRojo,
                    onChanged: (valor) => setState(() => _textoRojo = valor),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              InfoCard(
                title: 'Color seleccionado',
                subtitle: _textoRojo ? 'Rojo (manual)' : _coloresTexto[_paginaActual].toString().split('.').last,
                icon: Icons.color_lens,
                onTap: () {},
              ),
              const SizedBox(height: 12),

              // API CRUD card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('CRUD de usuarios', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _userIdController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'ID de usuario',
                          hintText: 'Usa 1 para datos de ejemplo',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _userNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _userEmailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton(onPressed: _cargarUsuarios, child: const Text('Cargar usuarios')),
                          ElevatedButton(onPressed: _crearUsuarioDemo, child: const Text('Crear usuario')),
                          ElevatedButton(onPressed: _actualizarUsuarioDemo, child: const Text('Actualizar usuario')),
                          ElevatedButton(onPressed: _eliminarUsuarioDemo, child: const Text('Eliminar usuario')),
                          ElevatedButton(onPressed: () => NotificationService.showNotification(2, 'Prueba', 'Notificación manual'), child: const Text('Notificación')),
                        ],
                      ),
                      if (_crudResult.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),
                        const Text('Resultado', style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            _crudResult,
                            style: const TextStyle(fontSize: 14, height: 1.4),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Async demos card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Operaciones async', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton(onPressed: _iniciarFutureBuilder, child: const Text('Iniciar Future')),
                          ElevatedButton(onPressed: _ejemploAsyncAwait, child: const Text('async/await')),
                          ElevatedButton(onPressed: _runComputeDemo, child: const Text('Compute (Isolate)')),
                          ElevatedButton(onPressed: _startTimer, child: const Text('Iniciar Timer')),
                          ElevatedButton(onPressed: _stopTimer, child: const Text('Parar Timer')),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Timer: $_timerCount s'),
                      const SizedBox(height: 8),
                      Text('Compute result: $_computeResult'),
                      const SizedBox(height: 8),
                      // FutureBuilder demo
                      _futureOperacion == null
                          ? const Text('Presiona "Iniciar Future" para ver un FutureBuilder')
                          : FutureBuilder<String>(
                              future: _futureOperacion,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator();
                                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                                return Text('Resultado: ${snapshot.data}');
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
