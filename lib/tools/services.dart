String dateToString(DateTime? date) {
  if (date == null) return "Pas de date limite";
  return "${date.day}/${date.month}/${date.year}";
}
