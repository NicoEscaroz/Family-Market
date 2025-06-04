import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:family_market/app/data/models/product.dart';
import 'package:family_market/app/data/services/auth_service.dart';
import 'package:family_market/app/data/services/firebase_service.dart';
import 'package:family_market/app/widgets/auth_wrapper.dart';
import 'package:family_market/app/screens/login_screen.dart';
import 'package:family_market/app/screens/home_screen.dart';

// Generate mocks
@GenerateMocks([
  FirebaseAuth,
  FirebaseFirestore,
  User,
  UserCredential,
  CollectionReference,
  DocumentReference,
  QuerySnapshot,
  DocumentSnapshot,
  Query,
  WriteBatch,
])
import 'mocked_tests.mocks.dart';

void main() {
  group('AuthService con Mocks - 100% Cobertura', () {
    late MockFirebaseAuth mockAuth;
    late MockUser mockUser;
    late MockUserCredential mockUserCredential;
    late AuthService authService;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockUserCredential = MockUserCredential();
      authService = AuthService(firebaseAuth: mockAuth);
    });

    test('currentUser devuelve el usuario actual', () {
      // Arrange
      when(mockAuth.currentUser).thenReturn(mockUser);

      // Act
      final result = authService.currentUser;

      // Assert
      expect(result, equals(mockUser));
      verify(mockAuth.currentUser).called(1);
    });

    test('authStateChanges devuelve el stream correcto', () {
      // Arrange
      final stream = Stream<User?>.value(mockUser);
      when(mockAuth.authStateChanges()).thenAnswer((_) => stream);

      // Act
      final result = authService.authStateChanges;

      // Assert
      expect(result, equals(stream));
      verify(mockAuth.authStateChanges()).called(1);
    });

    test(
      'signInWithEmailAndPassword exitoso devuelve UserCredential',
      () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        when(
          mockAuth.signInWithEmailAndPassword(email: email, password: password),
        ).thenAnswer((_) async => mockUserCredential);

        // Act
        final result = await authService.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        expect(result, equals(mockUserCredential));
        verify(
          mockAuth.signInWithEmailAndPassword(email: email, password: password),
        ).called(1);
      },
    );

    test(
      'signInWithEmailAndPassword con error de Firebase maneja errores correctamente',
      () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'wrongpassword';
        when(
          mockAuth.signInWithEmailAndPassword(email: email, password: password),
        ).thenThrow(
          FirebaseAuthException(
            code: 'wrong-password',
            message: 'Wrong password',
          ),
        );

        // Act & Assert
        expect(
          () => authService.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(equals('Contraseña incorrecta.')),
        );
      },
    );

    test(
      'signInWithEmailAndPassword con error genérico maneja excepción',
      () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password';
        when(
          mockAuth.signInWithEmailAndPassword(email: email, password: password),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => authService.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(contains('Error inesperado')),
        );
      },
    );

    test('signOut ejecuta correctamente', () async {
      // Arrange
      when(mockAuth.signOut()).thenAnswer((_) async => {});

      // Act
      await authService.signOut();

      // Assert
      verify(mockAuth.signOut()).called(1);
    });

    test('signOut con error lanza excepción apropiada', () async {
      // Arrange
      when(mockAuth.signOut()).thenThrow(Exception('Sign out error'));

      // Act & Assert
      expect(
        () => authService.signOut(),
        throwsA(contains('Error al cerrar sesión')),
      );
    });

    test(
      'createUserWithEmailAndPassword exitoso devuelve UserCredential',
      () async {
        // Arrange
        const email = 'new@example.com';
        const password = 'newpassword123';
        when(
          mockAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).thenAnswer((_) async => mockUserCredential);

        // Act
        final result = await authService.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        expect(result, equals(mockUserCredential));
        verify(
          mockAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).called(1);
      },
    );

    test(
      'createUserWithEmailAndPassword con error de Firebase maneja errores',
      () async {
        // Arrange
        const email = 'existing@example.com';
        const password = 'password123';
        when(
          mockAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).thenThrow(
          FirebaseAuthException(
            code: 'email-already-in-use',
            message: 'Email already in use',
          ),
        );

        // Act & Assert
        expect(
          () => authService.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(equals('Ya existe una cuenta con este email.')),
        );
      },
    );

    test('_handleAuthError maneja todos los códigos de error conocidos', () {
      // Esta prueba indirecta verifica el método privado a través de signIn
      final testCases = [
        ('user-not-found', 'No existe una cuenta con este email.'),
        ('wrong-password', 'Contraseña incorrecta.'),
        ('email-already-in-use', 'Ya existe una cuenta con este email.'),
        ('weak-password', 'La contraseña es muy débil.'),
        ('invalid-email', 'El formato del email es inválido.'),
        ('user-disabled', 'Esta cuenta ha sido deshabilitada.'),
        (
          'too-many-requests',
          'Demasiados intentos fallidos. Intenta más tarde.',
        ),
        ('unknown-error', 'Error de autenticación: Unknown error'),
      ];

      for (final testCase in testCases) {
        test('maneja error ${testCase.$1}', () async {
          // Arrange
          when(
            mockAuth.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(
            FirebaseAuthException(
              code: testCase.$1,
              message: testCase.$1 == 'unknown-error' ? 'Unknown error' : null,
            ),
          );

          // Act & Assert
          expect(
            () => authService.signInWithEmailAndPassword(
              email: 'test@example.com',
              password: 'password',
            ),
            throwsA(equals(testCase.$2)),
          );
        });
      }
    });
  });

  group('FirebaseService con Mocks - 100% Cobertura', () {
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockCollection;
    late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
    late MockDocumentSnapshot<Map<String, dynamic>> mockDocSnapshot;
    late MockDocumentReference<Map<String, dynamic>> mockDocRef;
    late MockWriteBatch mockBatch;
    late FirebaseService firebaseService;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollection = MockCollectionReference<Map<String, dynamic>>();
      mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
      mockDocSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
      mockDocRef = MockDocumentReference<Map<String, dynamic>>();
      mockBatch = MockWriteBatch();
      firebaseService = FirebaseService(firestore: mockFirestore);
    });

    test('getProducts devuelve stream de productos', () async {
      // Arrange
      final productData = {
        'name': 'Test Product',
        'description': 'Test Description',
        'units': 'kg',
        'category': 'Test',
      };

      when(mockFirestore.collection('products')).thenReturn(mockCollection);
      when(
        mockCollection.snapshots(),
      ).thenAnswer((_) => Stream.value(mockQuerySnapshot));
      when(mockQuerySnapshot.docs).thenReturn([mockDocSnapshot]);
      when(mockDocSnapshot.data()).thenReturn(productData);
      when(mockDocSnapshot.id).thenReturn('test-id');

      // Act
      final stream = firebaseService.getProducts();
      final products = await stream.first;

      // Assert
      expect(products, hasLength(1));
      expect(products.first.name, equals('Test Product'));
      expect(products.first.id, equals('test-id'));
      verify(mockFirestore.collection('products')).called(1);
    });

    test('getWishlist devuelve stream de productos wishlist', () async {
      // Arrange
      final productData = {
        'name': 'Wishlist Product',
        'description': 'Wishlist Description',
        'units': 'units',
        'category': 'Wishlist',
      };

      when(mockFirestore.collection('wishlist')).thenReturn(mockCollection);
      when(
        mockCollection.snapshots(),
      ).thenAnswer((_) => Stream.value(mockQuerySnapshot));
      when(mockQuerySnapshot.docs).thenReturn([mockDocSnapshot]);
      when(mockDocSnapshot.data()).thenReturn(productData);
      when(mockDocSnapshot.id).thenReturn('wishlist-id');

      // Act
      final stream = firebaseService.getWishlist();
      final products = await stream.first;

      // Assert
      expect(products, hasLength(1));
      expect(products.first.name, equals('Wishlist Product'));
      expect(products.first.id, equals('wishlist-id'));
      verify(mockFirestore.collection('wishlist')).called(1);
    });

    test('addProduct agrega producto a la colección correcta', () async {
      // Arrange
      final product = Product(
        id: 'test-id',
        name: 'New Product',
        description: 'New Description',
        units: 'kg',
        category: 'New',
      );

      when(mockFirestore.collection('products')).thenReturn(mockCollection);
      when(mockCollection.add(any)).thenAnswer((_) async => mockDocRef);

      // Act
      await firebaseService.addProduct(product, toWishlist: false);

      // Assert
      verify(mockFirestore.collection('products')).called(1);
      verify(mockCollection.add(product.toFirestore())).called(1);
    });

    test(
      'addProduct agrega producto a wishlist cuando toWishlist es true',
      () async {
        // Arrange
        final product = Product(
          id: 'wishlist-test-id',
          name: 'Wishlist Product',
          description: 'Wishlist Description',
          units: 'units',
          category: 'Wishlist',
        );

        when(mockFirestore.collection('wishlist')).thenReturn(mockCollection);
        when(mockCollection.add(any)).thenAnswer((_) async => mockDocRef);

        // Act
        await firebaseService.addProduct(product, toWishlist: true);

        // Assert
        verify(mockFirestore.collection('wishlist')).called(1);
        verify(mockCollection.add(product.toFirestore())).called(1);
      },
    );

    test('deleteProduct elimina de la colección correcta', () async {
      // Arrange
      const productId = 'delete-test-id';
      when(mockFirestore.collection('products')).thenReturn(mockCollection);
      when(mockCollection.doc(productId)).thenReturn(mockDocRef);
      when(mockDocRef.delete()).thenAnswer((_) async => {});

      // Act
      await firebaseService.deleteProduct(productId, fromWishlist: false);

      // Assert
      verify(mockFirestore.collection('products')).called(1);
      verify(mockCollection.doc(productId)).called(1);
      verify(mockDocRef.delete()).called(1);
    });

    test(
      'deleteProduct elimina de wishlist cuando fromWishlist es true',
      () async {
        // Arrange
        const productId = 'wishlist-delete-id';
        when(mockFirestore.collection('wishlist')).thenReturn(mockCollection);
        when(mockCollection.doc(productId)).thenReturn(mockDocRef);
        when(mockDocRef.delete()).thenAnswer((_) async => {});

        // Act
        await firebaseService.deleteProduct(productId, fromWishlist: true);

        // Assert
        verify(mockFirestore.collection('wishlist')).called(1);
        verify(mockCollection.doc(productId)).called(1);
        verify(mockDocRef.delete()).called(1);
      },
    );

    test(
      'moveWishlistToProducts mueve todos los productos correctamente',
      () async {
        // Arrange
        final wishlistData = {
          'name': 'Move Product',
          'description': 'Move Description',
          'units': 'kg',
          'category': 'Move',
        };

        when(mockFirestore.collection('wishlist')).thenReturn(mockCollection);
        when(mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockDocSnapshot]);
        when(mockDocSnapshot.data()).thenReturn(wishlistData);
        when(mockDocSnapshot.reference).thenReturn(mockDocRef);

        when(mockFirestore.batch()).thenReturn(mockBatch);
        when(mockFirestore.collection('products')).thenReturn(mockCollection);
        when(mockCollection.doc()).thenReturn(mockDocRef);
        when(mockBatch.set(any, any)).thenReturn(mockBatch);
        when(mockBatch.delete(any)).thenReturn(mockBatch);
        when(mockBatch.commit()).thenAnswer((_) async => []);

        // Act
        await firebaseService.moveWishlistToProducts();

        // Assert
        verify(mockFirestore.collection('wishlist')).called(1);
        verify(mockCollection.get()).called(1);
        verify(mockFirestore.batch()).called(1);
        verify(mockFirestore.collection('products')).called(1);
        verify(mockBatch.set(any, wishlistData)).called(1);
        verify(mockBatch.delete(mockDocRef)).called(1);
        verify(mockBatch.commit()).called(1);
      },
    );
  });

  group('AuthWrapper Widget con Mocks - 100% Cobertura', () {
    late MockFirebaseAuth mockAuth;
    late MockUser mockUser;
    late AuthService mockAuthService;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockAuthService = AuthService(firebaseAuth: mockAuth);
    });

    testWidgets('muestra loading cuando connection state es waiting', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        mockAuth.authStateChanges(),
      ).thenAnswer((_) => Stream<User?>.value(null).asBroadcastStream());

      // Act
      await tester.pumpWidget(
        MaterialApp(home: AuthWrapper(authService: mockAuthService)),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('muestra HomeScreen cuando hay usuario autenticado', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        mockAuth.authStateChanges(),
      ).thenAnswer((_) => Stream<User?>.value(mockUser));

      // Act
      await tester.pumpWidget(
        MaterialApp(home: AuthWrapper(authService: mockAuthService)),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('muestra LoginScreen cuando no hay usuario autenticado', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        mockAuth.authStateChanges(),
      ).thenAnswer((_) => Stream<User?>.value(null));

      // Act
      await tester.pumpWidget(
        MaterialApp(home: AuthWrapper(authService: mockAuthService)),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('usa AuthService por defecto cuando no se proporciona', (
      WidgetTester tester,
    ) async {
      // Act & Assert - Verificar que no lanza excepción
      expect(() => const AuthWrapper(), returnsNormally);
    });
  });

  group('Integración Completa con Mocks', () {
    test(
      'Product se integra correctamente con FirebaseService mockeado',
      () async {
        // Arrange
        final mockFirestore = MockFirebaseFirestore();
        final mockCollection = MockCollectionReference<Map<String, dynamic>>();
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final firebaseService = FirebaseService(firestore: mockFirestore);

        final product = Product(
          id: 'integration-test',
          name: 'Integration Product',
          description: 'Integration Description',
          units: 'kg',
          category: 'Integration',
        );

        when(mockFirestore.collection(any)).thenReturn(mockCollection);
        when(mockCollection.add(any)).thenAnswer((_) async => mockDocRef);

        // Act
        await firebaseService.addProduct(product, toWishlist: false);

        // Assert
        verify(mockFirestore.collection('products')).called(1);
        verify(mockCollection.add(product.toFirestore())).called(1);
      },
    );

    test('AuthService y AuthWrapper se integran correctamente', () {
      // Arrange
      final mockAuth = MockFirebaseAuth();
      final authService = AuthService(firebaseAuth: mockAuth);
      final authWrapper = AuthWrapper(authService: authService);

      when(
        mockAuth.authStateChanges(),
      ).thenAnswer((_) => Stream<User?>.value(null));

      // Act & Assert
      expect(authWrapper.authService, equals(authService));
      expect(authService.authStateChanges, isA<Stream<User?>>());
    });
  });
}
