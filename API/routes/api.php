<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\FavoriteController;
use App\Http\Controllers\RatingController;
use App\Http\Controllers\RealEstateController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\Admin\AuthController as AdminAuthController;
use App\Http\Controllers\Admin\RealEstateController as AdminRealEstateController;

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
Route::post('admin/login', [AdminAuthController::class, 'login']);

// Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
//     return $request->user();
// });

//admin dashboard
Route::group(['prefix' => 'dashboard', 'middleware' => ['auth:sanctum', 'admin']], function () {
    //admin test
    Route::get('/', function () {
        return "welcome Admin";
    });

    Route::prefix('realEstate')->group(function () {
        Route::resource('/realty', AdminRealEstateController::class);
        Route::post('/{id}/edit', [AdminRealEstateController::class, 'updateRealEstate']);
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

    Route::prefix('realEstate')->group(function () {
        Route::resource('/realty', RealEstateController::class);
        // Rating
        Route::post('/rate', [RatingController::class, 'rateRealEstate']);
    });

    Route::prefix('favorites')->group(function () {
        // Favorites
        Route::post('/add', [FavoriteController::class, 'addToFavorites']);
        Route::delete('/remove/{id}', [FavoriteController::class, 'removeFromFavorites']);
        Route::get('/show', [FavoriteController::class, 'getUserFavorites']);
    });




});