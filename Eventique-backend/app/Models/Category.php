<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\Translatable\HasTranslations;

class Category extends Model
{
    use HasFactory, HasTranslations;
    protected $fillable = ['name'];
    public $translatable = ['name'];

    public function services(){
        return $this->hasMany(Service::class , 'category_id');
    }

    public function companies(){
        return $this->belongsToMany(Company::class , 'category_company_pivot', 'category_id', 'company_id');
    }
}


