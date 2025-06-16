import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Términos y Condiciones de Uso',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Última actualización: 15 de junio de 2025',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 24),
            Text(
              '1. Aceptación de los Términos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Al acceder y usar esta aplicación, usted acepta cumplir con estos términos y condiciones. Si no está de acuerdo con alguna parte de estos términos, no debe utilizar la aplicación.',
            ),
            SizedBox(height: 16),
            Text(
              '2. Uso de la Aplicación',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'La aplicación Notas Discretas está diseñada para uso personal. Usted acepta no utilizar la aplicación para ningún propósito ilegal o no autorizado.',
            ),
            SizedBox(height: 16),
            Text(
              '3. Privacidad',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Su privacidad es importante para nosotros. Todos los datos personales que proporcione estarán protegidos según nuestra Política de Privacidad.',
            ),
            SizedBox(height: 16),
            Text(
              '4. Limitación de Responsabilidad',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'En ningún caso la Universidad Nacional o los desarrolladores serán responsables por daños indirectos, incidentales o consecuentes que resulten del uso de esta aplicación.',
            ),
            SizedBox(height: 16),
            Text(
              '5. Cambios en los Términos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Nos reservamos el derecho de modificar estos términos en cualquier momento. Se le notificarán los cambios importantes a través de la aplicación.',
            ),
            SizedBox(height: 24),
            Text(
              'Al usar esta aplicación, usted confirma que ha leído, entendido y aceptado estos términos y condiciones en su totalidad.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
