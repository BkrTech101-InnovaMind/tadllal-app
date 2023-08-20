<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use App\Models\ConstructionService;
use App\Models\RealEstateImage;
use App\Models\SubConstructionService;
use App\Models\User;
use App\Models\Rlocations;
use App\Models\Rtypes;
use App\Models\RealEstate;
use App\Models\Rating;
use App\Models\UserComment;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {

        // User::factory(50)->create();
        // Rlocations::factory(50)->create();
        // Rtypes::factory(50)->create();
        // RealEstate::factory(50)->create();
        // Rating::factory(50)->create();
        // RealEstateImage::factory(500)->create();
        // ConstructionService::factory(50)->create();
        // SubConstructionService::factory(50)->create();
        UserComment::factory(50)->create();
    }
}