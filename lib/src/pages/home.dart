import 'dart:math';

import 'package:banda_names/models/bands.dart';
import 'package:banda_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Bands> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    this.bands =
        (payload as List).map((banda) => Bands.fromMap(banda)).toList();

    setState(() {});
  }

  /*  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    // TODO: implement dispose
    super.dispose();
  } */

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online)
                ? Icon(
                    Icons.connected_tv_outlined,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.connected_tv_outlined,
                    color: Colors.red,
                  ),
          )
        ],
        title: const Text(
          'Nombres de bandas',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _ShowGrap(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (BuildContext context, int index) =>
                  Bandtile(bands[index]),
            ),
          ),
        ],
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
        onDismissed: (direction) => DeleteBandToList(band.id),
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
          onTap: () => VoteBand(band.id),
          leading: CircleAvatar(
            child: Text(band.name.substring(0, 2)),
            backgroundColor: Color.fromRGBO(random.nextInt(100),
                random.nextInt(100), random.nextInt(100), 1),
          ),
          title: Text(band.name),
          trailing: Text(
            '${band.vote}',
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
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (name.length > 1) {
      socketService.socket.emit('add-band', {'name': name});
      //emitir:add-band
      //{name:name}
    }

    void DeleteBandToList(String id) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      if (id.length > 1) {
        socketService.socket.emit('delete-band', {'id': id});
      }
    }

    Navigator.pop(context);
  }

  DeleteBandToList(String id) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (id.length > 1) {
      socketService.socket.emit('delete-band', {'id': id});
    }
  }

  VoteBand(String id) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (id.length > 1) {
      socketService.socket.emit('vote-band', {'id': id});
    }
  }

  _ShowGrap() {
    Map<String, double> dataMap = new Map();

    bands.forEach((banda) {
      dataMap.putIfAbsent(banda.name, () => banda.vote.toDouble());
    });

    return Container(width: double.infinity,height: 200, child: PieChart(dataMap: dataMap));
  }
}
