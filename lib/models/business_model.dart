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

  //FROM JSON (Backend → App)
  factory BusinessModel.fromJson(Map<String, dynamic> json){
    return BusinessModel(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        category: json['category'] ?? '',
        address: json['address'] ?? '',
        rating: json['rating'] ?? 0.0,
        queueCount: json['queue_count'],
        waitMinutes: json['wait_minutes'],
        isOpen: json['is_open'] ?? false,
    );
  }

  // TO JSON (App → Backend)
  Map<String, dynamic> toJson(){
    return{
      'id' : id,
      'name' : name,
      'category' : category,
      'address' : address,
      'rating' : rating,
      'queue_count' : queueCount,
      'wait_minutes' : waitMinutes,
      'is_open' : isOpen,
    };
  }
}