# mi_app

Aplicación Flutter de práctica con varias pantallas, validaciones, servicios locales y consumo de APIs.

## Descripción general

`mi_app` es una app de ejemplo que incluye:

- Pantalla de registro de usuario con validación de datos y encriptación de contraseña.
- Guardado local de datos en archivo (móvil/desktop).
- Persistencia de usuarios en base de datos SQLite (móvil/desktop).
- Pantalla secundaria con controles interactivos, CRUD sobre API pública, notificaciones y demos asíncronos.
- Widgets personalizados para campos de texto y botones.

## Funcionalidades implementadas

### Pantalla principal (`lib/pantalla_principal.dart`)

- Formulario de registro con campos:
  - Nombre de usuario
  - Correo electrónico
  - Contraseña
- Validaciones de formulario:
  - Nombre mínimo 3 caracteres
  - Email con formato válido y dominio permitido (`gmail.com`, `yahoo.com`, `outlook.com`, `hotmail.com`, `live.com`)
  - Contraseña mínimo 6 caracteres
  - Aceptar términos y condiciones
- Encriptación de contraseña con SHA-256 antes de almacenar.
- Inserción de usuario en base de datos local SQLite.
- Manejo de errores de registro y mensaje de usuario ya registrado.
- Guardado de datos en archivo local `usuario.txt` y lectura del mismo.
- Menú lateral (`Drawer`) con navegación a inicio y pantalla siguiente.
- Menú de opciones en AppBar con acciones de perfil, ajustes y cerrar sesión.

### Pantalla secundaria (`lib/pantalla_siguiente.dart`)

- Slider que cambia el color del texto principal.
- Selección de tipo de usuario con controles estilo Cupertino (`CupertinoRadioTile`).
- Tarjetas informativas personalizadas (`InfoCard`).
- Switch de color para alternar entre rojo y azul.
- Sección de CRUD sobre API pública usando `lib/api_service.dart` y `jsonplaceholder.typicode.com`:
  - Cargar usuarios
  - Crear usuario demo
  - Actualizar usuario por ID
  - Eliminar usuario por ID
- Notificaciones locales con `NotificationService`.
- Demos de asincronía:
  - `FutureBuilder`
  - `async/await`
  - `compute` e isolate con cálculo de Fibonacci pesado
  - Timer en tiempo real

## Servicios y utilidades

### Base de datos local

- `lib/database_helper.dart` exporta implementación según la plataforma.
- `lib/database_helper_io.dart` usa `sqflite` para SQLite en móviles y desktop.
- `lib/database_helper_web.dart` se usa en web.

### Archivo local

- `lib/file_service.dart` exporta implementación según la plataforma.
- `lib/file_service_mobile.dart` guarda y lee archivos en el directorio de documentos.
- `lib/file_service_web.dart` devuelve mensajes de no disponible en web.

### Notificaciones

- `lib/notification_service.dart` exporta implementación según la plataforma.
- `lib/notification_service_mobile.dart` usa `flutter_local_notifications` y `permission_handler`.
- `lib/notification_service_web.dart` no ejecuta notificaciones en web.

### Consumo de API

- `lib/api_service.dart` realiza peticiones HTTP a `https://jsonplaceholder.typicode.com`.

### Asincronía

- `lib/async_demo.dart` tiene simulaciones de llamadas de red y cálculo de Fibonacci para `compute`.

## Estructura de navegación

- Ruta inicial `/` → `PantallaPrincipal`
- Ruta `/siguiente` → `PantallaSiguiente`

## Dependencias importantes

- `crypto`
- `path`
- `sqflite`
- `sembast`
- `sembast_web`
- `path_provider`
- `http`
- `flutter_local_notifications`
- `permission_handler`

## Ejecutar el proyecto

Desde la carpeta `mi_app`:

```powershell
flutter pub get
flutter run -d chrome
```

Para ejecutar en Windows desktop:

```powershell
flutter run -d windows
```

> Nota: en Windows desktop se necesita la toolchain de Visual Studio C++.

## Notas por plataforma

- En web, el guardado de archivos locales se muestra como no disponible.
- En web, las notificaciones locales no se envían.
- La base de datos SQLite funciona en móvil y desktop con `sqflite`.
