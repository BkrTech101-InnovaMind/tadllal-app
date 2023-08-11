<?php

use App\Http\Controllers\Admin\UserManagementController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\FavoriteController;
use App\Http\Controllers\LocationsController;
use App\Http\Controllers\OrdersController;
use App\Http\Controllers\RatingController;
use App\Http\Controllers\RealEstateController;
use App\Http\Controllers\TypesController;
use App\Http\Controllers\UserPreferenceController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\Admin\AuthController as AdminAuthController;
use App\Http\Controllers\Admin\RealEstateController as AdminRealEstateController;
use App\Http\Controllers\Admin\TypesController as AdminTypesController;
use App\Http\Controllers\Admin\OrdersController as AdminOrdersController;

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

    Route::prefix('types')->group(function () {
        Route::resource('/types', AdminTypesController::class);
    });
    Route::prefix('locations')->group(function () {
        Route::resource('/location', AdminLocationsController::class);
    });

    Route::prefix('orders')->group(function () {
        Route::put('/approve/{orderId}', [AdminOrdersController::class, 'approveOrder']);
        Route::get('/', [AdminOrdersController::class, 'getAllOrders']);
        Route::get('/approved', [AdminOrdersController::class, 'getApprovedOrders']);
        Route::get('/pending', [AdminOrdersController::class, 'getPendingOrders']);
        Route::post('/delete/{orderId}', [AdminOrdersController::class, 'destroyOrder']);
    });

    Route::prefix('users')->group(function () {
        Route::get('/', [UserManagementController::class, 'viewUsers']);
        Route::post('/{id}', [UserManagementController::class, 'show']);
        Route::post('/add', [UserManagementController::class, 'store']);
        Route::put('/edit/{id}', [UserManagementController::class, 'modifyUser']);
        Route::put('/changeType/{id}', [UserManagementController::class, 'changeUserType']);
        Route::delete('delete/{id}', [UserManagementController::class, 'deleteUser']);

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

        Route::prefix('filters')->group(function () {
            Route::get('/by-location/{locationId}', [RealEstateController::class, 'getByLocation']);
            Route::get('/by-type/{typeId}', [RealEstateController::class, 'getByType']);
            Route::get('/by-Preference', [RealEstateController::class, 'getByUserPreference']);
            Route::get('/by-highest-rated', [RealEstateController::class, 'getHighestRated']);

            Route::get('/by-State/available', [RealEstateController::class, 'getByStateAvailable']);
            Route::get('/by-State/unavailable', [RealEstateController::class, 'getByStateUnavailable']);
            Route::get('/by-kind/forSale', [RealEstateController::class, 'getByType2ForSale']);
            Route::get('/by-kind/forRent', [RealEstateController::class, 'getByType2ForRent']);
            Route::get('/search/{query}', [RealEstateController::class, 'search']);
        });
    });

    Route::prefix('favorites')->group(function () {
        // Favorites
        Route::post('/add', [FavoriteController::class, 'addToFavorites']);
        Route::delete('/remove/{id}', [FavoriteController::class, 'removeFromFavorites']);
        Route::get('/show', [FavoriteController::class, 'getUserFavorites']);
    });
    Route::prefix('orders')->group(function () {
        Route::post('/new/{id}', [OrdersController::class, 'submitOrder']);
    });
    Route::prefix('preferences')->group(function () {
        //Add User Preference
        Route::post('/add', [UserPreferenceController::class, 'store']);
        Route::get('/show', [UserPreferenceController::class, 'getUserPreferences']);
        Route::get('/delete/{id}', [UserPreferenceController::class, 'delete']);
    });

    Route::prefix('types')->group(function () {
        Route::get('/', [TypesController::class, 'index']);
    });

    Route::prefix('locations')->group(function () {
        Route::get('/', [LocationsController::class, 'index']);
    });



});