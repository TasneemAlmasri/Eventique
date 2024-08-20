<?php

namespace App\Http\Controllers;

use App\Http\Resources\CompanyResource;
use App\Models\User;
use App\Models\UserWallet;
use App\Otp\UserRegistrationOtp;
use App\Otp\UserOperationsOtp;
use App\Services\Api\SendNotification;
use App\Services\FirebaseService;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use SadiqSalau\LaravelOtp\Facades\Otp;
use Illuminate\Support\Facades\Notification;
use Kreait\Firebase\Auth as FirebaseAuth;

class UserController extends Controller
{

    public function updateFCM (Request $request){
        $user = auth()->user();
        $user->update(['fcm_token' => $request->fcm_token]);
    }

    public function register (Request $request)
    {
        $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'lowercase', 'email', 'max:255', 'unique:users,email'],
            'password' => ['required', 'min:6' , 'max:14' , 'confirmed'],
            'image' => ['required', 'string', 'max:255']
        ]);
        if(User::where('email', $request->email)->first()){
            return response([
                'message' => 'Email already exists',
                'status'=>'failed'
            ], 200);
        }

//        $request->session()->put('user_email', $request->email);
          $request->session()->put('user_name', $request->name);
          $request->session()->put('user_pass', $request->password);

        $otp = Otp::identifier($request->email)->send(
            new UserRegistrationOtp(
                name: $request->name,
                email: $request->email,
                password: $request->password,
            ),
            Notification::route('mail', $request->email)
        );
        return success($otp['status'], Response::HTTP_OK, [
            'email' => $request->email,
            'image' => $request->image,
        ]);
    }

    public function login(Request $request){
        $request->validate([
            'email'=>'required|email',
            'password'=>'required|min:6|max:14',
        ]);
        $user = User::with('images')->where('email', $request->email)->first();
        if($user && Hash::check($request->password, $user->password)){
            $token = $user->createToken("Login Token")->plainTextToken;
            $firebaseToken = $user->createCustomToken($user->id);
            return success($user, Response::HTTP_OK, [
                'loginToken'=> $token,
                'firebaseToken'=> $firebaseToken,
            ]);
        }
        return error('wrong information check your email and password');
    }

    public function logout(Request $request){
        $request->user()->currentAccessToken()->delete();
        return response([
            'message' => 'Logout Success',
            'status'=>'success'
        ], 200);
    }

    public function logged_user(){
        $loggeduser = auth()->user();
        return response([
            'user'=>$loggeduser,
            'message' => 'Logged User Data',
            'status'=>'success'
        ], 200);
    }

    public function allUsers(){
        $users = User::with('images')->get();
        return response()->json($users);
    }

    public function postUser(Request $request){
        $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'lowercase', 'email', 'max:255', 'unique:users,email'],
            'password' => ['required', 'min:6' , 'max:14' ],
            'image' => ['required', 'string', 'max:255']
        ]);
        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);
        $user->images()->create(['url' => $request->image]);
        return response([
            'status'=>'success',
            'loginToken' => $user->createToken("Login Token")->plainTextToken,
            'registerToken' => $user->createToken($request->email)->plainTextToken,
        ], 200);
    }

    public function verRegistereOTP (Request $request){
        $request->validate([
            'code'  => ['required', 'string']
        ]);

        $email = $request->email;
        $userCheck = User::where('email',$email)->first();

        if (!$userCheck) {
            $otp = Otp::identifier($email)->attempt($request->code);
            if ($otp['status'] != Otp::OTP_PROCESSED) {
                abort(403, __($otp['status']));
            }
            $user = User::where('email',$email)->first();
            $user->images()->create(['url' => $request->image]);
            $registerToken = $user->createToken($email)->plainTextToken;
            $firebaseToken = $user->createCustomToken($user->id);
            $userInfo = User::with('images')->where('email', $email)->first();
            //session()->flush();
            UserWallet::create([
                'user_id'=>$user->id
            ]);

            return success($userInfo, Response::HTTP_OK, [
                'rigistertoken' => $registerToken,
                'logginToken' => $user->createToken("Login Token")->plainTextToken,
                'firebaseToken' => $firebaseToken,
            ]);
        }
        return error('registration verified failed');
    }

    public function verAuthOTP (Request $request){
        $request->validate([
            'code'  => ['required', 'string']
        ]);

        //$email = $request->session()->get('user_email');
        $email = $request->email;
        $user = User::where('email',$email)->first();
        $loggedUser = auth()->user();

        $otp = Otp::identifier($email)->attempt($request->code);
        if ($otp['status'] != Otp::OTP_PROCESSED) {
            abort(403, __($otp['status']));
        }

        if ($user) { // forget password verify

             $forgetToken = Str::random(60);
             DB::table('password_reset_tokens')->insert([
                 'email'=>$email,
                 'token'=>$forgetToken,
                 'created_at'=>Carbon::now()
             ]);
            session()->flush();
             return success();

        }else{ //change email

            $loggedUser->update([
                'email' => $email
            ]);
            session()->flush();
            return response([
                'message'=>'change email verified successfully',
                'status'=>'success'
            ], 200);
        }
    }

    public function sendOTP (Request $request){
        $request->validate([
            'email'    => ['required', 'string', 'email', 'max:255']
        ]);
//        $request->session()->put('user_email', $request->email);
         $name = $request->session()->get('user_name');
         $pass = $request->session()->get('user_pass');

        $usercheck = User::where('email',$request->email)->first();
        //send registration otp
        if (!$usercheck) {
            $otp = Otp::identifier($request->email)->send(
                new UserRegistrationOtp(
                    name: $name->name,
                    email: $request->email,
                    password: $pass->pass,
                ),
                Notification::route('mail', $request->email)
            );
            session()->flush();
            return success($otp['status'], Response::HTTP_OK, [
                'email' => $request->email
            ]);

        }else{   // send forget password otp

            $user = USER::where('email',$request->email)->first();
            $otp = Otp::identifier($request->email)->send(
                new UserOperationsOtp(
                    name: $user->name,
                    email: $user->email,
                    password: $user->password,
                ),
                Notification::route('mail', $request->email)
            );
            return success($otp['status']);
        }
    }

    public function resetPass (Request $request){
        $request->validate([
            'password' => ['required', 'min:6' , 'max:14' , 'confirmed']
        ]);
        //$email = $request->session()->get('user_email');
        $email = $request->email;
        $user = User::where('email', $email)->first();

        if(Hash::check($request->password,$user->password)) {
            return response([
                'message'=>'it is the same old password , try again',
                'status'=>'success'
            ], 500);
        }else {
            $user->update([
                'password' => Hash::make($request->password)
            ]);
            return response([
                'message'=>'updated pass successfully',
                'status'=>'success'
            ], 200);
        }
    }

    public function resetName(Request $request){
        $request->validate([
            'name' => ['required', 'string', 'max:255']
        ]);
        $user = auth()->user();
        $user->update([
            'name' => $request->name,
        ]);
        return response([
            'message'=>'updated name successfully',
        ], 200);
    }

    public function resetImage(Request $request){
        $request->validate([
            'image' => ['required', 'string', 'max:255']
        ]);
        $user = auth()->user();
        $userImage = $user->images()->first();
        $userImage->update([
            'url' => $request->image,
        ]);
        return response([
            'message'=>'updated image successfully',
        ], 200);
    }

    public function changePass (Request $request){
        $request->validate([
            'oldPassword' => ['required', 'min:6' , 'max:14'],
            'newPassword' => ['required', 'min:6' , 'max:14' , 'confirmed']
        ]);

        $user = auth()->user();

        if(Hash::check($request->oldPassword,$user->password)) {
            $user->update([
                'password' => Hash::make($request->newPassword)
            ]);
            return response([
                'message'=>'changed pass successfully',
                'status'=>'success'
            ], 200);
        }
            return response([
                'message'=>'your old password in wronge , try again',
                'status'=>'failed'
            ], 500);

    }
    public function changeEmailOTP(Request $request){
        $request->validate([
            'email'    => ['required', 'string', 'email', 'max:255']
        ]);

        $userAuth = auth()->user();
        $user = User::where('email', $request->email)->first();
        if ($user) {
            return error('sorry , email dosent available');
            }
            //$request->session()->put('user_email', $request->email);
            $otp = Otp::identifier($request->email)->send(
                new UserOperationsOtp(
                    name: $userAuth->name,
                    email: $request->email,
                    password: $userAuth->password,
                ),
                Notification::route('mail', $request->email)
            );
            return success($otp['status']);
    }

    public function notification(){
        //$user = auth()->user();
        $user = User::findorfail(4);
        $notification = new SendNotification(); // Manually instantiate
//        $noti =$notification->sendToUser($user, 'hiiii', 'haaaiaiiiiii');
  //      $user = $massage = $service->name . 'is rejected';
        $not = $notification->sendToUser($user, 'reject service', 'hghgghgh');
        return success($not);
    }
}
