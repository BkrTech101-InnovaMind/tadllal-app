<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Auth;

class SubConstructionServiceResource extends JsonResource
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
                    'description' => $this->description,
                    'image' => $this->image,
                    'construction_service_id' => $this->construction_service_id,
                    'construction' => $this->constructionService->name,
                ]
            ];
        } else {
            return [
                'id' => (string) $this->id,
                'attributes' => [
                    'name' => $this->name,
                    'description' => $this->description,
                    'image' => $this->image,
                    'construction_service_id' => $this->construction_service_id,
                ]
            ];
        }
    }
}