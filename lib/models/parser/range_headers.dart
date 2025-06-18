class ContentRangeHeader {
  final int start;
  final int end;
  final int total;

  ContentRangeHeader(this.start, this.end, this.total);

  factory ContentRangeHeader.parse(String value) {
    if (value.isEmpty) {
      throw FormatException('Invalid Content-Range header: $value');
    }

    final parts = value.split(' ');
    if (parts.length != 2) {
      throw FormatException('Invalid Content-Range header: $value');
    }

    final rangeParts = parts[1].split('/');
    if (rangeParts.length != 2) {
      throw FormatException('Invalid Content-Range header: $value');
    }

    final range = rangeParts[0].split('-');
    if (range.length != 2) {
      throw FormatException('Invalid Content-Range header: $value');
    }

    return ContentRangeHeader(
      int.parse(range[0]),
      int.parse(range[1]),
      int.parse(rangeParts[1]),
    );
  }

  @override
  String toString() {
    return 'bytes $start-$end/$total';
  }
}

class RangeHeader {
  final int start;
  final int? end;

  RangeHeader(this.start, this.end);

  factory RangeHeader.parse(String value) {
    if (value.isEmpty) {
      return RangeHeader(0, null);
    }

    final parts = value.split('=');
    if (parts.length != 2) {
      throw FormatException('Invalid Range header: $value');
    }

    final ranges = parts[1].split('-');

    return RangeHeader(
      int.parse(ranges[0]),
      ranges.elementAtOrNull(1) != null && ranges[1].isNotEmpty
          ? int.parse(ranges[1])
          : null,
    );
  }

  @override
  String toString() {
    return 'bytes=$start-${end ?? ""}';
  }
}
