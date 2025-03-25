import 'dart:math';
import 'package:flutter/material.dart';

class ColorR extends Color {
  ColorR(super.value);

  /// Método estático que genera un color aleatorio con opacidad variable
  static ColorR getRandomColorWithOpacity() {
    Random random = Random();
    return ColorR.fromARGB(
      random.nextInt(256), // Opacidad (0-255)
      random.nextInt(256), // Rojo (0-255)
      random.nextInt(256), // Verde (0-255)
      random.nextInt(256), // Azul (0-255)
    );
  }

  static Color getBrightRandomColor() {
    Random random = Random();
    return HSVColor.fromAHSV(
      1.0, // Opacidad (1.0 = 100%)
      random.nextDouble() * 360, // Tono (Hue) en grados (0-360)
      0.8 +
          random.nextDouble() * 0.2, // Saturación (0.8-1.0 para colores vivos)
      0.8 +
          random.nextDouble() *
              0.2, // Brillo (0.8-1.0 para evitar tonos oscuros)
    ).toColor();
  }

  /// Constructor adicional para facilitar la creación desde ARGB
  ColorR.fromARGB(super.a, super.r, super.g, super.b) : super.fromARGB();
}
