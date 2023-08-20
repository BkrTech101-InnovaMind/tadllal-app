<?php

namespace Database\Factories;

use App\Models\User;
use App\Models\RealEstate;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\UserComment>
 */
class UserCommentFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'real_estate_id' => RealEstate::factory(),
            'comment' => $this->faker->paragraph(),
        ];
    }
}