<?php

namespace App\Http\Controllers;

use App\Http\Resources\ServiceResource;
use App\Models\Favorite;
use App\Models\Service;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

class FavoriteController extends Controller
{
    public function store(Request $request){
        $user = Auth::user();
        Favorite::create([
            'user_id' => $user->id,
            'service_id' => $request->service_id
        ]);
        return success();
    }

//    public function destroy(Favorite $service){
//        $user = auth()->user();
//        $favorite = Favorite::where('user_id', $user->id)
//            ->where('service_id', $service)
//            ->firstOrFail();
//
//        $favorite->delete();
////        return success();
//        return $favorite;
    public function destroy($service)
        {
            $user = Auth::user();

            $favorite = Favorite::where('user_id', $user->id)
                ->where('service_id', $service)
                ->first();
            $favorite->deleteOrFail();
            return success();

        }

//    public function index(){
//        $user = auth()->user();
//
//        if($user){
//            return success([$user->favorites]);
//        }
//        return error('Invalid Auth');

    public function index() {
        $user = auth()->user();

        if ($user) {
            $favorites = $user->favorites()->with('services')->get();

            $favoritesWithServices = $favorites->map(function($favorite) {
                $service = new ServiceResource($favorite->services);

                return [
                    'id' => $favorite->id,
                    'user_id' => $favorite->user_id,
                    'service_id' => $favorite->service_id,
                    'service' => $service
                ];
            });
            return success($favoritesWithServices);
//            return response()->json([
//                'success' => true,
//                'code' => 200,
//                'data' => [
//                    'favorites' => $favoritesWithServices
//                ]
//            ]);

        }
    }
}
