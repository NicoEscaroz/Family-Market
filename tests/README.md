# Pruebas Unitarias - Family Market

Este directorio contiene las pruebas unitarias para el proyecto Family Market, una aplicación Flutter para gestión de mercado familiar.

## 📁 Estructura de Pruebas

```
tests/
├── README.md                 # Este archivo
├── unit_tests.dart          # Pruebas completas (incluye Firebase)
└── model_tests.dart         # Pruebas específicas del modelo Product
```

## 🧪 Tipos de Pruebas

### 1. Pruebas del Modelo Product (`model_tests.dart`)

**✅ Recomendado para ejecución regular**

Estas pruebas se ejecutan completamente sin dependencias externas y cubren:

- **Funcionalidad Core**: Creación de instancias, getters, setters
- **Conversión de Datos**: `toFirestore()`, `fromFirestore()`, `toMap()`, `fromMap()`
- **Null Safety**: Manejo de valores nulos y campos faltantes
- **Casos Edge**: Caracteres especiales, Unicode, emojis, texto muy largo
- **Integridad de Datos**: Simetría en conversiones, datos realistas

```bash
# Ejecutar solo las pruebas del modelo
flutter test tests/model_tests.dart
```

**Resultado esperado**: ✅ 16/16 pruebas pasando

### 2. Pruebas Completas (`unit_tests.dart`)

**⚠️ Requiere configuración de Firebase**

Incluye todas las pruebas del modelo más:

- **AuthService**: Autenticación de usuarios
- **FirebaseService**: Operaciones con Firestore
- **AuthWrapper Widget**: Testing de widgets
- **Pruebas de Integración**: Compatibilidad entre servicios

```bash
# Ejecutar todas las pruebas (algunas fallarán sin Firebase)
flutter test tests/unit_tests.dart
```

**Resultado esperado**: 
- ✅ 16/16 pruebas del modelo Product
- ❌ Algunas pruebas de Firebase (esperado sin configuración)

## 🚀 Cómo Ejecutar las Pruebas

### Opción 1: Pruebas Rápidas (Solo Modelo)
```bash
flutter test tests/model_tests.dart
```

### Opción 2: Todas las Pruebas
```bash
flutter test tests/unit_tests.dart
```

### Opción 3: Todas las Pruebas del Proyecto
```bash
flutter test
```

## 📊 Cobertura de Pruebas

### Modelo Product (100% cubierto)
- ✅ Constructor y propiedades
- ✅ Método `toFirestore()`
- ✅ Método `fromFirestore()`
- ✅ Método `toMap()`
- ✅ Método `fromMap()`
- ✅ Manejo de null safety
- ✅ Caracteres especiales y Unicode
- ✅ Casos extremos y edge cases
- ✅ Simetría en conversiones de datos

### AuthService (Parcialmente cubierto)
- ✅ Instanciación
- ✅ Propiedades públicas
- ✅ Métodos existentes
- ⚠️ Funcionalidad real (requiere Firebase)

### FirebaseService (Parcialmente cubierto)
- ✅ Instanciación  
- ✅ Tipos de retorno
- ✅ Parámetros de métodos
- ⚠️ Funcionalidad real (requiere Firebase)

### AuthWrapper Widget (Parcialmente cubierto)
- ✅ Tipo de widget
- ✅ Estructura básica
- ⚠️ Comportamiento completo (requiere Firebase)

## 🧪 Casos de Prueba Destacados

### 1. Manejo de Caracteres Especiales
```dart
// Prueba con caracteres especiales, acentos y símbolos
Product(
  name: 'Açaí & Granola (500g) - 100% Natural',
  description: 'Açaí con granola: ¡Delicioso y nutritivo!',
  // ...
)
```

### 2. Soporte Unicode y Emojis
```dart
// Prueba con múltiples idiomas y emojis
Product(
  id: '测试-тест-🧪-emoji',
  name: '🥑 Avocado Premium 中文 русский текст 🌟',
  // ...
)
```

### 3. Datos Realistas del Mercado
```dart
// Productos típicos de un mercado familiar
final familyProducts = [
  Product(name: 'Manzanas Rojas', category: 'Frutas'),
  Product(name: 'Leche Entera', category: 'Lácteos'),
  Product(name: 'Pan Integral', category: 'Panadería'),
  // ...
];
```

### 4. Simetría de Conversiones
```dart
// Verificación de que toFirestore() y fromFirestore() son simétricos
final original = Product(...);
final firestoreMap = original.toFirestore();
final recreated = Product.fromFirestore(firestoreMap, original.id);
expect(recreated.name, equals(original.name)); // ✅ Pasa
```

## 🔧 Configuración para Pruebas Completas

Si deseas ejecutar todas las pruebas incluyendo Firebase:

1. **Instalar dependencias de testing**:
   ```bash
   flutter pub get
   ```

2. **Dependencias incluidas en `pubspec.yaml`**:
   ```yaml
   dev_dependencies:
     flutter_test:
       sdk: flutter
     mockito: ^5.4.4
     build_runner: ^2.4.7
     fake_cloud_firestore: ^3.1.0
     firebase_auth_mocks: ^0.14.1
   ```

3. **Generar mocks** (opcional para pruebas avanzadas):
   ```bash
   dart run build_runner build
   ```

## 📈 Métricas de Calidad

### Pruebas del Modelo Product
- **16 pruebas** ejecutándose en ~1 segundo
- **0 fallos** en condiciones normales
- **Cobertura**: 100% de métodos públicos
- **Casos edge**: Valores nulos, strings vacíos, caracteres especiales
- **Rendimiento**: Pruebas con texto de hasta 5000 caracteres

### Beneficios de las Pruebas
- ✅ **Confiabilidad**: Detecta errores antes del despliegue
- ✅ **Refactoring seguro**: Cambios sin romper funcionalidad
- ✅ **Documentación**: Las pruebas actúan como especificación
- ✅ **Calidad**: Garantiza el comportamiento esperado
- ✅ **Mantenimiento**: Facilita futuras modificaciones

## 🐛 Resolución de Problemas

### Error: "No Firebase App has been created"
**Causa**: Las pruebas intentan usar Firebase sin inicialización.
**Solución**: Ejecutar solo `tests/model_tests.dart` para pruebas sin Firebase.

### Error: "Target of URI doesn't exist: '*.mocks.dart'"
**Causa**: Archivos de mock no generados.
**Solución**: Ejecutar `dart run build_runner build` o usar `model_tests.dart`.

### Error: Caracteres especiales en strings
**Causa**: Símbolos como `$` tienen significado especial en Dart.
**Solución**: Escapar con `\$` o usar comillas simples.
