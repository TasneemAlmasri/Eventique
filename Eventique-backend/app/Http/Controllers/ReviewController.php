<?php

namespace App\Http\Controllers;

use App\Models\Review;
use App\Models\User;
use Illuminate\Http\Response;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ReviewController extends Controller
{

    public function store (Request $request){

        $data = $request->only(['rate', 'description', 'service_id']);
        $data['user_id'] = Auth::id();
        Review::create($data);
        return success();

    }

//    public function show ($id){
//        $reviews = Review::where('service_id', $id)->get();
//        $averageRate = $reviews->avg('rate');
//        $descriptions = $reviews->pluck('description');
//        return success(null, Response::HTTP_OK, [
//                'average_rate' => $averageRate,
//                'descriptions' => $descriptions,
//            ]
//        );
//    }
    public function show($id)
    {
        $reviews = Review::where('service_id', $id)->with('user.images')->get();
//        $averageRate = $reviews->avg('rate');
        $userDetails = $reviews->map(function($review) {
            return [
                'user_id'=>$review->user->id,
                'review'=>$review->id,
                'name' => $review->user->name,
                'images' => $review->user->images->map(function($image) {
                    return $image->url; // Assuming the Image model has a 'url' attribute
                }),
                'description' => $review->description,
                'rate' => $review->rate
            ];
        });

        return response()->json([
//            'average_rate' => $averageRate,
            'users' => $userDetails,
        ], Response::HTTP_OK);
    }



    public function destroy($review){
        $user = Auth::user();
        $review = Review::where('user_id', $user->id)
        ->where('id', $review)
        ->first();
    $review->deleteorFail();
    return success();
    }

    public function showServiceReviews($id){
        $company = auth()->user();
        $ser = $company->services->where('id',$id);
        return $ser;
    }

}
