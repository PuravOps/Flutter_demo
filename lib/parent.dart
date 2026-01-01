import 'package:flutter/material.dart';

class ParentFrame extends StatefulWidget {
  const ParentFrame({super.key});

  @override
  State<ParentFrame> createState() => _ParentFrameState();
}

class _ParentFrameState extends State<ParentFrame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Frame')),
      body: const Center(child: Text('This is the Parent Frame')),
    );
  }
}
