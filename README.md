# 🍱 Cafetaria Marketplace App

A full-stack **B2B Catering Marketplace** built with **Laravel 13** and **Vue 3**, designed to connect office teams with local catering merchants. Office users can browse caterers, place orders, and manage invoices — while merchants can manage their menus and track incoming orders from a dedicated dashboard.

---

## ✨ Features

### 👔 For Office Users
- Browse and search catering merchants by cuisine type, city, and availability
- View detailed caterer profiles with full menu listings
- Add items to a shopping cart and place orders with delivery details
- Track order history and statuses
- View and pay invoices directly from the app

### 🧑‍🍳 For Merchants
- Dedicated merchant dashboard with order statistics
- Full menu management: create, update, and delete menu items with photo uploads
- Update order statuses (pending → confirmed → preparing → delivered)
- Automatic invoice generation when an order is placed

### 🔐 Authentication & Authorization
- Session-based authentication with role-based access control
- Two roles: `merchant` and `office`
- Route guards on both frontend (Vue Router) and backend (Laravel middleware)

---

## 🛠️ Tech Stack

| Layer       | Technology                                  |
|-------------|---------------------------------------------|
| Backend     | PHP 8.3, Laravel 13                         |
| Frontend    | Vue 3 (SPA), Vue Router 5                   |
| Styling     | Tailwind CSS v4                             |
| Build Tool  | Vite 8                                      |
| Database    | SQLite (development) / MySQL (production)   |
| Auth        | Laravel Session Auth                        |

---

## 📁 Project Structure

```
catering-marketplace/
├── app/
│   ├── Http/
│   │   ├── Controllers/Api/    # API controllers (Auth, Caterer, Order, Invoice, Menu, Profile, Dashboard)
│   │   └── Middleware/         # Role-based middleware
│   ├── Models/                 # Eloquent models (User, MenuItem, Order, OrderItem, Invoice)
│   └── Services/
│       └── OrderService.php    # Business logic for order creation & invoice generation
│
├── database/
│   ├── migrations/             # All database schema migrations
│   └── seeders/
│       ├── DatabaseSeeder.php  # Main seeder (demo accounts)
│       └── DemoMenuSeeder.php  # Seeds sample menu items for demo merchants
│
├── resources/
│   └── js/
│       ├── App.vue             # Root Vue component with navigation
│       ├── router.js           # Vue Router with role-based route guards
│       ├── stores/             # Reactive state (auth.js, cart.js, confirm.js)
│       ├── components/         # Shared components (ConfirmModal, StatusBadge)
│       └── pages/
│           ├── LandingPage.vue         # Public landing page
│           ├── LoginPage.vue           # Login form
│           ├── RegisterPage.vue        # Registration form (role selection)
│           ├── OrdersPage.vue          # Order history
│           ├── InvoicesPage.vue        # Invoice list
│           ├── InvoiceDetailPage.vue   # Invoice detail & payment
│           ├── ProfilePage.vue         # User profile settings
│           ├── merchant/
│           │   ├── DashboardPage.vue   # Merchant stats & recent orders
│           │   └── MenuPage.vue        # Merchant menu management
│           └── office/
│               ├── BrowsePage.vue      # Browse & filter caterers
│               ├── CatererPage.vue     # Caterer detail with full menu
│               └── CartPage.vue        # Cart & checkout
│
└── routes/
    └── web.php                 # All API routes + SPA fallback
```

---

## 🗄️ Database Schema

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

## 🚀 Getting Started

### Prerequisites
- PHP 8.3+
- Composer
- Node.js 20+ & npm

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/Ki2008-vi/Cafetaria-Marketplace-App.git
cd catering-marketplace

# 2. Install all dependencies and set up the application
composer run setup
```

The `setup` script will automatically:
- Install PHP dependencies (`composer install`)
- Copy `.env.example` to `.env` and generate an application key
- Run all database migrations
- Install Node.js dependencies and build frontend assets

### Running Locally

```bash
# Start all services concurrently (Laravel + Vite dev server)
composer run dev
```

Or start them individually:

```bash
php artisan serve   # Laravel backend at http://localhost:8000
npm run dev         # Vite frontend dev server
```

---

## 🌱 Demo Data

Seed the database with demo accounts and sample menu items:

```bash
php artisan db:seed
php artisan db:seed --class=DemoMenuSeeder
```

### Demo Accounts

| Role     | Email                       | Password   | Company              |
|----------|-----------------------------|------------|----------------------|
| Merchant | `merchant@catering.test`    | `password` | *(primary merchant)* |
| Merchant | `healthy@catering.test`     | `password` | Green Bowl Kitchen   |
| Office   | `office@catering.test`      | `password` | *(office team)*      |

---

## 🔌 API Endpoints

All routes are prefixed with `/api`.

### Public
| Method | Endpoint              | Description                   |
|--------|-----------------------|-------------------------------|
| POST   | `/register`           | Register a new user           |
| POST   | `/login`              | Login and start session       |
| GET    | `/caterers`           | List all caterers             |
| GET    | `/caterers/{id}`      | Get caterer detail + menu     |
| GET    | `/filters`            | Get available filter options  |

### Authenticated (all roles)
| Method | Endpoint                | Description              |
|--------|-------------------------|--------------------------|
| GET    | `/me`                   | Get current user info    |
| POST   | `/logout`               | Logout                   |
| GET    | `/dashboard`            | Dashboard statistics     |
| GET    | `/profile`              | View profile             |
| PUT    | `/profile`              | Update profile           |
| GET    | `/orders`               | List orders              |
| GET    | `/invoices`             | List invoices            |
| GET    | `/invoices/{id}`        | Get invoice detail       |

### Office Only
| Method | Endpoint                   | Description        |
|--------|----------------------------|--------------------|
| POST   | `/orders`                  | Place a new order  |
| POST   | `/invoices/{id}/pay`       | Pay an invoice     |

### Merchant Only
| Method | Endpoint                            | Description             |
|--------|-------------------------------------|-------------------------|
| GET    | `/merchant/menu-items`              | List own menu items     |
| POST   | `/merchant/menu-items`              | Create a menu item      |
| PUT    | `/merchant/menu-items/{id}`         | Update a menu item      |
| DELETE | `/merchant/menu-items/{id}`         | Delete a menu item      |
| PATCH  | `/merchant/orders/{id}/status`      | Update order status     |

---

## 🧪 Running Tests

```bash
composer run test
# or
php artisan test
```

---

## 📄 License

This project is open-sourced under the [MIT license](https://opensource.org/licenses/MIT).
