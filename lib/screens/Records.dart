// ignore: file_names
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Records extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  Future<List<String>> _loadUserRecords() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('user_records') ?? [];
  }

  Future<void> _deleteRecord(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> records = prefs.getStringList('user_records') ?? [];
    records.removeAt(index);
    await prefs.setStringList('user_records', records);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Record deleted."),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Records"),
      ),
      body: FutureBuilder<List<String>>(
        future: _loadUserRecords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text("Error loading records");
          } else {
            final records = snapshot.data ?? [];
            return ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(records[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteRecord(index);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
