<?php

namespace Database\Factories;

use App\Models\ConstructionService;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\SubConstructionService>
 */
class SubConstructionServiceFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $service = ConstructionService::inRandomOrder()->first();
        return [
            'name' => $this->faker->word(),
            'image' => $this->faker->imageUrl(400, 300),
            'description' => $this->faker->paragraph(),
            'construction_service_id' => $service->id,
        ];
    }
}