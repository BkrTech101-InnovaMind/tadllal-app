<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateRealEstateRequest extends FormRequest
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
            'name' => ['string', 'max:255'],
            'description' => ['string'],
            'price' => ['integer'],
            'location' => ['integer'],
            'firstType' => ['integer'],
            'photo' => ['file', 'mimes:jpeg,png,jpg,gif', 'max:4048'],
            'locationInfo' => ['string', 'max:255'],
            'secondType' => ['string'],
            'state' => ['string'],
            'images.*' => ['file', 'mimes:jpeg,png,jpg,gif', 'max:4048'],
        ];
    }
}