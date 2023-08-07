<?php

namespace App\Http\Controllers;

use App\Http\Resources\TypesResource;
use App\Models\Rtypes;
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

}