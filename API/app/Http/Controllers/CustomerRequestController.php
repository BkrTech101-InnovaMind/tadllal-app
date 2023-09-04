<?php

namespace App\Http\Controllers;

use App\Http\Resources\CustomersRequestResource;
use App\Http\Resources\CustomersResource;
use App\Models\Customers;
use App\Models\CustomersRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Traits\HttpResponses;

class CustomerRequestController extends Controller
{
    use HttpResponses;
    public function createCustomer(\App\Http\Requests\CustomersRequest $request)
    {
        $request->validated($request->all());
        $user = Auth::user();


        if ($user->role !== 'marketer' && $user->role !== 'company') {
            return $this->error('Error', ['message' => 'Unauthorized..'], 401);
        }




        $customer = Customers::create([
            'user_id' => $user->id,
            'customer_name' => $request->customer_name,
            'customer_number' => $request->customer_number,

        ]);


        $customerId = $customer->id;



        $this->createCustomerRequest($customerId, $request);
        return $this->success([
            'message' => 'Customer and request created successfully'
        ]);
    }

    public function createCustomerRequest($customerId, \App\Http\Requests\CustomersRequest $request)
    {
        $request->validated($request->all());
        // التحقق من الهوية للمستخدم الحالي
        $user = Auth::user();

        // التحقق من دور المستخدم (يجب أن يكون مسوقًا أو شركة)
        if ($user->role !== 'marketer' && $user->role !== 'company') {
            return $this->error('Error', ['message' => 'Unauthorized..'], 401);
        }



        // إنشاء طلب العميل مع استخدام معرف العميل وبقية تفاصيل الطلب
        CustomersRequest::create([
            'user_id' => $user->id,
            'customer_id' => $customerId,
            'location_id' => $request->location_id,
            'type_id' => $request->type_id,
            'property' => $request->property,
            'budget_from' => $request->budget_from,
            'budget_to' => $request->budget_to,
            'currency' => $request->currency,
            'other_details' => $request->other_details,
            'request_status' => 'pending',
            // افتراضيًا في انتظار المراجعة
            'communication_status' => 'pending', // افتراضيًا في انتظار التواصل
        ]);
    }

    public function getAllCustomerRequests()
    {
        $customerRequests = CustomersRequest::all();
        return CustomersRequestResource::collection($customerRequests);
    }
    public function getCustomersWithUsers()
    {
        $customers = Customers::with('user')->get();
        return CustomersResource::collection($customers);
    }
    public function updateCustomerRequestDetails(Request $request, $id)
    {
        $validatedData = $request->validate([
            'other_details' => 'required',
            '|max:255',
        ]);
        $cust = CustomersRequest::find($id);
        if (!$cust) {
            return $this->error('Error', ['message' => 'Customers Request not found..'], 404);
        }
        if (!empty($validatedData)) {

            $cust->update($validatedData);

            return $this->success([
                'message' => 'Customer details updated successfully'
            ]);
        }


        return $this->error('Error', ['message' => 'details not found..'], 401);
    }

    public function updateFirstRequestStatus(Request $request, $id)
    {
        $request->validate([
            'request_status' => 'required|in:pending,review,communicated',
        ]);

        $customerRequest = CustomersRequest::find($id);
        if (!$customerRequest) {
            return $this->error('Error', ['message' => 'Customers Request not found'], 404);
        }

        $customerRequest->update(['request_status' => $request->request_status]);
        return $this->success([
            'message' => 'Customers Request status updated successfully'
        ]);
    }


    public function updateSecondRequestStatus(Request $request, $id)
    {
        $request->validate([
            'communication_status' => 'required|in:pending,successful,unsuccessful',
        ]);

        $customerRequest = CustomersRequest::find($id);
        if (!$customerRequest) {
            return $this->error('Error', ['message' => 'Customers Request not found'], 404);
        }

        $customerRequest->update(['communication_status' => $request->communication_status]);
        return $this->success([
            'message' => 'Customers Request Communication status updated successfully'
        ]);
    }


}