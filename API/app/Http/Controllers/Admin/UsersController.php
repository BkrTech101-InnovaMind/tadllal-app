<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\UpdateUserRequest;
use Illuminate\Http\Request;
use App\Http\Requests\StoreUserRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use App\Traits\HttpResponses;
use Illuminate\Support\Facades\Storage;

class UsersController extends Controller
{
    use HttpResponses;
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return UserResource::collection(
            User::get()
        );
    }

    /**
     * Show the form for creating a new resource.
     */


    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreUserRequest $request)
    {
        $request->validated($request->all());
        $user = Auth::user();

        $newUser = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role' => $request->role,
            // 'registered_by' => $user->id,
        ]);


        return $this->success([
            'user' => new UserResource($newUser),
        ], 'New User account created successfully.');
    }

    /**
     * Display the specified resource.
     */
    public function show(User $user)
    {
        return new UserResource($user);
    }


    /**
     * Update the specified resource in storage.
     */
    public function update(StoreUserRequest $request, User $user)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(User $user)
    {
        if (!$user) {
            return $this->error('', 'User not found', 404);
        } else {
            $user->delete();

            return $this->success([

            ], 'The Userhas been deleted successfully');
        }
    }

    public function modifyUser(UpdateUserRequest $request, $userId)
    {
        $request->validated($request->all());

        $user = User::findOrFail($userId);
        if (!$user) {
            return $this->error('', 'User not found', 404);
        }
        if ($request->has('name')) {
            $user->name = $request->name;
        }
        if ($request->has('role')) {
            $user->role = $request->role;
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