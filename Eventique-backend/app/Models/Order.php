<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;
    protected $fillable = [
        'status',
        'total_price',
        'order_date',
        'user_id',
        'event_id',
    ];
    public function services(){
        return $this->belongsToMany(Service::class, 'service_order_pivot')
            ->withPivot('status', 'price', 'quantity')
            ->withTimestamps();
    }

    public function customizedServices()
    {
        return $this->hasMany(CustomizedService::class,'order_id');
    }

    public function event()
    {
        return $this->belongsTo(Event::class, 'event_id');
    }
    public function user()
    {
        return $this->belongsTo(User::class);
    }

}
