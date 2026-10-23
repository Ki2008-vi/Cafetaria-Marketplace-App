<?php

namespace App\Http\Controllers\Api;

use App\Http\Resources\UserResource;
use App\Models\Invoice;
use App\Models\OrderItem;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class ProfileController
{
    public function show(Request $request): JsonResponse
    {
        return response()->json(['user' => new UserResource($request->user())]);
    }

    public function update(Request $request): JsonResponse
    {
        $user = $request->user();

        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'company_name' => ['required', 'string', 'max:255'],
            'phone' => ['required', 'string', 'max:30'],
            'address' => ['required', 'string', 'max:255'],
            'city' => ['required', 'string', 'max:100'],
            'cuisine_type' => [$user->isMerchant() ? 'required' : 'nullable', 'string', 'max:100'],
            'description' => ['nullable', 'string', 'max:2000'],
        ]);

        $user->update($data);

        return response()->json(['user' => new UserResource($user)]);
    }

    public function destroy(Request $request): JsonResponse
    {
        $user = $request->user();

        DB::transaction(function () use ($user) {
            if ($user->isMerchant()) {
                foreach ($user->menuItems as $item) {
                    if ($item->photo_path) {
                        Storage::disk('public')->delete($item->photo_path);
                    }
                }
                $user->menuItems()->delete();

                $orderIds = $user->ordersAsCaterer()->pluck('id');
                Invoice::whereIn('order_id', $orderIds)->delete();
                OrderItem::whereIn('order_id', $orderIds)->delete();
                $user->ordersAsCaterer()->delete();
            }

            if ($user->isOffice()) {
                $orderIds = $user->ordersAsOffice()->pluck('id');
                Invoice::whereIn('order_id', $orderIds)->delete();
                OrderItem::whereIn('order_id', $orderIds)->delete();
                $user->ordersAsOffice()->delete();
            }

            $user->delete();
        });

        Auth::guard('web')->logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return response()->json(['message' => 'Akun berhasil dihapus.']);
    }
}
