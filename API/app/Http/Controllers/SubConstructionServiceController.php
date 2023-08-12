<?php

namespace App\Http\Controllers;

use App\Http\Resources\SubConstructionServiceResource;
use App\Models\ConstructionService;
use App\Models\SubConstructionService;
use Illuminate\Http\Request;

class SubConstructionServiceController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return SubConstructionServiceResource::collection(
            SubConstructionService::get()
        );
    }

    public function showSubServices($constructionServiceId)
    {
        $subServices = SubConstructionService::where('construction_service_id', $constructionServiceId)->get();

        return SubConstructionServiceResource::collection($subServices);
    }
}