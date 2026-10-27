import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Top level widget. It never changes, so it is Stateless.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun Signup App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignupPage(),
    );
  }
}

// The states of the tip feature.
enum TipStatus { idle, loading, success, error }

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // The key lets us validate the whole form at once.
  final _formKey = GlobalKey<FormState>();

  // Controllers keep track of what the user typed.
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Task A: preset tips stored inside the app, grouped by category.
  // These are fixed text. No internet and no AI is used.
  static const String _category = 'password_help';
  static const Map<String, List<String>> _tips = {
    'password_help': [
      'Use a longer password. Length matters more than fancy symbols.',
      'Try a short phrase of random words that you can picture easily.',
      'Do not reuse the same password on different sites.',
    ],
  };

  TipStatus _tipStatus = TipStatus.idle;
  String _tipText = '';
  int _tipIndex = 0;

  // This switch lets us demo the local error case.
  bool _simulateError = false;

  // Show loading, wait a moment, then show a tip or an error.
  Future<void> _getTip() async {
    setState(() {
      _tipStatus = TipStatus.loading;
    });

    await Future.delayed(const Duration(seconds: 1));

    // The screen might be closed while we waited.
    if (!mounted) return;

    final tipsForCategory = _tips[_category];

    if (_simulateError || tipsForCategory == null || tipsForCategory.isEmpty) {
      setState(() {
        _tipStatus = TipStatus.error;
      });
      return;
    }

    // Pick the next tip in order so the result is predictable.
    final tip = tipsForCategory[_tipIndex % tipsForCategory.length];
    _tipIndex++;

    setState(() {
      // Tips are limited to 240 characters.
      _tipText = tip.length > 240 ? tip.substring(0, 240) : tip;
      _tipStatus = TipStatus.success;
    });
  }

  // Build the area under the button based on the tip state.
  Widget _buildTipArea() {
    switch (_tipStatus) {
      case TipStatus.idle:
        return const SizedBox.shrink();
      case TipStatus.loading:
        return const Padding(
          padding: EdgeInsets.only(top: 12),
          child: CircularProgressIndicator(),
        );
      case TipStatus.success:
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              Text(_tipText, textAlign: TextAlign.center),
              const SizedBox(height: 4),
              const Text(
                'Preset demo tip—not live AI.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        );
      case TipStatus.error:
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              const Text(
                'Could not load a tip.',
                style: TextStyle(color: Colors.red),
              ),
              TextButton(
                onPressed: _getTip, // Retry
                child: const Text('Retry'),
              ),
            ],
          ),
        );
    }
  }

  // Free the controllers when the screen is removed.
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Us Today'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Scroll so nothing overflows when the keyboard opens.
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Create Your Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Sign up button. Only the validators decide success.
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Demo signup complete. Your form passed validation!',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                  ),
                  child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
                ),

                const Divider(height: 40),

                // Task A: signup tip feature (separate from the form)
                OutlinedButton(
                  onPressed: _tipStatus == TipStatus.loading ? null : _getTip,
                  child: const Text('Get a signup tip'),
                ),
                SwitchListTile(
                  title: const Text('Simulate tip error (demo)'),
                  value: _simulateError,
                  onChanged: (value) {
                    setState(() {
                      _simulateError = value;
                    });
                  },
                ),
                _buildTipArea(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
