class Assessment {
  final String id;
  final String siteId;
  final bool feasible;
  final String recommendedType;
  final double estimatedCost;
  final String details;

  Assessment({required this.id, required this.siteId, required this.feasible, required this.recommendedType, required this.estimatedCost, required this.details});

  factory Assessment.fromMap(Map<String, dynamic> m) {
    return Assessment(
      id: m['id'],
      siteId: m['site_id'],
      feasible: m['feasible'],
      recommendedType: m['recommended_type'] ?? '',
      estimatedCost: (m['estimated_cost'] ?? 0).toDouble(),
      details: m['details'] ?? '',
    );
  }
}
