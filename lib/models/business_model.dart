class BusinessModel {
  final String id;
  final String name;
  final String category;
  final String address;
  final double rating;
  final int    queueCount;
  final int    waitMinutes;
  final bool   isOpen;

  const BusinessModel({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.rating,
    required this.queueCount,
    required this.waitMinutes,
    this.isOpen = true,
  });
}