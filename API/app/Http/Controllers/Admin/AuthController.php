<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Laravel\Sanctum\Sanctum;
use App\Traits\HttpResponses;

use App\Http\Requests\LoginUserRequest;
use App\Models\User;

class AuthController extends Controller
{
    use HttpResponses;
    public function login(LoginUserRequest $request)
    {
        $request->validated($request->all());

        if (!Auth::attempt(['email' => $request->email, 'password' => $request->password, 'role' => 'admin'])) {
            return $this->error('', 'Credentials do not match', 401);
        }

        $user = User::where('email', $request->email)->first();

        return $this->success([
            'admin' => $user,
            'token' => $user->createToken('Api Token of ' . $user->name)->plainTextToken
        ]);
    }

    public function logout()
    {
        Auth::user()->currentAccessToken()->delete();

        return $this->success([
            'message' => 'You have successfully been logged out and your token has been deleted'
        ]);
    }

}