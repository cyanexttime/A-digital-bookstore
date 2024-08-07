import 'package:flutter/material.dart';
import 'package:oms/API/get_statistics.dart';

class BuildStatistics extends StatelessWidget {
  final String mangaID;

  const BuildStatistics({super.key, required this.mangaID});

  @override
  Widget build(BuildContext context) {
    return _BuildStatisticsState(mangaID: mangaID);
  }
}

class _BuildStatisticsState extends StatefulWidget {
  final String mangaID;

  const _BuildStatisticsState({required this.mangaID});

  @override
  __BuildStatisticsStateState createState() => __BuildStatisticsStateState();
}

class __BuildStatisticsStateState extends State<_BuildStatisticsState> {
  late Future<Map<String, dynamic>> _statisticsFuture;

  @override
  void initState() {
    super.initState();
    _statisticsFuture = GetStatistics(query: widget.mangaID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _statisticsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data!.isEmpty) {
            return const Center(child: Text('No data'));
          }
          return Row(
            children: [
              const Icon(Icons.star_border, color: Colors.amber),
              const SizedBox(width: 2),
              Text('${data['rating']['average'].toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Icon(Icons.comment_bank_outlined, color: Colors.blue),
              const SizedBox(width: 2),
              Text('${data['comments']?['repliesCount'] ?? 0}',
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Icon(Icons.people_alt_outlined, color: Colors.red),
              const SizedBox(width: 2),
              Text('${data['follows'] ?? 0}',
                  style: const TextStyle(fontSize: 20)),
            ],
          );
        }
        return const Center(child: Text('No data'));
      },
    );
  }
}
