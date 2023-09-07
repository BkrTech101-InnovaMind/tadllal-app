<?php

namespace App\Http\Resources;

use App\Models\User;
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

        $user = auth()->user(); // الحصول على المستخدم الحالي

        $data = [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'role' => $this->role,
            'phone' => $this->phone_number,
            'avatar' => $this->avatar ? url($this->avatar) : null,
        ];

        // إذا كان المستخدم مسؤولاً، قم بإضافة عدد العملاء وقائمة الطلبات
        if ($user && $user->role == 'admin') {
            $data['activated'] = $this->activated == 0 ? 'no' : 'yes';
            $data['customers_count'] = $this->customers()->count();
            $data['customer_requests'] = CustomersRequestResource::collection($this->customersRequest);
        }

        return $data;

    }
}