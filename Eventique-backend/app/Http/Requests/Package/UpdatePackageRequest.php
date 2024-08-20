<?php

namespace App\Http\Requests\Package;

use Illuminate\Foundation\Http\FormRequest;

class UpdatePackageRequest extends FormRequest
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
            'old_price' => '',
            'new_price' => '',
            'event_type_id' => 'exists:event_types,id',
            'image' => '',
            'services' => 'array|min:1',
            'services.*.id' => 'exists:services,id',
            'delete_services' => 'array',
            'delete_services.*' => 'exists:package_service,service_id,package_id, '. $this->route('package')->id,
        ];
    }

}
