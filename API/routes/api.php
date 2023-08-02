<?php

use App\Http\Controllers\AuthController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\Admin\AuthController as AdminAuthController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/
//Public routes
//app
Route::post('app/login', [AuthController::class, 'login']);
Route::post('app/register', [AuthController::class, 'register']);

//admin
Route::post('dashboard/login', [AdminAuthController::class, 'login']);

// Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
//     return $request->user();
// });

//admin dashboard
Route::group(['prefix' => 'dashboard', 'middleware' => ['auth:sanctum', 'admin']], function () {
    //admin test
    Route::get('/', function () {
        return "welcome Admin";
    });

    // Logout
    Route::post('/logout', [AdminAuthController::class, 'logout']);
});

//user app
Route::group(['middleware' => ['auth:sanctum'], 'prefix' => 'app'], function () {
    // Logout
    Route::post('/logout', [AuthController::class, 'logout']);

    Route::get('/', function () {
        return "welcome User";
    });
    Route::prefix('profile')->group(function () {
        Route::post('update', [AuthController::class, 'updateProfile']);
        Route::post('change-password', [AuthController::class, 'changePassword']);
        Route::post('/register-other-user', [AuthController::class, 'registerNormalUser']);
    });

});