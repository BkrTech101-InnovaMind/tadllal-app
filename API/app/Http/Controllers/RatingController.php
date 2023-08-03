<?php

namespace App\Http\Controllers;

use App\Models\Rating;
use App\Models\RealEstate;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Traits\HttpResponses;

class RatingController extends Controller
{
    use HttpResponses;
    public function rateRealEstate(Request $request)
    {
        $request->validate([
            'id' => 'required|exists:real_estates,id',
            'rate' => 'required|integer|min:1|max:5',
        ]);

        $user = Auth::user(); // Get the currently authenticated user
        $realEstate = RealEstate::find($request->id);
        if (!$user || !$realEstate) {
            return $this->error('Error', ['message' => 'User or real estate not found.'], 404);
        }
        $rating = $user->ratings()->where('real_estate_id', $realEstate->id)->first();

        if (!$rating) {
            $rating = new Rating([
                'user_id' => $user->id,
                'real_estate_id' => $request->id,
                'rating' => $request->rate,
            ]);
        } else {
            $rating->rating = $request->rate;
        }
        $rating->save();

        return $this->success([
            'message' => 'The real estate has been rated successfully.'
        ]);

    }
}