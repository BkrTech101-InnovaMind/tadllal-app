<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class StatisticsResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'statistics' => [
                'realEstatesCount' => $this->resource['realEstatesCount'],
                // 'mainServicesCount' => $this->resource['mainServicesCount'],
                // 'subServicesCount' => $this->resource['subServicesCount'],
                'realEstateOrdersCount' => $this->resource['realEstateOrdersCount'],
                'serviceOrdersCount' => $this->resource['serviceOrdersCount'],
                'totalServices' => $this->resource['totalServices'],
                'totalOrders' => $this->resource['totalOrders'],
            ],
            'latestRealEstateOrders' => $this->resource['latestRealEstateOrders'],
            'latestServiceOrders' => $this->resource['latestServiceOrders'],
            'latestRealEstates' => $this->resource['latestRealEstates'],
        ];
    }
}