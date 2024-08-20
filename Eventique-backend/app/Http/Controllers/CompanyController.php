<?php

namespace App\Http\Controllers;

use App\Http\Requests\Company\CompanyRequest;
use App\Http\Requests\company\updateCompanyRequest;
use App\Http\Resources\CompanyResource;
use App\Models\Company;
use App\Models\CompanyWallet;
use App\Models\User;
use App\Models\WorkHours;
use App\Otp\UserOperationsOtp;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Notification;
use Illuminate\Support\Str;
use SadiqSalau\LaravelOtp\Facades\Otp;
use Stichoza\GoogleTranslate\GoogleTranslate;
use Barryvdh\DomPDF\Facade\Pdf;


class CompanyController extends Controller
{
    public function insertcompany(CompanyRequest $request)
    {
        $validatedData = $request->validated();

        $currentLocale = app()->getLocale();
        $targetLocale = ($currentLocale === 'en') ? 'ar' : 'en';

        $lang = new GoogleTranslate($currentLocale);
        $lang->setSource($currentLocale)->setTarget($targetLocale);

        $validatedData['location'] = [
            $currentLocale => $validatedData['location'],
            $targetLocale => $lang->translate($validatedData['location'])
        ];
        $validatedData['city'] = [
            $currentLocale => $validatedData['city'],
            $targetLocale => $lang->translate($validatedData['city'])
        ];
        $validatedData['country'] = [
            $currentLocale => $validatedData['country'],
            $targetLocale => $lang->translate($validatedData['country'])
        ];
        $validatedData['description'] = [
            $currentLocale => $validatedData['description'],
            $targetLocale => $lang->translate($validatedData['description'])
        ];

        $validatedData['password'] = Hash::make($validatedData['password']);
        $company = Company::create($validatedData);
        $company->images()->create(['url' => $request->image]);

        CompanyWallet::create([
            'company_id'=>$company->id
        ]);
        $firebaseToken = $company->createCustomToken($company->id);
        $company->update(['fcm_token' => $request->fcm_token]);

        foreach ($validatedData['work_hours'] as $workHour) {
            $workHour['day'] = [
                $currentLocale => $workHour['day'],
                $targetLocale => $lang->translate($workHour['day'])
            ];
            WorkHours::create([
                'day' => $workHour['day'],
                'hours_from' => $workHour['hours_from'],
                'hours_to' => $workHour['hours_to'],
                'company_id' => $company->id
            ]);
        }

        foreach ($request->category_id as $categoryID) {
            $company->categories()->attach($categoryID);
        }
        foreach ($request->event_type_id as $eventTypeID) {
            $company->eventTypes()->attach($eventTypeID);
        }

        return success(new CompanyResource($company), Response::HTTP_OK, [
            'firebaseToken' => $firebaseToken
        ]);
    }
    public function destroy(Request $request)
    {
        $company = auth()->user();
        $company->delete();
        return success();
    }

    public function show(Company $company)
    {
        return success(new CompanyResource($company));
    }

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|min:6|max:14',
        ]);
        $company = Company::where('email', $request->email)->first();
        $firebaseToken = $company->createCustomToken($company->id);
        if($company->accessibility == 1){
            if ($company && Hash::check($request->password, $company->password)) {
                return success(new CompanyResource($company), Response::HTTP_OK, [
                    'loggintoken' => $company->createToken("Comp Login Token")->plainTextToken,
                    'firebaseToken' => $firebaseToken
                ]);
            }
            return error('wrong information check your email and password');
        }
        return error('your application didnt check yet');
    }

    public function logout(){
        $company = auth()->user();
        $company->currentAccessToken()->delete();
        return success();
    }

    public function sendOTP (Request $request){
        $request->validate([
            'email'    => ['required', 'string', 'email', 'max:255']
        ]);
          // send forget password otp
        $company = Company::where('email', $request->email)->first();
        if($company) {
            $otp = Otp::identifier($request->email)->send(
                new UserOperationsOtp(
                    name: $company->company_name,
                    email: $company->email,
                    password: $company->password,
                ),
                Notification::route('mail', $request->email)
            );
            return success($otp['status']);
        }
        return error('check your email');
    }


    public function verAuthOTP (Request $request)
    {
        $request->validate([
            'code' => ['required', 'string'],
            'email' => ['required', 'email']
        ]);

        $company = Company::where('email', $request->email)->first();

        $otp = Otp::identifier($request->email)->attempt($request->code);
        if ($otp['status'] != Otp::OTP_PROCESSED) {
            abort(403, __($otp['status']));
        }

        if ($company) { // forget password verify
            DB::table('password_reset_tokens')->insert([
                'email' => $request->email,
                'token' => $forgetToken = Str::random(60),
                'created_at' => Carbon::now()
            ]);
            return success($otp['status']);
        }
    }

    public function verEmail (Request $request){
        $request->validate([
            'code' => ['required', 'string'],
            'email' => ['required', 'email']
        ]);
        $companyAuth = auth()->user();
        $companyAuth->update([
            'email' => $request->email
        ]);
        return success('change email success');
    }

    public function resetPass (Request $request){
        $request->validate([
            'password' => ['required', 'min:6' , 'max:14' , 'confirmed']
        ]);

        $company = Company::where('email', $request->email)->first();

        if(Hash::check($request->password,$company->password)) {
            return error('it is the same old password , try again');
        }else {
            $company->update([
                'password' => Hash::make($request->password)
            ]);
            return success();
        }
    }

    public function update(updateCompanyRequest $request)
    {
        $validatedData = $request->validated();
        $company = auth()->user();

        $currentLocale = app()->getLocale();
        $targetLocale = ($currentLocale === 'en') ? 'ar' : 'en';

        $lang = new GoogleTranslate($currentLocale);
        $lang->setSource($currentLocale)->setTarget($targetLocale);

        $updateData = array_diff_key($validatedData, ['work_hours' => null]);

        foreach ($updateData as $key => $value) {
            if ($key === 'image') {
                $companyImage = $company->images()->first();
                $companyImage->update([
                    'url' => $value,
                ]);
            } else if (in_array($key, ['location', 'city', 'country', 'description'])) {
                $company->$key = [
                    $currentLocale => $value,
                    $targetLocale => $lang->translate($value)
                ];
            } else {
                $company->$key = $value;
            }
        }
        $company->save();
        if (isset($validatedData['work_hours'])) {
            $company->workHours()->delete();
            foreach ($validatedData['work_hours'] as $workHour) {
                $dayTranslation = [
                    $currentLocale => $workHour['day'],
                    $targetLocale => $lang->translate($workHour['day'])
                ];
                WorkHours::create([
                    'day' => $dayTranslation,
                    'hours_from' => $workHour['hours_from'],
                    'hours_to' => $workHour['hours_to'],
                    'company_id' => $company->id
                ]);
            }
            return success(new CompanyResource($company));
        }
    }

    public function changeEmailOTP(Request $request){
        $request->validate([
            'email'    => ['required', 'string', 'email', 'max:255']
        ]);

        $companyAuth = auth()->user();
        $company = User::where('email', $request->email)->first();
        if ($company) {
            return error('sorry , email dosent available');
        }
        $otp = Otp::identifier($request->email)->send(
            new UserOperationsOtp(
                name: $companyAuth->company_name,
                email: $request->email,
                password: $companyAuth->password,
            ),
            Notification::route('mail', $request->email)
        );
        return success($otp['status']);
    }

    public function changePass (Request $request){
        $request->validate([
            'oldPassword' => ['required', 'min:6' , 'max:14'],
            'newPassword' => ['required', 'min:6' , 'max:14' , 'confirmed']
        ]);

        $company = auth()->user();

        if(Hash::check($request->oldPassword,$company->password)) {
            $company->update([
                'password' => Hash::make($request->newPassword)
            ]);
            return success('changed pass successfully');
        }
        return error('your old password in wronge , try again');

    }
    public function allCompanies(){
        $companies = Company::all();
        return CompanyResource::collection($companies);
        //return CompanyResource::collection(Company::paginate(3));
    }

    public function pdf()
    {
        $pdf = Pdf::loadView('terms');
        return $pdf->download('terms and condition.pdf');
    }

    public function updateFCM (Request $request){
        $company = Company::findorfail($request->company_id);
        $company->update(['fcm_token' => $request->fcm_token]);
    }
}
