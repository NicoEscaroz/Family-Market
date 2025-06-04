import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:family_market/app/data/models/product.dart';
import 'package:family_market/app/data/services/auth_service.dart';
import 'package:family_market/app/data/services/firebase_service.dart';
import 'package:family_market/app/widgets/auth_wrapper.dart';

void main() {
  group('Product Model Tests', () {
    test('Product should create instance with required fields', () {
      // Arrange
      const id = 'test-id';
      const name = 'Test Product';
      const description = 'Test Description';
      const units = 'kg';
      const category = 'Food';

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

    test('Product.toFirestore should return correct map without id', () {
      // Arrange
      final product = Product(
        id: 'test-id',
        name: 'Test Product',
        description: 'Test Description',
        units: 'kg',
        category: 'Food',
      );

      // Act
      final result = product.toFirestore();

      // Assert
      expect(result, {
        'name': 'Test Product',
        'description': 'Test Description',
        'units': 'kg',
        'category': 'Food',
      });
      expect(result.containsKey('id'), isFalse);
    });

    test('Product.fromFirestore should create instance from map', () {
      // Arrange
      final map = {
        'name': 'Test Product',
        'description': 'Test Description',
        'units': 'kg',
        'category': 'Food',
      };
      const docId = 'test-doc-id';

      // Act
      final product = Product.fromFirestore(map, docId);

      // Assert
      expect(product.id, equals(docId));
      expect(product.name, equals('Test Product'));
      expect(product.description, equals('Test Description'));
      expect(product.units, equals('kg'));
      expect(product.category, equals('Food'));
    });

    test(
      'Product.fromFirestore should handle missing fields with defaults',
      () {
        // Arrange
        final map = <String, dynamic>{};
        const docId = 'test-doc-id';

        // Act
        final product = Product.fromFirestore(map, docId);

        // Assert
        expect(product.id, equals(docId));
        expect(product.name, equals(''));
        expect(product.description, equals(''));
        expect(product.units, equals(''));
        expect(product.category, equals(''));
      },
    );

    test('Product.toMap should return complete map with id', () {
      // Arrange
      final product = Product(
        id: 'test-id',
        name: 'Test Product',
        description: 'Test Description',
        units: 'kg',
        category: 'Food',
      );

      // Act
      final result = product.toMap();

      // Assert
      expect(result, {
        'id': 'test-id',
        'name': 'Test Product',
        'description': 'Test Description',
        'units': 'kg',
        'category': 'Food',
      });
    });

    test('Product.fromMap should create instance from map', () {
      // Arrange
      final map = {
        'name': 'Test Product',
        'description': 'Test Description',
        'units': 'kg',
        'category': 'Food',
      };
      const docId = 'test-doc-id';

      // Act
      final product = Product.fromMap(map, docId);

      // Assert
      expect(product.id, equals(docId));
      expect(product.name, equals('Test Product'));
      expect(product.description, equals('Test Description'));
      expect(product.units, equals('kg'));
      expect(product.category, equals('Food'));
    });

    test('Product.fromFirestore handles null values gracefully', () {
      // Arrange
      final mapWithNulls = <String, dynamic>{
        'name': null,
        'description': null,
        'units': null,
        'category': null,
      };

      // Act
      final product = Product.fromFirestore(mapWithNulls, 'test-id');

      // Assert
      expect(product.name, equals(''));
      expect(product.description, equals(''));
      expect(product.units, equals(''));
      expect(product.category, equals(''));
    });

    test('Product.fromMap handles null values gracefully', () {
      // Arrange
      final mapWithNulls = <String, dynamic>{
        'name': null,
        'description': null,
        'units': null,
        'category': null,
      };

      // Act
      final product = Product.fromMap(mapWithNulls, 'test-id');

      // Assert
      expect(product.name, equals(''));
      expect(product.description, equals(''));
      expect(product.units, equals(''));
      expect(product.category, equals(''));
    });
  });

  group('Product Data Validation Tests', () {
    test('Product should accept empty strings', () {
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

    test('Product should accept special characters', () {
      // Arrange & Act
      final product = Product(
        id: 'id-with-special-chars-123!@#',
        name: 'Açaí & Côco (500g)',
        description: 'Descripción con acentos: ñáéíóú',
        units: 'kg/m²',
        category: 'Categoría Especial',
      );

      // Assert
      expect(product.name, contains('Açaí'));
      expect(product.description, contains('ñáéíóú'));
      expect(product.units, contains('/'));
      expect(product.category, contains('Categoría'));
    });

    test('Product toFirestore and fromFirestore should be symmetric', () {
      // Arrange
      final originalProduct = Product(
        id: 'symmetry-test',
        name: 'Symmetry Test Product',
        description: 'Testing data symmetry',
        units: 'units',
        category: 'Test Category',
      );

      // Act
      final firestoreMap = originalProduct.toFirestore();
      final recreatedProduct = Product.fromFirestore(
        firestoreMap,
        originalProduct.id,
      );

      // Assert
      expect(recreatedProduct.id, equals(originalProduct.id));
      expect(recreatedProduct.name, equals(originalProduct.name));
      expect(recreatedProduct.description, equals(originalProduct.description));
      expect(recreatedProduct.units, equals(originalProduct.units));
      expect(recreatedProduct.category, equals(originalProduct.category));
    });

    test('Product toMap and fromMap should be symmetric', () {
      // Arrange
      final originalProduct = Product(
        id: 'map-symmetry-test',
        name: 'Map Symmetry Test Product',
        description: 'Testing map data symmetry',
        units: 'items',
        category: 'Map Test Category',
      );

      // Act
      final map = originalProduct.toMap();
      final recreatedProduct = Product.fromMap(map, originalProduct.id);

      // Assert
      expect(recreatedProduct.id, equals(originalProduct.id));
      expect(recreatedProduct.name, equals(originalProduct.name));
      expect(recreatedProduct.description, equals(originalProduct.description));
      expect(recreatedProduct.units, equals(originalProduct.units));
      expect(recreatedProduct.category, equals(originalProduct.category));
    });

    test('Product should handle long text values', () {
      // Arrange
      final longText = 'A' * 1000; // String de 1000 caracteres

      final product = Product(
        id: 'long-text-test',
        name: longText,
        description: longText,
        units: 'very-long-unit-name-that-could-cause-issues',
        category: longText,
      );

      // Act & Assert
      expect(product.name.length, equals(1000));
      expect(product.description.length, equals(1000));

      // Verificar que la conversión a Firestore funciona con texto largo
      final firestoreMap = product.toFirestore();
      expect(firestoreMap['name'].length, equals(1000));
      expect(firestoreMap['description'].length, equals(1000));
    });
  });

  group('AuthService Tests', () {
    test('AuthService should be instantiable', () {
      // Act
      final authService = AuthService();

      // Assert
      expect(authService, isA<AuthService>());
    });

    test('AuthService should expose currentUser property', () {
      // Arrange
      final authService = AuthService();

      // Act & Assert
      expect(authService.currentUser, isA<User?>());
    });

    test('AuthService should expose authStateChanges stream', () {
      // Arrange
      final authService = AuthService();

      // Act & Assert
      expect(authService.authStateChanges, isA<Stream<User?>>());
    });

    test('AuthService methods should be callable', () {
      // Arrange
      final authService = AuthService();

      // Assert - Verificar que los métodos existen y pueden ser llamados
      expect(() => authService.signOut(), returnsNormally);
      expect(
        () => authService.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
        returnsNormally,
      );
      expect(
        () => authService.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
        returnsNormally,
      );
    });
  });

  group('FirebaseService Tests', () {
    test('FirebaseService should be instantiable', () {
      // Act
      final firebaseService = FirebaseService();

      // Assert
      expect(firebaseService, isA<FirebaseService>());
    });

    test('FirebaseService methods should have correct return types', () {
      // Arrange
      final firebaseService = FirebaseService();

      // Act & Assert
      expect(firebaseService.getProducts(), isA<Stream<List<Product>>>());
      expect(firebaseService.getWishlist(), isA<Stream<List<Product>>>());
    });

    test('FirebaseService should accept Product objects correctly', () {
      // Arrange
      final firebaseService = FirebaseService();
      final product = Product(
        id: 'test-id',
        name: 'Test Product',
        description: 'Test Description',
        units: 'kg',
        category: 'Food',
      );

      // Act & Assert - Verificar que los métodos aceptan los parámetros correctos
      expect(
        () => firebaseService.addProduct(product, toWishlist: false),
        returnsNormally,
      );
      expect(
        () => firebaseService.addProduct(product, toWishlist: true),
        returnsNormally,
      );
      expect(
        () => firebaseService.deleteProduct('test-id', fromWishlist: false),
        returnsNormally,
      );
      expect(
        () => firebaseService.deleteProduct('test-id', fromWishlist: true),
        returnsNormally,
      );
      expect(() => firebaseService.moveWishlistToProducts(), returnsNormally);
    });
  });

  group('AuthWrapper Widget Tests', () {
    testWidgets('AuthWrapper should be a StatelessWidget', (
      WidgetTester tester,
    ) async {
      // Arrange
      const widget = AuthWrapper();

      // Assert
      expect(widget, isA<StatelessWidget>());
    });

    testWidgets('AuthWrapper should build without errors in test environment', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: AuthWrapper()));

      // Assert - Verificar que el widget se renderiza sin errores
      expect(find.byType(AuthWrapper), findsOneWidget);
    });

    testWidgets('AuthWrapper should contain a StreamBuilder', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: AuthWrapper()));

      // Assert
      expect(find.byType(StreamBuilder<User?>), findsOneWidget);
    });

    testWidgets('AuthWrapper should show loading indicator initially', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: AuthWrapper()));

      // Pump para procesar el primer frame
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('Integration Tests', () {
    test('Product model integrates correctly with service methods', () {
      // Arrange
      final product = Product(
        id: 'integration-test-id',
        name: 'Integration Test Product',
        description: 'Testing integration between components',
        units: 'pieces',
        category: 'Test',
      );
      final firebaseService = FirebaseService();

      // Act - Convertir producto a formato Firestore
      final firestoreMap = product.toFirestore();

      // Assert - Verificar integración
      expect(firestoreMap, isA<Map<String, dynamic>>());
      expect(firestoreMap.containsKey('name'), isTrue);
      expect(firestoreMap.containsKey('description'), isTrue);
      expect(firestoreMap.containsKey('units'), isTrue);
      expect(firestoreMap.containsKey('category'), isTrue);
      expect(
        firestoreMap.containsKey('id'),
        isFalse,
      ); // ID no debe estar en Firestore map

      // Verificar que el servicio puede trabajar con el producto
      expect(
        () => firebaseService.addProduct(product, toWishlist: false),
        returnsNormally,
      );

      // Verificar conversión simétrica
      final recreatedProduct = Product.fromFirestore(firestoreMap, product.id);
      expect(recreatedProduct.name, equals(product.name));
      expect(recreatedProduct.description, equals(product.description));
      expect(recreatedProduct.units, equals(product.units));
      expect(recreatedProduct.category, equals(product.category));
    });

    test('All services should be compatible with each other', () {
      // Arrange
      final authService = AuthService();
      final firebaseService = FirebaseService();

      // Assert - Verificar que los servicios son compatibles
      expect(authService, isA<AuthService>());
      expect(firebaseService, isA<FirebaseService>());

      // Verificar que AuthService expone los tipos correctos
      expect(authService.authStateChanges, isA<Stream<User?>>());
      expect(authService.currentUser, isA<User?>());

      // Verificar que FirebaseService trabaja con tipos de Product
      expect(firebaseService.getProducts(), isA<Stream<List<Product>>>());
      expect(firebaseService.getWishlist(), isA<Stream<List<Product>>>());
    });
  });

  group('Edge Cases and Error Handling', () {
    test('Product should handle extreme values gracefully', () {
      // Arrange & Act
      final productWithEmptyValues = Product(
        id: '',
        name: '',
        description: '',
        units: '',
        category: '',
      );

      final productWithSpecialChars = Product(
        id: '!@#\$%^&*()_+-=[]{}|;:,.<>?',
        name: '!@#\$%^&*()_+-=[]{}|;:,.<>?',
        description: 'Description with\nnewlines\tand\ttabs',
        units: '!!!',
        category: '???',
      );

      // Assert
      expect(productWithEmptyValues.toFirestore(), isA<Map<String, dynamic>>());
      expect(
        productWithSpecialChars.toFirestore(),
        isA<Map<String, dynamic>>(),
      );

      // Verificar que la conversión simétrica funciona con casos extremos
      final map1 = productWithEmptyValues.toFirestore();
      final recreated1 = Product.fromFirestore(map1, productWithEmptyValues.id);
      expect(recreated1.name, equals(productWithEmptyValues.name));

      final map2 = productWithSpecialChars.toFirestore();
      final recreated2 = Product.fromFirestore(
        map2,
        productWithSpecialChars.id,
      );
      expect(recreated2.name, equals(productWithSpecialChars.name));
    });

    test('Product should handle Unicode characters correctly', () {
      // Arrange
      final product = Product(
        id: '测试-тест-🧪',
        name: 'Prueba con 中文字符 и русский текст 🌟',
        description: 'Descripción con emojis 🥑🍎🥕 y acentos áéíóú',
        units: 'кг/м²',
        category: 'Categoría 测试',
      );

      // Act
      final firestoreMap = product.toFirestore();
      final mapResult = product.toMap();
      final recreated = Product.fromFirestore(firestoreMap, product.id);

      // Assert
      expect(recreated.name, equals(product.name));
      expect(recreated.description, equals(product.description));
      expect(recreated.units, equals(product.units));
      expect(recreated.category, equals(product.category));
      expect(mapResult['name'], contains('🌟'));
      expect(mapResult['description'], contains('🥑'));
    });
  });
}
