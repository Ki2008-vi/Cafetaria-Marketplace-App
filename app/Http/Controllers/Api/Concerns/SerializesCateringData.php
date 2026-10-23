<?php

namespace App\Http\Controllers\Api\Concerns;

use App\Models\Invoice;
use App\Models\MenuItem;
use App\Models\Order;
use App\Models\User;

trait SerializesCateringData
{
    protected function menuItemPayload(MenuItem $item): array
    {
        return [
            'id' => $item->id,
            'name' => $item->name,
            'description' => $item->description,
            'price' => (float) $item->price,
            'is_available' => (bool) $item->is_available,
            'photo_url' => $item->photoUrl(),
            'created_at' => $item->created_at?->toIso8601String(),
        ];
    }

    protected function catererCardPayload(User $caterer): array
    {
        $menuCount = $caterer->available_menu_count
            ?? ($caterer->relationLoaded('menuItems')
                ? $caterer->menuItems->where('is_available', true)->count()
                : $caterer->menuItems()->where('is_available', true)->count());

        $minPrice = $caterer->min_price
            ?? $caterer->menuItems()->where('is_available', true)->min('price');

        return [
            'id' => $caterer->id,
            'name' => $caterer->name,
            'company_name' => $caterer->company_name,
            'cuisine_type' => $caterer->cuisine_type,
            'city' => $caterer->city,
            'address' => $caterer->address,
            'phone' => $caterer->phone,
            'description' => $caterer->description,
            'menu_count' => (int) $menuCount,
            'min_price' => $minPrice === null ? null : (float) $minPrice,
        ];
    }

    protected function catererDetailPayload(User $caterer): array
    {
        $caterer->loadMissing(['menuItems' => fn ($query) => $query
            ->where('is_available', true)
            ->orderBy('name')]);

        return array_merge($this->catererCardPayload($caterer), [
            'menu_items' => $caterer->menuItems
                ->map(fn (MenuItem $item) => $this->menuItemPayload($item))
                ->values(),
        ]);
    }

    protected function orderPayload(Order $order): array
    {
        $order->loadMissing(['caterer', 'office', 'items', 'invoice']);

        return [
            'id' => $order->id,
            'order_number' => $order->order_number,
            'status' => $order->status,
            'delivery_date' => $order->delivery_date->toDateString(),
            'delivery_address' => $order->delivery_address,
            'notes' => $order->notes,
            'total' => (float) $order->total,
            'created_at' => $order->created_at?->toIso8601String(),
            'caterer' => [
                'id' => $order->caterer->id,
                'name' => $order->caterer->name,
                'company_name' => $order->caterer->company_name,
                'email' => $order->caterer->email,
                'phone' => $order->caterer->phone,
                'address' => $order->caterer->address,
                'city' => $order->caterer->city,
            ],
            'office' => [
                'id' => $order->office->id,
                'name' => $order->office->name,
                'company_name' => $order->office->company_name,
                'email' => $order->office->email,
                'phone' => $order->office->phone,
                'address' => $order->office->address,
                'city' => $order->office->city,
            ],
            'items' => $order->items->map(fn ($item) => [
                'id' => $item->id,
                'menu_item_id' => $item->menu_item_id,
                'name' => $item->name,
                'unit_price' => (float) $item->unit_price,
                'quantity' => $item->quantity,
                'line_total' => (float) $item->line_total,
            ])->values(),
            'invoice' => $order->invoice ? [
                'id' => $order->invoice->id,
                'invoice_number' => $order->invoice->invoice_number,
                'status' => $order->invoice->status,
                'total' => (float) $order->invoice->total,
            ] : null,
        ];
    }

    protected function invoicePayload(Invoice $invoice): array
    {
        return [
            'id' => $invoice->id,
            'invoice_number' => $invoice->invoice_number,
            'status' => $invoice->status,
            'issued_at' => $invoice->issued_at->toIso8601String(),
            'due_at' => $invoice->due_at->toIso8601String(),
            'paid_at' => $invoice->paid_at?->toIso8601String(),
            'total' => (float) $invoice->total,
            'order' => $this->orderPayload($invoice->order),
        ];
    }
}