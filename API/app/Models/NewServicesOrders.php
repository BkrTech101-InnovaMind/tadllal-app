<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class NewServicesOrders extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'new_services_id',
        'message',
        'status',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function NewServices()
    {
        return $this->belongsTo(NewServices::class, "new_services_id");
    }
}