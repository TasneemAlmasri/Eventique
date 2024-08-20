<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\Translatable\HasTranslations;

class CustomizedService extends Model
{
    use HasFactory, HasTranslations;
    protected $fillable = [
        'price',
        'description',
        'status',
        'user_id',
        'order_id',
        'service_id'
    ];
    public $translatable = ['description', 'status'];

    public function orders()
    {
        return $this->belongsTo(Order::class, 'order_id');
    }

    public function service()
    {
        return $this->belongsTo(Service::class, 'service_id');
    }
}
