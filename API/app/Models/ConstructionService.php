<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ConstructionService extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'image',
        'description',
    ];
    public function subServices()
    {
        return $this->hasMany(SubConstructionService::class, 'construction_service_id');
    }

}