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
        $commentsWithUserInfo = $this->comments->map(function ($comment) {
            return [
                'id' => (string) $comment->id,
                'attributes' => [
                    'user_id' => $comment->user->id,
                    'user_name' => $comment->user->name,
                    'user_image' => $comment->user->avatar,
                    'comment' => $comment->comment,
                ]
            ];
        });
        return [
            'id' => (string) $this->id,
            'attributes' => [
                'name' => $this->name,
                'description' => $this->description,
                'price' => $this->price,
                'location' => [
                    'id' => (string) $this->locations->id,
                    'name' => $this->locations->name
                ],
                'locationInfo' => $this->location_info,
                'firstType' => [
                    'id' => (string) $this->types->id,
                    'name' => $this->types->name
                ],
                'state' => $this->state,
                'secondType' => $this->type2,
                'date' => $this->created_at,
                'photo' => url($this->image),
                'rooms' => $this->rooms,
                // عدد الغرف
                'floors' => $this->floors,
                // عدد الادوار
                'vision' => $this->vision,
                // البصيرة
                'baptism' => $this->baptism,
                // التعميد
                'area' => $this->area,
                // المساحة
                'ratings' => $ratings,
                'isFavorite' => $this->isFavorite,
                'images' => $this->images->pluck('image')->map(function ($imageName) {
                    return url($imageName);
                })->toArray(),
                'comments' => $commentsWithUserInfo,
            ]
        ];
    }
}