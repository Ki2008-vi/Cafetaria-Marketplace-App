<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'role' => $this->role,
            'name' => $this->name,
            'email' => $this->email,
            'company_name' => $this->company_name,
            'phone' => $this->phone,
            'address' => $this->address,
            'city' => $this->city,
            'cuisine_type' => $this->cuisine_type,
            'description' => $this->description,
        ];
    }
}