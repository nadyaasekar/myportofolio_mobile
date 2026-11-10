import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('Halaman utama menampilkan identitas dan menu', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('NPM'), findsOneWidget);
    expect(find.text('Nama'), findsOneWidget);
    expect(find.text('Kelas'), findsOneWidget);
    expect(find.text('Welcome to MyPortfolio!'), findsOneWidget);

    expect(find.text('Lihat Proyek'), findsOneWidget);
    expect(find.text('Tambah Proyek'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  for (final menu in ['Lihat Proyek', 'Tambah Proyek', 'Logout']) {
    testWidgets('Tombol $menu menampilkan SnackBar', (tester) async {
      await tester.pumpWidget(const MyApp());

      final tombol = find.text(menu);
      await tester.ensureVisible(tombol);
      await tester.tap(tombol);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Kamu telah menekan tombol $menu!'), findsOneWidget);
    });
  }
}
