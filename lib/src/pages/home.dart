import 'dart:math';

import 'package:banda_names/models/bands.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Bands> bands = [
    Bands(id: '1', name: 'Ashes Remain', votes: 5),
    Bands(id: '2', name: 'Metallica', votes: 7),
    Bands(id: '3', name: 'Heroes del silencio', votes: 8),
    Bands(id: '4', name: 'HombresG', votes: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nombres de bandas',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index) {
          return Bandtile(bands[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        child: Icon(Icons.add),
        elevation: 1,
      ),
    );
  }

  Widget Bandtile(Bands band) {
    Random random = Random();
    return Dismissible(
        onDismissed: (direction) {
          print('Direccion $direction');
          print('Id ${band.id}');
        },
        direction: DismissDirection.startToEnd,
        background: Container(
          padding: EdgeInsets.only(left: 8),
          color: Colors.red,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Delete band'),
          ),
        ),
        key: Key(band.id),
        child: ListTile(
          onTap: () {
            print(band.name);
          },
          leading: CircleAvatar(
            child: Text(band.name.substring(0, 2)),
            backgroundColor: Color.fromRGBO(random.nextInt(100),
                random.nextInt(100), random.nextInt(100), 1),
          ),
          title: Text(band.name),
          trailing: Text(
            '${band.votes}',
            style: TextStyle(fontSize: 20),
          ),
        ));
  }

  addNewBand() {
    final textController = new TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New Band Name'),
            content: TextField(
              controller: textController,
            ),
            elevation: 5,
            titleTextStyle: TextStyle(color: Colors.black),
            actions: [
              MaterialButton(
                onPressed: () => addBandToList(textController.text),
                child: Text('Add'),
              )
            ],
          );
        });
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      this
          .bands
          .add(new Bands(id: DateTime.now().toString(), name: name, votes: 4));
      setState(() {});
    }

    Navigator.pop(context);
  }
}
