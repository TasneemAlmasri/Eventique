<?php

namespace App\Http\Controllers;

use App\Http\Resources\CompanyResource;
use App\Models\Admin;
use App\Models\AdminWallet;
use App\Models\Company;
use App\Models\User;
use App\Otp\UserOperationsOtp;
use App\Services\Api\SendNotification;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Notification;
use Illuminate\Support\Str;
use SadiqSalau\LaravelOtp\Facades\Otp;
use Illuminate\Http\Response;

class AdminController extends Controller
{
    public function admin(Request $request){
        $admin = Admin::create([
            'email'=>$request->email,
            'password'=>Hash::make($request->password)
        ]);
        AdminWallet::create([
            'admin_id'=>$admin->id
        ]);
        $firebaseToken = $admin->createCustomToken($admin->id);
        $admin->update(['fcm_token' => $firebaseToken]);
        return success();
    }

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|min:6|max:14',
        ]);
        $admin = Admin::where('email', $request->email)->first();
        if ($admin && Hash::check($request->password, $admin->password)) {

            return success(null, Response::HTTP_OK, [
                'loggintoken' => $admin->createToken("admin Login Token")->plainTextToken
            ]);
        }
        return error('wrong information check your email and password');
    }

    public function logout(){
        $admin = auth()->user();
        $admin->currentAccessToken()->delete();
        return success();
    }

    public function verAuthOTP (Request $request){
        $request->validate([
            'code'  => ['required', 'string']
        ]);
        $admin = Admin::first();

        $otp = Otp::identifier($admin->email)->attempt($request->code);
        if ($otp['status'] != Otp::OTP_PROCESSED) {
            abort(403, __($otp['status']));
        }

        if ($admin) { // forget password verify
            DB::table('password_reset_tokens')->insert([
                'email'=>$admin->email,
                'token'=>$forgetToken = Str::random(60),
                'created_at'=>Carbon::now()
            ]);
            return success($otp['status']);
        }
    }

    public function sendOTP (){
        // send forget password otp
        $admin = Admin::first();
        if($admin) {
            $otp = Otp::identifier($admin->email)->send(
                new UserOperationsOtp(
                    name: $admin->name,
                    email: $admin->email,
                    password: $admin->password,
                ),
                Notification::route('mail', $admin->email)
            );
            return success($otp['status']);
        }
        return error('check your email');
    }


    public function resetPass (Request $request){
        $request->validate([
            'password' => ['required', 'min:6' , 'max:14' , 'confirmed']
        ]);

        $admin = Admin::first();
        if(Hash::check($admin->password,$admin->password)) {
            return error('it is the same old password , try again');
        }else {
            $admin->update([
                'password' => Hash::make($request->password)
            ]);
            return success();
        }
    }

    public function applications(){
        $companies = Company::where('accessibility',0)->get();
        return CompanyResource::collection($companies);
    }

    public function acceptCompany(Request $request){

        $company = Company::findOrFail($request->companyId);
        if ($request->status == 1){
            $company->update(['accessibility' => 1]);

            $notification = new SendNotification();
            $massege = 'We are excited to inform you that your application to join our program has been approved! Welcome aboard!';
            $not =$notification->sendToCompany($company, 'Congratulations! Your Application is Accepted', $massege);

            return success($not);
        }else{
            Company::where('id',$request->companyId)->delete();

            $notification = new SendNotification();
            $massege ='Thank you for applying. Unfortunately, your application to our program was not accepted at this time. Please feel free to reapply in the future.';
            $notification->sendToCompany($company, 'Your Application Has Been Rejected', $massege);
            return success('deleted');
        }
    }

    public function userSearch(Request $request){
        $request->validate([
            'search' => 'required|string'
        ]);
        $user = User::where('email', 'like', '%' . $request->search . '%')
            ->orWhere('name', 'like', '%' . $request->search . '%')
            ->get();
        return success($user);
    }

    public function companySearch(Request $request){
        $request->validate([
            'search' => 'required|string'
        ]);

        $companies = Company::where(function ($query) use ($request) {
            $query->where('email', 'like', '%' . $request->search . '%')
                ->orWhere('company_name', 'like', '%' . $request->search . '%');
        })
            ->where('accessibility', 1)
            ->get();
        return success(CompanyResource::collection($companies));
    }

    public function deleteCompany($id){
        Company::where('id',$id)->delete();
        return success();
    }

    public function deleteUser($id){
        User::where('id',$id)->delete();
        return success();
    }
}
