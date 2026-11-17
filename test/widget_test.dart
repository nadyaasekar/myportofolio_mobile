import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('Halaman utama menampilkan identitas dan menu', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('NPM'), findsOneWidget);
    expect(find.text('Nama'), findsOneWidget);
    expect(find.text('Kelas'), findsOneWidget);
    expect(find.text('Lihat Proyek'), findsOneWidget);
    expect(find.text('Tambah Proyek'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  for (final menu in ['Lihat Proyek', 'Logout']) {
    testWidgets('Tombol $menu menampilkan SnackBar', (tester) async {
      await tester.pumpWidget(const MyApp());

      final tombol = find.text(menu);
      await tester.ensureVisible(tombol);
      await tester.tap(tombol);
      await tester.pumpAndSettle();

      expect(find.text('Kamu telah menekan tombol $menu!'), findsOneWidget);
    });
  }

  testWidgets('Tambah Proyek membuka form dan bisa kembali', (tester) async {
    await tester.pumpWidget(const MyApp());

    final tombol = find.text('Tambah Proyek');
    await tester.ensureVisible(tombol);
    await tester.tap(tombol);
    await tester.pumpAndSettle();

    expect(find.text('Add Project Form'), findsOneWidget);

    // Menyimulasikan navigasi kembali dari sistem.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Welcome to MyPortfolio!'), findsOneWidget);
  });

  testWidgets('Drawer dapat membuka form dan kembali ke Home', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.menu).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();

    expect(find.text('Add Project Form'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to MyPortfolio!'), findsOneWidget);
  });

  testWidgets('Form menolak nama dan deskripsi kosong', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Tambah Proyek'));
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Save'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Form menampilkan input dan mereset setelah OK', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Tambah Proyek'));
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);

    await tester.enterText(fields.at(0), 'Portofolio Nadya');
    await tester.enterText(fields.at(1), 'Aplikasi portofolio pribadi.');
    await tester.enterText(fields.at(2), 'Flutter, Django');
    await tester.enterText(fields.at(3), 'https://example.com');

    final category = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(category);
    await tester.tap(category);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mobile Development').last);
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Save'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Nama Proyek: Portofolio Nadya'), findsOneWidget);
    expect(
      find.text('Deskripsi: Aplikasi portofolio pribadi.'),
      findsOneWidget,
    );
    expect(find.text('Kategori: Mobile Development'), findsOneWidget);
    expect(find.text('Teknologi: Flutter, Django'), findsOneWidget);
    expect(find.text('Tautan: https://example.com'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);

    for (final field in tester.widgetList<EditableText>(
      find.byType(EditableText),
    )) {
      expect(field.controller.text, isEmpty);
    }

    final dropdownState = tester.state<FormFieldState<String>>(category);
    expect(dropdownState.value, 'Web Development');
  });
}
