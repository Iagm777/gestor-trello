import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'config/app_routes.dart';
import 'models/card_model.dart';
import 'screens/home/home_screen.dart';
import 'screens/board/board_screen.dart';
import 'screens/card/card_details_screen.dart';
import 'screens/card/create_card_screen.dart';
import 'screens/card/edit_card_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gestor Trello",

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      // Use named routes and set initial route based on auth
      initialRoute: (SupabaseConfig.client.auth.currentUser == null) ? AppRoutes.login : AppRoutes.home,
      routes: {
        ...AppRoutes.routes,
        "/card-detail": (_) => const CardDetailsScreen(),
        "/card-create": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return CreateCardScreen(listId: args['listId']);
        },
        "/card-edit": (context) {
          final card = ModalRoute.of(context)!.settings.arguments as CardModel;
          return EditCardScreen(card: card);
        },
      },
    );
  }
}
