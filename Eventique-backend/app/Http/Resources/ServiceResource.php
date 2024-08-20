<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ServiceResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $locale = app()->getLocale();

        // Decode the status JSON
        $status = json_decode($this->pivot ? $this->pivot->status : null, true);

        return [
            'id' => $this->id,
            'name' => $this->name,
            'price' => $this->price,
            'description' => $this->description,
            'discounted_packages' => $this->discounted_packages,
            'activation' => $this->activation,
            'category_id' => $this->category_id,
            'company_name' => $this->company->company_name,
            'images' => ImageResource::collection($this->images),
            'average_rating' => $this->average_rating,
            ////////انا ضفتهم يارب ما يخربو شي
            // 'status' => $status ? $status[$locale] : null,
            'status' => $status[$locale] ?? null,
            'quantity' => $this->pivot ? $this->pivot->quantity : null,
            'priceinpivot' => $this->pivot ? $this->pivot->price : null,
        ];
    }
}
