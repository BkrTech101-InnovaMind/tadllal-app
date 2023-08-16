<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\ConstructionServiceResource;
use App\Http\Resources\SubConstructionServiceResource;
use App\Models\ConstructionService;
use App\Models\SubConstructionService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use App\Traits\HttpResponses;

class ConstructionServiceController extends Controller
{
    use HttpResponses;
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
            'image' => ['required', 'file', 'mimes:jpeg,png,jpg,gif', 'max:4048'],
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

    public function updateService(Request $request, $id)
    {
        $validatedData = $request->validate([
            'name' => 'unique:construction_services|max:255',
            'description' => 'max:255',
            'image' => ['file', 'mimes:jpeg,png,jpg,gif', 'max:4048'],
        ]);
        $service = ConstructionService::find($id);
        if (!$service) {
            // If the real estate is not found, return a 404 response
            return $this->error('', 'service not found', 404);
        }
        $updatedFields = [];

        if ($request->file('image')) {
            $image = $request->file('image');
            $oldImagePath = str_replace('storage/', 'public/', $service->image);

            if ($oldImagePath && Storage::exists($oldImagePath)) {
                // Delete the previous image if it exists
                Storage::delete($oldImagePath);
            }
            // Store the new image and update the 'image' field in the updated fields array
            $imagePath = $image->store('public/images/types');
            $updatedFields['image'] = str_replace('public/', 'storage/', $imagePath);
        }
        if ($request->has('name')) {
            $updatedFields['name'] = $request->name;
        }

        if ($request->has('description')) {
            $updatedFields['description'] = $request->description;
        }
        $service->fill(array_filter($updatedFields));
        $service->save();
        return new ConstructionServiceResource($service);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(ConstructionService $service)
    {

        if (!$service) {
            return $this->error('', 'service not found', 404);
        } else {
            $imagePath = str_replace('storage/', 'public/', $service->image);
            Storage::delete($imagePath);
            $service->delete();

            return $this->success([
                'message' => 'The service has been deleted successfully',
            ]);

        }
    }

    public function showSubServices($constructionServiceId)
    {
        $subServices = SubConstructionService::where('construction_service_id', $constructionServiceId)->get();

        return SubConstructionServiceResource::collection($subServices);
    }
}