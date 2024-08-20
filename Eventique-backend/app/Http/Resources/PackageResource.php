<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PackageResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'old_price' => $this->old_price,
            'new_price' => $this->new_price,
            'name' => $this->eventType->name,
            'image' => $this->images,
            'services' => ServiceResource::collection($this->services),
        ];
    }
}
