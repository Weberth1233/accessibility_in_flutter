import 'package:flutter/material.dart';

class AccessibilitySettings {
  ValueNotifier<double> fontSizeController;
  ValueNotifier<bool> isContrast;

  AccessibilitySettings({
    double initialFontSize = 1.0,
    bool initialIsContrast = false,
  })  : fontSizeController = ValueNotifier<double>(initialFontSize),
        isContrast = ValueNotifier<bool>(initialIsContrast);
}

class AccessibilityController extends InheritedWidget {
  final AccessibilitySettings settings;

  const AccessibilityController({
    super.key,
    required this.settings,
    required super.child,
  });

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AccessibilityController(
      settings: AccessibilitySettings(),
      child: Builder(
        builder: (context) {
          final settings = AccessibilityController.of(context)!.settings;
          return AnimatedBuilder(
            //Combinando os varios ValueNotifier em apenas um Listenable para ouvir as alterações
            //cria um único Listenable que notifica seus ouvintes sempre que qualquer um dos ValueNotifier que estão dentro dele mudar
            // combinados muda ou seja se o fontsizecontroller ou contrast mudar ele build novamente
            //ValueNotifier é uma implementação do meu Listenable
            animation: Listenable.merge(
                [settings.fontSizeController, settings.isContrast]),
            builder: (context, child) {
              return MaterialApp(
                theme: CustomTheme()
                    .lightTheme(isContrast: settings.isContrast.value)
                    .copyWith(
                      textTheme: CustomTheme().lightTheme().textTheme.apply(
                            fontSizeFactor: settings.fontSizeController.value,
                          ),
                    ),
                home: HomeScreen(),
              );
            },
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = AccessibilityController.of(context)!;

    return Scaffold(
      appBar: AppBar(title: const Text('Accessibility')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Example Text', style: Theme.of(context).textTheme.bodyLarge),
            ElevatedButton(
              onPressed: () {
                settings.settings.fontSizeController.value =
                    (settings.settings.fontSizeController.value + 0.1)
                        .clamp(1.0, 1.5);
              },
              child: const Text('Increase Font Size'),
            ),
            ElevatedButton(
              onPressed: () {
                //.clamp(minino, maximo) - o tamanho da fonta vai diminuir apenas nesse intervalo
                settings.settings.fontSizeController.value =
                    (settings.settings.fontSizeController.value - 0.1)
                        .clamp(1.0, 1.5);
              },
              child: const Text('Decrease Font Size'),
            ),
            ElevatedButton(
              onPressed: () {
                settings.settings.fontSizeController.value = 1.0;
              },
              child: const Text('Reset Font Size'),
            ),
            ElevatedButton(
              onPressed: () {
                settings.settings.isContrast.value =
                    !settings.settings.isContrast.value;
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
    if (isContrast) {
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
