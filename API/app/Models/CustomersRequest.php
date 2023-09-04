<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CustomersRequest extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'customer_id',
        'location_id',
        'type_id',
        'property',
        'budget_from',
        'budget_to',
        'currency',
        'other_details',
        'request_status',
        'communication_status',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function customer()
    {
        return $this->belongsTo(Customers::class, 'customer_id');
    }

    public function location()
    {
        return $this->belongsTo(Rlocations::class, 'location_id');
    }

    public function type()
    {
        return $this->belongsTo(Rtypes::class, 'type_id');
    }
}