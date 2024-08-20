<?php

namespace App\Http\Controllers;

use App\Http\Requests\EventType\CreateEvTyRequest;
use App\Http\Requests\EventType\UpdateEvTyRequest;
use App\Http\Resources\EventTypeResource;
use App\Models\EventType;
use Illuminate\Http\Request;
use Stichoza\GoogleTranslate\GoogleTranslate;

class EventTypeController extends Controller
{
    public function index()
    {
        return success(EventTypeResource::collection(EventType::all()));
    }
    public function store(CreateEvTyRequest $request)
    {
        // check if it is the admin
        // if()
        $data = $request->validated();
        $currentLocale = app()->getLocale();
        $targetLocale = ($currentLocale === 'en') ? 'ar' : 'en';
        
        $lang = new GoogleTranslate($currentLocale);
        $lang->setSource($currentLocale)->setTarget($targetLocale);
        $data['name'] = [
            $currentLocale => $data['name'],
            $targetLocale => $lang->translate($data['name'])
        ];
        $type = EventType::create($data);
        return success(new EventTypeResource($type));
    }
    public function show(EventType $event_type)
    {
        return new EventTypeResource($event_type);
    }
    public function update(UpdateEvTyRequest $request, EventType $event_type)
    {
        $data = $request->validated();
        $currentLocale = app()->getLocale();
        $targetLocale = ($currentLocale === 'en') ? 'ar' : 'en';
        $lang = new GoogleTranslate($currentLocale);
        $lang->setSource($currentLocale)->setTarget($targetLocale);
        $data['name'] = [
            $currentLocale => $data['name'],
            $targetLocale => $lang->translate($data['name'])
        ];
        $event_type->update($data);
        return success(new EventTypeResource($event_type));
    }
    public function destroy(EventType $event_type)
    {
        $event_type->delete();
        return success();
    }
}
