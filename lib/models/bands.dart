class Bands {
  String id;
  String name;
  int vote;

  Bands({required this.id, required this.name, required this.vote});

  factory Bands.fromMap(Map<String, dynamic> obj) => Bands(
        id: obj.containsKey('id') ? obj['id'] : 'No hay id',
        name: obj.containsKey('name') ? obj['name'] : 'No hay banda registrada',
        vote:
            obj.containsKey('vote') ? obj['vote'] : 'No hay votos registrados',
      );
}
