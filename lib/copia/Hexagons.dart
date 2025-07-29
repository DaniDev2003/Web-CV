import 'dart:math';
import 'package:flutter/material.dart';

import 'Homepage.dart';

class HexagonButton extends StatefulWidget {
  @override
  _HexagonButtonState createState() => _HexagonButtonState();
}

class _HexagonButtonState extends State<HexagonButton> {
  int randomNumber = random.nextInt(101);
  double translateY = 0.0; // Desplazamiento inicial
  double translateX = 0.0;

  @override
  Widget build(BuildContext context) {
    return alto! > ancho! ? Stack(
      children: [
        Material(
            color: Colors.transparent,
            child: Card(
              color: gris,
              shape: HexagonShapeBorder(),
              elevation: 0, // Elevación siempre en 0, ya que estamos usando transformación
              child: SizedBox(
                width: 115,
                height: 72,
              ),
            ),
          ),
        randomNumber < 30 ? GradientHexagonContainer(
          translateX: translateX,
          translateY: translateY,
        ) : Container(),
      ],
    ) :
      MouseRegion(
        onEnter: (event) {
          // Guardar la posición anterior del mous
          // Cuando el mouse entra, el botón se "eleva" con un desplazamiento
          setState(() {
            // Si es la primera entrada, levantar hacia arriba
            if (previousMouseX == null) {
              translateY = -6.0;
              translateX = 0.0;
              previousMouseX = event.position.dx;
            } else {
              // Comparar la posición actual del mouse con la anterior
              if (previousMouseX! > event.position.dx) {
                // Movimiento hacia la izquierda
                translateY = -6.0;
                translateX = -6.0;
                previousMouseX = event.position.dx;
              } else {
                // Movimiento hacia la derecha
                translateY = -6.0;
                translateX = 6.0;
                previousMouseX = event.position.dx;
              }
              // Actualizar la posición anterior
              previousMouseX = event.position.dx;
            }
          });
        },
        onExit: (event) {
          // Cuando el mouse sale, vuelve a su posición original
          setState(() {
            translateY = 0.0;
            translateX = 0.0;
          });
        },
        child: Stack(
          children: [
            Card(
              color: celeste,
              shape: HexagonShapeBorder2(),
              elevation: 0, // Elevación siempre en 0, ya que estamos usando transformación
              child: SizedBox(
                width: 115,
                height: 72,
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200), // Animación suave
              transform: Matrix4.translationValues(translateX, translateY, 0), // Desplaza en el eje Y
              child: Material(
                color: Colors.transparent,
                child: Card(
                  color: gris,
                  shape: HexagonShapeBorder(),
                  elevation: 0, // Elevación siempre en 0, ya que estamos usando transformación
                  child: SizedBox(
                    width: 115,
                    height: 72,
                  ),
                ),
              ),
            ),
            randomNumber < 30 ? GradientHexagonContainer(
              translateX: translateX,
              translateY: translateY,
            ) : Container(),
          ],
        )
    );
  }
}

class GradientHexagonContainer extends StatelessWidget {
  final double translateX;
  final double translateY;

  GradientHexagonContainer({required this.translateX, required this.translateY});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      transform: Matrix4.translationValues(translateX + 4, translateY + 4, 0),
      child: CustomPaint(
        size: Size(115, 72),
        painter: GradientHexagonPainter(),
      ),
    );
  }
}

class GradientHexagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withOpacity(0.7),
          Colors.transparent,
          Colors.transparent
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final hexagonPath = HexagonShapeBorder().getOuterPath(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(hexagonPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class GradientHexagonContainer2 extends StatelessWidget {
  final double translateX;
  final double translateY;

  GradientHexagonContainer2({required this.translateX, required this.translateY});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      transform: Matrix4.translationValues(translateX ,translateY, 0),
      child: CustomPaint(
        size: Size(115, 72),
        painter: GradientHexagonPainter2(),
      ),
    );
  }
}

class GradientHexagonPainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withOpacity(0.4),
          Colors.transparent
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final hexagonPath = HexagonShapeBorder().getOuterPath(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(hexagonPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class GradientHexagonContainer3 extends StatelessWidget {
  final double translateX;
  final double translateY;

  GradientHexagonContainer3({required this.translateX, required this.translateY});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      transform: Matrix4.translationValues(translateX ,translateY, 0),
      child: CustomPaint(
        size: Size(115, 72),
        painter: GradientHexagonPainter3(),
      ),
    );
  }
}

class GradientHexagonPainter3 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          Colors.transparent
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final hexagonPath = HexagonShapeBorder().getOuterPath(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(hexagonPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class HexagonShapeBorder extends ShapeBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final double hexRadius = 40; // Ajustamos el radio para que se adapte
    final Path hexagonPath = Path();

    for (int i = 0; i < 6; i++) {
      double angle = (2 * pi / 6) * i;
      double x = rect.center.dx + hexRadius * cos(angle);
      double y = rect.center.dy + hexRadius * sin(angle);
      if (i == 0) {
        hexagonPath.moveTo(x, y);
      } else {
        hexagonPath.lineTo(x, y);
      }
    }
    hexagonPath.close();
    return hexagonPath;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(8.0);

  @override
  ShapeBorder scale(double t) => this;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  BorderSide get side => BorderSide.none;
}

class HexagonShapeBorder2 extends ShapeBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final double hexRadius = 39; // Ajustamos el radio para que se adapte
    final Path hexagonPath = Path();

    for (int i = 0; i < 6; i++) {
      double angle = (2 * pi / 6) * i;
      double x = rect.center.dx + hexRadius * cos(angle);
      double y = rect.center.dy + hexRadius * sin(angle);
      if (i == 0) {
        hexagonPath.moveTo(x, y);
      } else {
        hexagonPath.lineTo(x, y);
      }
    }
    hexagonPath.close();
    return hexagonPath;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(8.0);

  @override
  ShapeBorder scale(double t) => this;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  BorderSide get side => BorderSide.none;
}
