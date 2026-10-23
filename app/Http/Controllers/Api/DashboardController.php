<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\SerializesCateringData;
use App\Models\Invoice;
use App\Models\Order;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DashboardController
{
    use SerializesCateringData;

    public function __invoke(Request $request): JsonResponse
    {
        $user = $request->user();

        if ($user->isMerchant()) {
            $paidRevenue = Invoice::query()
                ->where('status', Invoice::STATUS_PAID)
                ->whereHas('order', fn ($query) => $query->where('caterer_id', $user->id))
                ->sum('total');

            $recentOrders = $user->ordersAsCaterer()
                ->with(['caterer', 'office', 'items', 'invoice'])
                ->latest()
                ->limit(5)
                ->get()
                ->map(fn (Order $order) => $this->orderPayload($order))
                ->values();

            return response()->json([
                'role' => $user->role,
                'stats' => [
                    'menu_items' => $user->menuItems()->count(),
                    'orders' => $user->ordersAsCaterer()->count(),
                    'pending_orders' => $user->ordersAsCaterer()->where('status', 'pending')->count(),
                    'paid_revenue' => (float) $paidRevenue,
                ],
                'recent_orders' => $recentOrders,
            ]);
        }

        $paidSpend = Invoice::query()
            ->where('status', Invoice::STATUS_PAID)
            ->whereHas('order', fn ($query) => $query->where('office_id', $user->id))
            ->sum('total');

        $unpaidTotal = Invoice::query()
            ->where('status', Invoice::STATUS_UNPAID)
            ->whereHas('order', fn ($query) => $query->where('office_id', $user->id))
            ->sum('total');

        $recentOrders = $user->ordersAsOffice()
            ->with(['caterer', 'office', 'items', 'invoice'])
            ->latest()
            ->limit(5)
            ->get()
            ->map(fn (Order $order) => $this->orderPayload($order))
            ->values();

        return response()->json([
            'role' => $user->role,
            'stats' => [
                'orders' => $user->ordersAsOffice()->count(),
                'unpaid_invoices' => $user->ordersAsOffice()
                    ->whereHas('invoice', fn ($query) => $query->where('status', Invoice::STATUS_UNPAID))
                    ->count(),
                'unpaid_total' => (float) $unpaidTotal,
                'paid_spend' => (float) $paidSpend,
            ],
            'recent_orders' => $recentOrders,
        ]);
    }
}