<?php

namespace App\Http\Controllers;

use App\Http\Resources\UserPerferenceResource;
use App\Models\Rtypes;
use App\Models\UserPreference;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Traits\HttpResponses;

class UserPreferenceController extends Controller
{
    use HttpResponses;
    public function store(Request $request)
    {

        $user_id = Auth::user()->id;
        $selected_types = $request->input('types');

        $existingTypes = Rtypes::whereIn('id', $selected_types)->pluck('id')->toArray();
        $nonExistingTypes = array_diff($selected_types, $existingTypes);

        if (!empty($nonExistingTypes)) {

            return $this->error('Error', ['message' => 'Invalid type IDs: ' . implode(', ', $nonExistingTypes)], 404);
        }


        UserPreference::where('user_id', $user_id)->delete();
        foreach ($selected_types as $type_id) {
            UserPreference::create([
                'user_id' => $user_id,
                'type_id' => $type_id,
            ]);
        }
        return $this->success([
            'message' => 'Preferences have been successfully recorded.'
        ]);
    }


    public function delete($id)
    {
        $user_id = Auth::user()->id;
        $rtype = Rtypes::find($id);

        if ($rtype) {
            $exists = UserPreference::where('user_id', $user_id)
                ->where('type_id', $id)
                ->exists();
            if ($exists) {
                UserPreference::where('user_id', $user_id)
                    ->where('type_id', $id)
                    ->delete();
                return $this->success([
                    'message' => 'Record has been successfully deleted.'
                ]);

            } else {
                return $this->error('Error', ['message' => 'Record not found in User Preference.'], 404);
            }
        } else {
            return $this->error('Error', ['message' => 'Record not found in Types.'], 404);
        }
    }

    public function getUserPreferences()
    {
        $user_id = Auth::user()->id;

        $user_preferences = UserPerferenceResource::collection(
            UserPreference::where('user_id', $user_id)
                ->with('type:id,name')
                ->get()
        );

        return response()->json(['user_preferences' => $user_preferences]);
    }
}