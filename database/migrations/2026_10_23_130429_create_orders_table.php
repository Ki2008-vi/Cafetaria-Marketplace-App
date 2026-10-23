<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('orders', function (Blueprint $table) {
            $table->id();
            $table->string('order_number', 40)->unique();
            $table->foreignId('caterer_id')->constrained('users')->restrictOnDelete();
            $table->foreignId('office_id')->constrained('users')->restrictOnDelete();
            $table->date('delivery_date');
            $table->string('delivery_address');
            $table->text('notes')->nullable();
            $table->string('status', 20)->default('pending');
            $table->decimal('total', 12, 2);
            $table->timestamps();

            $table->index(['caterer_id', 'status']);
            $table->index(['office_id', 'status']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('orders');
    }
};