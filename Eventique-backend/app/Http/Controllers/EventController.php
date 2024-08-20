<?php

namespace App\Http\Controllers;

use App\Http\Requests\Event\CreateEventRequest;
use App\Http\Requests\Event\UpdateEventRequest;
use App\Http\Resources\EventResource;
use App\Models\Event;
use App\Models\EventType;
use App\Services\Api\SendNotification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Kreait\Firebase\Messaging;

class EventController extends Controller
{
    public function index()
    {
        return EventResource::collection(Auth::user()->events);
    }
    public function indexPlanning()
    {
        $events = Auth::user()->events()->where('status', 'planning')->get();

        foreach ($events as $event) {
            $eventDateTime = \Carbon\Carbon::parse($event->date . ' ' . $event->time);
            $now = \Carbon\Carbon::now();

            if ($eventDateTime->lessThanOrEqualTo($now)) {
                $allOrdersCompleted = $event->orders()->where('status', '!=', 'processed')->count() == 0;

                if ($allOrdersCompleted) {
                    $event->update(['status' => 'completed']);
                }
            }
        }

        return success(EventResource::collection(Auth::user()->events()->where('status', 'planning')->get()));
    }
    public function indexCompleted()
    {
        // $planning = EventResource::collection(Auth::user()->events()->where('status', 'planning')->paginate(10));
//        $planning = EventResource::collection(Auth::user()->events()->where('status', 'planning')->get());
        // $completed = EventResource::collection(Auth::user()->events()->where('status', 'completed')->paginate(10));
//        $completed = EventResource::collection(Auth::user()->events()->where('status', 'completed')->get());
        return success(EventResource::collection(Auth::user()->events()->where('status', 'completed')->get()));
    }
    public function store(CreateEventRequest $request)
    {
        $data = $request->validated();
        $data['user_id'] = Auth::user()->id;
        $data['status'] = 'planning';
        $event = Event::create($data);

        return success(new EventResource($event));
    }
    public function show(Event $event)
    {
        return success(new EventResource($event));
    }
    public function update(UpdateEventRequest $request, Event $event)
    {
        $data = $request->validated();
        $event->update($data);
        return success(new EventResource($event));
    }

    public function destroy(Event $event)
    {
        if($event->user_id == Auth::user()->id)
        {
            $event->delete();
            return success();
        }
        return error('Invalid event id');
    }

}
