<?php

namespace App\Http\Controllers;

use App\Models\Admin;
use App\Models\User;
use App\Models\UserWallet;
//use GPBMetadata\Google\Api\Auth;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class WalletController extends Controller
{

    public function store(Request $request){
        $validated=$request->validate([
            'user_id'=>['required' , 'int'],
            'amount' => ['required' , 'numeric']
        ]);
        $user_id = $validated['user_id'];

        $wallet = UserWallet::where('user_id',$user_id)->first();
        if($request->amount > 0) {
            $wallet->update([
                'amount' => $wallet->amount + $request->amount
            ]);
            return success($wallet->amount);
        }
        return error('amount should be bigger than 0');
    }

    public function userWallet($user_id)
    {
        $user = User::find($user_id);

        if ($user) {
            $walletAmount = $user->userwallets ? $user->userwallets->amount : 0;
            $completedEventsCount = $user->events()->where('status', 'completed')->count();
            if ($completedEventsCount >= 3) {
                $walletAmount += 10000;
                $user->userwallets->update(['amount' => $walletAmount]);
            }
            return response()->json(['success' => true, 'amount' => $walletAmount], 200);
        }
        return response()->json(['success' => false, 'message' => 'Invalid User ID'], 400);
    }


    public function companyWallet()
    {
        $company = auth()->user();
        if ($company) {
            $walletAmount = $company->companywallets->amount;
            return response()->json(['success' => true, 'amount' => $walletAmount], 200);
        }
        return response()->json(['success' => false, 'message' => 'Invalid company ID'], 400);
    }

}
