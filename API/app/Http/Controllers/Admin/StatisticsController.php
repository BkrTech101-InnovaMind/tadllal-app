<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\NewServicesOrdersResource;
use App\Http\Resources\OrdersResource;
use App\Http\Resources\RealEstateResource;
use App\Http\Resources\ServicesOrdersResource;
use App\Http\Resources\StatisticsResource;
use App\Models\NewServices;
use App\Models\NewServicesOrders;
use App\Models\Orders;
use App\Models\RealEstate;
use App\Models\ServicesOrders;
use App\Models\SubConstructionService;
use App\Traits\HttpResponses;

class StatisticsController extends Controller
{
    use HttpResponses;
    public function getStatistics()
    {
        $realEstatesCount = RealEstate::count();
        // $mainServicesCount = SubConstructionService::count();
        // $subServicesCount = SubConstructionService::count();
        $services = NewServices::count();
        // $totalServices= $mainServicesCount+$subServicesCount;
        $realEstateOrdersCount = Orders::count();
        // $serviceOrdersCount = ServicesOrders::count();
        $serviceOrdersCount = NewServicesOrders::count();
        $totalOrders = $realEstateOrdersCount + $serviceOrdersCount;

        $latestRealEstateOrders = OrdersResource::collection(Orders::orderBy('created_at', 'desc')->take(10)->get());
        // $latestServiceOrders = ServicesOrdersResource::collection(ServicesOrders::orderBy('created_at', 'desc')->take(10)->get());
        $latestServiceOrders = NewServicesOrdersResource::collection(NewServicesOrders::orderBy('created_at', 'desc')->take(10)->get());
        $latestRealEstates = RealEstateResource::collection(RealEstate::orderBy('created_at', 'desc')->take(10)->get());

        $statistics = [

            'realEstatesCount' => $realEstatesCount,
            // 'mainServicesCount' => $mainServicesCount,
            // 'subServicesCount' => $subServicesCount,
            'realEstateOrdersCount' => $realEstateOrdersCount,
            'serviceOrdersCount' => $serviceOrdersCount,
            // 'totalServices' => $totalServices,
            'totalServices' => $services,
            'totalOrders' => $totalOrders,
            'latestRealEstateOrders' => $latestRealEstateOrders,
            'latestServiceOrders' => $latestServiceOrders,
            'latestRealEstates' => $latestRealEstates,

        ];

        return new StatisticsResource($statistics);
    }
    // return response()->json($statistics);

}