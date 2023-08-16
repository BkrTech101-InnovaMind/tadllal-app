<?php

namespace App\Http\Controllers;

use ActivationCodeMail;
use App\Http\Requests\LoginUserRequest;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use App\Http\Resources\UserResource;
use App\Mail\SampleMail;
use App\Models\User;
use App\Traits\HttpResponses;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Mail;



class AuthController extends Controller
{
    use HttpResponses;

    public function generateAndSendActivationCode(string $email, string $message)
    {
        // $activationCode = str_pad(rand(0, 9999), 4, '0', STR_PAD_LEFT); // توليد رمز تفعيل عشوائي مكون من 4 أرقام
        $existingCodes = User::pluck('activation_code')->toArray();

        do {
            $activationCode = str_pad(rand(0, 9999), 4, '0', STR_PAD_LEFT);
        } while (in_array($activationCode, $existingCodes));


        $user = User::where('email', $email)->first();

        if (!$user) {
            return $this->error('', 'User not found', 404);
        }

        $user->update([
            'activation_code' => $activationCode,
        ]);

        $content = [
            'subject' => 'Activation Code',
            'body' => 'Your activation code is: ' . $activationCode,
        ];

        $sampleMail = new SampleMail($content);
        Mail::to($user->email)->send($sampleMail);

        return $this->success([
            'user' => new UserResource($user),
            'code' => $activationCode,
        ], $message);
    }

    public function login(LoginUserRequest $request)
    {
        $request->validated($request->all());

        if (!Auth::attempt(['email' => $request->email, 'password' => $request->password])) {
            return $this->error('', 'Credentials do not match', 401);
        }

        $user = User::where('email', $request->email)->first();
        if (!$user->activated) {

            return $this->error('', 'Account is not activated', 401);
        }

        return $this->success([
            'user' => new UserResource($user),
            'token' => $user->createToken('Api Token of ' . $user->name)->plainTextToken
        ]);
    }

    public function activateAccount(Request $request)
    {
        $code = $request->input('code'); // استخراج الكود من الطلب

        $user = User::where('activation_code', $code)->first(); // البحث عن المستخدم باستخدام الكود

        if (!$user) {
            return $this->error('', 'Invalid activation code', 400);
        }

        // تفعيل حساب المستخدم
        $user->update([
            'activated' => true,
            'activation_code' => null,
        ]);

        return $this->success([
            'user' => new UserResource($user),
            'token' => $user->createToken('Api Token of ' . $user->name)->plainTextToken
        ], 'Account activated successfully');
    }

    public function register(StoreUserRequest $request)
    {

        $request->validated($request->all());
        $existingCodes = User::pluck('activation_code')->toArray();

        do {
            $activationCode = str_pad(rand(0, 9999), 4, '0', STR_PAD_LEFT);
        } while (in_array($activationCode, $existingCodes));


        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'activation_code' => $activationCode,
        ]);

        $content = [
            'subject' => 'TactivationCode',
            'body' => 'activationCode is :' . $activationCode,
        ];

        $sampleMail = new SampleMail($content);
        Mail::to($user->email)->send($sampleMail);



        return $this->success([
            'user' => new UserResource($user),
            'code' => $activationCode,
        ], 'Account created successfully. Please check your email for activation instructions.');
    }

    public function resendActivationCode(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:users,email',
        ]);

        return $this->generateAndSendActivationCode($request->email, 'Activation code has been generated and sent successfully.');
    }
    public function logout()
    {
        Auth::user()->currentAccessToken()->delete();

        return $this->success([], 'You have successfully been logged out and your token has been deleted');
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
            'user' => new UserResource($user),
        ], 'User data updated successfully.');
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

        return $this->generateAndSendActivationCode($newUser->email, 'New User account created successfully & Activation code has been generated and sent successfully.');
        // return $this->success([
        //     'user' => new UserResource($newUser),
        // ], 'New User account created successfully.');
    }

    public function user(Request $request)
    {
        return $request->user();
    }
}