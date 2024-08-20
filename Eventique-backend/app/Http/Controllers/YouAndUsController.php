<?php

namespace App\Http\Controllers;

use App\Http\Requests\CreateShareEventRequest;
use App\Http\Resources\ServiceResource;
use App\Models\Event;
use App\Models\YouAndUs;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class YouAndUsController extends Controller
{
    public function index()
    {
        // $all = YouAndUs::paginate(10);
        $all = YouAndUs::with('images')->get();
        return success($all);
    }
    public function store(CreateShareEventRequest $request)
    {
        $data = $request->validated();
        $event = Event::where('id', $data['event_id'])->first();
        if($event->status == 'completed'){
            $youAndUs = YouAndUs::create($data);
            foreach($data['images'] as $image)
                $youAndUs->images()->create(['url' => $image]);
            return success($youAndUs,200,['images' => $youAndUs->images]);
        }
        return error('The event did not complete yet!');
    }

    public function show(YouAndUs $youAndUs)
    {
        $event = $youAndUs->event;
        if ($event) {
            $services = $event->orders->flatMap(function ($order) {
                return $order->services;
            });
            return response( [
                'id' => $youAndUs->id,
                'description'=> $youAndUs->description,
                'images' => $youAndUs->images,
                'services' => ServiceResource::collection($services),
            ]);
        }

        return response()->json(['error' => 'Event not found'], 404);
    }

    public function destroy(YouAndUs $youAndUs)
    {
        if(Auth::user()->id == $youAndUs->event->user_id){
            $youAndUs->deleteOrFail();
            return success();
        }
        return error('invalid id');

    }
    public function getYouAndUsByUser($user_id)
    {
        $youandusRecords = YouAndUs::whereHas('event', function ($query) use ($user_id) {
            $query->where('user_id', $user_id);
        })->with('event')->get();

        return response()->json([
            'youandus' => $youandusRecords,
        ]);
    }
}
