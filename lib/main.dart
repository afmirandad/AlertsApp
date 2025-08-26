
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
  home: const MyHomePage(),
    );
  }
}




class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Map<String, String>> emergencySounds = [
    {'label': 'Alerta General', 'file': 'alerte.mp3', 'color': '0xFFE53935'},
    {'label': 'Emergencia Médica', 'file': 'emergencia_medica.mp3', 'color': '0xFF43A047'},
    {'label': 'Incendio', 'file': 'incendio.mp3', 'color': '0xFFFFA000'},
    {'label': 'Caída', 'file': 'caida.mp3', 'color': '0xFF1E88E5'},
  ];

  int? _activeIndex;

  void _playSound(String fileName, int index) async {
    setState(() {
      _activeIndex = index;
    });
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource('audio/$fileName'));
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _activeIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          '¡Emergencia Fácil!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8BBD0), Color(0xFFB39DDB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                'Presiona el botón de la emergencia que necesitas:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ...List.generate(emergencySounds.length, (i) {
              final sound = emergencySounds[i];
              final isActive = _activeIndex == i;
              return AnimatedScale(
                scale: isActive ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24),
                  child: GestureDetector(
                    onTap: () => _playSound(sound['file']!, i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Color(int.parse(sound['color']!)),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: isActive ? Border.all(color: Colors.black, width: 3) : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.campaign, color: Colors.white, size: 36),
                          const SizedBox(width: 18),
                          Text(
                            sound['label']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
