<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class YouAndUs extends Model
{
    use HasFactory;
    protected $fillable = [
        'description',
        'event_id'
    ];
    public function event(){
        return $this->belongsTo(Event::class , 'event_id');
    }
    public function images()
    {
        return $this->morphMany(Image::class, 'model');
    }
}
