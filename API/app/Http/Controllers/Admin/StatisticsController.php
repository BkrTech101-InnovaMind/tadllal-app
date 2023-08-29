<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\OrdersResource;
use App\Http\Resources\RealEstateResource;
use App\Http\Resources\ServicesOrdersResource;
use App\Models\Orders;
use App\Models\RealEstate;
use App\Models\ServicesOrders;
use App\Models\SubConstructionService;

class StatisticsController extends Controller
{
    public function getStatistics()
    {
        $realEstatesCount = RealEstate::count();
        $mainServicesCount = SubConstructionService::count();
        $subServicesCount = SubConstructionService::count();
        $totalServices= $mainServicesCount+$subServicesCount;
        $realEstateOrdersCount = Orders::count();
        $serviceOrdersCount = ServicesOrders::count();
        $totalOrders=$realEstateOrdersCount+$serviceOrdersCount;

        $latestRealEstateOrders = OrdersResource::collection(Orders::orderBy('created_at', 'desc')->take(10)->get());
        $latestServiceOrders = ServicesOrdersResource::collection(ServicesOrders::orderBy('created_at', 'desc')->take(10)->get());
        $latestRealEstates = RealEstateResource::collection(RealEstate::orderBy('created_at', 'desc')->take(10)->get());

        $statistics = [
            'realEstatesCount' => $realEstatesCount,
            'mainServicesCount' => $mainServicesCount,
            'subServicesCount' => $subServicesCount,
            'realEstateOrdersCount' => $realEstateOrdersCount,
            'serviceOrdersCount' => $serviceOrdersCount,
            'totalServices'=>$totalServices,
            'totalOrders'=>$totalOrders,
            'latestRealEstateOrders' => $latestRealEstateOrders,
            'latestServiceOrders' => $latestServiceOrders,
            'latestRealEstates' => $latestRealEstates,
          
        ];

        return response()->json($statistics);
    }
}
