<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreRealEstateRequest extends FormRequest
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
            'name' => ['required', 'string', 'max:255'],
            'description' => ['required', 'string'],
            'price' => ['integer', 'required'],
            'location' => ['required', 'integer'],
            'photo' => ['required', 'file', 'mimes:jpeg,png,jpg,gif', 'max:4048'],
            'firstType' => ['required', 'integer'],
            'locationInfo' => ['required', 'string', 'max:255'],
            'secondType' => ['required', 'string', Rule::in(['for sale', 'for rent'])],
            'images.*' => ['file', 'mimes:jpeg,png,jpg,gif', 'max:4048'],
        ];
    }
}