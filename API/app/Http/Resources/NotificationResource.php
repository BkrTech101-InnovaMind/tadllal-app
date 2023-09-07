<?php

namespace App\Http\Resources;

use App\Models\RealEstate;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class NotificationResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $realEstate = RealEstate::find($this->data['real_estates_id']);
        $realEstateResource = new RealEstateResource($realEstate);
        return [
            'id' => $this->id,
            'status' => $this->read_at == null ? 'unread' : 'read',
            'realEstate' => $realEstateResource,
        ];
    }
}