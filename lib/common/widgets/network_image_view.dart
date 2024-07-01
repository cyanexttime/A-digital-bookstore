import 'package:flutter/material.dart';

class NetworkImageView extends StatelessWidget {
  const NetworkImageView({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Image.network(
              url,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
