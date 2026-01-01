import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/UserDataSource.dart';
import 'package:flutter_application_1/services/users_screen.dart';
import '../widgets/app_drawer.dart';
import '../models/user.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class Employee {
  final int id;
  final String name;
  final String role;

  Employee(this.id, this.name, this.role);
}

class _UsersScreenState extends State<UsersScreen> {
  late Future<List<User>> usersFuture;

  void _createUser() {
    Navigator.pushReplacementNamed(context, '/users/manage');
  }

  late UserDataSource userDataSource;

  @override
  void initState() {
    super.initState();
    usersFuture = UserApiService().getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      drawer: const AppDrawer(),
      body: FutureBuilder<List<User>>(
        future: usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final users = snapshot.data!;

          // Create DataSource ONCE per fetch
          userDataSource = UserDataSource(users);

          return SfDataGrid(
            source: userDataSource,
            allowSorting: true,
            allowFiltering: true,
            columnWidthMode: ColumnWidthMode.fill,
            headerRowHeight: 50,
            rowHeight: 48,
            gridLinesVisibility: GridLinesVisibility.horizontal,
            headerGridLinesVisibility: GridLinesVisibility.horizontal,
            columns: [
              GridColumn(
                columnName: 'id',
                label: Center(child: Text('ID')),

              ),
              GridColumn(
                columnName: 'name',
                label: Center(child: Text('Name')),
              ),
              GridColumn(
                columnName: 'email',
                label: Center(child: Text('Email')),
              ),
            ],
          );

          // return ListView.builder(
          //   itemCount: users.length,
          //   itemBuilder: (_, i) => ListTile(
          //     title: Text(users[i].name),
          //     subtitle: Text(users[i].email),
          //   ),
          // );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createUser,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
