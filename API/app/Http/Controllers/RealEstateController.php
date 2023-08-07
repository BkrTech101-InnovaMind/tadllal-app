<?php

namespace App\Http\Controllers;

use App\Models\UserPreference;
use Illuminate\Http\Request;
use App\Http\Resources\RealEstateResource;
use App\Models\RealEstate;
use App\Traits\HttpResponses;
use Illuminate\Support\Facades\Auth;

class RealEstateController extends Controller
{
    use HttpResponses;

    // Get all real estates
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

            // Return the real estates as a resource
            return new RealEstateResource($realty);
        }
    }

    // Get all real estates in the specified location 
    public function getByLocation($locationId)
    {
        return RealEstateResource::collection(
            RealEstate::where('location_id', $locationId)
                ->with(['locations:id,name', 'types:id,name', 'ratings'])
                ->get()
        );
    }

    // Get all real estates of the specified type
    public function getByType($typeId)
    {
        return RealEstateResource::collection(
            RealEstate::where('type1_id', $typeId)
                ->with(['locations:id,name', 'types:id,name', 'ratings'])
                ->get()
        );
    }

    // Get all real estates that match the user's preferences in the top
    public function getByUserPreference()
    {
        $user_id = Auth::user()->id;

        // الحصول على تفضيلات المستخدم من جدول UserPreference
        $user_preferences = UserPreference::where('user_id', $user_id)->pluck('type_id')->toArray();

        // جلب العقارات بناءً على تفضيلات المستخدم (إذا كانت هناك تفضيلات)
        if (!empty($user_preferences)) {
            $preferredRealEstates = RealEstateResource::collection(
                RealEstate::whereIn('type1_id', $user_preferences)
                    ->with(['locations:id,name', 'types:id,name', 'ratings'])
                    ->withCount('ratings') // تحميل عدد التقييمات
                    ->withAvg('ratings', 'rating') // تحميل معدل التقييمات
                    ->get()
            );
            $otherRealEstates = RealEstateResource::collection(
                RealEstate::whereNotIn('type1_id', $user_preferences)
                    ->with(['locations:id,name', 'types:id,name', 'ratings'])
                    ->withCount('ratings') // تحميل عدد التقييمات
                    ->withAvg('ratings', 'rating') // تحميل معدل التقييمات
                    ->get()
            );

            $real_estates = $preferredRealEstates->merge($otherRealEstates);

        } else {
            // إذا لم يكن لديه تفضيلات، فسيتم عرض جميع العقارات
            $real_estates = RealEstate::all();
        }

        return response()->json(['real_estates' => $real_estates]);
    }

    public function getHighestRated()
    {
        // Get all real estates with ratings
        $realEstates = RealEstate::with(['locations:id,name', 'types:id,name', 'ratings'])
            ->withCount('ratings') // Load the number of ratings
            ->withAvg('ratings', 'rating') // Load the average rating
            ->get();

        // Sort the real estates by the number of ratings in descending order
        $realEstates = $realEstates->sortByDesc('ratings_avg_rating');
        // Take the top 10 real estates
        $realEstates = $realEstates->take(20);

        // Convert the Collection object to a resource
        $realEstatesResource = RealEstateResource::collection($realEstates);

        // Return the top 10 real estates
        return $realEstatesResource;
    }


    // Get all real estates that are available
    public function getByStateAvailable()
    {
        return RealEstateResource::collection(
            RealEstate::where('state', 'available')
                ->with(['locations:id,name', 'types:id,name', 'ratings'])
                ->get()
        );
    }

    // Get all real estates that are unavailable
    public function getByStateUnavailable()
    {
        return RealEstateResource::collection(
            RealEstate::where('state', 'unavailable')
                ->with(['locations:id,name', 'types:id,name', 'ratings'])
                ->get()
        );
    }

    // Get all real estates that are for sale
    public function getByType2ForSale()
    {
        return RealEstateResource::collection(
            RealEstate::where('type2', 'for sale')
                ->with(['locations:id,name', 'types:id,name', 'ratings'])
                ->get()
        );
    }

    // Get all real estates that are for rent
    public function getByType2ForRent()
    {
        return RealEstateResource::collection(
            RealEstate::where('type2', 'for rent')
                ->with(['locations:id,name', 'types:id,name', 'ratings'])
                ->get()
        );
    }

    public function search($query)
    {

        // Validate the query string
        if (empty($query)) {
            return $this->error('', 'The query string is empty.', 404);
        }
        // Sanitize the query string
        $query = filter_var($query, FILTER_SANITIZE_STRING);
        // // The query string can be empty


        // Split the query string into an array of words
        $words = explode(' ', $query);

        // Create a query builder instance
        $queryBuilder = RealEstate::query();

        // Loop through the words and add them to the where clause
        foreach ($words as $word) {
            $queryBuilder->where(function ($query) use ($word) {
                $query->where('name', 'like', '%' . $word . '%')
                    ->orWhere('description', 'like', '%' . $word . '%')
                    ->orWhere('type2', 'like', '%' . $word . '%')
                    ->orWhereHas('locations', function ($query) use ($word) {
                        $query->where('name', 'like', '%' . $word . '%');
                    })
                    ->orWhereHas('types', function ($query) use ($word) {
                        $query->where('name', 'like', '%' . $word . '%');
                    });
            });
        }

        // Get the real estates that match the query
        $realEstates = $queryBuilder
            ->with(['locations:id,name', 'types:id,name', 'ratings'])
            ->get();

        // Return the real estates as a resource
        return RealEstateResource::collection($realEstates);
    }

}