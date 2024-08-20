<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Kreait\Firebase\Auth as FirebaseAuth;
use Laravel\Sanctum\HasApiTokens;

class Admin extends Model
{
    use HasFactory , HasApiTokens;

    protected $fillable = ['name' , 'email' , 'password' , 'fcm_token'];

    public function adminwallets(){
        return $this->hasOne(AdminWallet::class);
    }

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

}
