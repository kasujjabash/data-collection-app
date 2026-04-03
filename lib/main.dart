import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'data/repositories/prescription_repository.dart';
import 'features/home/providers/home_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        // Repository is a plain object — not a ChangeNotifier
        Provider<PrescriptionRepository>(
          create: (_) => PrescriptionRepository(),
        ),
        // HomeProvider depends on the repository
        ChangeNotifierProxyProvider<PrescriptionRepository, HomeProvider>(
          create: (ctx) => HomeProvider(ctx.read<PrescriptionRepository>()),
          update: (_, repo, prev) => prev ?? HomeProvider(repo),
        ),
      ],
      child: const PharmacyApp(),
    ),
  );
}
