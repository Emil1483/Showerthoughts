class Thougth {
  final String thougth;
  final String author;
  final String id;

  Thougth({this.author, this.thougth, this.id});

  factory Thougth.fromString(String str) {
    List<String> parts = str.split("|||");
    return Thougth(
      thougth: parts[0],
      author: parts[1],
      id: parts[2],
    );
  }

  String toString() {
    Thougth t = trimmed();
    return "${t.thougth}|||${t.author}|||${t.id}";
  }

  static String trim(String str) => str.replaceAll("|", "");

  Thougth trimmed() {
    return Thougth(
      thougth: trim(thougth),
      author: trim(author),
      id: trim(id),
    );
  }

  int get hashCode => id.hashCode;

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
