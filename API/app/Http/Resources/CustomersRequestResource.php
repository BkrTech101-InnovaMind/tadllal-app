<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CustomersRequestResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => (string) $this->id,
            'attributes' => [
                'property' => $this->property,
                'user' => [
                    'id' => $this->user->id,
                    'name' => $this->user->name,
                    'email' => $this->user->email,
                    'phoneNumber' => $this->user->phone_number,
                    'userImage' => url($this->user->avatar),
                ],
                'customer' => [
                    'id' => $this->customer->id,
                    'name' => $this->customer->customer_name,
                    'phone_number' => $this->customer->customer_number,
                ],
                'location' => [
                    'id' => $this->location->id,
                    'name' => $this->location->name,
                ],
                'type' => [
                    'id' => $this->type->id,
                    'name' => $this->type->name,
                ],
                'budget' => [
                    'from' => $this->budget_from,
                    'to' => $this->budget_to,
                    'currency' => $this->currency,
                ],
                'other_details' => $this->other_details,
                'request_status' => $this->request_status,
                'communication_status' => $this->communication_status,
                'date' => $this->created_at,

            ]
        ];
    }
}