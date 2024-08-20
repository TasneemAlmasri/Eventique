<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CustomizedServiceResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $locale = app()->getLocale();

        // Decode the JSON fields
        $status = $this->status ? json_decode($this->status, true) : [];
        $description = $this->description ? json_decode($this->description, true) : [];

        return [
            'customized_service_id' => $this->id,
            'price' => $this->price,
            'description' => $description[$locale] ?? null,
            'status' => $status[$locale],
            'user_id' => $this->user_id,
            'order_id' => $this->order_id,
            'service_name' => $this->service->name,
            'service_images' => ImageResource::collection($this->service->images),
        ];
    }
}
