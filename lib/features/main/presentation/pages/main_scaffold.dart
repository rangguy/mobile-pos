import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/profile_page.dart';
import '../../../auth/presentation/pages/register_page.dart';
import '../../../product/presentation/pages/product_list_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        // Determine if user is owner
        final isOwner = authState.maybeWhen(
          authenticated: (user) => user.role == 'owner',
          registerSuccess: (user) => user.role == 'owner',
          profileLoaded: (user) => user.role == 'owner',
          orElse: () => false,
        );

        // Build navigation items based on user role
        final List<BottomNavigationBarItem> navItems = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Products',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ];

        // Add "Add User" tab for owners
        if (isOwner) {
          navItems.add(
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_add_outlined),
              activeIcon: Icon(Icons.person_add),
              label: 'Add User',
            ),
          );
        }

        // Ensure current index is valid
        if (_currentIndex >= navItems.length) {
          _currentIndex = 0;
        }

        // Build pages based on user role
        final List<Widget> pages = [
          const ProductListPage(showAppBar: true),
          BlocProvider.value(
            value: context.read<AuthBloc>(),
            child: const ProfilePage(showAppBar: true),
          ),
        ];

        // Add register page for owners
        if (isOwner) {
          pages.add(
            BlocProvider.value(
              value: context.read<AuthBloc>(),
              child: const RegisterPage(showAppBar: true),
            ),
          );
        }

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: navItems,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        );
      },
    );
  }
}
