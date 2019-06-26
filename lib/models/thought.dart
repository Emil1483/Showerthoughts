class Thougth {
  final String thougth;
  final String author;
  final String id;

  Thougth({this.author, this.thougth, this.id});

  int get hashCode => thougth.hashCode ^ author.hashCode ^ id.hashCode;

  bool operator ==(other) => other is Thougth && id == other.id;
}
