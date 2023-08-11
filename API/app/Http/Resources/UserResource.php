<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Auth;

class UserResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $user = Auth::user();
        if ($user->role == 'admin') {
            return [
                'id' => (string) $this->id,
                'attributes' => [
                    'name' => $this->name,
                    'email' => $this->email,
                    'role' => $this->role,
                    'phone' => $this->phone_number,
                    'avatar' => $this->avatar,
                    'registered_by' => $this->registered_by,
                ]
            ];
        } else {
            return [
                'id' => (string) $this->id,
                'attributes' => [
                    'name' => $this->name,
                    'email' => $this->email,
                    'role' => $this->role,
                    'phone' => $this->phone_number,
                    'avatar' => $this->avatar,
                ]
            ];
        }
    }
}