<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\SerializesCateringData;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CatererController
{
    use SerializesCateringData;

    public function index(Request $request): JsonResponse
    {
        $query = User::query()
            ->where('role', User::ROLE_MERCHANT)
            ->withCount([
                'menuItems as available_menu_count' => fn ($query) => $query->where('is_available', true),
            ])
            ->withMin([
                'menuItems as min_price' => fn ($query) => $query->where('is_available', true),
            ], 'price')
            ->orderBy('company_name');

        if ($search = trim((string) $request->query('search'))) {
            $term = '%'.strtolower($search).'%';

            $query->where(function ($query) use ($term) {
                $query->whereRaw('LOWER(company_name) LIKE ?', [$term])
                    ->orWhereRaw('LOWER(description) LIKE ?', [$term])
                    ->orWhereRaw('LOWER(cuisine_type) LIKE ?', [$term])
                    ->orWhereHas('menuItems', fn ($menuQuery) => $menuQuery->whereRaw('LOWER(name) LIKE ?', [$term])->orWhereRaw('LOWER(description) LIKE ?', [$term]));
            });
        }

        if ($city = trim((string) $request->query('city'))) {
            $query->whereRaw('LOWER(city) = ?', [strtolower($city)]);
        }

        if ($cuisine = trim((string) $request->query('cuisine'))) {
            $query->whereRaw('LOWER(cuisine_type) = ?', [strtolower($cuisine)]);
        }

        $caterers = $query->limit(60)->get()
            ->map(fn (User $caterer) => $this->catererCardPayload($caterer))
            ->values();

        return response()->json($caterers);
    }

    public function show(User $caterer): JsonResponse
    {
        abort_unless($caterer->isMerchant(), 404);

        return response()->json($this->catererDetailPayload($caterer));
    }

    public function filters(): JsonResponse
    {
        return response()->json([
            'cities' => User::query()
                ->where('role', User::ROLE_MERCHANT)
                ->distinct()
                ->orderBy('city')
                ->pluck('city'),
            'cuisines' => User::query()
                ->where('role', User::ROLE_MERCHANT)
                ->whereNotNull('cuisine_type')
                ->distinct()
                ->orderBy('cuisine_type')
                ->pluck('cuisine_type'),
        ]);
    }
}