<?php

namespace App\Http\Controllers;

use App\Http\Requests\LoginUserRequest;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use App\Models\User;
use App\Traits\HttpResponses;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;

class AuthController extends Controller
{
    use HttpResponses;

    public function login(LoginUserRequest $request)
    {
        $request->validated($request->all());

        if (!Auth::attempt(['email' => $request->email, 'password' => $request->password])) {
            return $this->error('', 'Credentials do not match', 401);
        }

        $user = User::where('email', $request->email)->first();

        return $this->success([
            'user' => $user,
            'token' => $user->createToken('Api Token of ' . $user->name)->plainTextToken
        ]);
    }



    public function register(StoreUserRequest $request)
    {

        $request->validated($request->all());

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);

        return $this->success([
            'user' => $user,
            'token' => $user->createToken('API Token of' . $user->name)->plainTextToken
        ]);
    }


    public function logout()
    {
        Auth::user()->currentAccessToken()->delete();

        return $this->success([
            'message' => 'You have successfully been logged out and your token has been deleted'
        ]);
    }


    public function updateProfile(UpdateUserRequest $request)
    {
        $request->validated($request->all());
        $user = Auth::user();


        if ($request->has('name')) {
            $user->name = $request->name;
        }

        if ($request->has('phone')) {
            $user->phone_number = $request->phone;
        }

        if ($request->hasFile('avatar')) {
            $image = $request->file('avatar');
            $oldImagePath = str_replace('storage/', 'public/', $user->avatar);

            if ($oldImagePath && Storage::exists($oldImagePath)) {

                Storage::delete($oldImagePath);
            }

            $imagePath = $image->store('public/images/users');
            $user->avatar = str_replace('public/', 'storage/', $imagePath);
        }

        $user->save();

        return $this->success([
            'message' => 'User data updated successfully.',
            'user' => $user,
        ]);
    }

    public function changePassword(Request $request)
    {
        $user = Auth::user();

        $this->validate($request, [
            'current_password' => 'required',
            'new_password' => 'required|min:8|confirmed',
        ]);

        // Check if the current password is correct
        if (!Hash::check($request->current_password, $user->password)) {
            return $this->error('', 'Current password is incorrect', 401);
        }

        // Update the new password
        $user->password = Hash::make($request->new_password);
        $user->save();
        // Logout from all devices except the current one
        // Refresh the current user's access token

        $token = $user->currentAccessToken();
        $token->refresh();

        // Remove all other tokens associated with the user except the current one
        foreach ($user->tokens as $userToken) {
            if ($userToken->id !== $token->id) {
                $userToken->delete();
            }
        }

        return $this->success([
            'message' => 'Password updated successfully',
        ]);
    }

    public function registerNormalUser(StoreUserRequest $request)
    {
        $request->validated($request->all());
        // Check if the user is a marketer or a company, if not, return appropriate response
        $user = Auth::user();
        if ($user->role !== 'marketer' && $user->role !== 'company') {
            return $this->error('', 'You are not authorized to perform this action', 403);
        }


        // Create the normal user account
        $newUser = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'registered_by' => $user->id,
        ]);

        return $this->success([
            'message' => 'New User account created successfully.',
            'user' => $newUser,
        ]);
    }
}