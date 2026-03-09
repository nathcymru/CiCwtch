class DashboardData {
  const DashboardData({
    required this.clientsTotal,
    required this.dogsTotal,
    required this.walksTotal,
    required this.walksToday,
    required this.walksUpcoming,
    required this.walkersTotal,
    required this.invoicesTotal,
    required this.invoicesOutstanding,
  });

  final int clientsTotal;
  final int dogsTotal;
  final int walksTotal;
  final int walksToday;
  final int walksUpcoming;
  final int walkersTotal;
  final int invoicesTotal;
  final int invoicesOutstanding;

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final clients = json['clients'] as Map<String, dynamic>;
    final dogs = json['dogs'] as Map<String, dynamic>;
    final walks = json['walks'] as Map<String, dynamic>;
    final walkers = json['walkers'] as Map<String, dynamic>;
    final invoices = json['invoices'] as Map<String, dynamic>;

    return DashboardData(
      clientsTotal: clients['total'] as int,
      dogsTotal: dogs['total'] as int,
      walksTotal: walks['total'] as int,
      walksToday: walks['today'] as int,
      walksUpcoming: walks['upcoming'] as int,
      walkersTotal: walkers['total'] as int,
      invoicesTotal: invoices['total'] as int,
      invoicesOutstanding: invoices['outstanding'] as int,
    );
  }
}
