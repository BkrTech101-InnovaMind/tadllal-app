<?php

namespace App\Http\Controllers;

use App\Models\ServicesOrders;
use App\Models\SubConstructionService;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use App\Http\Resources\OrdersResource;
use App\Models\Orders;
use App\Models\RealEstate;
use Illuminate\Support\Facades\Auth;
use App\Traits\HttpResponses;

class OrdersController extends Controller
{
    use HttpResponses;
    public function submitOrder(Request $request, $realEstateId)
    {

        $user = Auth::user();
        try {
            $realEstate = RealEstate::findOrFail($realEstateId);
        } catch (ModelNotFoundException $exception) {
            return $this->error('Error', ['message' => 'RealEstate not found..'], 404);
        }
        // Validation rules
        $validatedData = $request->validate([
            'message' => 'required|string|max:255',
        ], [
            'message.required' => 'The message field is required.',
            'message.string' => 'The message field must be a string.',
            'message.max' => 'The message field should not exceed 255 characters.',
        ]);

        // Save order information in the "orders" table
        Orders::create([
            'user_id' => $user->id,
            'real_estate_id' => $realEstate->id,
            'message' => $validatedData['message'],
        ]);

        return $this->success([
            'message' => 'Your order has been submitted successfully.',
        ]);
    }

    public function submitServiceOrder(Request $request, $serviceId)
    {

        $user = Auth::user();
        try {
            $service = SubConstructionService::findOrFail($serviceId);
        } catch (ModelNotFoundException $exception) {
            return $this->error('Error', ['message' => 'Service not found..'], 404);
        }
        // Validation rules
        $validatedData = $request->validate([
            'message' => 'required|string|max:255',
        ], [
            'message.required' => 'The message field is required.',
            'message.string' => 'The message field must be a string.',
            'message.max' => 'The message field should not exceed 255 characters.',
        ]);

        // Save order information in the "orders" table
        ServicesOrders::create([
            'user_id' => $user->id,
            'sub_construction_services_id' => $service->id,
            'message' => $validatedData['message'],
        ]);

        return $this->success([
            'message' => 'Your order has been submitted successfully.',
        ]);
    }


}