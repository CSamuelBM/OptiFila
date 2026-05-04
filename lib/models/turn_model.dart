enum TurnStatus { active, completed, cancelled }

class TurnModel {
  final String     id;
  final int        number;
  final String     businessName;
  final String     businessType;
  final String     address;
  final DateTime   dateTime;
  final TurnStatus status;
  final int?       waitMinutes;

  const TurnModel({
    required this.id,
    required this.number,
    required this.businessName,
    required this.businessType,
    required this.address,
    required this.dateTime,
    required this.status,
    this.waitMinutes,
  });
}