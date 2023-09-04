<?php

namespace App\Http\Controllers;

use App\Http\Resources\RealEstateWithCommentsResource;
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
    function WithIsFavority($realEstates)
    {
        $user = Auth::user();
        $realEstatesWithFavorites = $realEstates->map(function ($realEstate) use ($user) {
            $isFavorite = $user->favorites->contains('real_estate_id', $realEstate->id);
            $realEstate->isFavorite = $isFavorite;
            return $realEstate;
        });
        return RealEstateResource::collection($realEstatesWithFavorites);
    }
    public function index()
    {


        $realEstates = RealEstate::with(['locations:id,name', 'types:id,name', 'ratings', 'images'])
            ->withCount('ratings') // Load the number of ratings
            ->withAvg('ratings', 'rating') // Load the average rating
            ->where('state', 'available')
            ->get();

        return $this->WithIsFavority($realEstates);
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
            // // Load the count of ratings and the average rating for the real estate
            // $realty->loadCount('ratings'); // Load the number of ratings
            // $realty->loadAvg('ratings', 'rating'); // Load the average rating

            // $user = Auth::user();
            // $isFavorite = $user->favorites->contains('real_estate_id', $realty->id);
            // $realty->isFavorite = $isFavorite;
            // // Attach images' paths to the real estate data
            // $realty->images = $realty->images->pluck('image');


            // // Return the real estates as a resource
            // return new RealEstateResource($realty);

            $realty->load('comments.user'); // تحميل معلومات المستخدمين للتعليقات

            // Return the real estate with comments as a resource
            return new RealEstateWithCommentsResource($realty);
        }
    }

    // Get all real estates in the specified location 
    public function getByLocation($locationId)
    {

        $realEstates = RealEstate::where('location_id', $locationId)
            ->where('state', 'available')
            ->with(['locations:id,name', 'types:id,name', 'ratings'])
            ->get();

        return $this->WithIsFavority($realEstates);
    }

    // Get all real estates of the specified type
    public function getByType($typeId)
    {
        $realEstates = RealEstate::where('type1_id', $typeId)
            ->where('state', 'available')
            ->with(['locations:id,name', 'types:id,name', 'ratings'])
            ->get();

        return $this->WithIsFavority($realEstates);
    }

    // Get all real estates that match the user's preferences in the top
    public function getByUserPreference()
    {
        $user_id = Auth::user()->id;

        // الحصول على تفضيلات المستخدم من جدول UserPreference
        $user_preferences = UserPreference::where('user_id', $user_id)->pluck('type_id')->toArray();

        // جلب العقارات بناءً على تفضيلات المستخدم (إذا كانت هناك تفضيلات)
        if (!empty($user_preferences)) {
            $preferredRealEstates = RealEstate::whereIn('type1_id', $user_preferences)
                ->with(['locations:id,name', 'types:id,name', 'ratings'])
                ->withCount('ratings') // تحميل عدد التقييمات
                ->withAvg('ratings', 'rating') // تحميل معدل التقييمات
                ->where('state', 'available')
                ->get();

            $otherRealEstates = RealEstate::whereNotIn('type1_id', $user_preferences)
                ->with(['locations:id,name', 'types:id,name', 'ratings'])
                ->withCount('ratings') // تحميل عدد التقييمات
                ->withAvg('ratings', 'rating') // تحميل معدل التقييمات
                ->where('state', 'available')
                ->get();

            $real_estates = $preferredRealEstates->merge($otherRealEstates);

        } else {
            // إذا لم يكن لديه تفضيلات، فسيتم عرض جميع العقارات
            $real_estates = RealEstate::with(['locations:id,name', 'types:id,name', 'ratings'])
                ->withCount('ratings') // تحميل عدد التقييمات
                ->withAvg('ratings', 'rating') // تحميل معدل التقييمات();
                ->where('state', 'available')
                ->get();
        }

        return $this->WithIsFavority($real_estates);
    }

    public function getHighestRated()
    {
        // Get all real estates with ratings
        $realEstates = RealEstate::with(['locations:id,name', 'types:id,name', 'ratings'])
            ->withCount('ratings') // Load the number of ratings
            ->withAvg('ratings', 'rating') // Load the average rating
            ->where('state', 'available')
            ->get();

        // Sort the real estates by the number of ratings in descending order
        $realEstates = $realEstates->sortByDesc('ratings_avg_rating');
        // Take the top 10 real estates
        $realEstates = $realEstates->take(20);

        return $this->WithIsFavority($realEstates);
    }


    // Get all real estates that are available
    public function getByStateAvailable()
    {
        $realEstates = RealEstate::where('state', 'available')
            ->with(['locations:id,name', 'types:id,name', 'ratings'])
            ->get();

        return $this->WithIsFavority($realEstates);
    }

    // Get all real estates that are unavailable
    public function getByStateUnavailable()
    {
        $realEstates = RealEstate::where('state', 'unavailable')
            ->with(['locations:id,name', 'types:id,name', 'ratings'])
            ->get();
        return $this->WithIsFavority($realEstates);
    }

    // Get all real estates that are for sale
    public function getByType2ForSale()
    {

        $realEstates = RealEstate::where('type2', 'for sale')
            ->with(['locations:id,name', 'types:id,name', 'ratings'])
            ->where('state', 'available')
            ->get();
        return $this->WithIsFavority($realEstates);
    }

    // Get all real estates that are for rent
    public function getByType2ForRent()
    {

        $realEstates = RealEstate::where('type2', 'for rent')
            ->with(['locations:id,name', 'types:id,name', 'ratings'])
            ->where('state', 'available')
            ->get();
        return $this->WithIsFavority($realEstates);
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
            ->where('state', 'available')
            ->get();

        // Return the real estates as a resource
        return $this->WithIsFavority($realEstates);
    }

}