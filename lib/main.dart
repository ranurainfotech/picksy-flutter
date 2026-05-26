import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_design_system.dart';
import 'firebase_options.dart';
import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: PicksyApp()));
}

class PicksyApp extends ConsumerStatefulWidget {
  const PicksyApp({super.key});

  @override
  ConsumerState<PicksyApp> createState() => _PicksyAppState();
}

class _PicksyAppState extends ConsumerState<PicksyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createAppRouter(ref);
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Picksy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: _router,
    );
  }
}
