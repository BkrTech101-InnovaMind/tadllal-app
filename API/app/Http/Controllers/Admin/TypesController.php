<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Support\Str;
use App\Http\Controllers\Controller;
use App\Http\Resources\TypesResource;
use App\Models\Rtypes;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use App\Traits\HttpResponses;

class TypesController extends Controller
{
    use HttpResponses;
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
            'image' => ['file', 'mimes:jpeg,png,jpg,gif', 'max:4048'],
        ]);

        $imagePath = $request->file('image')->store('public/images/types');
        $newType = Rtypes::create([
            'name' => $request->name,
            'image' => str_replace('public/', 'storage/', $imagePath),
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
    public function updateTypes(Request $request, $id)
    {
        $validatedData = $request->validate([
            'name' => 'unique:rtypes|max:255',
            'image' => ['file', 'mimes:jpeg,png,jpg,gif', 'max:4048'],
        ]);
        $Types = Rtypes::find($id);
        if (!$Types) {
            // If the real estate is not found, return a 404 response
            return $this->error('', 'type not found', 404);
        }
        $updatedFields = [];

        if ($request->file('image')) {
            $image = $request->file('image');
            $oldImagePath = str_replace('storage/', 'public/', $Types->image);

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
        $Types->fill(array_filter($updatedFields));
        $Types->save();
        return new TypesResource($Types);
    }
    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Rtypes $type)
    {
        try {
            if (!$type) {
                return $this->error('', 'Type not found', 404);
            }

            $imagePath = str_replace('storage/', 'public/', $type->image);
            Storage::delete($imagePath);
            $type->delete();

            return $this->success([
                'message' => 'The type has been deleted successfully',
            ]);
        } catch (\Exception $e) {
            if (Str::contains($e->getMessage(), 'Integrity constraint violation')) {
                return $this->error('Cannot delete this type due to foreign key constraints', '', 400);
            }

            return $this->error('An error occurred while deleting the type', '', 500);
        }
    }
}