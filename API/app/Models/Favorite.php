<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Favorite extends Model
{
    use HasFactory;

    protected $fillable = ['user_id', 'real_estate_id'];

    public function realEstate()
    {
        return $this->belongsTo(RealEstate::class, 'real_estate_id');
    }
}