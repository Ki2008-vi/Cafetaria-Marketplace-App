<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CatererController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\InvoiceController;
use App\Http\Controllers\Api\MenuItemController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\ProfileController;
use Illuminate\Support\Facades\Route;

Route::prefix('api')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);

    Route::get('/caterers', [CatererController::class, 'index']);
    Route::get('/caterers/{caterer}', [CatererController::class, 'show']);
    Route::get('/filters', [CatererController::class, 'filters']);

    Route::middleware('auth')->group(function () {
        Route::get('/me', [AuthController::class, 'me']);
        Route::post('/logout', [AuthController::class, 'logout']);

        Route::get('/dashboard', DashboardController::class);
        Route::get('/profile', [ProfileController::class, 'show']);
        Route::put('/profile', [ProfileController::class, 'update']);
        Route::delete('/profile', [ProfileController::class, 'destroy']);

        Route::get('/orders', [OrderController::class, 'index']);
        Route::get('/invoices', [InvoiceController::class, 'index']);
        Route::get('/invoices/{invoice}', [InvoiceController::class, 'show']);
    });

    Route::middleware(['auth', 'role:merchant'])->group(function () {
        Route::get('/merchant/menu-items', [MenuItemController::class, 'index']);
        Route::post('/merchant/menu-items', [MenuItemController::class, 'store']);
        Route::put('/merchant/menu-items/{menuItem}', [MenuItemController::class, 'update']);
        Route::delete('/merchant/menu-items/{menuItem}', [MenuItemController::class, 'destroy']);
        Route::patch('/merchant/orders/{order}/status', [OrderController::class, 'updateStatus']);
    });

    Route::middleware(['auth', 'role:office'])->group(function () {
        Route::post('/orders', [OrderController::class, 'store']);
        Route::post('/invoices/{invoice}/pay', [InvoiceController::class, 'pay']);
    });
});

Route::get('/{any?}', fn () => view('app'))->where('any', '.*');