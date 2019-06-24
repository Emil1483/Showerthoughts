class Thougth {
  final String thougth;
  final String author;

  Thougth({this.author, this.thougth});

  int get hashCode => thougth.hashCode ^ author.hashCode;

  bool operator ==(other) =>
      other is Thougth && thougth == other.thougth && author == other.author;
}
