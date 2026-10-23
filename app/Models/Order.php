<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Order extends Model
{
    use HasFactory;

    public const STATUSES = [
        'pending',
        'confirmed',
        'preparing',
        'delivered',
        'cancelled',
    ];

    protected $fillable = [
        'order_number',
        'caterer_id',
        'office_id',
        'delivery_date',
        'delivery_address',
        'notes',
        'status',
        'total',
    ];

    protected function casts(): array
    {
        return [
            'delivery_date' => 'date',
            'total' => 'decimal:2',
        ];
    }

    public function caterer(): BelongsTo
    {
        return $this->belongsTo(User::class, 'caterer_id');
    }

    public function office(): BelongsTo
    {
        return $this->belongsTo(User::class, 'office_id');
    }

    public function items(): HasMany
    {
        return $this->hasMany(OrderItem::class);
    }

    public function invoice(): HasOne
    {
        return $this->hasOne(Invoice::class);
    }
}