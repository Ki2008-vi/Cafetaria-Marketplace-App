<?php

namespace App\Services;

use App\Models\Invoice;
use App\Models\MenuItem;
use App\Models\Order;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class OrderService
{
    public function create(User $office, array $data): Order
    {
        return DB::transaction(function () use ($office, $data) {
            $caterer = User::query()
                ->where('role', User::ROLE_MERCHANT)
                ->find($data['caterer_id']);

            if (! $caterer) {
                throw ValidationException::withMessages([
                    'caterer_id' => 'The selected caterer is not available.',
                ]);
            }

            $requestedItems = collect($data['items'])->keyBy('menu_item_id');

            $menuItems = MenuItem::query()
                ->where('caterer_id', $caterer->id)
                ->whereIn('id', $requestedItems->keys())
                ->where('is_available', true)
                ->get()
                ->keyBy('id');

            if ($menuItems->count() !== $requestedItems->count()) {
                throw ValidationException::withMessages([
                    'items' => 'One or more menu items are unavailable. Please refresh your cart.',
                ]);
            }

            $total = 0.0;

            $order = Order::create([
                'order_number' => $this->uniqueNumber('ORD', Order::class, 'order_number'),
                'caterer_id' => $caterer->id,
                'office_id' => $office->id,
                'delivery_date' => $data['delivery_date'],
                'delivery_address' => $data['delivery_address'],
                'notes' => $data['notes'] ?? null,
                'status' => 'pending',
                'total' => 0,
            ]);

            foreach ($data['items'] as $requested) {
                /** @var MenuItem $menuItem */
                $menuItem = $menuItems->get($requested['menu_item_id']);
                $quantity = (int) $requested['quantity'];
                $lineTotal = round((float) $menuItem->price * $quantity, 2);
                $total += $lineTotal;

                $order->items()->create([
                    'menu_item_id' => $menuItem->id,
                    'name' => $menuItem->name,
                    'unit_price' => $menuItem->price,
                    'quantity' => $quantity,
                    'line_total' => $lineTotal,
                ]);
            }

            $order->update(['total' => round($total, 2)]);

            $order->invoice()->create([
                'invoice_number' => $this->uniqueNumber('INV', Invoice::class, 'invoice_number'),
                'status' => Invoice::STATUS_UNPAID,
                'issued_at' => now(),
                'due_at' => now()->addDays(7),
                'total' => $order->total,
            ]);

            return $order->load(['caterer', 'office', 'items', 'invoice']);
        });
    }

    private function uniqueNumber(string $prefix, string $model, string $column): string
    {
        do {
            $number = $prefix.'-'.now()->format('Ymd').'-'.Str::upper(Str::random(6));
        } while ($model::query()->where($column, $number)->exists());

        return $number;
    }
}