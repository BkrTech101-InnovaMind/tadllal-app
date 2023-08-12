<?php

namespace App\Http\Controllers;

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

}