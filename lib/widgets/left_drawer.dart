import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/experience_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MyPortfolio',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Explore personal projects and experiences!',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.work_outline),
            title: const Text('Experience'),
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              navigator.pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const ExperienceListScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectFormPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: const Text('Add Education'),
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              navigator.pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const EducationFormPage(),
                ),
              );
            },
          ),
          const Divider(),
          if (!isLoggedIn)
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {
                final navigator = Navigator.of(context);
                navigator.pop();
                navigator.push(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            )
          else
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                final auth = context.read<AuthState>();
                final messenger = ScaffoldMessenger.of(context);

                Navigator.pop(context);

                var message = 'Berhasil logout.';

                try {
                  await auth.logout();
                } catch (_) {
                  message =
                      'Kamu sudah keluar dari aplikasi, '
                      'tetapi pencabutan token di server gagal.';
                }

                if (!messenger.mounted) return;

                messenger
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(message)));
              },
            ),
        ],
      ),
    );
  }
}
