<?php

namespace App\Http\Resources;

use App\Models\Company;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\App;
use Stichoza\GoogleTranslate\GoogleTranslate;

class CompanyResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $locale = App::getLocale() ?? 'en';
        return [
            'id' => $this->id,
            'first_name' => $this->first_name,
            'last_name' => $this->last_name,
            'email' => $this->email,
            'phone_number' => $this->phone_number,
            'company_name' => $this->company_name,
            'registration_number' => $this->registration_number,
            'location' => $this->getTranslation('location',$locale),
            'city' => $this->getTranslation('city',$locale),
            'country' => $this->getTranslation('country',$locale),
            'description' => $this->getTranslation('description',$locale),
            'accept_privacy' => $this->accept_privacy,
            'images' => ImageResource::collection($this->images),
            'workHours' => WorkHoursResource::collection($this->workHours),
        ];
    }
}
