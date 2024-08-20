<?php

namespace App\Http\Requests\company;

use Illuminate\Foundation\Http\FormRequest;

class updateCompanyRequest extends FormRequest
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
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'first_name' => 'sometimes|string|max:255',
            'last_name' => 'sometimes|string|max:255',
            'email' => 'sometimes|email|max:255',
            'password' => 'sometimes|string|lowercase|email|max:255| unique:companies,email',
            'phone_number' => 'sometimes|digits:10|numeric',
            'company_name' => 'sometimes|string|max:255',
            'registration_number' => 'sometimes|string|max:255',
            'location' => 'sometimes',
            'city' => 'sometimes',
            'country' => 'sometimes',
            'description' => 'sometimes',
            'accept_privacy' => 'sometimes',
            'image' => 'sometimes',
            'cover_image' => 'sometimes',
            'work_hours' => 'sometimes|array',
            'work_hours.*.day' => 'sometimes|max:255',
            'work_hours.*.hours_from' => 'sometimes|date_format:H:i',
            'work_hours.*.hours_to' => 'sometimes|date_format:H:i',
        ];
    }
}
