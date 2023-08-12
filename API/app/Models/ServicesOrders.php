<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ServicesOrders extends Model
{
    use HasFactory;
    protected $fillable = [
        'user_id',
        'sub_construction_services_id',
        'message',
        'status',
    ];
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function subConstructionService()
    {
        return $this->belongsTo(SubConstructionService::class);
    }

}