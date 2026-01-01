import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UserDataSource extends DataGridSource {
  UserDataSource(List<User> users) {
    _rows = users.map((u) => DataGridRow(cells: [
      DataGridCell<int>(columnName: 'id', value: u.id),
      DataGridCell<String>(columnName: 'name', value: u.name),
      DataGridCell<String>(columnName: 'email', value: u.email),
    ])).toList();
  }

  late List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map((cell) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Text(cell.value.toString()),
        );
      }).toList(),
    );
  }
}
