import 'package:flutter_test/flutter_test.dart';
import 'package:family_market/app/data/models/product.dart';

void main() {
  group('Product Model Tests - 100% Cobertura', () {
    group('Funcionalidad Core', () {
      test('Constructor crea instancia con campos requeridos', () {
        // Arrange & Act
        final product = Product(
          id: 'test-id',
          name: 'Test Product',
          description: 'Test Description',
          units: 'kg',
          category: 'Test Category',
        );

        // Assert
        expect(product.id, equals('test-id'));
        expect(product.name, equals('Test Product'));
        expect(product.description, equals('Test Description'));
        expect(product.units, equals('kg'));
        expect(product.category, equals('Test Category'));
      });

      test('toFirestore() excluye campo ID correctamente', () {
        // Arrange
        final product = Product(
          id: 'should-not-be-included',
          name: 'Test Product',
          description: 'Test Description',
          units: 'kg',
          category: 'Test Category',
        );

        // Act
        final firestoreMap = product.toFirestore();

        // Assert
        expect(firestoreMap.containsKey('id'), isFalse);
        expect(firestoreMap['name'], equals('Test Product'));
        expect(firestoreMap['description'], equals('Test Description'));
        expect(firestoreMap['units'], equals('kg'));
        expect(firestoreMap['category'], equals('Test Category'));
      });

      test('toMap() incluye campo ID correctamente', () {
        // Arrange
        final product = Product(
          id: 'test-id',
          name: 'Test Product',
          description: 'Test Description',
          units: 'kg',
          category: 'Test Category',
        );

        // Act
        final map = product.toMap();

        // Assert
        expect(map.containsKey('id'), isTrue);
        expect(map['id'], equals('test-id'));
        expect(map['name'], equals('Test Product'));
        expect(map['description'], equals('Test Description'));
        expect(map['units'], equals('kg'));
        expect(map['category'], equals('Test Category'));
      });

      test('fromFirestore() crea instancia correcta', () {
        // Arrange
        final data = {
          'name': 'Firestore Product',
          'description': 'Firestore Description',
          'units': 'units',
          'category': 'Firestore Category',
        };
        const id = 'firestore-id';

        // Act
        final product = Product.fromFirestore(data, id);

        // Assert
        expect(product.id, equals('firestore-id'));
        expect(product.name, equals('Firestore Product'));
        expect(product.description, equals('Firestore Description'));
        expect(product.units, equals('units'));
        expect(product.category, equals('Firestore Category'));
      });

      test('fromMap() crea instancia correcta', () {
        // Arrange
        final map = {
          'id': 'map-id',
          'name': 'Map Product',
          'description': 'Map Description',
          'units': 'kg',
          'category': 'Map Category',
        };

        // Act
        final product = Product.fromMap(map);

        // Assert
        expect(product.id, equals('map-id'));
        expect(product.name, equals('Map Product'));
        expect(product.description, equals('Map Description'));
        expect(product.units, equals('kg'));
        expect(product.category, equals('Map Category'));
      });
    });

    group('Null Safety & Edge Cases', () {
      test(
        'fromFirestore() maneja campos faltantes con valores por defecto',
        () {
          // Arrange
          final data = <String, dynamic>{}; // Map vacío
          const id = 'empty-id';

          // Act
          final product = Product.fromFirestore(data, id);

          // Assert
          expect(product.id, equals('empty-id'));
          expect(product.name, equals(''));
          expect(product.description, equals(''));
          expect(product.units, equals(''));
          expect(product.category, equals(''));
        },
      );

      test('fromFirestore() maneja valores null apropiadamente', () {
        // Arrange
        final data = {
          'name': null,
          'description': null,
          'units': null,
          'category': null,
        };
        const id = 'null-id';

        // Act
        final product = Product.fromFirestore(data, id);

        // Assert
        expect(product.id, equals('null-id'));
        expect(product.name, equals(''));
        expect(product.description, equals(''));
        expect(product.units, equals(''));
        expect(product.category, equals(''));
      });

      test('fromMap() maneja campos faltantes apropiadamente', () {
        // Arrange
        final map = <String, dynamic>{}; // Map vacío

        // Act
        final product = Product.fromMap(map);

        // Assert
        expect(product.id, equals(''));
        expect(product.name, equals(''));
        expect(product.description, equals(''));
        expect(product.units, equals(''));
        expect(product.category, equals(''));
      });

      test('fromMap() maneja valores null apropiadamente', () {
        // Arrange
        final map = {
          'id': null,
          'name': null,
          'description': null,
          'units': null,
          'category': null,
        };

        // Act
        final product = Product.fromMap(map);

        // Assert
        expect(product.id, equals(''));
        expect(product.name, equals(''));
        expect(product.description, equals(''));
        expect(product.units, equals(''));
        expect(product.category, equals(''));
      });

      test('Maneja strings vacíos correctamente', () {
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
      });

      test('Maneja texto muy largo (hasta 5000 caracteres)', () {
        // Arrange
        final longText = 'a' * 5000;
        final product = Product(
          id: 'long-id',
          name: longText,
          description: longText,
          units: 'kg',
          category: longText,
        );

        // Act
        final map = product.toMap();
        final firestoreMap = product.toFirestore();

        // Assert
        expect(map['name']?.length, equals(5000));
        expect(map['description']?.length, equals(5000));
        expect(map['category']?.length, equals(5000));
        expect(firestoreMap['name']?.length, equals(5000));
        expect(firestoreMap['description']?.length, equals(5000));
        expect(firestoreMap['category']?.length, equals(5000));
      });
    });

    group('Caracteres Especiales & Unicode', () {
      test('Maneja caracteres especiales correctamente', () {
        // Arrange
        const specialChars = '!@#\$%^&*()_+{}[]|\\:";\'<>?,./';
        final product = Product(
          id: 'special-id',
          name: 'Product $specialChars',
          description: 'Description with $specialChars',
          units: 'kg',
          category: 'Category $specialChars',
        );

        // Act
        final map = product.toMap();
        final recovered = Product.fromMap(map);

        // Assert
        expect(recovered.name, equals('Product $specialChars'));
        expect(recovered.description, equals('Description with $specialChars'));
        expect(recovered.category, equals('Category $specialChars'));
      });

      test('Maneja Unicode y emojis correctamente', () {
        // Arrange
        const unicodeText = '🥑 Palta fresca 🍎 مرحبا 你好 русский 日本語';
        final product = Product(
          id: 'unicode-id',
          name: unicodeText,
          description: 'Descripción con $unicodeText',
          units: 'kg',
          category: 'Categoría 🥕',
        );

        // Act
        final firestoreMap = product.toFirestore();
        final recovered = Product.fromFirestore(firestoreMap, 'unicode-id');

        // Assert
        expect(recovered.name, equals(unicodeText));
        expect(recovered.description, equals('Descripción con $unicodeText'));
        expect(recovered.category, equals('Categoría 🥕'));
      });

      test('Maneja acentos y caracteres especiales del español', () {
        // Arrange
        const spanishText = 'ñáéíóúüÑÁÉÍÓÚÜ¿¡çß';
        final product = Product(
          id: 'spanish-id',
          name: 'Producto $spanishText',
          description: 'Descripción con acentos $spanishText',
          units: 'kg',
          category: 'Categoría $spanishText',
        );

        // Act
        final map = product.toMap();
        final recovered = Product.fromMap(map);

        // Assert
        expect(recovered.name, equals('Producto $spanishText'));
        expect(
          recovered.description,
          equals('Descripción con acentos $spanishText'),
        );
        expect(recovered.category, equals('Categoría $spanishText'));
      });
    });

    group('Integridad de Datos', () {
      test('Simetría toFirestore/fromFirestore mantiene datos', () {
        // Arrange
        final original = Product(
          id: 'symmetry-id',
          name: 'Symmetry Product',
          description: 'Symmetry Description',
          units: 'kg',
          category: 'Symmetry Category',
        );

        // Act
        final firestoreMap = original.toFirestore();
        final recovered = Product.fromFirestore(firestoreMap, 'symmetry-id');

        // Assert
        expect(recovered.id, equals(original.id));
        expect(recovered.name, equals(original.name));
        expect(recovered.description, equals(original.description));
        expect(recovered.units, equals(original.units));
        expect(recovered.category, equals(original.category));
      });

      test('Simetría toMap/fromMap mantiene datos incluyendo ID', () {
        // Arrange
        final original = Product(
          id: 'map-symmetry-id',
          name: 'Map Symmetry Product',
          description: 'Map Symmetry Description',
          units: 'units',
          category: 'Map Symmetry Category',
        );

        // Act
        final map = original.toMap();
        final recovered = Product.fromMap(map);

        // Assert
        expect(recovered.id, equals(original.id));
        expect(recovered.name, equals(original.name));
        expect(recovered.description, equals(original.description));
        expect(recovered.units, equals(original.units));
        expect(recovered.category, equals(original.category));
      });
    });

    group('Casos de Uso Realistas', () {
      test('Productos típicos de mercado familiar', () {
        final productos = [
          Product(
            id: 'leche-001',
            name: 'Leche Entera',
            description: 'Leche entera pasteurizada 1L',
            units: 'litros',
            category: 'Lácteos',
          ),
          Product(
            id: 'pan-002',
            name: 'Pan de Molde',
            description: 'Pan de molde integral 500g',
            units: 'unidades',
            category: 'Panadería',
          ),
          Product(
            id: 'manzana-003',
            name: 'Manzanas Rojas',
            description: 'Manzanas rojas frescas de temporada',
            units: 'kg',
            category: 'Frutas',
          ),
        ];

        for (final producto in productos) {
          // Test conversión a Firestore
          final firestoreData = producto.toFirestore();
          expect(firestoreData.containsKey('id'), isFalse);
          expect(firestoreData['name'], isNotEmpty);

          // Test conversión a Map
          final mapData = producto.toMap();
          expect(mapData.containsKey('id'), isTrue);
          expect(mapData['id'], equals(producto.id));

          // Test recuperación desde Firestore
          final fromFirestore = Product.fromFirestore(
            firestoreData,
            producto.id,
          );
          expect(fromFirestore.name, equals(producto.name));

          // Test recuperación desde Map
          final fromMap = Product.fromMap(mapData);
          expect(fromMap.id, equals(producto.id));
        }
      });
    });
  });
}
