<?php

namespace Database\Factories;

use App\Models\Rlocations;
use Faker\Provider\ar_JO\Address;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Rlocations>
 */
class RlocationsFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = Rlocations::class;
    public function definition(): array
    {
        return [
            'name' => Address::state(),
        ];
    }
}