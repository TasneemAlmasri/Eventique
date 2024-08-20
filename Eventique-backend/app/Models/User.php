<?php

namespace App\Models;

//use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Kreait\Firebase\Auth as FirebaseAuth;

class User extends Authenticatable //implements MustVerifyEmail
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'email_verified_at',
        'fcm_token'
    ];


    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
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

    public function favorites(){
        return $this->hasMany(Favorite::class , 'user_id');
    }
    public function images()
    {
        return $this->morphMany(Image::class, 'model');
    }

    public function events()
    {
        return $this->hasMany(Event::class);
    }
    public function userwallets(){
        return $this->hasOne(UserWallet::class);
    }
    public function reviews(){
        return $this->hasMany(Review::class , 'user_id');

    }
    public function orders(){
        return $this->hasMany(Order::class , 'user_id');
    }
}
