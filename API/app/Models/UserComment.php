<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserComment extends Model
{
    use HasFactory;
    protected $fillable = [
        'user_id',
        'real_estate_id',
        'comment',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function realEstate()
    {
        return $this->belongsTo(RealEstate::class);
    }
}