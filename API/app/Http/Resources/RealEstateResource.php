<?php

namespace App\Http\Resources;

use App\Models\Rating;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class RealEstateResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */private function calculateRatings($realEstateId)
    {
        $averageRating = Rating::where('real_estate_id', $realEstateId)->avg('rating');
        $ratingCount = Rating::where('real_estate_id', $realEstateId)->count();

        return [
            'rating_count' => $ratingCount,
            'average_rating' => number_format($averageRating, 1),
        ];
    }



    public function toArray(Request $request): array
    {
        $ratings = $this->calculateRatings($this->id);
        return [
            'id' => (string) $this->id,
            'attributes' => [
                'name' => $this->name,
                'description' => $this->description,
                'price' => $this->price,
                'location' => $this->locations->name,
                'locationInfo' => $this->location_info,
                'firstType' => $this->types->name,
                'state' => $this->state,
                'secondType' => $this->type2,
                'date' => $this->created_at,
                'photo' => $this->image,
                'ratings' => $ratings,
            ]
        ];
    }
}