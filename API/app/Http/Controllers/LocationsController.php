<?php

namespace App\Http\Controllers;

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


}