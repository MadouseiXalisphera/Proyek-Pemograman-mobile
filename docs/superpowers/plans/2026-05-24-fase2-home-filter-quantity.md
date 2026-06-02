# Fase 2 — Home + Filter & Quantity-on-Card Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Bangun halaman Home lengkap dengan model MenuItem, MenuService, CartController (quantity-on-card), filter & sort via bottom sheet, dan footer navigasi 4 tab.

**Architecture:** GetX layered — Service (data) → Controller (state + logic) → View (UI only). CartController di-put permanent di main.dart agar quantity state persists lintas halaman. FilterSheet pakai StatefulWidget local state karena hanya temporary sampai user tap Terapkan.

**Tech Stack:** Flutter, GetX (`get ^4.6.6`), `google_fonts`, `shared_preferences`, AppColors dari `app_colors.dart`

---

## File Map

| Status | File | Tanggung Jawab |
|--------|------|----------------|
| CREATE | `lib/app/data/models/menu_item_model.dart` | Model MenuItem + getter hargaFormatted |
| CREATE | `lib/app/data/models/cart_item_model.dart` | Model CartItem + getter subtotal |
| MODIFY | `lib/app/data/dummy_data.dart` | Tambah 8 item menu dummy |
| CREATE | `lib/app/data/services/menu_service.dart` | CRUD menu pakai loop manual |
| CREATE | `lib/app/modules/cart/cart_controller.dart` | State keranjang + increment/decrement |
| CREATE | `lib/app/modules/cart/cart_binding.dart` | Binding boilerplate |
| CREATE | `lib/app/modules/cart/cart_view.dart` | Placeholder "Fase 4" |
| CREATE | `lib/app/modules/detail/detail_binding.dart` | Placeholder binding |
| CREATE | `lib/app/modules/detail/detail_view.dart` | Placeholder "Fase 3" |
| MODIFY | `lib/app/modules/home/home_controller.dart` | Extended: menu load, search, filter, sort |
| CREATE | `lib/app/core/widgets/quantity_control.dart` | Widget kontrol qty kompak (dipakai 2 kartu) |
| CREATE | `lib/app/core/widgets/top_pick_card.dart` | Kartu 170×300 horizontal scroll |
| CREATE | `lib/app/core/widgets/menu_list_card.dart` | Kartu 364×127 vertical list |
| CREATE | `lib/app/modules/home/widgets/filter_sheet.dart` | Bottom sheet filter & sort |
| MODIFY | `lib/app/modules/home/home_view.dart` | Full HomeView + FooterNav |
| MODIFY | `lib/app/routes/app_pages.dart` | Daftarkan /cart dan /detail |
| MODIFY | `lib/main.dart` | Register MenuService + CartController |

---

## Task 1: Model MenuItem & CartItem

**Files:**
- Create: `lib/app/data/models/menu_item_model.dart`
- Create: `lib/app/data/models/cart_item_model.dart`

- [ ] **Step 1.1 — Buat MenuItem model**

```dart
// lib/app/data/models/menu_item_model.dart
class MenuItem {
  final String id;
  final String nama;
  final String deskripsi;
  final int harga;
  final String kategori; // 'food' | 'drink'
  final String? fotoPath;
  final bool isTopPick;

  const MenuItem({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.kategori,
    this.fotoPath,
    this.isTopPick = false,
  });

  String get hargaFormatted {
    if (harga % 1000 == 0) return '${harga ~/ 1000}K';
    // format titik ribuan manual tanpa package
    final str = harga.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      count++;
    }
    return buffer.toString().split('').reversed.join();
  }
}
```

- [ ] **Step 1.2 — Buat CartItem model**

```dart
// lib/app/data/models/cart_item_model.dart
import 'menu_item_model.dart';

class CartItem {
  final MenuItem menuItem;
  int quantity;
  String catatan;

  CartItem({
    required this.menuItem,
    required this.quantity,
    this.catatan = '',
  });

  int get subtotal => menuItem.harga * quantity;
}
```

- [ ] **Step 1.3 — Verifikasi**

```
flutter analyze lib/app/data/models/
```
Expected: No issues found.

---

## Task 2: Dummy Menu Data

**Files:**
- Modify: `lib/app/data/dummy_data.dart`

- [ ] **Step 2.1 — Tambah import dan list menu ke DummyData**

Buka `lib/app/data/dummy_data.dart`. Tambahkan import di atas dan field `menu` di dalam class:

```dart
// lib/app/data/dummy_data.dart
import 'models/menu_item_model.dart';

class DummyData {
  DummyData._();

  // ... (users list yang sudah ada, jangan dihapus)

  static final List<MenuItem> menu = [
    MenuItem(
      id: 'kopi_hitam',
      nama: 'Kopi Hitam',
      deskripsi: 'Kopi arabica pilihan, diseduh dengan metode pour over',
      harga: 18000,
      kategori: 'drink',
      isTopPick: true,
    ),
    MenuItem(
      id: 'matcha_latte',
      nama: 'Matcha Latte',
      deskripsi: 'Matcha premium Jepang dicampur susu segar hangat atau dingin',
      harga: 28000,
      kategori: 'drink',
      isTopPick: true,
    ),
    MenuItem(
      id: 'lemon_tea',
      nama: 'Lemon Tea',
      deskripsi: 'Teh dengan perasan lemon segar, manis dan asam yang seimbang',
      harga: 15000,
      kategori: 'drink',
      isTopPick: true,
    ),
    MenuItem(
      id: 'es_teh_manis',
      nama: 'Es Teh Manis',
      deskripsi: 'Teh manis segar dengan es batu, cocok untuk cuaca panas',
      harga: 8000,
      kategori: 'drink',
    ),
    MenuItem(
      id: 'nasi_goreng',
      nama: 'Nasi Goreng',
      deskripsi: 'Nasi goreng bumbu spesial cafe, dilengkapi telur dan kerupuk',
      harga: 35000,
      kategori: 'food',
      isTopPick: true,
    ),
    MenuItem(
      id: 'roti_bakar',
      nama: 'Roti Bakar',
      deskripsi: 'Roti tawar panggang dengan pilihan topping selai atau mentega',
      harga: 22000,
      kategori: 'food',
    ),
    MenuItem(
      id: 'pisang_goreng',
      nama: 'Pisang Goreng',
      deskripsi: 'Pisang kepok goreng crispy, disajikan dengan keju atau coklat',
      harga: 18000,
      kategori: 'food',
    ),
    MenuItem(
      id: 'mie_goreng',
      nama: 'Mie Goreng',
      deskripsi: 'Mie goreng dengan bumbu khas, sayuran segar, dan telur ceplok',
      harga: 32000,
      kategori: 'food',
    ),
  ];
}
```

- [ ] **Step 2.2 — Verifikasi**

```
flutter analyze lib/app/data/dummy_data.dart
```
Expected: No issues found.

---

## Task 3: MenuService

**Files:**
- Create: `lib/app/data/services/menu_service.dart`

- [ ] **Step 3.1 — Buat MenuService**

```dart
// lib/app/data/services/menu_service.dart
import '../dummy_data.dart';
import '../models/menu_item_model.dart';

class MenuService {
  List<MenuItem> getAllMenu() {
    return DummyData.menu;
  }

  List<MenuItem> getTopPicks() {
    final result = <MenuItem>[];
    for (int i = 0; i < DummyData.menu.length; i++) {
      if (DummyData.menu[i].isTopPick) {
        result.add(DummyData.menu[i]);
      }
    }
    return result;
  }

  MenuItem? getById(String id) {
    for (int i = 0; i < DummyData.menu.length; i++) {
      if (DummyData.menu[i].id == id) return DummyData.menu[i];
    }
    return null;
  }

  List<MenuItem> search(String query) {
    final q = query.toLowerCase();
    final result = <MenuItem>[];
    for (int i = 0; i < DummyData.menu.length; i++) {
      if (DummyData.menu[i].nama.toLowerCase().contains(q)) {
        result.add(DummyData.menu[i]);
      }
    }
    return result;
  }
}
```

- [ ] **Step 3.2 — Register MenuService di main.dart**

Buka `lib/main.dart`. Di dalam `main()`, setelah `Get.put<AuthService>(...)`, tambahkan:

```dart
// Tambah import di atas:
import 'app/data/services/menu_service.dart';

// Di dalam main(), setelah Get.put<AuthService>(...):
Get.put<MenuService>(MenuService(), permanent: true);
```

- [ ] **Step 3.3 — Verifikasi**

```
flutter analyze lib/app/data/services/menu_service.dart lib/main.dart
```
Expected: No issues found.

---

## Task 4: CartController + CartBinding + Registrasi

**Files:**
- Create: `lib/app/modules/cart/cart_controller.dart`
- Create: `lib/app/modules/cart/cart_binding.dart`
- Modify: `lib/main.dart`

- [ ] **Step 4.1 — Buat CartController**

```dart
// lib/app/modules/cart/cart_controller.dart
import 'package:get/get.dart';

import '../../data/models/cart_item_model.dart';
import '../../data/models/menu_item_model.dart';

class CartController extends GetxController {
  final RxList<CartItem> items = <CartItem>[].obs;

  int getQuantity(String menuId) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].menuItem.id == menuId) return items[i].quantity;
    }
    return 0;
  }

  void increment(String menuId, MenuItem item) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].menuItem.id == menuId) {
        items[i].quantity++;
        items.refresh();
        return;
      }
    }
    items.add(CartItem(menuItem: item, quantity: 1, catatan: ''));
    items.refresh();
  }

  void decrement(String menuId) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].menuItem.id == menuId) {
        if (items[i].quantity > 1) {
          items[i].quantity--;
          items.refresh();
        } else {
          items.removeAt(i);
          items.refresh();
        }
        return;
      }
    }
  }

  void addItem(MenuItem item) {
    increment(item.id, item);
  }

  void clearCart() {
    items.clear();
  }
}
```

- [ ] **Step 4.2 — Buat CartBinding**

```dart
// lib/app/modules/cart/cart_binding.dart
import 'package:get/get.dart';

// CartController sudah permanent di main.dart.
// Binding ini ada untuk konsistensi pola modul GetX.
class CartBinding extends Bindings {
  @override
  void dependencies() {}
}
```

- [ ] **Step 4.3 — Register CartController di main.dart**

Tambahkan setelah `Get.put<MenuService>(...)`:

```dart
// Tambah import:
import 'app/modules/cart/cart_controller.dart';

// Di dalam main(), setelah Get.put<MenuService>(...):
Get.put<CartController>(CartController(), permanent: true);
```

- [ ] **Step 4.4 — Verifikasi**

```
flutter analyze lib/app/modules/cart/ lib/main.dart
```
Expected: No issues found.

---

## Task 5: Placeholder CartView & DetailView

**Files:**
- Create: `lib/app/modules/cart/cart_view.dart`
- Create: `lib/app/modules/detail/detail_binding.dart`
- Create: `lib/app/modules/detail/detail_view.dart`

- [ ] **Step 5.1 — Buat CartView placeholder**

```dart
// lib/app/modules/cart/cart_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('Keranjang'),
      ),
      body: const Center(
        child: Text(
          'Halaman Cart — Fase 4',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
```

- [ ] **Step 5.2 — Buat DetailBinding placeholder**

```dart
// lib/app/modules/detail/detail_binding.dart
import 'package:get/get.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {}
}
```

- [ ] **Step 5.3 — Buat DetailView placeholder**

```dart
// lib/app/modules/detail/detail_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: const Center(
        child: Text(
          'Halaman Detail — Fase 3',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
```

- [ ] **Step 5.4 — Verifikasi**

```
flutter analyze lib/app/modules/cart/cart_view.dart lib/app/modules/detail/
```
Expected: No issues found.

---

## Task 6: HomeController Extended

**Files:**
- Modify: `lib/app/modules/home/home_controller.dart`

- [ ] **Step 6.1 — Timpa home_controller.dart dengan versi extended**

```dart
// lib/app/modules/home/home_controller.dart
import 'package:get/get.dart';

import '../../data/models/menu_item_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/menu_service.dart';
import '../../routes/app_routes.dart';

class HomeController extends GetxController {
  // 1. Dependencies
  final AuthService _auth = Get.find<AuthService>();
  final MenuService _menuService = Get.find<MenuService>();

  // 2. State observable
  final RxList<MenuItem> topPicks = <MenuItem>[].obs;
  final RxList<MenuItem> allMenu = <MenuItem>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString kategori = 'all'.obs; // 'all' | 'food' | 'drink'
  final RxString sortBy = 'default'.obs; // 'default' | 'price_asc' | 'price_desc' | 'name_asc'

  // 3. Getter dari AuthService
  String get username => _auth.currentUser?.username ?? '-';
  String get namaMeja => _auth.currentUser?.namaMeja ?? '-';

  // 4. Getter filteredMenu — 4 step manual
  List<MenuItem> get filteredMenu {
    // Step 1: filter kategori
    final List<MenuItem> afterKategori = <MenuItem>[];
    for (int i = 0; i < allMenu.length; i++) {
      if (kategori.value == 'all' || allMenu[i].kategori == kategori.value) {
        afterKategori.add(allMenu[i]);
      }
    }

    // Step 2: filter searchQuery
    final q = searchQuery.value.toLowerCase();
    final List<MenuItem> afterSearch = <MenuItem>[];
    for (int i = 0; i < afterKategori.length; i++) {
      if (q.isEmpty || afterKategori[i].nama.toLowerCase().contains(q)) {
        afterSearch.add(afterKategori[i]);
      }
    }

    // Step 3: sort
    if (sortBy.value != 'default') {
      afterSearch.sort((a, b) {
        if (sortBy.value == 'price_asc') return a.harga.compareTo(b.harga);
        if (sortBy.value == 'price_desc') return b.harga.compareTo(a.harga);
        if (sortBy.value == 'name_asc') return a.nama.compareTo(b.nama);
        return 0;
      });
    }

    return afterSearch;
  }

  // 5. Lifecycle
  @override
  void onInit() {
    super.onInit();
    topPicks.assignAll(_menuService.getTopPicks());
    allMenu.assignAll(_menuService.getAllMenu());
  }

  // 6. Methods
  void applyFilter(String kategoriBaru, String sortByBaru) {
    kategori.value = kategoriBaru;
    sortBy.value = sortByBaru;
  }

  void resetFilter() {
    kategori.value = 'all';
    sortBy.value = 'default';
  }

  Future<void> logout() async {
    await _auth.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
```

- [ ] **Step 6.2 — Verifikasi**

```
flutter analyze lib/app/modules/home/home_controller.dart
```
Expected: No issues found.

---

## Task 7: QuantityControl Widget (shared)

**Files:**
- Create: `lib/app/core/widgets/quantity_control.dart`

Widget compact dipakai di dalam TopPickCard dan MenuListCard.

- [ ] **Step 7.1 — Buat QuantityControl**

```dart
// lib/app/core/widgets/quantity_control.dart
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class QuantityControl extends StatelessWidget {
  final int qty;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const QuantityControl({
    super.key,
    required this.qty,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onMinus,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.remove, color: Colors.white, size: 18),
            ),
          ),
          Text(
            '${qty}x',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          GestureDetector(
            onTap: onPlus,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.add, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 7.2 — Verifikasi**

```
flutter analyze lib/app/core/widgets/quantity_control.dart
```
Expected: No issues found.

---

## Task 8: TopPickCard & MenuListCard

**Files:**
- Create: `lib/app/core/widgets/top_pick_card.dart`
- Create: `lib/app/core/widgets/menu_list_card.dart`

- [ ] **Step 8.1 — Buat TopPickCard**

```dart
// lib/app/core/widgets/top_pick_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/menu_item_model.dart';
import '../../modules/cart/cart_controller.dart';
import '../theme/app_colors.dart';
import 'quantity_control.dart';

class TopPickCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback? onTap;

  const TopPickCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final CartController cart = Get.find<CartController>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        height: 300,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Area gambar atas
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: item.fotoPath != null
                  ? Image.asset(
                      item.fotoPath!,
                      width: 170,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 170,
                      height: 200,
                      color: AppColors.imagePlaceholder,
                    ),
            ),
            // Konten bawah
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.deskripsi,
                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.hargaFormatted,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Obx(() {
                          final qty = cart.getQuantity(item.id);
                          if (qty == 0) {
                            return GestureDetector(
                              onTap: () => cart.increment(item.id, item),
                              child: const Icon(
                                Icons.add_circle_outline,
                                size: 30,
                                color: AppColors.primary,
                              ),
                            );
                          }
                          return QuantityControl(
                            qty: qty,
                            onMinus: () => cart.decrement(item.id),
                            onPlus: () => cart.increment(item.id, item),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 8.2 — Buat MenuListCard**

```dart
// lib/app/core/widgets/menu_list_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/menu_item_model.dart';
import '../../modules/cart/cart_controller.dart';
import '../theme/app_colors.dart';
import 'quantity_control.dart';

class MenuListCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback? onTap;

  const MenuListCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final CartController cart = Get.find<CartController>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 127,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // Gambar kiri
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
              child: item.fotoPath != null
                  ? Image.asset(
                      item.fotoPath!,
                      width: 127,
                      height: 127,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 127,
                      height: 127,
                      color: AppColors.imagePlaceholder,
                    ),
            ),
            // Konten kanan
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        item.deskripsi,
                        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.hargaFormatted,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Obx(() {
                          final qty = cart.getQuantity(item.id);
                          if (qty == 0) {
                            return GestureDetector(
                              onTap: () => cart.increment(item.id, item),
                              child: const Icon(
                                Icons.add_circle_outline,
                                size: 30,
                                color: AppColors.primary,
                              ),
                            );
                          }
                          return QuantityControl(
                            qty: qty,
                            onMinus: () => cart.decrement(item.id),
                            onPlus: () => cart.increment(item.id, item),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 8.3 — Verifikasi**

```
flutter analyze lib/app/core/widgets/
```
Expected: No issues found.

---

## Task 9: FilterSheet

**Files:**
- Create: `lib/app/modules/home/widgets/filter_sheet.dart`

- [ ] **Step 9.1 — Buat direktori dan FilterSheet**

```dart
// lib/app/modules/home/widgets/filter_sheet.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../home_controller.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late String _kategoriPilihan;
  late String _sortPilihan;

  final HomeController _homeController = Get.find<HomeController>();

  final List<Map<String, String>> _kategoriOptions = const [
    {'value': 'all', 'label': 'Semua'},
    {'value': 'food', 'label': 'Makanan'},
    {'value': 'drink', 'label': 'Minuman'},
  ];

  final List<Map<String, String>> _sortOptions = const [
    {'value': 'default', 'label': 'Default'},
    {'value': 'price_asc', 'label': 'Harga termurah'},
    {'value': 'price_desc', 'label': 'Harga termahal'},
    {'value': 'name_asc', 'label': 'Nama A-Z'},
  ];

  @override
  void initState() {
    super.initState();
    _kategoriPilihan = _homeController.kategori.value;
    _sortPilihan = _homeController.sortBy.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        24 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Filter & Urutkan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Label Kategori
          const Text(
            'Kategori',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          // Chip kategori
          Wrap(
            spacing: 8,
            children: _kategoriOptions.map((opt) {
              final isActive = _kategoriPilihan == opt['value'];
              return GestureDetector(
                onTap: () => setState(() => _kategoriPilihan = opt['value']!),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: isActive ? AppColors.primary : AppColors.border,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    opt['label']!,
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          // Label Urutkan
          const Text(
            'Urutkan',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          // Radio sort
          ..._sortOptions.map((opt) {
            final isActive = _sortPilihan == opt['value'];
            return GestureDetector(
              onTap: () => setState(() => _sortPilihan = opt['value']!),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      isActive
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isActive ? AppColors.primary : AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      opt['label']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: isActive ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          // Tombol Reset & Terapkan
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() {
                    _kategoriPilihan = 'all';
                    _sortPilihan = 'default';
                  }),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _homeController.applyFilter(_kategoriPilihan, _sortPilihan);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Terapkan'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 9.2 — Verifikasi**

```
flutter analyze lib/app/modules/home/widgets/
```
Expected: No issues found.

---

## Task 10: HomeView + FooterNav

**Files:**
- Modify: `lib/app/modules/home/home_view.dart`

HomeView pakai `StatefulWidget` (bukan `GetView`) karena perlu `ScrollController`
dan `GlobalKey` yang persist antar rebuild. Controller diakses via `Get.find`.

- [ ] **Step 10.1 — Timpa home_view.dart**

```dart
// lib/app/modules/home/home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/menu_list_card.dart';
import '../../core/widgets/top_pick_card.dart';
import '../../routes/app_routes.dart';
import 'home_controller.dart';
import 'widgets/filter_sheet.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.find<HomeController>();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _allMenuKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToAllMenu() {
    final ctx = _allMenuKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _openFilterSheet() {
    Get.bottomSheet(
      const FilterSheet(),
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollController,
                children: [
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: TextField(
                        onChanged: (v) => controller.searchQuery.value = v,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 18),
                        ),
                      ),
                    ),
                  ),

                  // Header Top Picks
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Top Picks',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: _scrollToAllMenu,
                          child: const Text(
                            'See All',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Top Picks horizontal list
                  const SizedBox(height: 12),
                  Obx(() => SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.topPicks.length,
                      itemBuilder: (context, index) {
                        final item = controller.topPicks[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index < controller.topPicks.length - 1 ? 12 : 0,
                          ),
                          child: TopPickCard(
                            item: item,
                            onTap: () => Get.toNamed(
                              AppRoutes.detail,
                              arguments: item.id,
                            ),
                          ),
                        );
                      },
                    ),
                  )),

                  // Header All Menu — GlobalKey untuk auto-scroll
                  Padding(
                    key: _allMenuKey,
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'All Menu',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Obx(() {
                          final filterAktif =
                              controller.kategori.value != 'all' ||
                              controller.sortBy.value != 'default';
                          return GestureDetector(
                            onTap: _openFilterSheet,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.tune,
                                    color: AppColors.textSecondary,
                                    size: 24,
                                  ),
                                ),
                                if (filterAktif)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: AppColors.error,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  // All Menu vertical list (reactive)
                  Obx(() {
                    final list = controller.filteredMenu;
                    return Column(
                      children: [
                        for (int i = 0; i < list.length; i++)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: MenuListCard(
                              item: list[i],
                              onTap: () => Get.toNamed(
                                AppRoutes.detail,
                                arguments: list[i].id,
                              ),
                            ),
                          ),
                      ],
                    );
                  }),

                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Footer navigasi
            const _FooterNav(),
          ],
        ),
      ),
    );
  }
}

// Footer nav — Home selalu aktif karena kita sedang di halaman ini
class _FooterNav extends StatelessWidget {
  const _FooterNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 81,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1.5),
        ),
      ),
      child: Row(
        children: [
          _buildTab(
            icon: Icons.home,
            label: 'Home',
            isActive: true,
          ),
          _buildTab(
            icon: Icons.shopping_basket_outlined,
            label: 'Cart',
            onTap: () => Get.toNamed(AppRoutes.cart),
          ),
          _buildTab(
            icon: Icons.receipt_long_outlined,
            label: 'Order',
            onTap: () => Get.snackbar(
              'Segera Hadir',
              'Fitur ini akan datang di pembaruan berikutnya',
              snackPosition: SnackPosition.BOTTOM,
            ),
          ),
          _buildTab(
            icon: Icons.menu_book_outlined,
            label: 'How to Use',
            onTap: () => Get.snackbar(
              'Segera Hadir',
              'Fitur ini akan datang di pembaruan berikutnya',
              snackPosition: SnackPosition.BOTTOM,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required IconData icon,
    required String label,
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    final color = isActive ? AppColors.primary : AppColors.primaryLight;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: color),
            ),
            if (isActive) ...[
              const SizedBox(height: 4),
              Container(
                height: 2,
                width: 24,
                color: AppColors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 10.2 — Verifikasi**

```
flutter analyze lib/app/modules/home/home_view.dart
```
Expected: No issues found.

---

## Task 11: Route Updates + Final Analyze

**Files:**
- Modify: `lib/app/routes/app_pages.dart`

- [ ] **Step 11.1 — Tambah route /cart dan /detail ke app_pages.dart**

```dart
// lib/app/routes/app_pages.dart
import 'package:get/get.dart';

import '../core/middlewares/auth_middleware.dart';
import '../modules/cart/cart_binding.dart';
import '../modules/cart/cart_view.dart';
import '../modules/detail/detail_binding.dart';
import '../modules/detail/detail_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';
import 'app_routes.dart';

abstract class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.detail,
      page: () => const DetailView(),
      binding: DetailBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartView(),
      binding: CartBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
```

- [ ] **Step 11.2 — Full analyze**

```
flutter analyze
```
Expected: No issues found.

- [ ] **Step 11.3 — Jalankan app**

```
flutter run
```

Verifikasi manual (checklist dari design doc):
1. Login berhasil → masuk Home, lihat Top Picks + All Menu
2. Tap `+` di kartu → berubah jadi `− 1x +`
3. Tap `+` lagi → `2x`, `3x`, dst.
4. Tap `−` sampai 0 → kembali ke tombol `+`
5. Tap Cart di footer → halaman "Halaman Cart — Fase 4"
6. Kembali → tap item → halaman "Halaman Detail — Fase 3"
7. Ketik di search → list All Menu ter-filter
8. Tap funnel → bottom sheet muncul dengan chip & radio
9. Pilih "Makanan" + "Harga termurah" → Terapkan → list ter-filter & sorted
10. Badge merah muncul di funnel icon
11. Buka filter → Reset → Terapkan → list kembali full, badge hilang
12. Tap "See All" → scroll ke section All Menu
