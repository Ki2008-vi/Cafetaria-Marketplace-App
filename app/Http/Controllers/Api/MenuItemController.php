<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\SerializesCateringData;
use App\Models\MenuItem;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class MenuItemController
{
    use SerializesCateringData;

    public function index(Request $request): JsonResponse
    {
        $items = $request->user()->menuItems()->orderBy('name')->get()
            ->map(fn (MenuItem $item) => $this->menuItemPayload($item))
            ->values();

        return response()->json($items);
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'description' => ['required', 'string', 'max:2000'],
            'price' => ['required', 'numeric', 'min:0.01', 'max:99999999'],
            'photo' => ['required', 'image', 'max:4096'],
            'is_available' => ['sometimes', 'boolean'],
        ]);

        $path = $request->file('photo')->store('menu-items', 'public');

        $item = $request->user()->menuItems()->create([
            'name' => $data['name'],
            'description' => $data['description'],
            'price' => $data['price'],
            'photo_path' => $path,
            'is_available' => $request->boolean('is_available', true),
        ]);

        return response()->json(['menu_item' => $this->menuItemPayload($item)], 201);
    }

    public function update(Request $request, int $menuItem): JsonResponse
    {
        $item = $request->user()->menuItems()->findOrFail($menuItem);

        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'description' => ['required', 'string', 'max:2000'],
            'price' => ['required', 'numeric', 'min:0.01', 'max:99999999'],
            'photo' => ['nullable', 'image', 'max:4096'],
            'is_available' => ['sometimes', 'boolean'],
        ]);

        if ($request->hasFile('photo')) {
            Storage::disk('public')->delete($item->photo_path);
            $data['photo_path'] = $request->file('photo')->store('menu-items', 'public');
        }

        $data['is_available'] = $request->has('is_available')
            ? $request->boolean('is_available')
            : $item->is_available;

        unset($data['photo']);
        $item->update($data);

        return response()->json(['menu_item' => $this->menuItemPayload($item->fresh())]);
    }

    public function destroy(Request $request, int $menuItem): JsonResponse
    {
        $item = $request->user()->menuItems()->findOrFail($menuItem);

        Storage::disk('public')->delete($item->photo_path);
        $item->delete();

        return response()->json(null, 204);
    }
}