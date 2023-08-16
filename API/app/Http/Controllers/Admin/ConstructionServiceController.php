<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\ConstructionServiceResource;
use App\Models\ConstructionService;
use Illuminate\Http\Request;

class ConstructionServiceController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return ConstructionServiceResource::collection(
            ConstructionService::get()
        );
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'name' => 'required|unique:construction_services|max:255',
            'description' => 'required|max:255',
            'image' => ['file', 'mimes:jpeg,png,jpg,gif', 'max:4048'],
        ]);

        $imagePath = $request->file('image')->store('public/images/constructionServices');
        $newType = ConstructionService::create([
            'name' => $request->name,
            'description' => $request->description,
            'image' => str_replace('public/', 'storage/', $imagePath),
        ]);

        return new ConstructionServiceResource($newType);
    }

    /**
     * Display the specified resource.
     */
    public function show(ConstructionService $service)
    {
        return new ConstructionServiceResource($service);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}