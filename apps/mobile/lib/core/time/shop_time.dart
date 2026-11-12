/// Damascus has kept UTC+3 all year since 2022 (FR-LOC-03), so the shop's
/// calendar date is the UTC time moved three hours.
const shopUtcOffset = Duration(hours: 3);

/// The shop's date for an instant, as YYYY-MM-DD.
String shopDateOf(DateTime instant) =>
    instant.toUtc().add(shopUtcOffset).toIso8601String().substring(0, 10);

/// Whole days from [from] to [to], both YYYY-MM-DD.
int daysBetween(String from, String to) =>
    DateTime.parse('${to}T00:00:00Z')
        .difference(DateTime.parse('${from}T00:00:00Z'))
        .inDays;
