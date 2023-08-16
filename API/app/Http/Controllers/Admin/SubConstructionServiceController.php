<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use App\Models\SubConstructionService;
use App\Http\Resources\SubConstructionServiceResource;
use App\Traits\HttpResponses;

class SubConstructionServiceController extends Controller
{
    use HttpResponses;
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return SubConstructionServiceResource::collection(
            SubConstructionService::get()
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
            'name' => 'required|max:255',
            'description' => 'required|max:255',
            'image' => ['required', 'file', 'mimes:jpeg,png,jpg,gif', 'max:4048'],
            'construction_service_id' => 'required|exists:construction_services,id',
        ]);

        $imagePath = $request->file('image')->store('public/images/subConstructionServices');
        $newSubService = SubConstructionService::create([
            'name' => $request->name,
            'description' => $request->description,
            'image' => str_replace('public/', 'storage/', $imagePath),
            'construction_service_id' => $request->construction_service_id,
        ]);

        return new SubConstructionServiceResource($newSubService);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $subService = SubConstructionService::find($id);
        if (!$subService) {
            return $this->error('', 'Sub-service not found', 404);
        } else {
            return new SubConstructionServiceResource($subService);
        }
    }

    public function updateSubService(Request $request, $id)
    {
        $validatedData = $request->validate([
            'name' => 'max:255',
            'description' => 'max:255',
            'image' => ['file', 'mimes:jpeg,png,jpg,gif', 'max:4048'],
            'construction_service_id' => 'exists:construction_services,id',
        ]);

        $subService = SubConstructionService::find($id);

        if (!$subService) {
            return $this->error('', 'Sub-service not found', 404);
        }

        $updatedFields = [];

        if ($request->file('image')) {
            $image = $request->file('image');
            $oldImagePath = str_replace('storage/', 'public/', $subService->image);

            if ($oldImagePath && Storage::exists($oldImagePath)) {
                Storage::delete($oldImagePath);
            }

            $imagePath = $image->store('public/images/subTypes');
            $updatedFields['image'] = str_replace('public/', 'storage/', $imagePath);
        }

        if ($request->has('name')) {
            $updatedFields['name'] = $request->name;
        }

        if ($request->has('description')) {
            $updatedFields['description'] = $request->description;
        }
        if ($request->has('construction_service_id')) {
            $updatedFields['construction_service_id'] = $request->construction_service_id;
        }
        $subService->fill(array_filter($updatedFields));
        $subService->save();

        return new SubConstructionServiceResource($subService);
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
    public function destroy(SubConstructionService $subService)
    {
        if (!$subService) {
            return $this->error('', 'Sub-service not found', 404);
        } else {
            $imagePath = str_replace('storage/', 'public/', $subService->image);
            Storage::delete($imagePath);
            $subService->delete();

            return $this->success([
                'message' => 'The sub-service has been deleted successfully',
            ]);
        }
    }
}