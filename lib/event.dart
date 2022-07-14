
class Event {
  final String title;
  final List<String> notes;
  final bool isPeriod;

  const Event({required this.title, required this.isPeriod, required this.notes});

  @override
  String toString() => '${[title, isPeriod]}';
}