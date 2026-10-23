<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;

class DemoMenuSeeder extends Seeder
{
    public function run(): void
    {
        Storage::disk('public')->makeDirectory('menu-items');

        $primaryMerchant = User::where('email', 'merchant@catering.test')->firstOrFail();

        $secondMerchant = User::updateOrCreate(
            ['email' => 'healthy@catering.test'],
            [
                'role' => User::ROLE_MERCHANT,
                'name' => 'Ardi Santoso',
                'password' => Hash::make('password'),
                'company_name' => 'Green Bowl Kitchen',
                'phone' => '0813-2222-1100',
                'address' => 'Jl. Dago Asri No. 7',
                'city' => 'Bandung',
                'cuisine_type' => 'Healthy',
                'description' => 'Balanced, colourful bowls with locally sourced produce. Vegetarian and high-protein options available with daily delivery to offices in Bandung.',
            ],
        );

        $items = [
            [$primaryMerchant, 'Nasi Rendang Box', 'Slow-cooked beef rendang with fragrant coconut rice, cassava leaves and pickles.', 45000, 'nasi-rendang', 'Nasi Rendang', '#7c2d12', '#c2410c'],
            [$primaryMerchant, 'Ayam Bakar Sambal Matah', 'Charcoal-grilled chicken with Balinese raw sambal, steamed rice and fresh vegetables.', 42000, 'ayam-bakar', 'Ayam Bakar', '#78350f', '#ea580c'],
            [$primaryMerchant, 'Gado-Gado Segar', 'Seasonal vegetables, tofu, tempeh and boiled egg with a creamy peanut dressing.', 32000, 'gado-gado', 'Gado-Gado', '#14532d', '#65a30d'],
            [$primaryMerchant, 'Es Teh Lemon', 'Freshly brewed Indonesian tea with lemon and a touch of palm sugar.', 10000, 'es-teh', 'Es Teh Lemon', '#365314', '#a3e635'],
            [$secondMerchant, 'Grilled Chicken Quinoa Bowl', 'Grilled chicken breast, tri-colour quinoa, roasted pumpkin and a lemon herb dressing.', 55000, 'chicken-quinoa', 'Chicken Quinoa', '#064e3b', '#10b981'],
            [$secondMerchant, 'Vegan Buddha Bowl', 'Brown rice, crispy tofu, chickpeas, avocado and seasonal greens with tahini sauce.', 48000, 'buddha-bowl', 'Vegan Bowl', '#365314', '#84cc16'],
            [$secondMerchant, 'Tropical Fruit Salad', 'Papaya, pineapple, mango and mint with a tangy lime dressing.', 30000, 'fruit-salad', 'Fruit Salad', '#9a3412', '#f59e0b'],
            [$secondMerchant, 'Infused Water', 'Chilled mineral water infused with cucumber, lemon and mint.', 12000, 'infused-water', 'Infused Water', '#0c4a6e', '#0ea5e9'],
        ];

        foreach ($items as [$merchant, $name, $description, $price, $file, $label, $from, $to]) {
            $path = "menu-items/{$file}.svg";

            Storage::disk('public')->put($path, $this->photoSvg($label, $from, $to));

            $merchant->menuItems()->updateOrCreate(
                ['name' => $name],
                [
                    'description' => $description,
                    'price' => $price,
                    'photo_path' => $path,
                    'is_available' => true,
                ],
            );
        }
    }

    private function photoSvg(string $label, string $from, string $to): string
    {
        $label = htmlspecialchars($label, ENT_QUOTES);

        return <<<SVG
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 600" role="img" aria-label="{$label}">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="{$from}"/>
      <stop offset="1" stop-color="{$to}"/>
    </linearGradient>
    <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="18" stdDeviation="22" flood-opacity="0.25"/>
    </filter>
  </defs>
  <rect width="800" height="600" fill="url(#bg)"/>
  <circle cx="690" cy="80" r="190" fill="#ffffff" opacity="0.07"/>
  <circle cx="80" cy="540" r="150" fill="#ffffff" opacity="0.08"/>
  <g filter="url(#shadow)">
    <circle cx="400" cy="270" r="170" fill="#ffffff" opacity="0.16"/>
    <circle cx="400" cy="270" r="137" fill="#fff7ed"/>
    <circle cx="400" cy="270" r="111" fill="#fde68a"/>
    <path d="M330 270c20-50 60-70 70-30 10-40 50-20 70 30-20 20-40 45-70 55-30-10-50-35-70-55z" fill="{$from}" opacity="0.75"/>
    <circle cx="360" cy="250" r="17" fill="{$to}"/>
    <circle cx="435" cy="285" r="12" fill="#ffffff" opacity="0.9"/>
  </g>
  <text x="400" y="510" text-anchor="middle" font-family="Georgia, serif" font-size="38" font-weight="700" fill="#ffffff">{$label}</text>
  <text x="400" y="550" text-anchor="middle" font-family="Arial, sans-serif" font-size="17" letter-spacing="4" fill="#ffffff" opacity="0.75">CATERING MARKETPLACE</text>
</svg>
SVG;
    }
}
