# Desain Fase 2 — Halaman Home + Filter & Quantity-on-Card

**Tanggal:** 2026-05-24  
**Status:** Disetujui  
**Scope:** Fase 2 ROADMAP.md + extended fitur filter & quantity control

---

## Ringkasan

Membangun halaman Home sebagai halaman utama pelanggan setelah login.
Fitur: daftar menu (Top Picks + All Menu), search realtime, filter & sort via bottom sheet,
quantity control langsung di kartu tanpa buka halaman detail, dan footer navigasi 4 tab.

---

## Section 1 — Data Layer

### `MenuItem` model
**File:** `lib/app/data/models/menu_item_model.dart`

Fields:
- `id` (String)
- `nama` (String)
- `deskripsi` (String)
- `harga` (int) — rupiah penuh, contoh: 49000
- `kategori` (String) — `'food'` atau `'drink'`
- `fotoPath` (String?) — path asset lokal, nullable
- `isTopPick` (bool, default false)

Getter `hargaFormatted`:
- `harga % 1000 == 0` → `"${harga ~/ 1000}K"` (contoh: `"49K"`)
- Selain itu → format titik ribuan manual tanpa package (contoh: `"49.500"`)

### `CartItem` model
**File:** `lib/app/data/models/cart_item_model.dart`

Fields:
- `menuItem` (MenuItem)
- `quantity` (int)
- `catatan` (String, default `''`)

Getter `subtotal`: `menuItem.harga * quantity`

> Dibuat sekarang (Fase 2) karena dibutuhkan CartController untuk quantity-on-card.
> Detail CartView ditunda ke Fase 4.

### Dummy menu
**File:** `lib/app/data/dummy_data.dart` (tambah ke class yang ada)

- 8 item total: 4 food, 4 drink
- 4 di-mark `isTopPick: true`
- Harga range: 8.000–48.000
- `fotoPath: null` semua (gunakan placeholder Container)
- Nama menu: tema cafe Indonesia (kopi, teh, makanan ringan, dll)

### `MenuService`
**File:** `lib/app/data/services/menu_service.dart`

Methods (semua implementasi loop manual sesuai CONVENTIONS.md):
- `getAllMenu()` → `List<MenuItem>`
- `getTopPicks()` → `List<MenuItem>` (filter `isTopPick == true`)
- `getById(String id)` → `MenuItem?`
- `search(String query)` → `List<MenuItem>` (case-insensitive contains pada `nama`)

Registrasi di `main.dart`: `Get.put<MenuService>(MenuService(), permanent: true)`

---

## Section 2 — Controller Layer

### `CartController`
**File:** `lib/app/modules/cart/cart_controller.dart`

State:
- `RxList<CartItem> items = <CartItem>[].obs`

Methods:
- `getQuantity(String menuId)` → int
  Loop manual `items`, return `quantity` kalau ketemu, return `0` kalau tidak.

- `increment(String menuId, MenuItem item)`
  Loop manual, kalau item ditemukan: `items[i].quantity++; items.refresh()`
  Kalau tidak ditemukan: `items.add(CartItem(menuItem: item, quantity: 1, catatan: '')); items.refresh()`

- `decrement(String menuId)`
  Loop manual, kalau ditemukan:
    - `quantity > 1` → `items[i].quantity--; items.refresh()`
    - `quantity == 1` → `items.removeAt(i); items.refresh()`

- `addItem(MenuItem item)` — wrapper ke `increment(item.id, item)` (backward compatible)

- `clearCart()` → `items.clear()`

Registrasi di `main.dart`: `Get.put<CartController>(CartController(), permanent: true)`

> CartController lengkap dibuat di Fase 2 karena dibutuhkan quantity-on-card.
> CartView (UI keranjang penuh) ditunda ke Fase 4.

### `HomeController`
**File:** `lib/app/modules/home/home_controller.dart` (extend placeholder yang ada)

State:
- `RxList<MenuItem> topPicks` — dari `MenuService.getTopPicks()`
- `RxList<MenuItem> allMenu` — dari `MenuService.getAllMenu()`
- `RxString searchQuery = ''.obs`
- `RxString kategori = 'all'.obs` — `'all' | 'food' | 'drink'`
- `RxString sortBy = 'default'.obs` — `'default' | 'price_asc' | 'price_desc' | 'name_asc'`

Getter `filteredMenu` — 4 step manual:
1. Filter kategori (loop manual, skip jika `kategori == 'all'`)
2. Filter searchQuery (loop manual, `toLowerCase().contains(query.toLowerCase())`)
3. Sort kalau `sortBy != 'default'` (List.sort dengan comparator inline)
4. Return hasil

Methods:
- `onInit()` → load data via MenuService
- `applyFilter(String kategoriBaru, String sortByBaru)` → set keduanya sekaligus
- `resetFilter()` → `kategori = 'all'`, `sortBy = 'default'`
- `logout()` → tetap ada, tidak dihapus

---

## Section 3 — UI

### File yang dibuat

```
lib/app/core/widgets/top_pick_card.dart
lib/app/core/widgets/menu_list_card.dart
lib/app/modules/home/widgets/filter_sheet.dart
lib/app/modules/home/home_view.dart          (overwrite placeholder)
lib/app/modules/cart/cart_view.dart          (scaffold kosong placeholder)
lib/app/modules/cart/cart_binding.dart
```

### `HomeView` layout

Scaffold, bg: `AppColors.background`, body: `CustomScrollView` dengan `ScrollController`
(dipakai untuk "See All" auto-scroll).

1. **Search bar** — pill, h:60, `BorderRadius.circular(60)`, bg putih,
   prefix icon `Icons.search`, placeholder "Search...", 24px semi-bold `AppColors.textSecondary`.
   `onChanged` → `controller.searchQuery.value = value`

2. **Section "Top Picks"** (judul 24px bold hitam + "See All" 16px textSecondary di kanan)
   - "See All" tap → `ScrollController.animateTo` ke posisi All Menu
   - `SizedBox` h:200 + `ListView.builder` horizontal, `shrinkWrap: false`
   - Kartu 170×300, `BorderRadius.circular(20)`, bg putih → delegasi ke `TopPickCard`

3. **Section "All Menu"** (judul 24px bold hitam + funnel icon kanan)
   - Funnel area: `Stack + Positioned`, dot 8×8 merah kalau filter aktif (`Obx`)
   - Tap funnel → `Get.bottomSheet(FilterSheet(), ...)`
   - `ListView.builder` vertical, kartu 364×127 → delegasi ke `MenuListCard`
   - Key pada section ini dipakai oleh `ScrollController` untuk auto-scroll

4. **Footer nav** — h:81, bg putih, border-top 1.5px `AppColors.border`, 4 tab:
   - Home / Cart / Order / How to Use (icons: `home`, `shopping_basket`, `receipt_long`, `menu_book`)
   - Tab aktif: icon + text `AppColors.primary` + underline 2px di bawah label
   - Tab inactive: icon + text `AppColors.primaryLight`
   - Cart → `Get.toNamed(AppRoutes.cart)`
   - Order & How to Use → `Get.snackbar("Segera Hadir", "Fitur ini akan datang di pembaruan berikutnya")`

### `TopPickCard` (widget terpisah)

Parameter: `MenuItem item`, `VoidCallback? onTap`

Layout kartu (170×300):
- Image area atas (170×200, rounded 20px): `fotoPath != null` → `Image.asset`, selain itu `Container` bg `AppColors.imagePlaceholder`
- Padding bawah 8px: nama 16px semi-bold (textSecondary), desc 10px regular (1 baris, overflow ellipsis), harga 16px semi-bold
- Kanan bawah: quantity control (reactive, `Obx`)

### `MenuListCard` (widget terpisah)

Parameter: `MenuItem item`, `VoidCallback? onTap`

Layout kartu (364×127):
- Image kiri (127×115, rounded 10px): placeholder sama seperti di atas
- Text kanan: nama 16px semi-bold, desc 10px regular (2 baris max), harga 16px semi-bold
- Kanan: quantity control (reactive, `Obx`)

### Quantity Control (logika sama di kedua kartu)

```
qty = CartController.getQuantity(item.id)

if qty == 0:
  IconButton(icon: Icons.add_circle_outline, size: 30)
  onTap: cartController.increment(item.id, item)

if qty > 0:
  Row [
    IconButton minus → cartController.decrement(item.id)
    Text "${qty}x" putih bold 12px
    IconButton plus → cartController.increment(item.id, item)
  ]
  Container bg AppColors.primary, rounded 14px, padding 4px, h:36
```

**Tidak ada snackbar** — visual quantity control sudah cukup feedback.

### `FilterSheet` (StatefulWidget)

**File:** `lib/app/modules/home/widgets/filter_sheet.dart`

State lokal (bukan GetxController — hanya temporary sampai user tap Terapkan):
- `String _kategoriPilihan` — init dari `HomeController.kategori.value`
- `String _sortPilihan` — init dari `HomeController.sortBy.value`

Layout (Padding 24px all):
- Handle bar 4×40, abu-abu (#E0E0E0), rounded, centered
- "Filter & Urutkan" 18px bold
- **Kategori** (14px semi-bold label):
  - Wrap/Row 3 chip: [Semua] [Makanan] [Minuman]
  - Chip aktif: bg `AppColors.primary`, text putih
  - Chip inactive: bg transparan, border 1px `AppColors.border`, text textSecondary
  - Padding chip: 12px horizontal, 8px vertical, `BorderRadius.circular(20)`
- **Urutkan** (14px semi-bold label):
  - 4 baris: Default / Harga termurah / Harga termahal / Nama A-Z
  - Icon `radio_button_checked` (active) / `radio_button_unchecked` (inactive) di kiri
- **Row 2 tombol** (keduanya `Expanded`):
  - "Reset" outlined (border primary, text primary) → `setState` reset ke `'all'` & `'default'`
  - "Terapkan" filled primary → `homeController.applyFilter(...)` + `Get.back()`
- `SizedBox(height: MediaQuery.of(context).padding.bottom)` untuk safe area

---

## Section 4 — Routing

### `CartView` placeholder
**File:** `lib/app/modules/cart/cart_view.dart`

Scaffold dengan body `Center(child: Text("Halaman Cart — Fase 4"))`.
**Jangan render list CartItem** — detail kartunya belum dirancang.

### `app_pages.dart` tambah:
```dart
GetPage(
  name: AppRoutes.detail,
  page: () => const DetailView(),   // placeholder scaffold
  middlewares: [AuthMiddleware()],
),
GetPage(
  name: AppRoutes.cart,
  page: () => const CartView(),
  binding: CartBinding(),
  middlewares: [AuthMiddleware()],
),
```

> `DetailView` placeholder: Scaffold + `Center(child: Text("Halaman Detail — Fase 3"))`
> File: `lib/app/modules/detail/detail_view.dart` + `detail_binding.dart`

---

## Checklist Verifikasi Manual

1. Tap `+` di kartu → berubah jadi `− 1x +` tanpa pindah halaman
2. Tap `+` lagi → `2x`, `3x`, dst.
3. Tap `−` sampai 0 → kembali ke tombol `+`
4. Buka Cart page → scaffold placeholder muncul (Fase 4)
5. Tap funnel → bottom sheet muncul dengan chip kategori & radio sort
6. Pilih "Makanan" + "Harga termurah" → Terapkan → list ter-filter & sorted
7. Badge merah muncul di icon funnel
8. Buka filter lagi → Reset → Terapkan → list kembali full, badge hilang
9. Search "kopi" → hanya item yang namanya mengandung "kopi" tampil
10. "See All" → body auto-scroll ke section All Menu

---

## Constraint Penting

- Semua loop MANUAL sesuai CONVENTIONS.md — tidak boleh `firstWhere`, `where`, `map` di production logic
- Warna: selalu `AppColors.*`, tidak boleh hardcode hex di view
- Bahasa UI & komentar: Bahasa Indonesia
- Business logic di controller, BUKAN di view atau widget
- `FilterSheet` pakai `StatefulWidget` state lokal — tidak perlu GetxController untuk state temporary
- `items.refresh()` dipanggil setiap mutasi di CartController agar `Obx` trigger rebuild
