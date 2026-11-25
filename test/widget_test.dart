import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';

import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/experience_detail_screen.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

const sampleExperience = {
  'id': 'test-experience',
  'title': 'Mentor Fasilkom',
  'description': 'Mendampingi peserta kegiatan.',
  'category': 'volunteer',
  'category_display': 'Volunteer',
  'thumbnail': null,
  'started_at': '2026-01-01',
  'ended_at': null,
  'is_ongoing': true,
  'star_count': 2,
  'is_starred': false,
  'starred_by_names': '',
};

Widget buildTestApp(ApiClient api) {
  return MultiProvider(
    providers: [
      Provider<ApiClient>.value(value: api),
      ChangeNotifierProvider<AuthState>(create: (_) => AuthState(api)),
    ],
    child: const MyApp(),
  );
}

Future<void> tapText(WidgetTester tester, String text) async {
  final target = find.text(text);
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

void main() {
  late ApiClient api;

  setUp(() {
    api = ApiClient(
      client: MockClient((request) async {
        if (request.method == 'GET' &&
            request.url.path == '/api/v1/experiences/') {
          return http.Response(
            jsonEncode([sampleExperience]),
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        return http.Response('{"detail":"Not found"}', 404);
      }),
    );
  });

  tearDown(() {
    api.close();
  });

  testWidgets('Home menampilkan identitas dan menu terbaru', (tester) async {
    await tester.pumpWidget(buildTestApp(api));

    expect(find.text('NPM'), findsOneWidget);
    expect(find.text('Nama'), findsOneWidget);
    expect(find.text('Kelas'), findsOneWidget);
    expect(find.text('Lihat Experience'), findsOneWidget);
    expect(find.text('Tambah Experience'), findsOneWidget);
    expect(find.text('Tambah Education'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('Pengunjung bisa membuka daftar dan detail', (tester) async {
    await tester.pumpWidget(buildTestApp(api));

    await tapText(tester, 'Lihat Experience');

    expect(find.text('Mentor Fasilkom'), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);

    await tapText(tester, 'Mentor Fasilkom');

    expect(find.byType(ExperienceDetailScreen), findsOneWidget);
    expect(find.text('Mendampingi peserta kegiatan.'), findsOneWidget);
    expect(find.text('★ 2 star'), findsOneWidget);
  });

  testWidgets('Tambah Experience meminta login dan memvalidasi isian', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestApp(api));

    await tapText(tester, 'Tambah Experience');

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(ExperienceFormPage), findsNothing);

    // Tunggu SnackBar dari kartu menu selesai.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    final loginButton = find.widgetWithText(ElevatedButton, 'Login');
    await tester.ensureVisible(loginButton);
    await tester.pumpAndSettle();
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Username tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Password tidak boleh kosong!'), findsOneWidget);
  });

  testWidgets('Logout tanpa sesi menampilkan pesan', (tester) async {
    await tester.pumpWidget(buildTestApp(api));

    await tapText(tester, 'Logout');

    expect(find.text('Kamu belum login.'), findsOneWidget);
  });

  test('Login menyimpan token dan logout mencabutnya', () async {
    final requests = <http.Request>[];

    final authApi = ApiClient(
      client: MockClient((request) async {
        requests.add(request);

        if (request.url.path == '/api/v1/auth/token/') {
          expect(request.method, 'POST');
          expect(jsonDecode(request.body), {
            'username': 'akun-test',
            'password': 'password-test',
          });
          return http.Response('{"token":"token-test"}', 200);
        }

        if (request.url.path == '/api/v1/auth/logout/') {
          expect(request.method, 'POST');
          expect(request.headers['Authorization'], 'Token token-test');
          return http.Response('', 204);
        }

        return http.Response('{}', 404);
      }),
    );

    final auth = AuthState(authApi);
    addTearDown(authApi.close);
    addTearDown(auth.dispose);

    await auth.login('akun-test', 'password-test');

    expect(auth.isLoggedIn, isTrue);
    expect(auth.token, 'token-test');

    await auth.logout();

    expect(auth.isLoggedIn, isFalse);
    expect(auth.token, isNull);
    expect(requests.length, 2);
  });

  test('POST Experience mengirim token dan field yang bisa ditulis', () async {
    final createApi = ApiClient(
      client: MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/experiences/');
        expect(request.headers['Authorization'], 'Token token-test');

        final body = jsonDecode(request.body) as Map<String, dynamic>;

        expect(body['title'], 'Mentor Fasilkom');
        expect(body['category'], 'volunteer');
        expect(body.containsKey('id'), isFalse);
        expect(body.containsKey('star_count'), isFalse);
        expect(body.containsKey('is_starred'), isFalse);

        return http.Response(jsonEncode(sampleExperience), 201);
      }),
    );
    addTearDown(createApi.close);

    final saved = await createApi.createExperience(
      const Experience(
        title: 'Mentor Fasilkom',
        description: 'Mendampingi peserta kegiatan.',
        category: 'volunteer',
        startedAt: '2026-01-01',
      ),
      token: 'token-test',
    );

    expect(saved.id, 'test-experience');
    expect(saved.title, 'Mentor Fasilkom');
  });
}
