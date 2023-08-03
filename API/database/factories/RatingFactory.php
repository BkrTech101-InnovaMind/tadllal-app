<?php

namespace Database\Factories;

use App\Models\RealEstate;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Rating>
 */
class RatingFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $user = User::inRandomOrder()->first();
        $realEstate = RealEstate::inRandomOrder()->first();

        return [
            'user_id' => $user->id,
            'real_estate_id' => $realEstate->id,
            'rating' => $this->faker->numberBetween(1, 5),
        ];
    }
}