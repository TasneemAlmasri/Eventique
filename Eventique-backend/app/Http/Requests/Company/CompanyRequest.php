<?php

namespace App\Http\Requests\Company;

use Illuminate\Foundation\Http\FormRequest;

class CompanyRequest extends FormRequest
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
            'first_name' => ['required', 'string', 'max:255'],
            'last_name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'lowercase', 'email', 'max:255', 'unique:companies,email'],
            'password' => ['required', 'min:6', 'max:14', 'confirmed'],
            'phone_number' => ['required', 'digits:10', 'numeric'],
            'company_name' => ['required', 'string', 'max:255'],
            'registration_number' => ['required', 'string', 'max:255'],
            'location' => ['required'],
            'city' => ['required'],
            'country' => ['required'],
            'description' => ['required'],
            'accept_privacy' => ['required'],
            'work_hours' => ['required','array'],
            'work_hours.*.day' => ['required','max:255'],
            'work_hours.*.hours_from' => ['required','date_format:H:i'],
            'work_hours.*.hours_to' => ['required','date_format:H:i'],
        ];
    }
}
