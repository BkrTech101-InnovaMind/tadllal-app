<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RealEstateImage extends Model
{
    use HasFactory;
    protected $fillable = ['real_estate_id', 'image'];

    public function realEstate()
    {
        return $this->belongsTo(RealEstate::class);
    }
}