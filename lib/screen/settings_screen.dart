import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oms/common/styles/paddings.dart';
import 'package:oms/cubits/cubit_theme.dart';
import 'package:oms/screen/login.dart';
import 'package:oms/screen/profile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : const Color(0xFFF1DCD1);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SETTINGS',
          style: TextStyle(
            
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF219F94),
      ),
      body: const Padding(
        padding: Paddings.defaultPadding,
        child: Column(
          children: [
            ProfileScreenButton(),
            SizedBox(height: 10),
            AppThemeSwitch(),
            SizedBox(height: 10),
            SizedBox(height: 10),
            SignOutSwitch(),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
    );
  }
}

class AppThemeSwitch extends StatefulWidget {
  const AppThemeSwitch({super.key});

  @override
  State<AppThemeSwitch> createState() => AppThemeSwitchState();
}

class AppThemeSwitchState extends State<AppThemeSwitch> {
  bool isDarkMode = false;
  Future<void> toggleTheme(value) async {
    setState(() => isDarkMode = !isDarkMode);
    await context.read<Themecubit>().changeTheme(
          isDarkMode: isDarkMode,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Dark Mode",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          BlocBuilder<Themecubit, ThemeMode>(builder: (context, state) {
            isDarkMode = state == ThemeMode.dark;
            return CupertinoSwitch(
              value: isDarkMode,
              onChanged: toggleTheme,
            );
          })
        ],
      ),
    );
  }
}

class SignOutSwitch extends StatelessWidget {
  const SignOutSwitch({super.key});
  Future<void> signOut(BuildContext context) async {
    final bool? confirmSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF219F94),
            ),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF219F94),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (confirmSignOut == true) {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login or welcome screen
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const MyLogin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => signOut(context),
          icon: const Icon(Icons.logout),
          label: const Text('Log out',
              style: TextStyle(
                fontSize: 18,
              )),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF219F94),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
        ),
      ),
    );
  }
}

class ProfileScreenButton extends StatelessWidget {
  const ProfileScreenButton({super.key});

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : const Color.fromARGB(255, 241, 220, 209);
    final Color buttonColor1 = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: buttonColor1,
              backgroundColor: buttonColor,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            child: const Padding(
              padding: EdgeInsets.only(left: 13.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            )),
      ),
    );
  }
}