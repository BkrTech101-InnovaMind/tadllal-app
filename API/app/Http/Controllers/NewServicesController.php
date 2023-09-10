<?php

namespace App\Http\Controllers;

use App\Http\Resources\NewServicesResource;
use App\Models\NewServices;
use Illuminate\Http\Request;
use App\Traits\HttpResponses;

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
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
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