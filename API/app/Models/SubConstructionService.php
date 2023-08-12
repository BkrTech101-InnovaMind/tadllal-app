<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SubConstructionService extends Model
{

    use HasFactory;
    protected $fillable = [
        'name',
        'image',
        'description',
        'construction_service_id',
    ];

    public function constructionService()
    {
        return $this->belongsTo(ConstructionService::class, 'construction_service_id');
    }

}