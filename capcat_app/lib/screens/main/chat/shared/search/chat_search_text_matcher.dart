String normalizeChatSearchText(String input) {
  final collapsed = input.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  if (collapsed.isEmpty) return '';

  var normalized = collapsed;
  _vietnameseSearchMap.forEach((pattern, replacement) {
    normalized = normalized.replaceAll(RegExp(pattern), replacement);
  });
  return normalized;
}

bool chatSearchContains({required String source, required String query}) {
  final normalizedQuery = normalizeChatSearchText(query);
  if (normalizedQuery.isEmpty) return true;
  return normalizeChatSearchText(source).contains(normalizedQuery);
}

const Map<String, String> _vietnameseSearchMap = {
  r'[àáạảãâầấậẩẫăằắặẳẵ]': 'a',
  r'[èéẹẻẽêềếệểễ]': 'e',
  r'[ìíịỉĩ]': 'i',
  r'[òóọỏõôồốộổỗơờớợởỡ]': 'o',
  r'[ùúụủũưừứựửữ]': 'u',
  r'[ỳýỵỷỹ]': 'y',
  r'[đ]': 'd',
};
