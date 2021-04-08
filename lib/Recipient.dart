class Recipient {
  final int id;
  final String name;

  Recipient({
    this.id,
    this.name,
  });

  @override
  String toString() {
    return this.name;
  }
}
