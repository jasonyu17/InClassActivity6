import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class Counter with ChangeNotifier {
  int _value = 0;
  int get value => _value;
  void setValue(double newValue) {
    _value = newValue.toInt();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('I am '),
            Consumer<Counter>(
              builder: (context, counter, child) => Text(
                '${counter.value}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const Text(' years old.'),
            const SizedBox(height: 20),
            Consumer<Counter>(
              builder: (context, counter, child) {
                Color sliderColor;
                if (counter.value <= 33) {
                  sliderColor = Colors.green;
                } else if (counter.value <= 67) {
                  sliderColor = Colors.yellow;
                } else {
                  sliderColor = Colors.red;
                }
                return SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: sliderColor,
                    
                    thumbColor: sliderColor,
                    trackHeight: 4.0,
                  ),
                  child: Slider(
                    value: counter.value.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: counter.value.toString(),
                    onChanged: (double newValue) {
                      counter.setValue(newValue);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
