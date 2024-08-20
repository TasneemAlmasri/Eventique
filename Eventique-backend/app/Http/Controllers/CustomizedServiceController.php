<?php

namespace App\Http\Controllers;

use App\Constants\Constants;
use App\Http\Resources\CustomizedServiceResource;
use App\Models\CustomizedService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Stichoza\GoogleTranslate\GoogleTranslate;

class CustomizedServiceController extends Controller
{
//    public function store(Request $request){
//        $currentLocale = app()->getLocale();
//        $targetLocale = ($currentLocale === 'en') ? 'ar' : 'en';
//        $lang = new GoogleTranslate($currentLocale);
//        $lang->setSource($currentLocale)->setTarget($targetLocale);
//
//        $validated = $request->validate([
//            'price' => 'required|integer|min:1',
//            'description' => 'required',
//            //'user_id' => 'required|exists:users,id',
//            'service_id' => 'required|exists:services,id'
//        ]);
//        $validated['description'] = [
//            $currentLocale => $validated['description'],
//            $targetLocale => $lang->translate($validated['description'])
//        ];
//        $validated['status'] = json_encode(Constants::SERVICE_ORDER_STATUSES['PENDING']);
//        $customizeService = CustomizedService::create($validated);
//        return success(CustomizedServiceResource::make($customizeService));
//    }
    public function store(Request $request)
    {
        // Validate the request
        $validator = Validator::make($request->all(), [
            'price' => 'required|numeric|min:0',
            'description' => 'required|string',
            'service_id' => 'required|exists:services,id',
            'order_id' => 'sometimes|exists:orders,id',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $currentLocale = app()->getLocale();
        $targetLocale = ($currentLocale === 'en') ? 'ar' : 'en';
        $translator = new GoogleTranslate($currentLocale);
        $translator->setSource($currentLocale)->setTarget($targetLocale);

        $user = Auth::user();
        $description = [
            $currentLocale => $request->input('description'),
            $targetLocale => $translator->translate($request->input('description')),
        ];
        $customizedService = CustomizedService::create([
            'price' => $request->input('price'),
            'description' => json_encode($description),
            'status' => json_encode(Constants::SERVICE_ORDER_STATUSES['PENDING']),
            'user_id' => $user->id,
            'order_id' => $request->input('order_id'),
            'service_id' => $request->input('service_id'),
        ]);

        return success(CustomizedServiceResource::make($customizedService));

    }
    public function show(CustomizedService $customizedService)
    {
        return success(CustomizedServiceResource::make($customizedService));
    }
}
