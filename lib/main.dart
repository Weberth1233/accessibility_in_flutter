import 'package:flutter/material.dart';

class AccessibilitySettings {
  double fontSizeController;
  bool isContrast;

  AccessibilitySettings({
    this.fontSizeController = 1.0,
    this.isContrast = false,
  });
}

class AccessibilityController extends InheritedWidget {
  final AccessibilitySettings settings;
  final Function(double) updateFontSize;
  final Function() toggleHighContrast;

  AccessibilityController({
    Key? key,
    required this.settings,
    required this.updateFontSize,
    required this.toggleHighContrast,
    required Widget child,
  }) : super(key: key, child: child);

  //Sempre Notificando(true) a arvore de InheritedWidget que ouve uma alteração no antigo widget que estava buildado
  //os widgets dependentes serão reconstruídos para refletir essas mudanças. Garantindo que as atualizações
  //nos dados de acessibilidade, por exemplo, sejam propagadas para todos os widgets que dependem delas
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  //Atalho para que possamos acessa nosso AcessibilityController dentro da nossa arvore de Widgtes
  //Passando o contexto para fazer isso - AcessibilityController.of(context)
  static AccessibilityController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AccessibilityController>();
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AccessibilitySettings settings = AccessibilitySettings();

  void updateFontSize(double multiplier) {
    setState(() {
      settings.fontSizeController = multiplier;
    });
  }

  void toggleHighContrast() {
    setState(() {
      settings.isContrast = !settings.isContrast;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AccessibilityController(
      settings: settings,
      updateFontSize: updateFontSize,
      toggleHighContrast: toggleHighContrast,
      child: Builder(
        builder: (context) {
          final accessibilitySettings =
              AccessibilityController.of(context)!.settings;
          return MaterialApp(
            theme: CustomTheme()
                .lightTheme(
                    isContrast: AccessibilityController.of(context)!
                        .settings
                        .isContrast)
                .copyWith(
                  textTheme: CustomTheme().lightTheme().textTheme.apply(
                      fontSizeFactor: accessibilitySettings.fontSizeController),
                ),
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = AccessibilityController.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Accessibility')),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Example Text', style: Theme.of(context).textTheme.bodyLarge),
            ElevatedButton(
              onPressed: () {
                double newFontSize =
                    settings!.settings.fontSizeController + 0.1;
                settings.updateFontSize(newFontSize);
              },
              child: const Text('Increase Font Size'),
            ),
            ElevatedButton(
              onPressed: () {
                double newFontSize =
                    (settings!.settings.fontSizeController - 0.1)
                        .clamp(1.0, 2.0);
                settings.updateFontSize(newFontSize);
              },
              child: const Text('Decrease Font Size'),
            ),
            ElevatedButton(
              onPressed: () {
                settings!.updateFontSize(1.0);
              },
              child: const Text('Reset Font Size'),
            ),
            ElevatedButton(
              onPressed: () {
                settings!.toggleHighContrast();
              },
              child: const Text('High Contrast'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTheme {
  static final ThemeData _baseTheme = BaseTheme.getTheme();

  ThemeData lightTheme({bool isContrast = false}) {
    return _baseTheme.copyWith(
      textTheme: _textTheme(),
      colorScheme: _colorScheme(isContrast),
    );
  }

  ColorScheme _colorScheme(bool isContrast) {
    if (isContrast == true) {
      return const ColorScheme(
        primary: Color(0xFF6200EE),
        secondary: Color(0xFF03DAC6),
        surface: Colors.white,
        error: Color(0xFFB00020),
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black,
        onError: Colors.white,
        brightness: Brightness.light,
      );
    } else {
      return const ColorScheme(
        primary: Color.fromARGB(255, 83, 70, 102),
        secondary: Color.fromARGB(255, 101, 113, 112),
        surface: Color.fromARGB(255, 108, 102, 102),
        error: Color(0xFFB00020),
        onPrimary: Color.fromARGB(255, 139, 115, 115),
        onSecondary: Colors.black,
        onSurface: Colors.black,
        onError: Color.fromARGB(255, 182, 101, 101),
        brightness: Brightness.light,
      );
    }
  }

  // ColorScheme _colorSchemeContrast() {
  //   return const ColorScheme(
  //     primary: Color.fromARGB(255, 83, 70, 102),
  //     secondary: Color.fromARGB(255, 101, 113, 112),
  //     surface: Color.fromARGB(255, 108, 102, 102),
  //     error: Color(0xFFB00020),
  //     onPrimary: Color.fromARGB(255, 139, 115, 115),
  //     onSecondary: Colors.black,
  //     onSurface: Colors.black,
  //     onError: Color.fromARGB(255, 182, 101, 101),
  //     brightness: Brightness.light,
  //   );
  // }

  TextTheme _textTheme() {
    return const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 37,
        fontWeight: FontWeight.w900,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 32,
        fontWeight: FontWeight.w900,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 26,
        fontWeight: FontWeight.w900,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Roboto Condensed',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        height: 1,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Roboto Condensed',
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Roboto Condensed',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12,
      ),
    );
  }
}

class BaseTheme {
  static ThemeData getTheme() {
    return ThemeData(useMaterial3: true, fontFamily: 'Roboto');
  }
}
