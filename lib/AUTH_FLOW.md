# Flujo de Autenticación

El sistema de autenticación utiliza:

1. **Pantallas**:
   - `auth_screen.dart`: Login principal
   - `register_screen.dart`: Registro de nuevos usuarios

2. **BLoC**:
   - Maneja estados de autenticación
   - Eventos: login, registro, logout
   - Estados: loading, authenticated, error

3. **Repositorio**:
   - `auth_repository.dart`
   - Implementa llamadas a Firebase Auth
   - Maneja persistencia de sesión

Diagrama de flujo:
Usuario -> Pantalla -> BLoC -> Repositorio -> Firebase