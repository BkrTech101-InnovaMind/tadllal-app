<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class CustomersRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array|string>
     */
    public function rules(): array
    {
        return [
            'customer_name' => ['required', 'string', 'max:255'],
            'customer_number' => ['required', 'string', 'max:255'],
            'location_id' => ['required', 'exists:rlocations,id'],
            'type_id' => ['required', 'exists:rtypes,id'],
            'property' => ['required', 'string'],
            'budget_from' => ['required', 'integer'],
            'budget_to' => ['required', 'integer'],
            'currency' => ['required', Rule::in(['SAR', 'YER', 'USD'])],
            'other_details' => ['nullable', 'string'],
        ];
    }
}