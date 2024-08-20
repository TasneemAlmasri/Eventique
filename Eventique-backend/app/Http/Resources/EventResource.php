<?php
namespace App\Http\Resources;

use App\Constants\Constants;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class EventResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {

        $services = $this->orders->flatMap(function ($order) {
            return $order->services->filter(function ($service) {
                // Decode JSON status into an associative array
                $status = json_decode($service->pivot->status, true);
                return $status['en'] === Constants::SERVICE_ORDER_STATUSES['ACCEPTED']['en'];
            });
        });

        $customizedServices = $this->orders->flatMap(function ($order) {
            return $order->customizedServices->filter(function ($customizedService) {
                // Decode JSON status into an associative array
                $status = json_decode($customizedService->status, true);
                return $status['en'] === Constants::SERVICE_ORDER_STATUSES['ACCEPTED']['en'];
            });
        });

        return [
            'id' => $this->id,
            'name' => $this->name,
            'date' => $this->date,
            'time' => $this->time,
            'budget' => $this->budget,
            'guests' => $this->guests,
            'status' => $this->status,
            'event_type_id' => $this->event_type_id,
            'user_id' => $this->user_id,
            'services' => ServiceResource::collection($services),
            'customized_services' => CustomizedServiceResource::collection($customizedServices),
        ];
    }
}
