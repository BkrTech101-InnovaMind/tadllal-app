<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\OrdersResource;
use App\Models\Orders;
use Illuminate\Http\Request;
use App\Traits\HttpResponses;

class OrdersController extends Controller
{
    use HttpResponses;
    public function getAllOrders()
    {
        $orders = Orders::with('user', 'realEstate')->get();

        return $this->success([
            'orders' => OrdersResource::collection($orders),
        ]);
    }

    public function approveOrder($orderId)
    {
        $order = Orders::find($orderId);

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

    public function getApprovedOrders()
    {
        $approvedOrders = Orders::where('status', 'Approved')->with('user', 'realEstate')->get();

        return $this->success([
            'approvedOrders' => OrdersResource::collection($approvedOrders),
        ]);
    }

    public function getPendingOrders()
    {
        $pendingOrders = Orders::where('status', 'Under Review')->with('user', 'realEstate')->get();

        return $this->success([
            'pendingOrders' => OrdersResource::collection($pendingOrders),
        ]);
    }

    public function destroyOrder($orderId)
    {
        $order = Orders::find($orderId);

        if (!$order) {
            return $this->error('', 'Order not found', 404);
        }

        $order->delete();

        return $this->success([
            'message' => 'Order has been deleted successfully',
        ]);
    }

}