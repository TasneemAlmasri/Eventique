<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Package extends Model
{
    use HasFactory;

    protected $fillable = [
        'old_price',
        'new_price',
        'event_type_id',
    ];
    public function images()
    {
        return $this->morphMany(Image::class, 'model');
    }
    public function eventType(){
        return $this->belongsTo(EventType::class, 'event_type_id');
    }
    public function services(){
        return $this->belongsToMany(Service::class, 'package_service', 'package_id', 'service_id');
    }
}
