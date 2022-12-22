import 'package:drift/drift.dart';
import 'package:drift_platforms/database/database.dart';
import 'package:drift_platforms/database/executor/executor.dart';
import 'package:flutter/material.dart';

/// Do not use global variables in production code.
late final AppDatabase db;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  db = await configureDb();
  runApp(const App());
}

/// {@template main}
/// App widget
/// {@endtemplate}
class App extends StatelessWidget {
  /// {@macro main}
  const App({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: Home(),
      );
}

/// {@template home}
/// Home widget
/// {@endtemplate}
class Home extends StatefulWidget {
  /// {@macro home}
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final Stream<List<User>> _users;
  late final TextEditingController _nameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _users = db.select(db.users).watch();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Text('Cross-platform Drift'),
              floating: true,
              snap: true,
            ),
            SliverList(
                delegate: SliverChildListDelegate(
              [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                ElevatedButton(
                  onPressed: () async {
                    await db.into(db.users).insert(
                          UsersCompanion.insert(
                            name: _nameController.text,
                            password: _passwordController.text,
                            email: Value(_emailController.text),
                          ),
                        );
                    _nameController.clear();
                    _passwordController.clear();
                  },
                  child: const Text('Add user'),
                ),
              ],
            )),
            const SliverPadding(padding: EdgeInsets.only(top: 20)),
            StreamBuilder<List<User>>(
              stream: _users,
              builder: (context, snapshot) {
                final data = snapshot.data;
                if (data != null && data.isNotEmpty) {
                  final users = snapshot.data!;
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final user = users[index];
                        return ListTile(
                          title: Text(user.name),
                          subtitle: Text(user.password),
                        );
                      },
                      childCount: users.length,
                    ),
                  );
                } else {
                  return const SliverToBoxAdapter(
                    child: Text('Users not found'),
                  );
                }
              },
            ),
          ],
        ),
      );
} // Home
