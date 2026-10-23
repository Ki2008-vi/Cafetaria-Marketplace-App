<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        User::factory()->create([
            'role' => 'merchant',
            'name' => 'Rani Prameswari',
            'email' => 'merchant@catering.test',
            'company_name' => 'Dapur Nusantara Catering',
            'phone' => '0812-3456-7890',
            'address' => 'Jl. Kebon Jeruk No. 18',
            'city' => 'Jakarta',
            'cuisine_type' => 'Indonesian',
            'description' => 'Home-style Indonesian lunches for offices across Jakarta.',
        ]);

        User::factory()->create([
            'role' => 'office',
            'name' => 'Dina Lestari',
            'email' => 'office@company.test',
            'company_name' => 'PT Maju Bersama',
            'phone' => '021-555-0199',
            'address' => 'Jl. Sudirman Kav. 52, Lantai 8',
            'city' => 'Jakarta',
            'cuisine_type' => null,
            'description' => 'A growing technology team in central Jakarta.',
        ]);

        $this->call(DemoMenuSeeder::class);
    }
}
