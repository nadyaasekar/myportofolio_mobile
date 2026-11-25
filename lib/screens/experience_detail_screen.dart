import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/experience.dart';

class ExperienceDetailScreen extends StatelessWidget {
  const ExperienceDetailScreen({super.key, required this.experience});

  final Experience experience;

  @override
  Widget build(BuildContext context) {
    final thumbnail = experience.thumbnail;
    final category = experience.categoryDisplay.isEmpty
        ? experience.category
        : experience.categoryDisplay;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Experience')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (thumbnail != null && thumbnail.isNotEmpty) ...[
              Image.network(
                thumbnail,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 100,
                    child: Center(child: Text('Gambar tidak dapat dimuat.')),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
            Text(
              experience.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(category),
            const SizedBox(height: 8),
            Text(
              '${experience.startedAt ?? "Tanggal mulai belum diisi"}'
              ' — ${experience.endedAt ?? "Sekarang"}',
            ),
            const SizedBox(height: 16),
            Text(experience.description),
            const SizedBox(height: 16),
            Text('Status: ${experience.isOngoing ? "Berlangsung" : "Selesai"}'),
            const SizedBox(height: 8),
            Text('★ ${experience.starCount} star'),
          ],
        ),
      ),
    );
  }
}
