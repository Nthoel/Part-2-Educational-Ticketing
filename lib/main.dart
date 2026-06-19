import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/catalog/presentation/views/event_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: EducationalTicketingApp()));
}

class EducationalTicketingApp extends StatelessWidget {
  const EducationalTicketingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Educational Ticketing',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const EventListScreen(),
    );
  }
}
