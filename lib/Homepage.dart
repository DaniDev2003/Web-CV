import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Hexagons.dart';
import 'package:animate_gradient/animate_gradient.dart';

//medidas
double? alto;
double? ancho;

//aleatoriedad
Random random = Random();

//Colores
Color celeste = Color.fromRGBO(115, 204, 204, 1.0); //bordo
Color azul = Color.fromRGBO(0, 0, 255, 1);
Color magenta = Color.fromRGBO(255, 0, 255, 0.5);
Color gris = Color.fromRGBO(21, 21, 21, 1.0); //rojo
final List<Color> titulo = [
  Color(0xFFFFFFFF), // Blanco (brillante)
  Color(0xFF808080), //
  Color(0xFF404040), //
  Color(0xFF404040), //
  Color(0xFF808080), //
  Color(0xFFFFFFFF), // Blanco (brillante)
  Color(0xFF808080), //
  Color(0xFF404040), //
];
final List<Color> proyecto = [
  Colors.pink,
  Color.fromRGBO(255, 255, 255, 1.0),
  Colors.pink,
];
final List<Color> boton = [
  Color(0xFFD7D7D7), // Blanco (brillante)
  Color(0xFF808080), //
  Color(0xFF404040), //
  Color(0xFF404040), //
  Color(0xFF808080), //
  Color(0xFF808080), //
  Color(0xFF404040), //
];

// posicion del mouse
double? previousMouseX;

//variables
int? indexProyectoSeleccionado; // Variable para almacenar el índice seleccionado

final ScrollController _scrollController = ScrollController(); // Controlador de scroll
final GlobalKey experienciaKey = GlobalKey(); //llave de experiencias
final GlobalKey habilidadesKey = GlobalKey(); //llave de habilidades tecnicas
final GlobalKey educacionKey = GlobalKey(); //llave de educacion
final GlobalKey projectKey = GlobalKey(); //llave de educacion
final GlobalKey comentariosKey = GlobalKey(); //llave de educacion

TextEditingController _ComentController = TextEditingController();
TextEditingController NombreController = TextEditingController();



class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    incrementarVisitas();
  }

  void incrementarVisitas() async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance.collection('Danidev2003').doc('data');

      // Actualiza el campo 'visitar' con FieldValue.increment
      await docRef.update({'visitas': FieldValue.increment(1)});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gracias por visitar mi página CV, no olvides dejar un comentario ;)'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print("Error al incrementar visitas: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    alto = screenHeight;
    ancho = screenWidth;
    final hexagonWidth = screenWidth * 0.0808823529411765; // Ancho de cada hexágono
    final hexagonMargin = 61.5; // Margen izquierdo para filas pares
    int rowCount = (screenHeight / 31).floor() + 1;
    final List<Widget> hexagonRows = [];

    if (screenWidth > screenHeight) {
      for (int rowIndex = 0; rowIndex < rowCount; rowIndex++) {
        int hexagonCount;
        double leftOffset;

        if (rowIndex % 2 == 0) {
          // Filas pares
          hexagonCount = (screenWidth / hexagonWidth).floor();
          leftOffset = 0;
        } else {
          // Filas impares
          hexagonCount = (screenWidth / hexagonWidth).floor() + 1;
          leftOffset = -hexagonMargin;
        }

        int? izquierda;
        int? centro;
        int? derecha;


        if (rowIndex < rowCount * 0.1) {
          // Proporciones para el primer rango (0% - 30%)
          izquierda = (hexagonCount * 0.4).round();
          centro = (hexagonCount * 0.3).round();
          derecha = hexagonCount - centro - izquierda;
        } else if (rowIndex < rowCount * 0.4) {
          // Proporciones para el segundo rango (30% - 50%)
          izquierda = (hexagonCount * 0.34).round();
          centro = (hexagonCount * 0.3).round();
          derecha = hexagonCount - centro - izquierda;
        } else if (rowIndex < rowCount * 0.7) {
          // Proporciones para el tercer rango (50% - 80%)
          izquierda = (hexagonCount * 0.2).round();
          centro = (hexagonCount * 0.3).round();
          derecha = hexagonCount - centro - izquierda;
        } else {
          // Proporciones para el cuarto rango (80% - 100%)
          izquierda = (hexagonCount * 0.4).round();
          centro = (hexagonCount * 0.3).round();
          derecha = hexagonCount - centro - izquierda;
        }

// Verificar que las sumas sean correctas
        if (hexagonCount != (izquierda + centro + derecha)) {
          derecha += hexagonCount - (izquierda + centro + derecha);
        }

        int randomNumber = Random().nextInt(
            100); // Generar un número aleatorio entre 0 y 99
        int numGradient2 = (randomNumber / 50)
            .round(); // Calcular cuántos GradientHexagonContainer2 generar
        int numGradient3 = centro -
            numGradient2; // El resto serán GradientHexagonContainer3

        // Crear una lista con los GradientHexagonContainer en el orden deseado
        List<Widget> gradientWidgets = [];

        // Agregar GradientHexagonContainer2
        gradientWidgets.addAll(List.generate(numGradient2, (index) {
          return GradientHexagonContainer2(translateX: 0, translateY: 0);
        }));

        // Agregar GradientHexagonContainer3
        gradientWidgets.addAll(List.generate(numGradient3, (index) {
          return GradientHexagonContainer3(translateX: 0, translateY: 0);
        }));

        // Barajar la lista para tener un orden aleatorio
        gradientWidgets.shuffle(Random());


        // Generar los widgets según las proporciones
        List<Widget> rowWidgets = [];

        // Agregar widgets a la izquierda
        rowWidgets.addAll(List.generate(izquierda, (index) {
          return HexagonButton();
        }));

        // Agregar widgets en el centro (GradientHexagonContainer3)
        rowWidgets.addAll(gradientWidgets);

        // Agregar widgets a la derecha
        rowWidgets.addAll(List.generate(derecha, (index) {
          return HexagonButton();
        }));

        double topPosition = -40 +
            (rowIndex * 35.4); // Ajuste vertical para cada fila

        // Agregar la fila completa de widgets a la lista de filas
        hexagonRows.add(
          Positioned(
            left: leftOffset,
            top: topPosition,
            child: Row(children: rowWidgets),
          ),
        );
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          // Fondo con Positioned.fill para que ocupe toda la pantalla
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    azul,
                    magenta
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          screenWidth > screenHeight ?
          Stack(
            children: hexagonRows,
          ) : SizedBox(),
          Container(
            child: Padding(
              padding: screenHeight > screenWidth ?EdgeInsets.only(left: screenWidth * 0.015, right: screenWidth * 0.015) : EdgeInsets.only(left: screenWidth * 0.15, right: screenWidth * 0.15, top: screenHeight * 0.01, bottom: screenHeight * 0.01),
              child: Theme(
                data: Theme.of(context).copyWith(
                  scrollbarTheme: ScrollbarThemeData(
                    thumbColor: MaterialStateProperty.all(Colors.grey[400]), // Color más claro
                    trackColor: MaterialStateProperty.all(Colors.grey[200]), // Fondo de la barra
                  ),
                ),
                child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true, // Mantener visible la barra de desplazamiento
                thickness: 6, // Grosor de la barra
                radius: Radius.circular(8), // Bordes redondeados
                child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  screenHeight > screenWidth ?
                  SizedBox(height: screenHeight * 0.005) : SizedBox(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black.withOpacity(0.85),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(padding: EdgeInsets.only(left: 2, right: 12, top: 8, bottom: 8),
                        child: screenHeight > screenWidth ?
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(padding: EdgeInsets.only(left: 12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4),
                                Text(
                                  "Programador Full-stack",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Carlos Daniel Balcedo",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32,
                                  ),
                                ),
                                Divider(),
                                SizedBox(height: 12),
                                Text(
                                  "Fecha de nacimiento: 20/07/2003",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "Dirección: Ensenada - Buenos Aires / Argentina",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 16),
                                GestureDetector(
                                  onTap: () async {
                                    final Uri phoneUri = Uri.parse("+5492213050330");
                                    if (await canLaunchUrl(phoneUri)) {
                                      await launchUrl(phoneUri);
                                    }
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Teléfono: ",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "+54 9 2213050330",
                                          style: TextStyle(
                                            color: Colors.lightBlueAccent,
                                            fontSize: 18,
                                            decoration: TextDecoration.underline,
                                            decorationColor: Colors.lightBlueAccent, // Color del subrayado
                                            decorationThickness: 2, // Grosor del subrayado
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ),
                                SizedBox(height: 12),
                                Wrap(
                                  children: [
                                    Image.asset(
                                      'lib/assets/imagenes/Gmail.png',
                                      width: 25,
                                      height: 25,
                                    ),
                                    SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(text: "Danielbalcedo2002@gmail.com")).then((_) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Texto copiado'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        });
                                      },
                                      child: Text(
                                        'Danielbalcedo2002@gmail.com',
                                        style: TextStyle(
                                          fontSize: 18,
                                          decoration: TextDecoration.underline,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Wrap(
                                  children: [
                                    Image.asset(
                                      'lib/assets/imagenes/lk.png',
                                      width: 25,
                                      height: 25,
                                    ),
                                    SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () async {
                                        await launch("https://www.linkedin.com/in/carlos-daniel-balcedo");
                                      },
                                      child: Text(
                                        'carlos-daniel-balcedo',
                                        style: TextStyle(
                                          fontSize: 18,
                                          decoration: TextDecoration.underline,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                              ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 4,
                                left: screenWidth * 0.05,
                                right: screenWidth * 0.04,
                                bottom: 14,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierColor: Colors.black.withOpacity(0.5), // Fondo transparente
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        backgroundColor: Colors.black.withOpacity(0.3),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0), // Borde alrededor del contenedor
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            height: screenHeight * 0.7,
                                                            child: Image.asset(
                                                              'lib/assets/imagenes/img.jpeg',
                                                              fit: BoxFit.scaleDown,
                                                            ),
                                                          ),
                                                          Positioned(
                                                            right: 0,
                                                            top: 0,
                                                            child: ClipOval(
                                                              child: Container(
                                                                color: Colors.red.withOpacity(0.5),
                                                                child: Padding(
                                                                  padding: EdgeInsets.all(7),
                                                                  child: IconButton(
                                                                    icon: Icon(Icons.close, color: Colors.white),
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromRGBO(169, 255, 231, 0.1),
                                        blurRadius: 15,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    'lib/assets/imagenes/img-png.png',
                                    width: 300, // Ajusta el tamaño si es necesario
                                    height: 280,
                                    fit: BoxFit.cover, // Asegura que la imagen se ajuste bien
                                  ),
                                )
                              ),
                            ),
                          ],
                        ) :
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround, // Alineación similar al primer ejemplo
                          children: [
                            Padding(
                                padding: EdgeInsets.only(top: 6, left: screenWidth * 0.05, right: screenWidth * 0.04, bottom: 6),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromRGBO(227,126,229, 0.6),
                                        blurRadius: 15,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(2),
                                    child:ClipOval(
                                      child: GestureDetector(
                                          child: Padding(
                                            padding: EdgeInsets.all(7),
                                            child: CircleAvatar(
                                              radius: 60,
                                              backgroundColor: Colors.transparent,
                                              backgroundImage: AssetImage('lib/assets/imagenes/img.jpeg'),
                                            ),
                                          ),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              barrierColor: Colors.black.withOpacity(0.5), // Fondo transparente
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return Dialog(
                                                      backgroundColor: Colors.black.withOpacity(0.3),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(16.0), // Borde de 20 alrededor del contenedor
                                                        child: SingleChildScrollView (
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              //escritorio
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    width: screenWidth * 0.5,
                                                                    height: screenHeight * 0.8,
                                                                    child: Stack(
                                                                        children: [
                                                                          Center(
                                                                            child: Image.asset(
                                                                              'lib/assets/imagenes/img.jpeg',
                                                                              fit: BoxFit.scaleDown,
                                                                            ),
                                                                          ),
                                                                          Positioned(
                                                                            right: 0,
                                                                            top: 0,
                                                                            child: ClipOval(
                                                                                child: Container(
                                                                                  color: Colors.red.withOpacity(0.5),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.all(7),
                                                                                    child: IconButton(
                                                                                      icon: Icon(Icons.close, color: Colors.white),
                                                                                      onPressed: () {
                                                                                        setState(() {
                                                                                          Navigator.pop(context);
                                                                                        });
                                                                                      },
                                                                                    ),
                                                                                  ),)
                                                                            ),
                                                                          ),
                                                                        ] ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          }
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            Expanded( // Para que el contenido ocupe el espacio disponible
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Carlos Daniel Balcedo",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Programador Full-stack",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Fecha de nacimiento: 20/07/2003.",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Nacido en Argentina La Plata, Reside en Buenos Aires",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Wrap(
                                    spacing: screenWidth * 0.01,
                                    runSpacing: screenWidth * 0.01,
                                    children: [
                                      GestureDetector(
                                          onTap: () async {
                                            final Uri phoneUri = Uri.parse("+5492213050330");
                                            if (await canLaunchUrl(phoneUri)) {
                                              await launchUrl(phoneUri);
                                            }
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Teléfono: ",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "+54 9 2213050330",
                                                  style: TextStyle(
                                                    color: Colors.lightBlueAccent,
                                                    fontSize: 14,
                                                    decoration: TextDecoration.underline,
                                                    decorationColor: Colors.lightBlueAccent, // Color del subrayado
                                                    decorationThickness: 2, // Grosor del subrayado
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                      Wrap(
                                        children: [
                                          Image.asset(
                                            'lib/assets/imagenes/Gmail.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          SizedBox(width: 3),
                                          GestureDetector(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(text: "Danielbalcedo2002@gmail.com")).then((_) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Texto copiado'),
                                                    duration: Duration(seconds: 2),
                                                  ),
                                                );
                                              });
                                            },
                                            child: Text(
                                              'Danielbalcedo2002@gmail.com',
                                              style: TextStyle(
                                                fontSize: 14,
                                                decoration: TextDecoration.underline,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Wrap(
                                        children: [
                                          Image.asset(
                                            'lib/assets/imagenes/lk.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          SizedBox(width: 3),
                                          GestureDetector(
                                            onTap: () async {
                                              await launch("https://www.linkedin.com/in/carlos-daniel-balcedo");
                                            },
                                            child: Text(
                                              'carlos-daniel-balcedo',
                                              style: TextStyle(
                                                fontSize: 14,
                                                decoration: TextDecoration.underline,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Informacion(scrollController: _scrollController),
                  SizedBox(height: screenHeight * 0.01),
                  ScrollableContainer(),
                  SizedBox(height: screenHeight * 0.01),
                  Comentarios(),
                ],
              ),
            ),
                ),
                ),
          )
              )
        ],
      ),
    );
  }
}

class Informacion extends StatefulWidget {
  final ScrollController scrollController;

  const Informacion({super.key, required this.scrollController});

  @override
  State<Informacion> createState() => _InformacionState();
}

class _InformacionState extends State<Informacion> with TickerProviderStateMixin {
  Timer? _scrollTimer;

  late List<AnimationController> _slideControllers;
  late List<Animation<Offset>> _slideAnimations;
  late List<AnimationController> _fadeControllers;
  late List<Animation<double>> _fadeAnimations;
  late List<AnimationController> _arrowFadeControllers;
  late List<Animation<double>> _arrowFadeAnimations;

  // Función para hacer scroll a la posición del item
  void _scrollToExpansionTile(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    // Definir cuántos objetos animados habrá
    int numItems = 3; // Cambia este valor según la cantidad de objetos

    // Crear controladores de animación
    _slideControllers = List.generate(numItems, (index) => AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    ));

    _fadeControllers = List.generate(numItems, (index) => AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    ));

    _arrowFadeControllers = List.generate(numItems, (index) => AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    ));

    // Crear lista de animaciones deslizantes
    _slideAnimations = List.generate(numItems, (index) => Tween<Offset>(
      begin: const Offset(-10.0, 0.0), // Fuera de la pantalla
      end: Offset.zero, // Posición final
    ).animate(CurvedAnimation(
      parent: _slideControllers[index], // Vinculado al controlador correcto
      curve: Curves.easeInOut,
    )));

    // Crear lista de animaciones de fade-in
    _fadeAnimations = List.generate(numItems, (index) => Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeControllers[index], // Vinculado al controlador correcto
      curve: Curves.easeInOut,
    )));

    // Crear animaciones de fade-out para las flechas
    _arrowFadeAnimations = List.generate(numItems, (index) => Tween<double>(
      begin: 1.0, // Flecha visible
      end: 0.0, // Flecha desaparece
    ).animate(CurvedAnimation(
      parent: _arrowFadeControllers[index],
      curve: Curves.easeInOut,
    )));

    // Add scroll listener to trigger animations
    widget.scrollController.addListener(_onScroll);
    _onScroll();
  }

  @override
  void dispose() {
    for (var controller in _slideControllers) {
      controller.dispose();
    }
    for (var controller in _fadeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer(Duration(milliseconds: 100), _handleScrollAnimations);
  }

  // Function to handle scrolling and trigger animations
  void _handleScrollAnimations() {
    double offset = widget.scrollController.offset;

    if (alto! > ancho!) {
      // Móvil: Definir umbrales específicos para cada índice
      //primer item
      if (offset >= 100 && !_slideControllers[0].isAnimating && !_slideControllers[0].isCompleted) {
        _slideControllers[0].forward(); // Start sliding animation for "hola"
      } else if (offset < 100 && _slideControllers[0].isCompleted) {
        _slideControllers[0].reverse(); // Reverse sliding animation for "hola"
      }

      if (offset >= 100 && !_fadeControllers[0].isAnimating && !_fadeControllers[0].isCompleted) {
        _fadeControllers[0].forward(); // Start fade-in for "mundo"
      } else if (offset < 100 && _fadeControllers[0].isCompleted) {
        _fadeControllers[0].reverse(); // Reverse fade effect for "mundo"
      }


      //segundo item
      //slider
      if (offset >= 660 && !_slideControllers[1].isAnimating && !_slideControllers[1].isCompleted) {
        _slideControllers[1].forward(); // Start sliding animation for "hola"
      } else if (offset < 660 && _slideControllers[1].isCompleted) {
        _slideControllers[1].reverse(); // Reverse sliding animation for "hola"
      }

      //fade y arrow
      if (offset >= 660 && !_fadeControllers[1].isAnimating && !_fadeControllers[1].isCompleted) {
        _fadeControllers[1].forward(); // Start fade-in for "mundo"
        _arrowFadeControllers[0].forward();
      } else if (offset < 660 && _fadeControllers[1].isCompleted) {
        _fadeControllers[1].reverse(); // Reverse fade effect for "mundo"
        _arrowFadeControllers[0].reverse();
      }

      //tercer item
      //slider
      if (offset >= 2160 && !_slideControllers[2].isAnimating && !_slideControllers[2].isCompleted) {
        _slideControllers[2].forward();
      } else if (offset < 2160 && _slideControllers[2].isCompleted) {
        _slideControllers[2].reverse();
      }

      //fade y arrow
      if (offset >= 2160 && !_fadeControllers[2].isAnimating && !_fadeControllers[2].isCompleted) {
        _fadeControllers[2].forward();
        _arrowFadeControllers[1].forward();
      } else if (offset < 2160 && _fadeControllers[2].isCompleted) {
        _fadeControllers[2].reverse();
        _arrowFadeControllers[1].reverse();
      }

    } else {

      //primer item
      if (offset >= 0 && !_slideControllers[0].isAnimating && !_slideControllers[0].isCompleted) {
        _slideControllers[0].forward(); // Start sliding animation for "hola"
      } else if (offset < 0 && _slideControllers[0].isCompleted) {
        _slideControllers[0].reverse(); // Reverse sliding animation for "hola"
      }

      if (offset >= 0 && !_fadeControllers[0].isAnimating && !_fadeControllers[0].isCompleted) {
        _fadeControllers[0].forward(); // Start fade-in for "mundo"
      } else if (offset < 0 && _fadeControllers[0].isCompleted) {
        _fadeControllers[0].reverse(); // Reverse fade effect for "mundo"
      }


      //segundo item
      //slider
      if (offset >= 280 && !_slideControllers[1].isAnimating && !_slideControllers[1].isCompleted) {
        _slideControllers[1].forward(); // Start sliding animation for "hola"
      } else if (offset < 280 && _slideControllers[1].isCompleted) {
        _slideControllers[1].reverse(); // Reverse sliding animation for "hola"
      }

      //fade y arrow
      if (offset >= 280 && !_fadeControllers[1].isAnimating && !_fadeControllers[1].isCompleted) {
        _fadeControllers[1].forward(); // Start fade-in for "mundo"
        _arrowFadeControllers[0].forward();
      } else if (offset < 280 && _fadeControllers[1].isCompleted) {
        _fadeControllers[1].reverse(); // Reverse fade effect for "mundo"
        _arrowFadeControllers[0].reverse();
      }

      //tercer item
      //slider
      if (offset >= 1070 && !_slideControllers[2].isAnimating && !_slideControllers[2].isCompleted) {
        _slideControllers[2].forward();
      } else if (offset < 1070 && _slideControllers[2].isCompleted) {
        _slideControllers[2].reverse();
      }

      //fade y arrow
      if (offset >= 1070 && !_fadeControllers[2].isAnimating && !_fadeControllers[2].isCompleted) {
        _fadeControllers[2].forward();
        _arrowFadeControllers[1].forward();
      } else if (offset < 1070 && _fadeControllers[2].isCompleted) {
        _fadeControllers[2].reverse();
        _arrowFadeControllers[1].reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double offset = widget.scrollController.offset;
    final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black.withOpacity(0.85),
      ),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //SizedBox(height: 12),

            SizedBox(height: 16),
            //botones
            screenHeight > screenWidth ?
            Wrap(
              alignment: WrapAlignment.spaceAround,
              runSpacing: screenHeight * 0.011,
              spacing: screenHeight* 0.011,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButtonExample(
                      buttonText: 'Habilidades técnicas',
                      onPressed: () {
                        _scrollToExpansionTile(habilidadesKey);
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButtonExample(
                      buttonText: 'Experiencia',
                      onPressed: () {
                        _scrollToExpansionTile(experienciaKey);
                      },
                    ),],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButtonExample(
                      buttonText: 'Educación',
                      onPressed: () {
                        _scrollToExpansionTile(educacionKey);
                      },
                    ),],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButtonExample(
                      buttonText: 'Proyectos',
                      onPressed: () {
                        _scrollToExpansionTile(projectKey);
                      },
                    ),],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButtonExample(
                      buttonText: 'Comentarios',
                      onPressed: () {
                        _scrollToExpansionTile(comentariosKey);
                      },
                    ),],
                ),
              ],
            ) : SizedBox(),

            SizedBox(height: 6),

            screenHeight > screenWidth ?
            Divider(
              height: 10,
              thickness: 2,
              color: Color(0xFF808080),
            ) : SizedBox(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // Alineación similar al primer ejemplo
              children: [
                Expanded( // Para que el contenido ocupe el espacio disponible
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        //Habilidades tecnicas
                        Container(
                          key: habilidadesKey,
                          child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              key: GlobalKey(),
                              children: [
                                Padding(
                                padding: EdgeInsets.only(left: 12,),
                                child: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: titulo,
                                  ).createShader(bounds),
                                  child:                               Offstage(
                                    offstage: screenHeight > screenWidth ? offset < 80 : false, // Si el offset es menor a 260, no se renderiza
                                    child: SlideTransition(
                                    position: _slideAnimations[0],
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Habilidades técnicas",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                                        ),
                                      ),
                                    ),
                                  ),
                                  ),
                                ),
                              ),
                  Offstage(
                      offstage: screenHeight > screenWidth ? offset < 80 : false, // Si el offset es menor a 260, no se renderiza
                      child: FadeTransition(
                                  opacity: _fadeAnimations[0],
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: 12),
                                      Padding(
                                        padding: EdgeInsets.only(top: 6, left: screenWidth * 0.07, right: screenWidth * 0.07, bottom: 6),
                                        child: Wrap(
                                          alignment: WrapAlignment.start,
                                          children: [
                                            Text(
                                              "Idiomas: ",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "Español nativo, Inglés avanzado (B2, certificado Anglia).",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Padding(
                                        padding: EdgeInsets.only(top: 6, left: screenWidth * 0.07, right: screenWidth * 0.07, bottom: 6),
                                        child: Wrap(
                                          alignment: WrapAlignment.start,
                                          children: [
                                            Text(
                                              "Lenguajes: ",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "Dart, C++, C#, Java, JavaScript, Python, HTML, CSS, .NET, ",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Padding(
                                        padding: EdgeInsets.only(top: 6, left: screenWidth * 0.07, right: screenWidth * 0.07, bottom: 6),
                                        child: Wrap(
                                          alignment: WrapAlignment.start,
                                          children: [
                                            Text(
                                              "Conocimientos: ",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "Creación y consumo de REST APIs, manejo de bases de datos SQL y Firestore, implementación de servicios de terceros, servicios en la nube, Google Cloud Console, Firebase (Firestore, Realtime Database, Storage, Cloud Functions), sistema de notificaciones.",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Padding(
                                        padding: EdgeInsets.only(top: 6, left: screenWidth * 0.07, right: screenWidth * 0.07, bottom: 6),
                                        child: Wrap(
                                          alignment: WrapAlignment.start,
                                          children: [
                                            Text(
                                              "Frameworks y herramientas: ",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "Flutter, React Native, Angular, Node.js, Firebase, MercadoPago API, PayPal API, In App Purchase Google Play, .NET, Visual Studio && Visual Studio Code",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                    ],
                                  )
                                ),
                  )
                              ]
                          ),
                        ),

                        Divider(
                          height: 1,
                          thickness: 2,
                          color: Color(0xFF808080),
                        ),

                        //Experiencia profesional
                        Container(
                          key: experienciaKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            key: GlobalKey(),
                            children: [
                              Offstage(
                                offstage: screenHeight < screenWidth ? offset < 260 : offset < 640, // Si el offset es menor a 260, no se renderiza
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          FadeTransition(
                                            opacity: _arrowFadeAnimations[0], // Flecha desaparece con el scroll
                                            child: Icon(Icons.keyboard_arrow_down, size: 40, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                              padding: EdgeInsets.only(left: 12,),
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: titulo,
                                ).createShader(bounds),
                                child:
                                Offstage(
                                  offstage: screenHeight < screenWidth ? offset < 260 : offset < 640, // Si el offset es menor a 260, no se renderiza
                                  child: SlideTransition(
                                  position: _slideAnimations[1],
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Experiencia profesional",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                                      ),
                                    ),
                                  ),
                                ),
                                ),
                              ),
                            ),
                          Offstage(
                            offstage: screenHeight < screenWidth ? offset < 260 : offset < 640, // Si el offset es menor a 260, no se renderiza
                            child: FadeTransition(
                                opacity: _fadeAnimations[1],
                                  child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 6, left: screenWidth * 0.07, right: screenWidth * 0.07, bottom: 6),
                                        child: Wrap(
                                          runSpacing: 3,
                                          alignment: WrapAlignment.start,
                                          children: [
                                            Text(
                                              "2021-08 A 2021-12 / Digital Express-Goya / Programador JR.",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "Durante mi pasantía extracurricular a la edad de 18 años en esta empresa, adquirí experiencia en el manejo de bases de datos MySQL y familiaridad con varios conceptos y lenguajes de programación, especialmente Dart. Además, tuve la oportunidad de desarrollar habilidades en trabajo en equipo y familiarizarme con el entorno laboral.",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Padding(
                                        padding: EdgeInsets.only(top: 6, left: screenWidth * 0.07, right: screenWidth * 0.07, bottom: 6),
                                        child: Wrap(
                                          runSpacing: 3,
                                          alignment: WrapAlignment.start,
                                          children: [
                                            Text(
                                              "2022-04 A 2021-09 / Municipalidad Goya / Programador.",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "He sido contratado para desarrollar una aplicación móvil y una página web para la gestión del turismo local, con el objetivo de agilizar la publicidad de los atractivos turísticos de la región. Todo el proceso de programación y administración de este proyecto fue llevado a cabo por mí personalmente. El trabajo fue completado y entregado puntualmente y se encuentra en la Play Store bajo el nombre de 'Turismo Goya'.",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Padding(
                                        padding: EdgeInsets.only(top: 6, left: screenWidth * 0.07, right: screenWidth * 0.07, bottom: 6),
                                        child: Wrap(
                                          runSpacing: 5,
                                          alignment: WrapAlignment.start,
                                          children: [
                                            Text(
                                              "2022-10 - Actualidad / Programador Freelancer",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "Actualmente, y desde hace dos años, me dedico al desarrollo de aplicaciones web y móviles para clientes particulares y proyectos personales. Entre los trabajos más destacados se encuentran:",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "         ---Bingo online multijugador: Permite a los jugadores competir en tiempo real y comunicarse mediante un chat. Las fichas del juego se compran a través de Mercado Pago y se entregan automáticamente a los usuarios tras la confirmación del pago.",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "         ---E-commerce: Desarrollo de una plataforma de comercio electrónico con compras integradas, gestión de stock, administración de ventas y manejo de la parte impositiva.",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "         ---Juego 2D en Unity: Implementación de un sistema de estadísticas, inventario y enemigos inteligentes que merodean aleatoriamente hasta detectar al jugador. Aunque el juego no se completó, se estructuró el código de manera que facilita la futura incorporación de objetos, misiones y personajes de manera eficiente.",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "         ---Plataforma estilo foro: Implementación de funcionalidades como subida de contenido multimedia mediante el uso de Storage, sistema de autenticación con inicio de sesión mediante Auth, recuperación de contraseñas y autenticación por SMS.",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "         ---Godot Engine: Desarrollo de un juego multijugador, incluyendo funciones remotas, servidores, creación y consumo de REST APIs, y manejo de bases de datos.",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                    ],
                                ),
                                ),
                          ),
                            ],
                          ),
                        ),

                        Divider(
                          height: 1,
                          thickness: 2,
                          color: Color(0xFF808080),
                        ),

                        //Educacion
                        Container(
                          key: educacionKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            key: GlobalKey(),
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  Offstage(
                                  offstage: screenHeight > screenWidth ? offset < 2140 : offset < 1050, // Si el offset es menor a 260, no se renderiza
                                    child: FadeTransition(
                                        opacity: _arrowFadeAnimations[1], // Flecha desaparece con el scroll
                                        child: Icon(Icons.keyboard_arrow_down, size: 40, color: Colors.grey),
                                      ),
                                  ),
                                    ],
                                  ))
                                ],
                              ),
                            Padding(
                              padding: EdgeInsets.only(left: 12,),
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: titulo,
                                ).createShader(bounds),
                                child:
                                Offstage(
                                  offstage: screenHeight > screenWidth ? offset < 2140 : offset < 1050, // Si el offset es menor a 260, no se renderiza
                                  child: SlideTransition(
                                  position: _slideAnimations[2],
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Educación",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                                      ),
                                    ),
                                  ),
                                ),
                                ),
                              ),
                            ),
                  Offstage(
                    offstage: screenHeight > screenWidth ? offset < 2140 : offset < 1050, // Si el offset es menor a 260, no se renderiza
                    child: FadeTransition(
                                opacity: _fadeAnimations[2],
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 6, left: screenWidth * 0.07, right: screenWidth * 0.07, bottom: 6),
                                      child: Wrap(
                                        runSpacing: 3,
                                        alignment: WrapAlignment.start,
                                        children: [
                                          Text(
                                            "Técnico Informático (Recibido en 2022).",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            "Escuela Técnica Valentín Virasoro, Goya / Corrientes, Escuela Técnica N°2 / Ensenada.",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Padding(
                                      padding: EdgeInsets.only(top: 6, left: screenWidth * 0.07, right: screenWidth * 0.07, bottom: 6),
                                      child: Wrap(
                                        runSpacing: 3,
                                        alignment: WrapAlignment.start,
                                        children: [
                                          Text(
                                            "Certificación en Inglés por Anglia - B2 Advance (2016-2022).",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            "E.I.S institute Ensenada / Dolo's classroom Goya.",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Padding(
                                      padding: EdgeInsets.only(top: 6, left: screenWidth * 0.07, right: screenWidth * 0.07, bottom: 6),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Certificados adicionales (obtenidos en 2023).",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                            "Cursos avalados por el Instituto Tecnológico de Goya (ITG):",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            "      ---Programador HTML Y CSS",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            "      ---Creación de videojuegos con Unity",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            "      ---Realidad aumentada e inteligencia artificial",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                  ],
                                ),
                              ),
                  ),
                            ],
    ),
                        ),
                      ]
                  ),
                )
              ],
            ),
          ]
      ),
    );
  }
}


class ElevatedButtonExample extends StatefulWidget {
  final String buttonText;
  final VoidCallback onPressed;

  ElevatedButtonExample({required this.buttonText, required this.onPressed});

  @override
  _ElevatedButtonExampleState createState() => _ElevatedButtonExampleState();
}

class _ElevatedButtonExampleState extends State<ElevatedButtonExample> {
  double translateX = 0.0;
  double translateY = 0.0;

  void _onPress() {
    setState(() {
      translateX = -4.0;
      translateY = -4.0;
    });
  }

  void _onRelease() {
    setState(() {
      translateX = 0.0;
      translateY = 0.0;
    });
    // Llama a la función pasada como parámetro
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sombra adaptativa
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.4),
                  blurRadius: 16.0,
                  spreadRadius: 3.0,
                ),
              ],
            ),
          child: Text(widget.buttonText, style: TextStyle(color: Colors.transparent, fontSize: 18),),
          ),
          // Botón principal
          GestureDetector(
            onTapDown: (_) => _onPress(),
            onTapUp: (_) => _onRelease(),
            onTapCancel: () => _onRelease(),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              transform: Matrix4.translationValues(translateX, translateY, 0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: boton,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Text(
                  widget.buttonText,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}


class ScrollableContainer extends StatefulWidget {
  @override
  _ScrollableContainerState createState() => _ScrollableContainerState();
}

class _ScrollableContainerState extends State<ScrollableContainer> {
  final ScrollController _horizontalscrollController = ScrollController(); // Controlador de scroll

  List<Widget> detallesProyectos = [
    //detalles alerta familiar
    Padding(padding: EdgeInsets.all(16),
    child: Row(
      children: [
    Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: proyecto,
              ).createShader(bounds),
              child: Text(
                "Alerta familiar!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                ),
              ),
            ),
          )
        ],
        ),
        SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.start,
          children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: proyecto,
          ).createShader(bounds),
          child: Text(
            "Plataforma: ",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
            ),
          ),
        ),
            Text("Aplicación móvil, disponible en PlayStore", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
            ),),
          ]
        ),
        SizedBox(height: 4),
        Wrap(
            alignment: WrapAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: proyecto,
                ).createShader(bounds),
                child: Text(
                  "Tecnologías clave: ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                  ),
                ),
              ),
              Text("Firestore, Funciones en la nube (JavaScript), Google In-App Purchase, Firebase Notifications", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
              ),),
            ]
        ),
        SizedBox(height: 4),
        ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: proyecto,
                ).createShader(bounds),
                child: Text(
                  "Puntos a destacar: ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                  ),
                ),
              ),
        Text("   ---Función en la nube que dispara eventos basados en actualizaciones de Firestore.", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
              ),),
        Text("   ---Notificaciones enviadas a los miembros del grupo usando clave FMC.", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
        ),),
        Text("   ---Subscripciones de Google Play verificadas al iniciar la app, y gestión del ciclo de vida del grupo según el estado de la subscripción.", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
        ),),
        Text("   ---Actualización periódica de la ubicación para forzar disparadores de eventos.", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
        ),),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: proyecto,
              ).createShader(bounds),
              child: Text(
                "Descripción: ",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                ),
              ),
            ),
          ],
        ),
        Text("      Este proyecto para seguridad familiar crea grupos en una base de datos Firestore. Cada grupo es un documento que almacena datos necesarios y las claves FMC de los usuarios que ingresen el código del grupo en la app. "
            "Una vez unidos, con una función en la nube (Cloud Functions), cada vez que el documento se actualiza con nueva información, toma todas las tokens FMC de los usuarios y arma una notificación. El código cliente recibe esta señal y arma la notificación para el usuario, "
            "redirigiéndolo a Google Maps con las coordenadas de la persona que activó la alerta. Esta señal se seguirá enviando del emisor hasta que lo apague manualmente o pase un lapso de tiempo prolongado en el que se espera ya haya recibido asistencia. Por lo tanto, los receptores recibirán esta notificación actualizada cada ciertos periodos de tiempo. "
            "Puedes encontrar esta aplicación en la Play Store con el nombre 'Alerta familiar!'", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
        )),
            SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            await launch("https://play.google.com/store/apps/details?id=com.alertafamiliar.example&pli=1");
          },
          child: Text(
            "O descarga Alerta Familiar! haciendo clic aquí.",
            style: TextStyle(
              fontSize: 14,
              decoration: TextDecoration.underline,
              color: Colors.blue,
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    ),),
  ],
    ),
  ),

    //detalles BingoJxh
    Padding(padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [        ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: proyecto,
                    ).createShader(bounds),
                    child: Text(
                      "BingoJxh",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                      ),
                    ),
                  ),],
                ),
                SizedBox(height: 8),
                Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: proyecto,
                        ).createShader(bounds),
                        child: Text(
                          "Plataforma: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                          ),
                        ),
                      ),
                      Text("Aplicación móvil, Multijugador en línea", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                      ),),
                    ]
                ),
                SizedBox(height: 4),
                Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: proyecto,
                        ).createShader(bounds),
                        child: Text(
                          "Tecnologías clave: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                          ),
                        ),
                      ),
                      Text("Firebase Realtime Database, Mercado Pago, Funciones en la nube (JavaScript)", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                      ),),
                    ]
                ),
                SizedBox(height: 4),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: proyecto,
                  ).createShader(bounds),
                  child: Text(
                    "Puntos a destacar: ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                    ),
                  ),
                ),
                Text("   ---Gestión de partidas multijugador con una función en la nube que asigna cartones a los jugadores y sortea números.", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                ),),
                Text("   ---Integración con Mercado Pago para la compra de fichas.", style: TextStyle(fontSize: 16, color: Colors.white),),
                Text("   ---Múltiples instancias de un jugador con diferentes cartones para la misma partida.", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                ),),
                Text("   ---Sistema de chat en tiempo real usando Firebase Realtime Database con notificaciones de nuevos mensajes.", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                ),),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: proyecto,
                      ).createShader(bounds),
                      child: Text(
                        "Descripción: ",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                        ),
                      ),
                    ),
                  ],
                ),
                Text("      Para este proyecto utilizo metodos de autenticacion y registros de usuarios, almaceno los datos cifrados en la base de datos desde el registro del usuario "
                    "una vez ingresado a la app el codigo cliente hara un stream en directo a las ubicaciones de la base de datos donde se actualizan las partidas y el chat en tiempo real, mostrando cada cambio al usuario,"
                    " el usuario puede cargar fichas mediante mercado pago pidiendo a la api de esta que cree la preferencia y almacenandola en la base de datos del usuario, una vez vuelva a la aplicacion se verifican las preferencias almacenadas, si el estado fue aprobado se dan las fichas al jugador y se elimina de su base de datos."
                    " las partidas son administradas por una funcion en la nube quien verifica los usuarios asigna numeros de cartones y sortea los numeros durante la partida, funciona con un disparador que ejecuta el usuario al crear e iniciar una partida en la sala, a su vez, cada sala tiene su propio chat en tiempo real con los miembros de la sala"
                    ", este proyecto es a pedido de un cliente de identidad reservada por lo que aun y hasta la autorizacion de este no se compartiran los datos ni accesos a la app hasta el lanzamiento oficial.", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                ),),
                SizedBox(height: 8),
              ],
            ),),
        ],
      ),
    ),

    //detalles ecomerce
    Padding(padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [        ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: proyecto,
                    ).createShader(bounds),
                    child: Text(
                      "E-commerce (En desarrollo)",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                      ),
                    ),
                  ),],
                ),
                SizedBox(height: 8),
                Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: proyecto,
                        ).createShader(bounds),
                        child: Text(
                          "Plataforma: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                          ),
                        ),
                      ),
                      Text("Web", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                      ),),
                    ]
                ),
                SizedBox(height: 4),
                Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: proyecto,
                        ).createShader(bounds),
                        child: Text(
                          "Tecnologías clave: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                          ),
                        ),
                      ),
                      Text("Firestore, Mercado Pago, Firebase Storage", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                      ),),
                    ]
                ),
                SizedBox(height: 4),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: proyecto,
                  ).createShader(bounds),
                  child: Text(
                    "Puntos a destacar: ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                    ),
                  ),
                ),
                Text("   ---Control de stock y cálculo automático de impuestos y ganancias tras cada compra.", style: TextStyle(fontSize: 16, color: Colors.white,),),
                Text("   ---Almacenamiento de fotos de productos en Firebase Storage.", style: TextStyle(fontSize: 16, color: Colors.white),),
                Text("   ---Pedidos gestionados automáticamente con integración de pagos vía Mercado Pago.", style: TextStyle(fontSize: 16, color: Colors.white,),),
               // Text("   ---Sistema de chat en tiempo real usando Firebase Realtime Database con notificaciones de nuevos mensajes.", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),),),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: proyecto,
                      ).createShader(bounds),
                      child: Text(
                        "Descripción: ",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                        ),
                      ),
                    ),
                  ],
                ),
                Text("      Esta página web está hecha con la idea de que un cliente que tenga el usuario de administrador pueda cargar, eliminar y modificar tanto productos "
                    "como un stock disponible, donde se encuentran los ingredientes en caso de comidas o los mismos productos con su precio y cantidad. Estos serán descontados una vez que la compra se haya completado, "
                    "a la vez que se resta a su precio de venta su costo de producción o precio de fábrica para sumar las ganancias en la sección impositiva. "
                    "Esta sección tiene en cuenta un historial de ventas, pérdidas, pagos a empleados y proveedores, entre otras cosas. La página de pedidos visualiza todos los clientes que hayan comprado, y si su compra fue completada, se confirma para proceder a los cálculos o se elimina de la lista si cancela la compra. "
                    "Se planea agregar más funciones y mejorar el diseño antes de hacerlo público, como una página de ventas y administración para negocios, dando varias herramientas a estos para un mayor control y flexibilidad.", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                )),
                SizedBox(height: 8),
              ],
            ),),
        ],
      ),
    ),

    //detalles bullysurvivor
    Padding(padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: proyecto,
                        ).createShader(bounds),
                        child: Text(
                          "Bully-survivor",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8),
                Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: proyecto,
                        ).createShader(bounds),
                        child: Text(
                          "Plataforma: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                          ),
                        ),
                      ),
                      Text("Videojuego 2D (Unity)", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                      ),),
                    ]
                ),
                SizedBox(height: 4),
                Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: proyecto,
                        ).createShader(bounds),
                        child: Text(
                          "Tecnologías clave: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                          ),
                        ),
                      ),
                      Text("Unity, C#", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                      ),),
                    ]
                ),
                SizedBox(height: 4),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: proyecto,
                  ).createShader(bounds),
                  child: Text(
                    "Puntos a destacar: ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                    ),
                  ),
                ),
                Text("   ---IA de enemigos con merodeo aleatorio y persecución al jugador.", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                ),),
                Text("   ---Sistema de estadísticas variables (vida, velocidad, daño) que se modifican con objetos en el juego.", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                ),),
                Text("   ---Inventario funcional, sistema de diálogos, y objetos que alteran las estadísticas del jugador.", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                ),),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: proyecto,
                      ).createShader(bounds),
                      child: Text(
                        "Descripción: ",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                        ),
                      ),
                    ),
                  ],
                ),
                Text("      Este proyecto Unity fue realizado con la idea de aprender sobre las actualizaciones por segundo de un videojuego, cómo funciona la lógica de estos. "
                    "El reto mismo de tratar de crearlo, conociendo todos los desafíos y la complejidad de ejecutar todo al mismo tiempo dependiendo de varios factores, simplemente me pareció interesante "
                    "y una buena oportunidad para aprender otro lenguaje y ponerlo en práctica. En este proyecto demostré que lo aprendí, entendí y planteé varios objetivos que pude cumplir. Por falta de tiempo, no pude desarrollar más la historia o agregar más objetos. "
                    "Planeo hacer uno más complejo y multijugador, similar a Miscrits, en el futuro, con un equipo de desarrollo más completo y algún diseñador. "
                    "Si quieres probar este juego, puedes hacerlo en este enlace:", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                )),
                SizedBox(height: 6),
                GestureDetector(
                  onTap: () async {
                    await launch("https://www.mediafire.com/file/x1kpd7w0wqbjtze/Bully+Survivor.rar/file");
                  },
                  child: Text(
                    'Descargar Bully survivor',
                    style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),),
        ],
      ),
    ),

    //detalles Turismo Goya
    Padding(padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: proyecto,
                        ).createShader(bounds),
                        child: Text(
                          "Turismo Goya",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8),
                Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: proyecto,
                        ).createShader(bounds),
                        child: Text(
                          "Plataforma: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                          ),
                        ),
                      ),
                      Text("Aplicación móvil", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                      ),),
                    ]
                ),
                SizedBox(height: 4),
                Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: proyecto,
                        ).createShader(bounds),
                        child: Text(
                          "Tecnologías clave: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                          ),
                        ),
                      ),
                      Text("ASP.NET, MySQL, REST API", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                      ),),
                    ]
                ),
                SizedBox(height: 4),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: proyecto,
                  ).createShader(bounds),
                  child: Text(
                    "Puntos a destacar: ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                    ),
                  ),
                ),
                Text("   ---Conexión con una REST API para obtener datos de múltiples tablas (hoteles, gastronomía, etc.) en una base de datos MySQL.", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                ),),
                Text("   ---Función de filtro de búsqueda que arma dinámicamente la URL según los parámetros seleccionados por el usuario.", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                ),),
                Text("   ---Visualización de resultados en forma de 'cartas' con nombre, fotos, descripción y servicios del luga", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                ),),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: proyecto,
                      ).createShader(bounds),
                      child: Text(
                        "Descripción: ",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                        ),
                      ),
                    ),
                  ],
                ),
                Text("      Este proyecto, trabajado con la oficina de turismo de Goya y participación del municipio, "
                    "fue hecho durante mi pasantía en el municipio. El propósito era crear una app móvil que ofreciera ayuda para buscar distintos servicios en la ciudad, así como actividades. "
                    "El diseño fue cambiado al tiempo de mi entrega, junto al ícono y algunos detalles. De todas formas, quería compartir el diseño original y mi aporte en este proyecto. Si bien no me pertenece, toda la parte de desarrollo "
                    "desde la API, base de datos y front-end fue hecha por mí. Los invito a revisarlas en el enlace aquí abajo. Además, agrego que, si bien el diseño inicial y mi trabajo son algo precarios, en este entonces, recién con 17 años, empezando en el mundo de la programación y como primera app desarrollada, al menos me siento orgulloso de que funcione bien y a día de hoy se siga utilizando.", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                )),
                    SizedBox(height: 6),
                GestureDetector(
                  onTap: () async {
                    await launch("https://play.google.com/store/apps/details?id=com.companyname.turismo&hl=es_VE");
                  },
                  child: Text(
                    'Descargar Turismo Goya.',
                    style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),),
        ],
      ),
    ),

    //detalles Upuh
    Padding(padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: proyecto,
                        ).createShader(bounds),
                        child: Text(
                          "Foro Unidos por un hermano",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8),
                Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: proyecto,
                        ).createShader(bounds),
                        child: Text(
                          "Plataforma: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                          ),
                        ),
                      ),
                      Text("Web", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                      ),),
                    ]
                ),
                SizedBox(height: 4),
                Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: proyecto,
                        ).createShader(bounds),
                        child: Text(
                          "Tecnologías clave: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                          ),
                        ),
                      ),
                      Text("Firebase Storage, Firestore", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                      ),),
                    ]
                ),
                SizedBox(height: 4),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: proyecto,
                  ).createShader(bounds),
                  child: Text(
                    "Puntos a destacar: ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                    ),
                  ),
                ),
                Text("   ---Página de configuración para modificar los datos en tiempo real.", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                ),),
                Text("   ---Sección de donaciones, comentarios, y publicaciones dinámicas.", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                ),),
                Text("   ---Carga y manejo de imágenes en Firebase Storage, con listas dinámicas que se adaptan a la cantidad de fotos subidas.", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                ),),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: proyecto,
                      ).createShader(bounds),
                      child: Text(
                        "Descripción: ",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                        ),
                      ),
                    ),
                  ],
                ),
                Text("      No hay mucho que decir de este proyecto; es una página hecha para una organización no gubernamental para mostrar "
                    "el trabajo que hacen en su organización, hacer publicaciones con imágenes y texto acerca de sus actividades y demás, información para dar a conocer la organización y formas de aportar, donando vía web o presencial. "
                    "También permite a los usuarios dejar sus comentarios y aportes; la página tiene una sección de administración para cambiar los textos, información, imágenes y la galería superior de imágenes. "
                    "A la vez que las donaciones llevan a Mercado Pago y añaden su aporte a la lista de donadores, esta página almacena imágenes en Storage para publicaciones, galerías, íconos y el texto en Firestore con las referencias de las imágenes. "
                    "Procesa método de pago y actualiza en tiempo real cuando el administrador modifica un dato en las configuraciones debido al stream en su base de datos.", style: TextStyle(fontSize: 16, color: Colors.white, // Para un backup color en caso que no se vea bien el degradado),
                )),
                SizedBox(height: 6),
                GestureDetector(
                  onTap: () async {
                    await launch("unidosporunhermano.org");
                  },
                  child: Text(
                    'Visita la pagina',
                    style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),),
        ],
      ),
    ),
  ];

  List<Map<String, String>> proyectos = [
    {
      "nombre": "Alerta familiar!",
      "imagen1": "lib/assets/alerta-familiar/ic_launcher.png",
      "imagen2": "lib/assets/alerta-familiar/IMG-20241004-WA0023.jpg"
    },
    {
      "nombre": "Proyecto BingoJXH",
      "imagen1": "lib/assets/bingo/Captura de pantalla (152).png",
      "imagen2": "lib/assets/bingo/IMG-20241004-WA0025.jpg"
    },
    {
      "nombre": "E-commerce",
      "imagen1": "lib/assets/ecomerce/Captura de pantalla (70).png",
      "imagen2": "lib/assets/ecomerce/Captura de pantalla (98).png"
    },
    {
      "nombre": "Bully survivor",
      "imagen1": "lib/assets/bully-survivor/Sin título.png",
      "imagen2": "lib/assets/bully-survivor/Sin título2.png"
    },
    {
      "nombre": "Turismo Goya",
      "imagen1": "lib/assets/turismogoya/ic_launcher.png",
      "imagen2": "lib/assets/turismogoya/Imagen de WhatsApp 2024-10-05 a las 00.02.11_24df8b24.jpg"
    },
    {
      "nombre": "Foro Unidos por un hermano",
      "imagen1": "lib/assets/upuh/logo.png",
      "imagen2": "lib/assets/upuh/IMG-20241004-WA0038.jpg"
    },
  ];

  // Definimos una lista de mapas que contendrá la información de cada proyecto
  List<Map<String, dynamic>> imagenesProyecto = [
    //alerta familiar
    {
      'imagenes': [
        {'imagen1': 'lib/assets/alerta-familiar/IMG-20241004-WA0022.jpg', 'descripcion1': 'Menú lateral de la aplicación. En este podemos ver los grupos, con un botón para copiar el código y compartirlo, o ver los participantes en este. Podemos agregar un nuevo grupo o cambiar el mensaje que enviaremos al presionar el botón. Si no hay mensaje, se manda uno por defecto. Además, se puede cambiar el plan de suscripción para que otra persona sea la responsable de la manutención del grupo.', 'imagen2': 'lib/assets/alerta-familiar/IMG-20241004-WA0023.jpg', 'descripcion2': 'Interfaz principal de la aplicación una vez completado el registro: un acceso rápido al botón de emergencia y una previsualización del mensaje que se enviaría.'},
        {'imagen1': 'lib/assets/alerta-familiar/grafico ayuda vecinal.png', 'descripcion1': 'Visualización de la notificación recibida por esta app y ubicación mostrada al presionar en esta en Google Maps.', 'imagen2': 'lib/assets/alerta-familiar/Sin título.png', 'descripcion2': 'Aquí se puede ver el código encargado de enviar las notificaciones a los miembros del grupo, hecho en JavaScript, subido en Cloud Functions con Google Console para una mayor estabilidad.'},
      ],
    },
    //proyecto Bingojxh
    {
      'imagenes': [
        {'imagen1': 'lib/assets/bingo/Captura de pantalla (152).png', 'descripcion1': 'Aplicación vista durante una partida en ejecución sincronizada con la base de datos.', 'imagen2': 'lib/assets/bingo/IMG-20241004-WA0025.jpg', 'descripcion2': 'Sala de juego durante la espera de más jugadores.'},
        {'imagen1': 'lib/assets/bingo/IMG-20241004-WA0024.jpg', 'descripcion1': 'Lobby principal con el color alternativo, mostrando el chat en tiempo real con los demás jugadores.', 'imagen2': 'lib/assets/bingo/IMG-20241004-WA0026.jpg', 'descripcion2': 'Menú lateral con la configuración y opciones de la app.'},
        {'imagen1': 'lib/assets/bingo/IMG-20241004-WA0028.jpg', 'descripcion1': 'Imagen del login de usuario con las opciones de registrar, recordar y recuperar contraseña. Verifica con Auth y sincroniza a la base de datos los jugadores si existe el registro de este.', 'imagen2': 'lib/assets/bingo/IMG-20241004-WA0027.jpg', 'descripcion2': 'Sección para registro de usuario. Se envía un código por SMS para verificar que se trata de un usuario real y se pasa al formulario de registro.'},
        {'imagen1': 'lib/assets/bingo/Sin título.png', 'descripcion1': 'Fragmento de la función en la nube con su disparador para administrar las partidas y repartir los premios al ganador.', 'imagen2': 'lib/assets/bingo/Sin título2.png', 'descripcion2': 'Segundo fragmento del código mostrando la generación de cartones o asignación en caso de que no los tenga, eliminación del usuario si no posee cartones ni fichas, y creando la lista de jugadores con los números asignados o con uno o más cartones que elija jugar el usuario.'},
      ],
    },
    //proyecto Ecomerce
    {
      'imagenes': [
        {'imagen1': 'lib/assets/ecomerce/Captura de pantalla (73).png', 'descripcion1': 'Sección principal del banner con información y login de usuario en la parte superior.', 'imagen2': 'lib/assets/ecomerce/Captura de pantalla (95).png', 'descripcion2': 'Confirmar compra, donde lleva al método de pago y muestra un resumen de la información recopilada.'},
        {'imagen1': 'lib/assets/ecomerce/Imagen de WhatsApp 2024-10-04 a las 23.30.23_61468827.jpg', 'descripcion1': 'Sección impositiva donde muestra ganancias y pérdidas de compras y pagos.', 'imagen2': 'lib/assets/ecomerce/IMG-20241004-WA0033.jpg', 'descripcion2': 'Sección de pedidos donde se ven las compras recientes y la opción de confirmar la compra o eliminarla en caso de que se cancele el pedido.'},
        {'imagen1': 'lib/assets/ecomerce/Captura de pantalla (70).png', 'descripcion1': 'Cátalogo de productos una vez cargados.', 'imagen2': 'lib/assets/ecomerce/Captura de pantalla (98).png', 'descripcion2': 'Sección administrativa para la modificación o eliminación de un producto existente, o agregar nuevos productos.'},
        {'imagen1': 'lib/assets/ecomerce/IMG-20241004-WA0034.jpg', 'descripcion1': 'Sección administrativa para la configuración del banner y los productos.', 'imagen2': 'lib/assets/ecomerce/Captura de pantalla (75).png', 'descripcion2': 'Sección administrativa para cargar productos manualmente. Cuando un usuario compra por la página, se encuentra con un formulario similar para completar el pedido.'},
      ],
    },
    //bullysurvivor
    {
      'imagenes': [
        {'imagen1': 'lib/assets/bully-survivor/Sin título.png', 'descripcion1': 'Interfaz de Unity con los scripts para las interacciones con el usuario y el mapa. De fondo, se puede ver el mapa 2D con algunos enemigos y su barra de vida, mientras hay unos puntos rojos que sirven para la navegación aleatoria de los enemigos cuando deambulan.', 'imagen2': 'lib/assets/bully-survivor/Sin título3.png', 'descripcion2': 'Con el juego iniciado, el jugador puede comenzar a recorrer el mapa y disparar eventos según sus interacciones.'},
        {'imagen1': 'lib/assets/bully-survivor/persecucion cuando vision pasa dato.png', 'descripcion1': 'En este ejemplo de código se ve cómo se dan las instrucciones para que el enemigo persiga al jugador mientras lo tenga en vista. Hay otras funciones que ayudan a que la vista lo siga para facilitar la persecución. Cuando se pierde de vista al jugador, el enemigo, de todas formas, se dirige a la última ubicación donde lo vio, tratando de buscarlo antes de ponerse a deambular nuevamente.', 'imagen2': 'lib/assets/bully-survivor/Sin título4.png', 'descripcion2': 'Este otro fragmento de código es el que le da las instrucciones al cuerpo y movimiento del enemigo. En este código se trata de verificar si el usuario está en el radio donde el enemigo lo puede detectar ("vista"), y si es así, el enemigo va a seguirlo con la vista al jugador. La vista es una variable que, cuando el jugador está en un radio determinado y no hay obstáculos en medio, es verdadera, activando varias tareas del enemigo, como la persecución y el seguimiento con la vista.'},
      ],
    },
    //turismogoya
    {
      'imagenes': [
        {'imagen1': 'lib/assets/turismogoya/IMG-20241004-WA0041.jpg', 'descripcion1': 'Solo un poco de trabajo de diseño, añadiendo unos videos y texto del lugar, frases de invitación y eslogan de la ciudad.', 'imagen2': 'lib/assets/turismogoya/IMG-20241004-WA0042.jpg', 'descripcion2': 'Lista de hoteles desplegable con la información de cada uno al desplegar.'},
        {'imagen1': 'lib/assets/turismogoya/Imagen de WhatsApp 2024-10-05 a las 00.02.10_6389673a.jpg', 'descripcion1': 'Opción de alojamientos con las listas para filtrar los resultados deseados.', 'imagen2': 'lib/assets/turismogoya/IMG-20241004-WA0039.jpg', 'descripcion2': 'Caja de comentarios para dejar valoración y comentarios del lugar. Cada lugar tiene su propia caja de comentarios y calificaciones (actualmente eliminaron esta función, con lo que me había costado).'},
        {'imagen1': 'lib/assets/turismogoya/IMG-20241004-WA0040.jpg', 'descripcion1': 'Ejemplo visual de un resultado filtrado y seleccionado. Aclaro que abajo hay una opción de mapa que abre Google Maps para navegar al lugar indicado por coordenadas.', 'imagen2': 'lib/assets/turismogoya/IMG-20241004-WA0044.jpg', 'descripcion2': 'Otro ejemplo de resultado filtrado.'},
      ],
    },
    //upuh
    {
      'imagenes': [
        {'imagen1': 'lib/assets/upuh/IMG-20241004-WA0038.jpg', 'descripcion1': 'Galería de imágenes e íconos expandibles con información.', 'imagen2': 'lib/assets/upuh/IMG-20241004-WA0037.jpg', 'descripcion2': 'Tabla de donadores y la opción de donar, que lleva a Mercado Pago con el monto que quieres donar.'},
        {'imagen1': 'lib/assets/upuh/IMG-20241004-WA0035.jpg', 'descripcion1': 'Caja de comentarios con un ejemplo de publicación más arriba.', 'imagen2': 'lib/assets/upuh/IMG-20241004-WA0036.jpg', 'descripcion2': 'Ejemplo de comentario e información de contacto de la organización.'},
      ],
    },
    // Agregar más proyectos según sea necesario
  ];

  void _scrollLeft() {
    _horizontalscrollController.animateTo(
      _horizontalscrollController.offset - 200, // Mueve 100 píxeles a la izquierda
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _horizontalscrollController.animateTo(
      _horizontalscrollController.offset + 200, // Mueve 100 píxeles a la derecha
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void mostrarDialogoImagenes(BuildContext context, Map<String, String> imagen1, Map<String, String> imagen2) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool mostrarImagen1 = true;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Fondo transparente
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.black.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Borde de 20 alrededor del contenedor
                child: SingleChildScrollView (
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    screenWidth < screenHeight ?
                        //celular
                    Row(
                      children: [
                        Expanded(
                            child: Stack(
                          children: [
                            Container(
                              height: screenHeight * 0.7,
                              child: Image.asset(
                                mostrarImagen1 ? imagen1['imagen']! : imagen2['imagen']!,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            // Botón de navegación
                            mostrarImagen1 ? Positioned(
                              right: 0,
                              top: screenHeight * 0.4,
                              child: ClipOval(
                                  child: Container(
                                    color: Colors.black.withOpacity(0.7),
                                    child: Padding(
                                      padding: EdgeInsets.all(7),
                                      child: IconButton(
                                        icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                                        onPressed: () {
                                          setState(() {
                                            mostrarImagen1 = !mostrarImagen1; // Alternar entre imagen1 e imagen2
                                          });
                                        },
                                      ),
                                    ),)
                              ),
                            ) : Positioned(
                              left: 0,
                              top: screenHeight * 0.4,
                              child: ClipOval(
                                  child: Container(
                                    color: Colors.black.withOpacity(0.7),
                                    child: Padding(
                                      padding: EdgeInsets.all(7),
                                      child: IconButton(
                                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                                        onPressed: () {
                                          setState(() {
                                            mostrarImagen1 = !mostrarImagen1; // Alternar entre imagen1 e imagen2
                                          });
                                        },
                                      ),
                            ),)
                              ),
                          ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: ClipOval(
                                  child: Container(
                                    color: Colors.red.withOpacity(0.5),
                                    child: Padding(
                                      padding: EdgeInsets.all(7),
                                      child: IconButton(
                                        icon: Icon(Icons.close, color: Colors.white),
                                        onPressed: () {
                                          setState(() {
                                            Navigator.pop(context);
                                          });
                                        },
                                      ),
                                    ),)
                              ),
                            ),
                  ]
                        )),
                      ],
                    ) :
                        //escritorio
                    Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: screenWidth * 0.5,
                              height: screenHeight * 0.8,
                              child: Stack(
                              children: [
                                Center(
                                  child: Image.asset(
                                    mostrarImagen1 ? imagen1['imagen']! : imagen2['imagen']!,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                                !mostrarImagen1 ? Positioned(
                                  top: screenHeight * 0.4,
                                  left: 0,
                                  child: ClipOval(
                                      child: Container(
                                        color: Colors.black.withOpacity(0.7),
                                        child: Padding(
                                          padding: EdgeInsets.all(7),
                                          child: IconButton(
                                            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                                            onPressed: () {
                                              setState(() {
                                                mostrarImagen1 = !mostrarImagen1; // Alternar entre imagen1 e imagen2
                                              });
                                            },
                                          ),
                                        ),)
                                  ),
                                ) : Positioned(
                                  right: 0,
                                  top: screenHeight * 0.4,
                                  child: ClipOval(
                                      child: Container(
                                        color: Colors.black.withOpacity(0.7),
                                        child: Padding(
                                          padding: EdgeInsets.all(7),
                                          child: IconButton(
                                            icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                                            onPressed: () {
                                              setState(() {
                                                mostrarImagen1 = !mostrarImagen1; // Alternar entre imagen1 e imagen2
                                              });
                                            },
                                          ),
                                        ),)
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: ClipOval(
                                      child: Container(
                                        color: Colors.red.withOpacity(0.5),
                                        child: Padding(
                                          padding: EdgeInsets.all(7),
                                          child: IconButton(
                                            icon: Icon(Icons.close, color: Colors.white),
                                            onPressed: () {
                                              setState(() {
                                                Navigator.pop(context);
                                              });
                                            },
                                          ),
                                        ),)
                                  ),
                                ),
                              ] ),
                            ),
                          ],
                        ),
                    SizedBox(height: 8),
                           Text(
                          mostrarImagen1 ? imagen1['descripcion']! : imagen2['descripcion']!,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                  ],
                ),
              ),
              ),
            );
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black.withOpacity(0.85),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 5,),
          Padding(padding: EdgeInsets.all(8),
          child: Text("Muchos de los proyectos son comerciales o de clientes de identidad reservada; por esta razón, no se ha subido un repositorio. Sin embargo, en cada proyecto se muestra la lógica utilizada y el código relevante, si lo hay.", style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),),
    ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                key: projectKey,
                child: Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 30,),
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: titulo,
                    ).createShader(bounds),
                    child: Text(
                      "Proyectos",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                      ),
                    ),
                  ),),
              ),
              )

            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: screenHeight * 0.05,
                top: 0,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
               screenWidth > screenHeight ? IconButton(
                  icon: Icon(Icons.arrow_left, color: Colors.white, size: 50),
                  onPressed: _scrollLeft,
                ) : SizedBox(),
                Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                      controller: _horizontalscrollController,
                      scrollDirection: Axis.horizontal, // Desplazamiento horizontal
                      child: Row(
                        children: List.generate(proyectos.length, (itemIndex) {
                          bool isSelected = indexProyectoSeleccionado == itemIndex;

                          return Padding(
                            padding: EdgeInsets.only(left: 8, right: 8, top: 40, bottom: 15),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  indexProyectoSeleccionado = itemIndex;
                                });
                              },
                              child: Transform.translate(
                                offset: isSelected ? Offset(0, -20) : Offset(0, 0),
                                child: isSelected
                                    ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueAccent.withOpacity(0.6),
                                        blurRadius: 15,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: screenHeight > screenWidth ?
                                  Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('lib/assets/imagenes/Grabacin2025-01-28184024-ezgif.com-video-to-gif-converter.gif'), // Ruta de tu GIF
                                          fit: BoxFit.cover, // Asegúrate de que el GIF ocupe todo el espacio disponible
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: CartaDelProyecto(
                                          itemIndex, proyectos[itemIndex]["nombre"]!, proyectos[itemIndex]["imagen1"]!, proyectos[itemIndex]["imagen2"]!,),
                                      ),
                                  )
                                  :
                                  AnimateGradient(
                                    primaryBegin: Alignment.topLeft,
                                    primaryEnd: Alignment.bottomLeft,
                                    secondaryBegin: Alignment.bottomLeft,
                                    secondaryEnd: Alignment.topRight,
                                    primaryColors: const [
                                      Colors.pink,
                                      Colors.pinkAccent,
                                      Colors.white,
                                    ],
                                    secondaryColors: const [
                                      Colors.white,
                                      Colors.blueAccent,
                                      Colors.blue,
                                    ],
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: CartaDelProyecto(
                                        itemIndex, proyectos[itemIndex]["nombre"]!, proyectos[itemIndex]["imagen1"]!, proyectos[itemIndex]["imagen2"]!,),
                                    ),
                                  ),
                                ) : CartaDelProyecto(
                                  itemIndex, proyectos[itemIndex]["nombre"]!, proyectos[itemIndex]["imagen1"]!, proyectos[itemIndex]["imagen2"]!,), // Carta normal para los no seleccionados
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
               screenWidth > screenHeight ? IconButton(
                  icon: Icon(Icons.arrow_right, color: Colors.white, size: 50),
                  onPressed: _scrollRight,
                ) : SizedBox(),
              ],
            ),
          ),
          SizedBox(height: 4),
          indexProyectoSeleccionado != null ? detallesProyectos[indexProyectoSeleccionado!] : SizedBox(),
          indexProyectoSeleccionado != null ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
              padding: EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 8),
                  child: Wrap(
                    alignment: WrapAlignment.spaceAround,
                    children: List.generate(
                      imagenesProyecto[indexProyectoSeleccionado!]['imagenes'].length,
                          (imgIndex) {
                        // Accediendo a las imágenes y descripciones
                        var imagenData = imagenesProyecto[indexProyectoSeleccionado!]['imagenes'][imgIndex];
                        String imagen1 = imagenData['imagen1'];
                        String imagen2 = imagenData['imagen2'];
                        String descripcion1 = imagenData['descripcion1'];
                        String descripcion2 = imagenData['descripcion2'];

                        return GestureDetector(
                          child: Container(
                            height: 200,
                            width: 150, // Ajusta el tamaño de la carta
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.4),
                                  blurRadius: 16.0,
                                  spreadRadius: 3.0,
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Imagen en la esquina inferior derecha
                                Positioned(
                                  right: 0,
                                  child: Card(
                                    elevation: 8, // Añade elevación a esta imagen
                                    child: Image.asset(
                                      imagen1,
                                      fit: BoxFit.scaleDown,
                                      height: 180,
                                      width: 70,
                                    ),
                                  ),
                                ),
                                // Imagen en la esquina superior izquierda
                                Positioned(
                                  left: 0,
                                  child: Card(
                                    elevation: 8, // Añade más elevación para mayor efecto 3D
                                    child: Image.asset(
                                      imagen2,
                                      fit: BoxFit.scaleDown,
                                      height: 180,
                                      width: 70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            mostrarDialogoImagenes(context, {'imagen': imagen1, 'descripcion': descripcion1,
                            }, {'imagen': imagen2, 'descripcion': descripcion2,});
                          },
                        );
                      },
                    ),
                  )
                  ),
                ],
              ) : SizedBox(),
          indexProyectoSeleccionado != null ? SizedBox(height: 8) : SizedBox(),
        ],
      ),
    );
  }
}

class CartaDelProyecto extends StatelessWidget {
  final int index;
  final String nombreProyecto;
  final String imagen1;  // Ruta de la primera imagen
  final String imagen2;  // Ruta de la segunda imagen

  CartaDelProyecto(this.index, this.nombreProyecto, this.imagen1, this.imagen2);  // Constructor modificado

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 150, // Ajusta el tamaño de la carta
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.4),
            blurRadius: 16.0,
            spreadRadius: 3.0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Imagen en la esquina inferior derecha
          Positioned(
            bottom: 0,
            right: 0,
            child: Card(
              elevation: 4,  // Añade elevación a esta imagen
              child: Image.asset(
                imagen2,
                fit: BoxFit.scaleDown,
                height: 150,
                width: 90,
              ),
            ),
          ),
          // Imagen en la esquina superior izquierda
          Positioned(
            top: 0,
            left: 0,
            child: Card(
              elevation: 8,  // Añade más elevación para mayor efecto 3D
              child: Image.asset(imagen1,
                fit: BoxFit.scaleDown,
                height: 80,
                width: 80,
              ),
            ),
          ),
          // Texto en el centro
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black,
                      Colors.black,
                      Colors.black54,
                      Colors.black,
                      Colors.black54,
                    ],
                  ).createShader(bounds),
                  child: Text(nombreProyecto,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Comentarios extends StatefulWidget {
  const Comentarios({super.key});

  @override
  State<Comentarios> createState() => _ComentariosState();
}

class _ComentariosState extends State<Comentarios> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Container(
      key: comentariosKey,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black.withOpacity(0.85),
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: proyecto,
                              ).createShader(bounds),
                              child: Text(
                                "¿Quieres darle vida a tu idea de startup o te gustaría que participe en tu proyecto?",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                                ),
                              ),
                            ),
                          ]
                      ),),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: proyecto,
                    ).createShader(bounds),
                    child: Text(
                      "Deja tu oferta aca abajo",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: screenHeight * 0.01,
                    top: 0,
                    left: screenWidth > screenHeight ? screenWidth * 0.05 : screenWidth * 0.01,
                    right: screenWidth > screenHeight ? screenWidth * 0.05 : screenWidth * 0.01),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 8, right: 8, top: 20, bottom: 15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(227,126,229, 0.6),
                                          blurRadius: 10,
                                          spreadRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                            padding: EdgeInsets.all(6),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(6),
                                                    color: Colors.black.withOpacity(0.9)
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: screenWidth > screenHeight ? screenWidth * 0.21 : screenWidth * 0.35,
                                                        child: TextField(
                                                          style: TextStyle(color: Colors.white),
                                                          controller: NombreController,
                                                          decoration: InputDecoration(
                                                            hintText: 'Escribe tu nombre...', hintStyle: TextStyle(color: Colors.white),
                                                            border: OutlineInputBorder(),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 12),
                                                      Container(
                                                        width: screenWidth > screenHeight ? screenWidth * 0.55 : screenWidth * 0.78,
                                                        child: TextField(
                                                          style: TextStyle(color: Colors.white),
                                                          maxLines: 3,
                                                          controller: _ComentController,
                                                          decoration: InputDecoration(
                                                            hintText: '¿En que te puedo ayudar?', hintStyle: TextStyle(color: Colors.white),
                                                            border: OutlineInputBorder(),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 12),
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          foregroundColor: Colors.white,
                                                          backgroundColor: Colors.black.withOpacity(0.4),
                                                        ),
                                                          onPressed: () {
                                                            if (_ComentController.text.isNotEmpty) {
                                                              Map<String, dynamic> nuevoMensaje = {
                                                                'nombre': NombreController.text,
                                                                'mensaje': _ComentController.text
                                                              };

                                                              DocumentReference salaRef = FirebaseFirestore.instance.collection('Danidev2003').doc('data');

                                                              salaRef.update({
                                                              'mensajes': FieldValue.arrayUnion([nuevoMensaje])
                                                              }).then((value) {
                                                              setState(() {
                                                              // Limpiar los campos después de enviar el mensaje
                                                              NombreController.clear();
                                                              _ComentController.clear();
                                                              });
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(
                                                                  content: Text('Gracias por su comentario.'),
                                                                  duration: Duration(seconds: 2),
                                                                ),
                                                              );
                                                              }).catchError((error) {
                                                                print("Error al enviar el mensaje: $error");
                                                              });
                                                            }
                                                            },
                                                        child: Text('Comentar', style: TextStyle(fontSize: 16)),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                            )
                                        ),
                                      )
                                    ),

                              ],
                            )
                        ),
                      ),
                    ]
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child:
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: proyecto,
                      ).createShader(bounds),
                      child: Text(
                        "O si no, contactame por Whatsapp",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Para un backup color en caso que no se vea bien el degradado
                        ),
                      ),
                    ),),
                  ],
                ),
              ),
              SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await launch("https://wa.me/+5492213050330?text=${Uri.encodeComponent("Hola, quisiera contratar su servicio como programador Full-Stack")}");
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'lib/assets/imagenes/social.png',
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(width: 10), // Espacio entre el icono y el texto
                        Text(
                          'WhatsApp',
                          style: TextStyle(
                            fontFamily: "dibujada",
                            color: Colors.blue, // Color del enlace
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
            ]
        )
    );
  }
}


