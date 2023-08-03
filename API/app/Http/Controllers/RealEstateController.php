<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Resources\RealEstateResource;
use App\Models\RealEstate;
use App\Traits\HttpResponses;

class RealEstateController extends Controller
{
    use HttpResponses;
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return RealEstateResource::collection(
            RealEstate::with(['locations:id,name', 'types:id,name', 'ratings'])
                ->withCount('ratings') // Load the number of ratings
                ->withAvg('ratings', 'rating') // Load the average rating
                ->get()
        );
    }

    /**
     * Display the specified resource.
     */
    public function show(RealEstate $realty)
    {
        if (!$realty) {
            // If the real estate is not found, return a 404 response
            return $this->error('', 'Real estate not found', 404);
        } else {
            // Load the count of ratings and the average rating for the real estate
            $realty->loadCount('ratings'); // Load the number of ratings
            $realty->loadAvg('ratings', 'rating'); // Load the average rating

            return new RealEstateResource($realty);
        }
    }



}