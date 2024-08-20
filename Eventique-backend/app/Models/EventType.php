<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\Translatable\HasTranslations;

class EventType extends Model
{
    use HasFactory, HasTranslations;

    protected $fillable = [
        'name',
        ];

    public $translatable = ['name'];

    public function events(){
        return $this->hasMany(Event::class , 'event_type_id');
    }
    public function packages(){
        return $this->hasMany(Package::class , 'event_type_id');
    }
    public function orders(){
        return $this->hasMany(Order::class , 'event_type_id');
    }
    public function companies(){
        return $this->belongsToMany(Company::class , 'eventtype_company_pivot');
    }
}
