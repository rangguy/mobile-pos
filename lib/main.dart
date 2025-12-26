import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/main/presentation/pages/main_scaffold.dart';
import 'features/product/presentation/bloc/product_bloc.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => sl<AuthBloc>()..add(const AuthEvent.checkStatus())),
        BlocProvider(create: (_) => sl<ProductBloc>()),
      ],
      child: MaterialApp(
        title: 'POS App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return state.when(
              initial: () => const LoginPage(),
              loading: () => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
              authenticated: (_) => const MainScaffold(),
              registerSuccess: (_) => const MainScaffold(),
              profileLoaded: (_) => const MainScaffold(),
              unauthenticated: () => const LoginPage(),
              error: (_) => const LoginPage(),
            );
          },
        ),
      ),
    );
  }
}
