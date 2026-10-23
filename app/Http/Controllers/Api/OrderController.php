<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\SerializesCateringData;
use App\Models\Order;
use App\Services\OrderService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class OrderController
{
    use SerializesCateringData;

    public function index(Request $request): JsonResponse
    {
        $user = $request->user();

        $orders = $user->isMerchant()
            ? $user->ordersAsCaterer()
            : $user->ordersAsOffice();

        $orders = $orders
            ->with(['caterer', 'office', 'items', 'invoice'])
            ->latest()
            ->get()
            ->map(fn (Order $order) => $this->orderPayload($order))
            ->values();

        return response()->json($orders);
    }

    public function store(Request $request, OrderService $orderService): JsonResponse
    {
        $data = $request->validate([
            'caterer_id' => ['required', 'integer', 'exists:users,id'],
            'delivery_date' => ['required', 'date', 'after_or_equal:today'],
            'delivery_address' => ['required', 'string', 'max:500'],
            'notes' => ['nullable', 'string', 'max:1000'],
            'items' => ['required', 'array', 'min:1'],
            'items.*.menu_item_id' => ['required', 'integer', 'distinct', 'exists:menu_items,id'],
            'items.*.quantity' => ['required', 'integer', 'min:1', 'max:1000'],
        ]);

        $order = $orderService->create($request->user(), $data);

        return response()->json(['order' => $this->orderPayload($order)], 201);
    }

    public function updateStatus(Request $request, int $order): JsonResponse
    {
        $order = $request->user()->ordersAsCaterer()->findOrFail($order);

        $data = $request->validate([
            'status' => ['required', Rule::in(Order::STATUSES)],
        ]);

        $order->update(['status' => $data['status']]);

        return response()->json(['order' => $this->orderPayload($order->fresh())]);
    }
}