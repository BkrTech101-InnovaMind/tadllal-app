<?php

namespace Database\Factories;

use App\Models\RealEstate;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\RealEstateImage>
 */
class RealEstateImageFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {

        $realEstate = RealEstate::inRandomOrder()->first();
        return [
            'real_estate_id' => $realEstate->id,
            'image' => $this->faker->imageUrl(),
        ];
    }
}