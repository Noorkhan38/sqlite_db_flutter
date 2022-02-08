
/*** Model class for data operations ****/
class Grocery {
  final int? id;
  final String name;

  Grocery({required this.id, required this.name});

  factory Grocery.fromMap(Map<String, dynamic> json) => new Grocery(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}