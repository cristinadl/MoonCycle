
class Event {
  String title;
  List<String> notes;
  bool isPeriod;
  double bloodFlow;

  Event({required this.title, required this.notes})
      : isPeriod = true, bloodFlow = 3;

  @override
  String toString() => '${[title, isPeriod, bloodFlow]}';
}