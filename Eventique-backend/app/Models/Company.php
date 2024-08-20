<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Kreait\Firebase\Auth as FirebaseAuth;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Translatable\HasTranslations;

class Company extends Model
{
    use HasFactory, HasTranslations ,HasApiTokens;

    protected $fillable = [
        'first_name',
        'last_name',
        'email',
        'password',
        'phone_number',
        'company_name',
        'registration_number',
        'location',
        'city',
        'country',
        'description',
        'accept_privacy',
        'accessibility',
        'fcm_token'
    ];

    public $translatable = [
        'location',
        'city',
        'country',
        'description',
    ];
    public function getFirebaseAuth()
    {
        return app(FirebaseAuth::class);
    }

    public function createCustomToken()
    {
        $firebaseAuth = $this->getFirebaseAuth();
        $customToken = $firebaseAuth->createCustomToken($this->id);
        return $customToken->toString();
    }


    public function categories(){
        return $this->belongsToMany(Category::class , 'category_company_pivot', 'company_id', 'category_id');
    }
    public function workHours()
    {
        return $this->hasMany(WorkHours::class);
    }
    public function eventTypes(){
        return $this->belongsToMany(EventType::class , 'eventtype_company_pivot');
    }
    public function companywallets(){
        return $this->hasOne(CompanyWallet::class);
    }
    public function images(){
        return $this->morphMany(Image::class, 'model');
    }
    public function services(){
        return $this->hasMany(Service::class, 'company_id');
    }
}
