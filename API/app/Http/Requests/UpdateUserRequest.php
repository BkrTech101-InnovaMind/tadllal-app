<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rules\Password;

class UpdateUserRequest extends FormRequest
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
            'name' => ['nullable', 'string', 'max:255'],
            'email' => ['nullable', 'string', 'max:255', 'unique:users'],
            'password' => ['nullable', 'confirmed', Password::defaults()],
            'role' => ['nullable', 'string', 'in:user,marketer,company'],
            'phone' => ['nullable', 'string', 'max:20'],
            'avatar' => ['nullable', 'file', 'mimes:jpeg,png,jpg,gif', 'max:4048'],
        ];
    }
}