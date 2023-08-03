<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Rlocations extends Model
{
    use HasFactory;
    protected $fillable = [
        'name',
    ];

    public function realEstates()
    {
        return $this->hasMany(RealEstate::class, 'location_id');
    }


}