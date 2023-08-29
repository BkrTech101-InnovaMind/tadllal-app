<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\ServicesOrdersResource;
use App\Models\ServicesOrders;
use App\Traits\HttpResponses;

class ServicesOrdersController extends Controller
{
    use HttpResponses;
    public function getAllServicesOrders()
    {
        $orders = ServicesOrders::with('user', 'subConstructionService')->get();

        return $this->success([
            'orders' => ServicesOrdersResource::collection($orders),
        ]);
    }

    public function approveServiceOrder($orderId)
    {
        $order = ServicesOrders::find($orderId);

        if (!$order) {
            return $this->error('', 'Order not found', 404);
        }

        if ($order->status == 'Under Review') {
            $order->status = 'Approved';
        } else {
            $order->status = 'Under Review';
        }

        $order->save();

        return $this->success([
            'message' => 'Order has been approved successfully',
        ]);
    }

    public function getApprovedServiceOrders()
    {
        $approvedOrders = ServicesOrders::where('status', 'Approved')->with('user', 'subConstructionService')->get();

        return $this->success([
            'approvedOrders' => ServicesOrdersResource::collection($approvedOrders),
        ]);
    }

    public function getPendingServiceOrders()
    {
        $pendingOrders = ServicesOrders::where('status', 'Under Review')->with('user', 'subConstructionService')->get();

        return $this->success([
            'pendingOrders' => ServicesOrdersResource::collection($pendingOrders),
        ]);
    }

    public function destroyServiceOrder($orderId)
    {
        $order = ServicesOrders::find($orderId);

        if (!$order) {
            return $this->error('', 'Order not found', 404);
        }

        $order->delete();

        return $this->success([
            'message' => 'Order has been deleted successfully',
        ]);
    }
}