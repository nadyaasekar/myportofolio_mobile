import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>(
          create: (_) => ApiClient(),
          dispose: (_, client) => client.close(),
        ),
        ChangeNotifierProvider<AuthState>(
          create: (context) => AuthState(context.read<ApiClient>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPortfolio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)
            .copyWith(secondary: Colors.amber[700]),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
