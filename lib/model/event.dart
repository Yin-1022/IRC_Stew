class Event
{
  String title;

  Event
  (
      this.title
  );

  @override
  String toString() => title;
}

bool isSameDayWithoutTime(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}