# 📦 Family Market

**Family Market** es una aplicación móvil desarrollada con Flutter que permite a los usuarios de una familia gestionar los productos comprados y por comprar en el hogar. La aplicación utiliza Firebase Firestore como backend para almacenar la información en la nube y actualizar los datos en tiempo real.

---

## 🚀 Características

- ✅ Visualización de productos comprados.
- 🛒 Lista de productos por comprar (wishlist).
- ➕ Agregado de productos con nombre, descripción, categoría y unidades.
- 🧹 Eliminación de productos mediante deslizamiento (swipe).
- 🔁 Mover productos de la wishlist a la lista de comprados.
- ☁️ Sincronización en tiempo real con Firebase Firestore.

---

## 🧱 Estructura del Proyecto

```bash
lib/
│
├── app/
│   ├── data/
│   │   ├── models/         # Modelos de datos (Product)
│   │   ├── providers/      # Futuro manejo de estados
│   │   └── services/       # Servicios (FirebaseService)
│   ├── login/              # Autenticación (futura implementación)
│   ├── screens/            # Pantallas de la app (productos, wishlist, agregar)
│   └── widgets/            # Componentes reutilizables
│
└── main.dart               # Punto de entrada de la aplicación
