<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Notifications\NewPropertyNotification;
use Illuminate\Http\Request;
use App\Models\RealEstate;
use App\Http\Requests\StoreRealEstateRequest;
use App\Http\Requests\UpdateRealEstateRequest;
use App\Http\Resources\RealEstateResource;
use Illuminate\Support\Facades\Notification;
use Illuminate\Support\Facades\Storage;
use App\Models\Rating;
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
                ->withAvg('ratings', 'rating')
                ->get()
        );
    }


    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreRealEstateRequest $request)
    {
        $request->validated($request->all());
        $imagePath = $request->file('photo')->store('public/images/realEstate');


        // Upload the images and get their paths
        $images = [];
        if ($request->hasFile('images')) {

            foreach ($request->file('images') as $image) {
                // $path = $image->store('public/images/realEstate/images');
                $path = Storage::put('public/images/realEstate/images', $image);
                $images[] = ['image' => str_replace('public/', 'storage/', $path)];
            }
        }
        $realEstate = RealEstate::create([
            'name' => $request->name,
            'description' => $request->description,
            'price' => $request->price,
            'location_id' => $request->location,
            'image' => str_replace('public/', 'storage/', $imagePath),
            'type1_id' => $request->firstType,
            'location_info' => $request->locationInfo,
            'type2' => $request->secondType,
            'rooms' => $request->rooms,
            // عدد الغرف
            'floors' => $request->floors,
            // عدد الادوار
            'vision' => $request->vision,
            // البصيرة
            'baptism' => $request->baptism,
            // التعميد
            'area' => $request->area, // المساحة
        ]);

        // Associate the images with the real estate
        $realEstate->images()->createMany($images);
        $usersToNotify = User::get();
        Notification::send($usersToNotify, new NewPropertyNotification($realEstate));
        return new RealEstateResource($realEstate);
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

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateRealEstateRequest $request, RealEstate $realty)
    {
        if (!$realty) {
            // If the real estate is not found, return a 404 response
            return $this->error('', 'Real estate not found', 404);
        }
        $fieldMappings = [
            'name' => 'name',
            'description' => 'description',
            'price' => 'price',
            'location' => 'location_id',
            'firstType' => 'type1_id',
            'photo' => 'image',
            'locationInfo' => 'location_info',
            'secondType' => 'type2',
        ];

        $updatedFields = [];
        foreach ($fieldMappings as $requestField => $dbField) {
            if ($request->filled($requestField)) {
                if ($requestField == 'image') {

                    $imagePath = $request->file('photo')->store('public/images/realEstate');
                    $updatedFields[$dbField] = $imagePath;
                } else {
                    $updatedFields[$dbField] = $request->$requestField;
                }

            }
        }

        if (!empty($updatedFields)) {
            $realty->update($updatedFields);
            // Create new images

        }
        return new RealEstateResource($realty);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(RealEstate $realty)
    {
        if (!$realty) {
            // If the real estate is not found, return a 404 response
            return $this->error('', 'Real estate not found', 404);
        } else {
            foreach ($realty->images as $image) {
                $imagePath = str_replace('storage/', 'public/', $image->image);
                Storage::delete($imagePath);
            }
            $imagePath = str_replace('storage/', 'public/', $realty->image);
            Storage::delete($imagePath);
            $realty->images()->delete();
            $realty->delete();

            return $this->success([
                'message' => 'The real estate has been deleted successfully',
            ]);

        }


    }

    public function updateRealEstate(UpdateRealEstateRequest $request, $id)
    {
        // Mapping between request fields and database fields
        $fieldMappings = [
            'name' => 'name',
            'description' => 'description',
            'price' => 'price',
            'location' => 'location_id',
            'firstType' => 'type1_id',
            'photo' => 'image',
            'locationInfo' => 'location_info',
            'secondType' => 'type2',
            'rooms' => 'rooms',
            // عدد الغرف
            'floors' => 'floors',
            // عدد الادوار
            'vision' => 'vision',
            // البصيرة
            'baptism' => 'baptism',
            // التعميد
            'area' => 'area',
            // المساحة
            'state' => 'state',
        ];
        // Find the real estate record by its ID
        $realEstate = RealEstate::find($id);
        if (!$realEstate) {
            // If the real estate is not found, return a 404 response
            return $this->error('', 'Real estate not found', 404);
        }

        // Initialize an array to hold the updated fields
        $updatedFields = [];
        // Loop through the request fields and map them to database fields
        foreach ($fieldMappings as $requestField => $dbField) {
            // Check if the request field is filled with a value
            if ($request->filled($requestField)) {
                // If filled, add the request field and its value to the updated fields array
                $updatedFields[$dbField] = $request->$requestField;
            }
        }

        // Handle updating the image if provided in the request
        $imageUrl = '';
        if ($request->file('photo')) {
            $image = $request->file('photo');
            $oldImagePath = str_replace('storage/', 'public/', $realEstate->image);

            if ($oldImagePath && Storage::exists($oldImagePath)) {
                // Delete the previous image if it exists
                Storage::delete($oldImagePath);
            }
            // Store the new image and update the 'image' field in the updated fields array
            $imagePath = $image->store('public/images/realEstate');
            $updatedFields['image'] = str_replace('public/', 'storage/', $imagePath);

        }

        $images = [];
        if ($request->hasFile('images')) {
            // Delete existing images from the storage folder

            foreach ($realEstate->images as $image) {
                $imagePath = str_replace('storage/', 'public/', $image->image); // تحويل المسار ليكون متوافقا مع Storage
                Storage::delete($imagePath);
            }
            // Delete existing images from the database
            $realEstate->images()->delete();

            // Upload and associate the new images
            foreach ($request->file('images') as $image) {
                $path = Storage::put('public/images/realEstate/images', $image);
                $images[] = ['image' => str_replace('public/', 'storage/', $path)];
            }



            // Create new images
            $realEstate->images()->createMany($images);
        }
        // Fill the real estate model with the updated fields and save it to the database
        $realEstate->fill(array_filter($updatedFields));
        $realEstate->save();


        // جلب العقار بعد تنفيذ العمليات
        $updatedRealEstate = RealEstate::find($id);
        // Return the updated real estate resource as the response
        return new RealEstateResource($updatedRealEstate);

    }
    public function getByLocation($locationId)
    {

        $realEstates = RealEstate::where('location_id', $locationId)
            ->with(['locations:id,name', 'types:id,name', 'ratings'])
            ->get();

        return new RealEstateResource($realEstates);
    }


    public function getByType($typeId)
    {
        $realEstates = RealEstate::where('type1_id', $typeId)
            ->with(['locations:id,name', 'types:id,name', 'ratings'])
            ->get();

        return new RealEstateResource($realEstates);
    }


    public function getByStateAvailable()
    {
        $realEstates = RealEstate::where('state', 'available')
            ->with(['locations:id,name', 'types:id,name', 'ratings'])
            ->get();

        return new RealEstateResource($realEstates);
    }

    // Get all real estates that are unavailable
    public function getByStateUnavailable()
    {
        $realEstates = RealEstate::where('state', 'unavailable')
            ->with(['locations:id,name', 'types:id,name', 'ratings'])
            ->get();
        return new RealEstateResource($realEstates);
    }

    public function getByType2ForSale()
    {

        $realEstates = RealEstate::where('type2', 'for sale')
            ->with(['locations:id,name', 'types:id,name', 'ratings'])
            ->get();
        return new RealEstateResource($realEstates);
    }

    // Get all real estates that are for rent
    public function getByType2ForRent()
    {

        $realEstates = RealEstate::where('type2', 'for rent')
            ->with(['locations:id,name', 'types:id,name', 'ratings'])
            ->get();
        return new RealEstateResource($realEstates);
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
        return new RealEstateResource($realEstates);
    }
}