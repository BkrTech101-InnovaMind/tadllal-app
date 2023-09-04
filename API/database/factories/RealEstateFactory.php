<?php

namespace Database\Factories;

use App\Models\Rlocations;
use App\Models\Rtypes;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\RealEstate>
 */
class RealEstateFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $types = ['for sale', 'for rent'];
        $randomTypes = $this->faker->randomElement($types);
        return [
            'name' => $this->faker->name(),
            'description' => $this->faker->paragraph(),
            'price' => $this->faker->randomFloat(2, 10000, 1000000),
            'location_id' => Rlocations::factory(),
            'image' => $this->faker->imageUrl(),
            'type1_id' => Rtypes::factory(),
            'location_info' => $this->faker->address(),
            'type2' => $randomTypes,
            'rooms' => $this->faker->numberBetween(1, 10),
            // عدد الغرف
            'floors' => $this->faker->numberBetween(1, 5),
            // عدد الادوار
            'vision' => $this->faker->word(),
            // البصيرة
            'baptism' => $this->faker->word(),
            // التعميد
            'area' => $this->faker->numberBetween(50, 500), // المساحة
        ];
    }
}