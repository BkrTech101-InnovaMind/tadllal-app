<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Support\Str;
use App\Http\Controllers\Controller;
use App\Http\Resources\LocatiosResource;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use App\Models\Rlocations;
use Illuminate\Http\Request;
use App\Traits\HttpResponses;

class LocationsController extends Controller
{
    use HttpResponses;
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return LocatiosResource::collection(
            Rlocations::get()
        );
    }


    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'name' => 'required|unique:rlocations|max:255',
        ]);

        $newLocation = Rlocations::create([
            'name' => $request->name,
        ]);

        return new LocatiosResource($newLocation);
    }

    /**
     * Display the specified resource.
     */
    public function show(Rlocations $Location)
    {
        return new LocatiosResource($Location);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Rlocations $Location)
    {
        $validatedData = $request->validate([
            'name' => 'required|unique:rlocations,name,' . $Location->id . '|max:255',
        ]);

        if (!empty($validatedData)) {
            $Location->update($validatedData);
        }

        return new LocatiosResource($Location);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Rlocations $Location)
    {
        try {
            if (!$Location) {
                return $this->error('', 'Location not found', 404);
            }
            $Location->delete();

            return $this->success([
                'message' => 'The location has been deleted successfully',
            ]);


        } catch (\Exception $e) {
            if (Str::contains($e->getMessage(), 'Integrity constraint violation')) {
                return $this->error('Cannot delete this location due to foreign key constraints', '', 400);
            }

            return $this->error('An error occurred while deleting the location', '', 500);
        }
    }
}