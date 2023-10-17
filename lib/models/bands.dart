class Bands {
  String id;
  String name;
  int votes;

  Bands({required this.id, required this.name, required this.votes});

  factory Bands.fromMap(Map<String, dynamic> obj) => Bands(
        id: obj['id'],
        name: obj['Name'],
        votes: obj['Votes'],
      );
}
