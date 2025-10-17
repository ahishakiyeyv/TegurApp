class TipModel {
  final String id;
  final String title; // e.g., "Road flooding on Main Street"
  final String location; // e.g., "Bujumbura"
  final String description; // long text from the form
  final String imageUrl; // public link (ImgBB / Cloud Storage)
  final String submittedBy; // e.g., "Community"
  final DateTime createdAt;

  const TipModel({
    required this.id,
    required this.title,
    required this.location,
    required this.description,
    required this.imageUrl,
    required this.submittedBy,
    required this.createdAt,
  });
}

/// Helper to format "2 Days Ago" etc.
String relativeTime(DateTime t) {
  final d = DateTime.now().difference(t);
  if (d.inDays >= 1) return '${d.inDays} Days Ago';
  if (d.inHours >= 1) return '${d.inHours} hours';
  if (d.inMinutes >= 1) return '${d.inMinutes} min';
  return 'just now';
}
