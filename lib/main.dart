import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:js' as js;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  String _imageUrl = '';
  bool isMenuOpen = false;

  void _loadImage() {
    setState(() {
      _imageUrl = _urlController.text;
    });
  }

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }


  void _toggleFullScreen() {
    final html.Element? element = html.document.documentElement;
    if (html.document.fullscreenElement == null) {
      element?.requestFullscreen();
    } else {
      html.document.exitFullscreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: _imageUrl.isNotEmpty
                        ? GestureDetector(
                      onDoubleTap: _toggleFullScreen,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          // decoration: BoxDecoration(
                          //   color: Colors.grey,
                          //   borderRadius: BorderRadius.circular(12),
                          // ),
                          child: Image.network(
                            _imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image,
                                size: 100, color: Colors.red),
                          ),
                        ),
                      ),
                    )
                        : const Text("Enter an image URL and press the button"),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 400,
                        child: TextField(
                          controller: _urlController,
                          decoration:
                          const InputDecoration(hintText: 'Image URL'),
                        ),
                      ),
                      const SizedBox(
                          width: 20),
                      ElevatedButton(
                        onPressed: _loadImage,
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                          child: Icon(Icons.arrow_forward),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isMenuOpen)
            GestureDetector(
              onTap: _toggleMenu,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isMenuOpen)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: IntrinsicHeight( // Ensures the container only takes necessary height
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _toggleFullScreen();
                                _toggleMenu();
                              },
                              child: const Text('Enter Fullscreen'),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                html.document.exitFullscreen();
                                _toggleMenu();
                              },
                              child: const Text('Exit Fullscreen'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  FloatingActionButton(
                    onPressed: _toggleMenu,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
