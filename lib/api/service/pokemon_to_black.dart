import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image/image.dart';

Future<(Uint8List, Uint8List)> convertToBlackAndWhite(Uri imageUrl) async {
  // Descarga la imagen
  final response = await http.get(imageUrl);

  // Comprueba si la solicitud fue exitosa
  if (response.statusCode == 200) {
    // Si la solicitud fue exitosa,  guarda los bytes de la imagen
    var imagebytes = response.bodyBytes;

    Image image = decodeImage(imagebytes)!;

    // Usando luminanceThreshold, convierte la imagen a blanco

    var imagebw = luminanceThreshold(image, threshold: 1);

    // Codifica la imagen en bytes
    var imagebwbytes = encodePng(imagebw);

    // Devuelve los bytes de la imagen
    return (imagebytes, Uint8List.fromList(imagebwbytes));
  } else {
    // Si la solicitud falló, lanza una excepción
    throw Exception('Failed to download image');
  }
}
