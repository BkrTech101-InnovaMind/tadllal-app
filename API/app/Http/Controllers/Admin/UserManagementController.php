<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreUserRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use App\Traits\HttpResponses;
use Illuminate\Support\Facades\Storage;

class UserManagementController extends Controller
{
    use HttpResponses;
    public function store(StoreUserRequest $request)
    {
        $request->validated($request->all());
        $user = Auth::user();

        $newUser = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'registered_by' => $user->id,
        ]);


        return $this->success([
            'user' => new UserResource($newUser),
        ], 'New User account created successfully.');
    }

    public function deleteUser(int $userId)
    {
        $user = User::findOrFail($userId);
        if ($user) {
            $user->delete();
            return $this->success([], 'User deleted successfully');
        } else {
            return $this->error('', 'User not Found', 401);
        }



    }

    public function modifyUser(StoreUserRequest $request, int $userId)
    {
        $request->validated($request->all());

        $user = User::findOrFail($userId);
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

        if ($request->has('password')) {
            $user->password = Hash::make($request->new_password);
        }



        $user->save();

        return $this->success([
            'user' => $user,
        ], 'User data updated successfully.');
    }

    public function viewUsers()
    {
        return UserResource::collection(
            User::get()
        );
    }

    public function show(User $user)
    {
        return new UserResource($user);
    }
    public function changeUserType(Request $request, int $userId)
    {
        $data = $request->validate([
            'role' => 'required|string|in:user,admin,marketer,company',
        ]);

        $user = User::findOrFail($userId);
        if ($user) {
            $user->update([
                'role' => $data['role'],
            ]);

            return $this->success([

                'user' => $user,
            ], 'User type changed successfully');
        } else {
            return $this->error('', 'User not Found', 401);
        }


    }
}