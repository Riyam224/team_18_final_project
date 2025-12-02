/// Removes invisible direction markers and trims whitespace.
String cleanInput(String value) {
  return value
      .replaceAll('\u200E', '')
      .replaceAll('\u200F', '')
      .replaceAll('\u202A', '')
      .replaceAll('\u202B', '')
      .replaceAll('\u202C', '')
      .trim();
}
