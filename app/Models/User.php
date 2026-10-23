<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Hidden;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Database\Eloquent\Relations\HasMany;

#[Fillable([
    'role',
    'name',
    'email',
    'password',
    'company_name',
    'phone',
    'address',
    'city',
    'cuisine_type',
    'description',
])]

#[Hidden(['password', 'remember_token'])]
class User extends Authenticatable
{
    /** @use HasFactory<UserFactory> */
    use HasFactory, Notifiable;

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }
    public const ROLE_MERCHANT = 'merchant';

    public const ROLE_OFFICE = 'office';

    public function isMerchant(): bool
    {
        return $this->role === self::ROLE_MERCHANT;
    }

    public function isOffice(): bool
    {
        return $this->role === self::ROLE_OFFICE;
    }

    public function menuItems(): HasMany
    {
        return $this->hasMany(MenuItem::class, 'caterer_id');
    }

    public function ordersAsCaterer(): HasMany
    {
        return $this->hasMany(Order::class, 'caterer_id');
    }

    public function ordersAsOffice(): HasMany
    {
        return $this->hasMany(Order::class, 'office_id');
    }
}
