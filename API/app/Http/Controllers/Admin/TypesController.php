<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\TypesResource;
use App\Models\Rtypes;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;

class TypesController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return TypesResource::collection(
            Rtypes::get()
        );
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'name' => 'required|unique:rtypes|max:255',
        ]);

        $newType = Rtypes::create([
            'name' => $request->name,
        ]);

        return new TypesResource($newType);
    }

    /**
     * Display the specified resource.
     */
    public function show(Rtypes $type)
    {
        return new TypesResource($type);
    }


    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Rtypes $type)
    {
        $validatedData = $request->validate([
            'name' => 'required|unique:rtypes,name,' . $type->id . '|max:255',
        ]);

        if (!empty($validatedData)) {
            $type->update($validatedData);
        }

        return new TypesResource($type);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Rtypes $type)
    {
        $type->delete();
        return response(null, 204);
    }
}