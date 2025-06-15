# Arquitectura de la Aplicación

Esta aplicación sigue una arquitectura limpia con separación de capas:

- **Capa de Presentación**: 
  - Widgets y pantallas en `lib/features/*/screens/`
  - BLoCs para manejo de estado

- **Capa de Dominio**: 
  - Modelos de datos en `lib/features/*/models/`
  - Casos de uso (implícitos en los BLoCs)

- **Capa de Datos**: 
  - Repositorios en `lib/features/*/repositories/`
  - Conexión con Firebase

Estructura de directorios:
- `app/`: Configuración inicial
- `core/`: Componentes compartidos
- `features/`: Funcionalidades separadas