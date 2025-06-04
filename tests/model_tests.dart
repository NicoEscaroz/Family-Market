import 'package:flutter_test/flutter_test.dart';
import 'package:family_market/app/data/models/product.dart';

void main() {
  group('Product Model - Core Functionality', () {
    test('Product should create instance with all required fields', () {
      // Arrange
      const id = 'test-product-001';
      const name = 'Manzanas Rojas';
      const description = 'Manzanas rojas frescas de la región';
      const units = 'kg';
      const category = 'Frutas';

      // Act
      final product = Product(
        id: id,
        name: name,
        description: description,
        units: units,
        category: category,
      );

      // Assert
      expect(product.id, equals(id));
      expect(product.name, equals(name));
      expect(product.description, equals(description));
      expect(product.units, equals(units));
      expect(product.category, equals(category));
    });

    test('Product.toFirestore should exclude id field', () {
      // Arrange
      final product = Product(
        id: 'should-not-appear',
        name: 'Producto de Prueba',
        description: 'Descripción del producto',
        units: 'unidades',
        category: 'Categoría Test',
      );

      // Act
      final firestoreMap = product.toFirestore();

      // Assert
      expect(firestoreMap, isA<Map<String, dynamic>>());
      expect(firestoreMap.containsKey('id'), isFalse);
      expect(firestoreMap.containsKey('name'), isTrue);
      expect(firestoreMap.containsKey('description'), isTrue);
      expect(firestoreMap.containsKey('units'), isTrue);
      expect(firestoreMap.containsKey('category'), isTrue);

      expect(firestoreMap['name'], equals('Producto de Prueba'));
      expect(firestoreMap['description'], equals('Descripción del producto'));
      expect(firestoreMap['units'], equals('unidades'));
      expect(firestoreMap['category'], equals('Categoría Test'));
    });

    test('Product.toMap should include id field', () {
      // Arrange
      final product = Product(
        id: 'should-appear',
        name: 'Producto Completo',
        description: 'Descripción completa',
        units: 'kg',
        category: 'Categoria Completa',
      );

      // Act
      final map = product.toMap();

      // Assert
      expect(map, isA<Map<String, dynamic>>());
      expect(map.containsKey('id'), isTrue);
      expect(map.containsKey('name'), isTrue);
      expect(map.containsKey('description'), isTrue);
      expect(map.containsKey('units'), isTrue);
      expect(map.containsKey('category'), isTrue);

      expect(map['id'], equals('should-appear'));
      expect(map['name'], equals('Producto Completo'));
      expect(map['description'], equals('Descripción completa'));
      expect(map['units'], equals('kg'));
      expect(map['category'], equals('Categoria Completa'));
    });

    test('Product.fromFirestore should create instance correctly', () {
      // Arrange
      final firestoreData = {
        'name': 'Pan Integral',
        'description': 'Pan integral casero',
        'units': 'unidades',
        'category': 'Panadería',
      };
      const documentId = 'doc-123-abc';

      // Act
      final product = Product.fromFirestore(firestoreData, documentId);

      // Assert
      expect(product.id, equals(documentId));
      expect(product.name, equals('Pan Integral'));
      expect(product.description, equals('Pan integral casero'));
      expect(product.units, equals('unidades'));
      expect(product.category, equals('Panadería'));
    });

    test('Product.fromMap should create instance correctly', () {
      // Arrange
      final mapData = {
        'name': 'Leche Descremada',
        'description': 'Leche descremada 1 litro',
        'units': 'litros',
        'category': 'Lácteos',
      };
      const documentId = 'doc-456-def';

      // Act
      final product = Product.fromMap(mapData, documentId);

      // Assert
      expect(product.id, equals(documentId));
      expect(product.name, equals('Leche Descremada'));
      expect(product.description, equals('Leche descremada 1 litro'));
      expect(product.units, equals('litros'));
      expect(product.category, equals('Lácteos'));
    });
  });

  group('Product Model - Null Safety & Edge Cases', () {
    test('fromFirestore should handle missing fields gracefully', () {
      // Arrange
      final incompleteData = <String, dynamic>{};
      const documentId = 'incomplete-doc';

      // Act
      final product = Product.fromFirestore(incompleteData, documentId);

      // Assert
      expect(product.id, equals(documentId));
      expect(product.name, equals(''));
      expect(product.description, equals(''));
      expect(product.units, equals(''));
      expect(product.category, equals(''));
    });

    test('fromFirestore should handle null values correctly', () {
      // Arrange
      final dataWithNulls = {
        'name': null,
        'description': null,
        'units': null,
        'category': null,
      };
      const documentId = 'null-doc';

      // Act
      final product = Product.fromFirestore(dataWithNulls, documentId);

      // Assert
      expect(product.id, equals(documentId));
      expect(product.name, equals(''));
      expect(product.description, equals(''));
      expect(product.units, equals(''));
      expect(product.category, equals(''));
    });

    test('fromMap should handle missing fields gracefully', () {
      // Arrange
      final incompleteMap = <String, dynamic>{};
      const documentId = 'incomplete-map-doc';

      // Act
      final product = Product.fromMap(incompleteMap, documentId);

      // Assert
      expect(product.id, equals(documentId));
      expect(product.name, equals(''));
      expect(product.description, equals(''));
      expect(product.units, equals(''));
      expect(product.category, equals(''));
    });

    test('fromMap should handle null values correctly', () {
      // Arrange
      final mapWithNulls = {
        'name': null,
        'description': null,
        'units': null,
        'category': null,
      };
      const documentId = 'null-map-doc';

      // Act
      final product = Product.fromMap(mapWithNulls, documentId);

      // Assert
      expect(product.id, equals(documentId));
      expect(product.name, equals(''));
      expect(product.description, equals(''));
      expect(product.units, equals(''));
      expect(product.category, equals(''));
    });

    test('Product should handle empty string values', () {
      // Arrange & Act
      final product = Product(
        id: '',
        name: '',
        description: '',
        units: '',
        category: '',
      );

      // Assert
      expect(product.id, equals(''));
      expect(product.name, equals(''));
      expect(product.description, equals(''));
      expect(product.units, equals(''));
      expect(product.category, equals(''));

      // Verificar que las conversiones funcionan con valores vacíos
      final firestoreMap = product.toFirestore();
      final map = product.toMap();

      expect(firestoreMap['name'], equals(''));
      expect(map['name'], equals(''));
    });
  });

  group('Product Model - Special Characters & Unicode', () {
    test('Product should handle special characters correctly', () {
      // Arrange & Act
      final product = Product(
        id: 'special-chars-123!@#\$%^&*()',
        name: 'Açaí & Granola (500g) - 100% Natural',
        description:
            'Açaí con granola: ¡Delicioso y nutritivo! Contiene: açaí, granola, miel & frutas.',
        units: 'gr/porción',
        category: 'Superalimentos & Snacks',
      );

      // Assert
      expect(product.name, contains('Açaí'));
      expect(product.name, contains('&'));
      expect(product.name, contains('('));
      expect(product.name, contains(')'));
      expect(product.description, contains('¡'));
      expect(product.description, contains('&'));
      expect(product.units, contains('/'));
      expect(product.category, contains('&'));

      // Verificar que las conversiones preservan los caracteres especiales
      final firestoreMap = product.toFirestore();
      final map = product.toMap();

      expect(firestoreMap['name'], equals(product.name));
      expect(map['name'], equals(product.name));
    });

    test(
      'Product should handle Unicode characters (emojis, diferentes idiomas)',
      () {
        // Arrange & Act
        final product = Product(
          id: '测试-тест-🧪-emoji',
          name: '🥑 Avocado Premium 中文 русский текст 🌟',
          description:
              'Descripción con emojis 🥑🍎🥕 y caracteres especiales: ñáéíóú çüß',
          units: 'кг/м² 单位',
          category: 'Categoría Internacional 🌍',
        );

        // Assert
        expect(product.id, contains('测试'));
        expect(product.id, contains('тест'));
        expect(product.id, contains('🧪'));
        expect(product.name, contains('🥑'));
        expect(product.name, contains('中文'));
        expect(product.name, contains('русский'));
        expect(product.name, contains('🌟'));
        expect(product.description, contains('🥑'));
        expect(product.description, contains('ñáéíóú'));
        expect(product.description, contains('çüß'));
        expect(product.units, contains('кг'));
        expect(product.units, contains('单位'));
        expect(product.category, contains('🌍'));

        // Verificar conversiones con Unicode
        final firestoreMap = product.toFirestore();
        final map = product.toMap();
        final recreated = Product.fromFirestore(firestoreMap, product.id);

        expect(firestoreMap['name'], equals(product.name));
        expect(map['name'], equals(product.name));
        expect(recreated.name, equals(product.name));
        expect(recreated.description, equals(product.description));
      },
    );

    test('Product should handle very long text values', () {
      // Arrange
      final longText = 'A' * 1000; // 1000 caracteres
      final veryLongText = 'B' * 5000; // 5000 caracteres

      final product = Product(
        id: 'long-text-test',
        name: longText,
        description: veryLongText,
        units: 'unidad-con-nombre-muy-largo-que-podria-causar-problemas',
        category: longText,
      );

      // Act & Assert
      expect(product.name.length, equals(1000));
      expect(product.description.length, equals(5000));
      expect(product.units.length, greaterThan(20));
      expect(product.category.length, equals(1000));

      // Verificar que las conversiones funcionan con texto largo
      final firestoreMap = product.toFirestore();
      final map = product.toMap();

      expect(firestoreMap['name'].length, equals(1000));
      expect(firestoreMap['description'].length, equals(5000));
      expect(map['name'].length, equals(1000));
      expect(map['description'].length, equals(5000));

      // Verificar conversión simétrica con texto largo
      final recreated = Product.fromFirestore(firestoreMap, product.id);
      expect(recreated.name, equals(product.name));
      expect(recreated.description, equals(product.description));
    });
  });

  group('Product Model - Data Integrity & Symmetry', () {
    test('toFirestore and fromFirestore should be perfectly symmetric', () {
      // Arrange
      final originalProducts = [
        Product(
          id: 'symmetry-test-1',
          name: 'Producto Simétrico 1',
          description: 'Test de simetría en conversión',
          units: 'unidades',
          category: 'Test',
        ),
        Product(
          id: 'symmetry-test-2',
          name: '',
          description: '',
          units: '',
          category: '',
        ),
        Product(
          id: 'symmetry-test-3',
          name: 'Açaí & Granola 🥑',
          description: 'Descripción con ñáéíóú y 中文',
          units: 'кг/м²',
          category: 'Categoría Especial',
        ),
      ];

      for (final original in originalProducts) {
        // Act
        final firestoreMap = original.toFirestore();
        final recreated = Product.fromFirestore(firestoreMap, original.id);

        // Assert
        expect(recreated.id, equals(original.id));
        expect(recreated.name, equals(original.name));
        expect(recreated.description, equals(original.description));
        expect(recreated.units, equals(original.units));
        expect(recreated.category, equals(original.category));
      }
    });

    test('toMap and fromMap should be perfectly symmetric', () {
      // Arrange
      final originalProducts = [
        Product(
          id: 'map-symmetry-1',
          name: 'Producto Map 1',
          description: 'Test de simetría para maps',
          units: 'litros',
          category: 'Map Test',
        ),
        Product(
          id: 'map-symmetry-2',
          name: 'Special chars: !@#\$%^&*()',
          description: 'Description with\nnewlines\tand\ttabs',
          units: 'special/units',
          category: 'Special Category',
        ),
      ];

      for (final original in originalProducts) {
        // Act
        final map = original.toMap();
        final recreated = Product.fromMap(map, original.id);

        // Assert
        expect(recreated.id, equals(original.id));
        expect(recreated.name, equals(original.name));
        expect(recreated.description, equals(original.description));
        expect(recreated.units, equals(original.units));
        expect(recreated.category, equals(original.category));
      }
    });

    test(
      'All Product methods should work with realistic family market data',
      () {
        // Arrange - Datos realistas para un mercado familiar
        final familyProducts = [
          Product(
            id: 'prod-001',
            name: 'Manzanas Rojas',
            description: 'Manzanas rojas frescas de temporada',
            units: 'kg',
            category: 'Frutas',
          ),
          Product(
            id: 'prod-002',
            name: 'Leche Entera',
            description: 'Leche entera pasteurizada 1 litro',
            units: 'litros',
            category: 'Lácteos',
          ),
          Product(
            id: 'prod-003',
            name: 'Pan Integral',
            description: 'Pan integral con semillas',
            units: 'unidades',
            category: 'Panadería',
          ),
          Product(
            id: 'prod-004',
            name: 'Arroz Blanco',
            description: 'Arroz blanco grano largo 1kg',
            units: 'kg',
            category: 'Granos y Cereales',
          ),
          Product(
            id: 'prod-005',
            name: 'Aceite de Oliva',
            description: 'Aceite de oliva extra virgen 500ml',
            units: 'ml',
            category: 'Aceites y Condimentos',
          ),
        ];

        // Act & Assert
        for (final product in familyProducts) {
          // Verificar que todos los campos están correctamente asignados
          expect(product.id, isNotEmpty);
          expect(product.name, isNotEmpty);
          expect(product.description, isNotEmpty);
          expect(product.units, isNotEmpty);
          expect(product.category, isNotEmpty);

          // Verificar conversiones
          final firestoreMap = product.toFirestore();
          final map = product.toMap();

          expect(firestoreMap, isA<Map<String, dynamic>>());
          expect(map, isA<Map<String, dynamic>>());

          // Verificar que Firestore map no contiene ID
          expect(firestoreMap.containsKey('id'), isFalse);

          // Verificar que map completo contiene ID
          expect(map.containsKey('id'), isTrue);
          expect(map['id'], equals(product.id));

          // Verificar simetría
          final fromFirestore = Product.fromFirestore(firestoreMap, product.id);
          final fromMap = Product.fromMap(map, product.id);

          expect(fromFirestore.name, equals(product.name));
          expect(fromMap.name, equals(product.name));
        }
      },
    );
  });
}
