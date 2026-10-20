import 'package:flutter_test/flutter_test.dart';
import 'package:tailor_records/features/customers/data/customer.dart';

void main() {
  test('Customer measurements serialize and deserialize', () {
    final customer = Customer()..name = 'John Doe';

    expect(customer.measurements, isEmpty);

    customer.measurements = {
      "Men's Shirt": {
        'Collar': '15.5',
        'Chest': '42.0',
      }
    };

    expect(customer.measurementsJson, contains('15.5'));
    expect(customer.measurementsJson, contains('Chest'));

    final retrieved = customer.measurements;
    expect(retrieved["Men's Shirt"]?['Collar'], '15.5');
    expect(retrieved["Men's Shirt"]?['Chest'], '42.0');
  });
}
