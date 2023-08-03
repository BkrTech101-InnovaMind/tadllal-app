<?php

namespace App\Http\Controllers;

use App\Http\Resources\RealEstateResource;
use App\Models\Favorite;
use Illuminate\Http\Request;
use App\Traits\HttpResponses;
use Illuminate\Support\Facades\Auth;


class FavoriteController extends Controller
{
    use HttpResponses;
    public function addToFavorites(Request $request)
    {

        $request->validate([
            'id' => 'required|exists:real_estates,id',
        ]);

        $user = Auth::user();
        $favorite = Favorite::where('user_id', $user->id)
            ->where('real_estate_id', $request->id)
            ->first();

        if ($favorite) {
            return $this->error('Error', ['message' => 'The real estate is already in favorites..'], 404);
        } else {
            $favorite = new Favorite([
                'user_id' => $user->id,
                'real_estate_id' => $request->id,
            ]);
            $favorite->save();
            return $this->success([
                'message' => 'The real estate has been added to favorites successfully.'
            ]);

        }



    }

    public function removeFromFavorites($id)
    {
        // $request->validate([
        //     'id' => 'required|exists:real_estates,id',
        // ]);

        $user = Auth::user(); // Get the currently authenticated user
        $favorite = Favorite::where('user_id', $user->id)
            ->where('real_estate_id', $id)
            ->first();

        if ($favorite) {
            $favorite->delete();
            return $this->success(['message' => 'The real estate has been removed from favorites successfully.']);
        } else {
            return $this->error('Error', ['message' => 'The real estate is not in favorites.'], 404);
        }
    }


    public function getUserFavorites(Request $request)
    {
        $user = Auth::user(); // Get the currently authenticated user
        $userFavorites = Favorite::where('user_id', $user->id)
            ->with('realEstate') // Load real estate data to avoid N+1 query
            ->get();

        $userFavoritesResources = RealEstateResource::collection(
            $userFavorites->pluck('realEstate')
        );

        return response(['favorites' => $userFavoritesResources], 200);
    }
}