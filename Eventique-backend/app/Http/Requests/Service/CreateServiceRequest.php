<?php

namespace App\Http\Requests\Service;

use Illuminate\Foundation\Http\FormRequest;

class CreateServiceRequest extends FormRequest
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
            'price' => 'required|numeric',
            'category_id' => 'required|exists:categories,id',
            'name' => 'required',
            'description' => 'required',
            'images' => 'required|array|min:1',
            'discounted_packages' => 'boolean',
//            deletethis
            'company_id' => ''
        ];
    }
}
