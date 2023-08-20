<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RealEstate extends Model
{
    use HasFactory;
    protected $fillable = [
        'name',
        'description',
        'price',
        'location_id',
        'image',
        'type1_id',
        'location_info',
        'state',
        'type2',
    ];

    public function comments()
    {
        return $this->hasMany(UserComment::class, 'real_estate_id');
    }
    public function locations()
    {
        return $this->belongsTo(Rlocations::class, 'location_id');
        // return $this->hasOne(Rlocations::class);
    }

    public function types()
    {
        return $this->belongsTo(Rtypes::class, 'type1_id');
        // return $this->hasOne(Rtypes::class);
    }

    public function ratings()
    {
        return $this->hasMany(Rating::class, 'real_estate_id');
    }
    public function images()
    {
        return $this->hasMany(RealEstateImage::class);
    }

}