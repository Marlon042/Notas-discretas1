import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize({required bool enableNotifications}) async {
    // Solicitar permisos para notificaciones
    if (enableNotifications) {
      await _firebaseMessaging.requestPermission();
    } else {
      print('Notificaciones desactivadas');
    }

    // Obtener el token del dispositivo
    String? token = await _firebaseMessaging.getToken();
    print('Firebase Messaging Token: $token');

    // Configurar el manejo de mensajes
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mensaje recibido: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notificación abierta: ${message.notification?.title}');
    });
  }
}
