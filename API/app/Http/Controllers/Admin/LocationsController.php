<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\LocatiosResource;
use App\Models\Rlocations;
use Illuminate\Http\Request;

class LocationsController extends Controller
{
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
        $Location->delete();
        return response(null, 204);
    }
}