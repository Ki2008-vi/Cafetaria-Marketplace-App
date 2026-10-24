# 🍱 Cafetaria Marketplace App

Aplikasi **B2B Catering Marketplace** *full-stack* yang dibangun menggunakan **Laravel 13** dan **Vue 3**, dirancang untuk menghubungkan tim perkantoran dengan mitra katering lokal. Pengguna kantor dapat mencari katering, melakukan pemesanan, dan mengelola faktur (invoice) — sementara mitra katering dapat mengelola menu mereka serta memantau pesanan masuk melalui dasbor khusus.

---

## ✨ Fitur Utama

### 👔 Untuk Pengguna Kantor (Office)
- Menjelajahi dan mencari mitra katering berdasarkan jenis kuliner, kota, dan ketersediaan
- Melihat profil lengkap katering beserta daftar menu yang tersedia
- Menambahkan item ke keranjang belanja dan membuat pesanan beserta detail pengiriman
- Memantau riwayat dan status pemesanan
- Melihat dan membayar tagihan (invoice) langsung dari aplikasi

### 🧑🍳 Untuk Mitra Katering (Merchant)
- Dasbor khusus merchant dengan statistik pemesanan
- Manajemen menu lengkap: membuat, memperbarui, dan menghapus item menu disertai unggah foto
- Memperbarui status pesanan (*pending* → *confirmed* → *preparing* → *delivered*)
- Pembuatan invoice otomatis setiap kali pesanan baru dibuat

### 🔐 Autentikasi & Otorisasi
- Autentikasi berbasis *session* dengan kontrol akses berbasis peran (*role-based access control*)
- Dua peran (*roles*): `merchant` dan `office`
- Pembatasan rute (*route guards*) di sisi *frontend* (Vue Router) maupun *backend* (Laravel middleware)

---

## 🛠️ Teknologi yang Digunakan

| Komponen    | Teknologi                                   |
|-------------|---------------------------------------------|
| Backend     | PHP 8.3, Laravel 13                         |
| Frontend    | Vue 3 (SPA), Vue Router 5                   |
| Styling     | Tailwind CSS v4                             |
| Build Tool  | Vite 8                                      |
| Database    | SQLite (pengembangan) / MySQL (produksi)    |
| Auth        | Laravel Session Auth                        |

---

## 📁 Struktur Proyek

```
catering-marketplace/
├── app/
│   ├── Http/
│   │   ├── Controllers/Api/    # Controller API (Auth, Caterer, Order, Invoice, Menu, Profile, Dashboard)
│   │   └── Middleware/         # Middleware berbasis peran
│   ├── Models/                 # Model Eloquent (User, MenuItem, Order, OrderItem, Invoice)
│   └── Services/
│       └── OrderService.php    # Logika bisnis untuk pembuatan pesanan & invoice
│
├── database/
│   ├── migrations/             # Semua migrasi skema database
│   └── seeders/
│       ├── DatabaseSeeder.php  # Seeder utama (akun demo)
│       └── DemoMenuSeeder.php  # Seeder item menu sampel untuk demo merchant
│
├── resources/
│   └── js/
│       ├── App.vue             # Komponen utama Vue beserta navigasi
│       ├── router.js           # Vue Router dengan route guards berbasis peran
│       ├── stores/             # Manajemen state reaktif (auth.js, cart.js, confirm.js)
│       ├── components/         # Komponen bersama (ConfirmModal, StatusBadge)
│       └── pages/
│           ├── LandingPage.vue         # Halaman utama publik
│           ├── LoginPage.vue           # Form login
│           ├── RegisterPage.vue        # Form registrasi (pemilihan peran)
│           ├── OrdersPage.vue          # Riwayat pemesanan
│           ├── InvoicesPage.vue        # Daftar tagihan / invoice
│           ├── InvoiceDetailPage.vue   # Detail invoice & pembayaran
│           ├── ProfilePage.vue         # Pengaturan profil pengguna
│           ├── merchant/
│           │   ├── DashboardPage.vue   # Statistik merchant & pesanan terbaru
│           │   └── MenuPage.vue        # Manajemen menu merchant
│           └── office/
│               ├── BrowsePage.vue      # Cari & filter katering
│               ├── CatererPage.vue     # Detail katering beserta menu lengkap
│               └── CartPage.vue        # Keranjang belanja & checkout
│
└── routes/
    └── web.php                 # Seluruh rute API + fallback SPA
```

---

## 🗄️ Skema Basis Data

```
users
├── id, role (merchant|office)
├── name, email, password
├── company_name, phone, address, city
├── cuisine_type, description
└── timestamps

menu_items
├── id, caterer_id (→ users)
├── name, description, photo_path
├── price, is_available
└── timestamps

orders
├── id, order_number (unique)
├── caterer_id, office_id (→ users)
├── delivery_date, delivery_address, notes
├── status (pending|confirmed|preparing|delivered|cancelled)
├── total
└── timestamps

order_items
├── id, order_id (→ orders)
├── menu_item_id, name (snapshot), price (snapshot)
├── quantity, subtotal
└── timestamps

invoices
├── id, order_id (→ orders)
├── invoice_number (unique)
├── status (unpaid|paid)
├── issued_at, due_at, paid_at
├── total
└── timestamps
```

---

## 🚀 Panduan Memulai

### Prasyarat
- PHP 8.3+
- Composer
- Node.js 20+ & npm

### Instalasi

```bash
# 1. Clone repository
git clone https://github.com/Ki2008-vi/Cafetaria-Marketplace-App.git
cd catering-marketplace

# 2. Instal semua dependensi dan siapkan aplikasi
composer run setup
```

Perintah `setup` di atas akan otomatis melakukan:
- Menginstal dependensi PHP (`composer install`)
- Menyalin file `.env.example` ke `.env` dan membuat application key
- Menjalankan seluruh migrasi database
- Menginstal dependensi Node.js dan mengompilasi aset frontend

### Menjalankan secara Lokal

```bash
# Menjalankan semua layanan secara bersamaan (server backend Laravel + dev server Vite)
composer run dev
```

Atau jalankan secara terpisah di terminal yang berbeda:

```bash
php artisan serve   # Backend Laravel di http://localhost:8000
npm run dev         # Frontend dev server Vite
```

---

## 🌱 Data Demo

Isi database dengan akun demo dan contoh menu:

```bash
php artisan db:seed
php artisan db:seed --class=DemoMenuSeeder
```

### Akun Demo

| Peran (Role) | Email                       | Kata Sandi | Perusahaan           |
|--------------|-----------------------------|------------|----------------------|
| Merchant     | `merchant@catering.test`    | `password` | *(primary merchant)* |
| Merchant     | `healthy@catering.test`     | `password` | Green Bowl Kitchen   |
| Office       | `office@catering.test`      | `password` | *(office team)*      |

---

## 🔌 Endpoint API

Semua rute diawali dengan prefix `/api`.

### Publik
| Method | Endpoint              | Deskripsi                              |
|--------|-----------------------|----------------------------------------|
| POST   | `/register`           | Pendaftaran pengguna baru              |
| POST   | `/login`              | Masuk (login) dan memulai sesi         |
| GET    | `/caterers`           | Menampilkan semua katering             |
| GET    | `/caterers/{id}`      | Menampilkan detail katering beserta menu|
| GET    | `/filters`            | Mengambil opsi filter yang tersedia    |

### Terautentikasi (Semua Peran)
| Method | Endpoint                | Deskripsi                         |
|--------|-------------------------|-----------------------------------|
| GET    | `/me`                   | Mengambil data pengguna saat ini  |
| POST   | `/logout`               | Keluar (logout)                   |
| GET    | `/dashboard`            | Statistik dasbor                  |
| GET    | `/profile`              | Melihat profil                    |
| PUT    | `/profile`              | Memperbarui profil                |
| GET    | `/orders`               | Menampilkan daftar pesanan        |
| GET    | `/invoices`             | Menampilkan daftar tagihan        |
| GET    | `/invoices/{id}`        | Melihat detail tagihan            |

### Khusus Pengguna Kantor (Office Only)
| Method | Endpoint                   | Deskripsi                 |
|--------|----------------------------|---------------------------|
| POST   | `/orders`                  | Membuat pesanan baru      |
| POST   | `/invoices/{id}/pay`       | Membayar tagihan          |

### Khusus Mitra Katering (Merchant Only)
| Method | Endpoint                            | Deskripsi                         |
|--------|-------------------------------------|-----------------------------------|
| GET    | `/merchant/menu-items`              | Menampilkan menu milik sendiri    |
| POST   | `/merchant/menu-items`              | Menambahkan item menu baru        |
| PUT    | `/merchant/menu-items/{id}`         | Memperbarui item menu             |
| DELETE | `/merchant/menu-items/{id}`         | Menghapus item menu               |
| PATCH  | `/merchant/orders/{id}/status`      | Memperbarui status pesanan        |

---

## 🧪 Menjalankan Pengujian (Testing)

```bash
composer run test
# atau
php artisan test
```

---

## 📄 Lisensi

Proyek ini merupakan perangkat lunak sumber terbuka di bawah lisensi [MIT license](https://opensource.org/licenses/MIT).
