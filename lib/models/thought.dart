class Thougth {
  final String thougth;
  final String author;
  final String id;

  Thougth({this.author, this.thougth, this.id});

  int get hashCode => thougth.hashCode ^ author.hashCode ^ id.hashCode;

  bool operator ==(other) => other is Thougth && id == other.id;

  static List<Thougth> listFromJson(Map<String, dynamic> data) {
    List<Thougth> thougths = [];
    data.forEach(
      (String id, dynamic map) {
        thougths.add(
          Thougth(
            thougth: map["thougth"],
            author: map["author"],
            id: id,
          ),
        );
      },
    );
    return thougths;
  }

  Map<String, dynamic> toJson() {
    return {
      id.toString(): {
        "thougth": thougth,
        "author": author,
      },
    };
  }
}
