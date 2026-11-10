import 'package:flutter_test/flutter_test.dart';
import 'package:code_test/features/home/domain/models/home_models.dart';

void main() {
  group('ProductItem formatting tests', () {
    test('formats 3200 to 3,200 MMK', () {
      const item = ProductItem(
        id: '1',
        code: 'JD001',
        name: 'Donut',
        priceMmk: 3200,
        imageUrl: '',
        description: '',
        section: '',
      );
      expect(item.formattedPrice, equals('3,200 MMK'));
    });

    test('formats 12000 to 12,000 MMK', () {
      const item = ProductItem(
        id: '2',
        code: 'JD002',
        name: 'Box',
        priceMmk: 12000,
        imageUrl: '',
        description: '',
        section: '',
      );
      expect(item.formattedPrice, equals('12,000 MMK'));
    });

    test('formats 850 to 850 MMK', () {
      const item = ProductItem(
        id: '3',
        code: 'JD003',
        name: 'Single',
        priceMmk: 850,
        imageUrl: '',
        description: '',
        section: '',
      );
      expect(item.formattedPrice, equals('850 MMK'));
    });
  });
}
