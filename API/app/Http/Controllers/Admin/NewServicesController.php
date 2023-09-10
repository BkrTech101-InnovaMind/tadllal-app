<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Traits\HttpResponses;
use App\Http\Resources\NewServicesResource;
use App\Models\NewServices;
use Illuminate\Support\Facades\Storage;

class NewServicesController extends Controller
{
    use HttpResponses;
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return NewServicesResource::collection(
            NewServices::get()
        );
    }

    public function getServicesByType(int $type)
    {
        if ($type !== 1 && $type !== 2) {
            return $this->error('', 'plese select type 1 or 2 ', 400);
        }
        $services = NewServices::where('type', $type)->get();
        return NewServicesResource::collection($services);
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
            'name' => 'required|unique:new_services|max:255',
            'description' => 'required|max:255',
            'image' => ['required', 'file', 'mimes:jpeg,png,jpg,gif', 'max:4048'],
            'type' => 'required|in:1,2',
        ]);

        $imagePath = $request->file('image')->store('public/images/newServices');
        $newType = NewServices::create([
            'name' => $request->name,
            'description' => $request->description,
            'image' => str_replace('public/', 'storage/', $imagePath),
            'type' => $request->type,
        ]);

        return new NewServicesResource($newType);
    }

    /**
     * Display the specified resource.
     */
    public function show(NewServices $service)
    {
        return new NewServicesResource($service);
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
            'name' => 'unique:new_services|max:255',
            'description' => 'max:255',
            'image' => ['file', 'mimes:jpeg,png,jpg,gif', 'max:4048'],
            'type' => 'in:1,2',
        ]);
        $service = NewServices::find($id);
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

        if ($request->has('type')) {
            $updatedFields['type'] = $request->type;
        }
        $service->fill(array_filter($updatedFields));
        $service->save();
        return new NewServicesResource($service);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(NewServices $service)
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
}