<?php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\CompanyController;
use App\Http\Controllers\CustomizedServiceController;
use App\Http\Controllers\EventController;
use App\Http\Controllers\EventTypeController;
use App\Http\Controllers\FavoriteController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\ReviewController;
use App\Http\Controllers\ServiceController;
use App\Http\Controllers\StatisticsController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\WalletController;
use App\Http\Controllers\YouAndUsController;
use App\Http\Controllers\PackageController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

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

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
Route::get('/admin',[AdminController::class ,'admin']);

Route::controller(UserController::class)->group(function() {
    Route::post('/register', 'register');
    Route::post('/verRegistereOTP', 'verRegistereOTP');
    Route::post('/sendOTP', 'sendOTP');
    Route::post('/verAuthOTP' , 'verAuthOTP');
    Route::post('resetPass','resetPass');
    Route::get('/allUsers', 'allUsers');
    Route::post('/postUser', 'postUser');
});
Route::apiResource('/categories', CategoryController::class)->middleware('locale');
Route::apiResource('/event-type', EventTypeController::class)->middleware('locale');

Route::get('/shares', [YouAndUsController::class, 'index'])->middleware('locale');
Route::get('/shares/{youAndUs}', [YouAndUsController::class, 'show'])->middleware('locale');
Route::get('/notification', [UserController::class,'notification']);
Route::middleware(['auth:sanctum'])->group(function() {
    Route::controller(UserController::class)->group(function () {
        Route::post('/login', 'login');
        Route::post('/logout', 'logout');
        Route::post('/changePass', 'changePass');
        Route::post('/resetName', 'resetName');
        Route::post('/resetImage', 'resetImage');
        Route::get('/loggedUser', 'logged_user');
        Route::post('/changeEmailOTP', 'changeEmailOTP');
//        Route::get('/notification', 'notification');
        Route::post('/updateFCM', 'updateFCM');
    });
    Route::get('/companies/allCompanies', [CompanyController::class ,'allCompanies'] )->middleware('locale');
});
    Route::middleware(['locale'])->group(function() {
        Route::apiResource('/services', ServiceController::class);

        Route::get('/categories/{category}/services', [ServiceController::class, 'indexByCategory']);

        Route::apiResource('/event-type', EventTypeController::class);
        Route::delete('/event-type/{event_type}/delete', [EventTypeController::class, 'destroy']);
        Route::middleware(['auth:sanctum'])->group(function(){
            Route::apiResource('/events', EventController::class);
            Route::delete('/events/{event}/delete', [EventController::class, 'destroy']);
            Route::get('/events/orderBy/planning', [EventController::class, 'indexPlanning']);
            Route::get('/events/orderBy/completed', [EventController::class, 'indexCompleted']);
            Route::get('getYouAndUsByUser/{user_id}', [YouAndUsController::class, 'getYouAndUsByUser']);
            Route::post('/shares', [YouAndUsController::class, 'store']);
            Route::delete('/shares/{youAndUs}', [YouAndUsController::class, 'destroy']);
        });
    });

        Route::middleware(['locale'])->group(function () {
            Route::apiResource('/packages', PackageController::class);
            Route::delete('/packages/{package}', [PackageController::class, 'destroy']);
            Route::get('/packages/services/packagable', [PackageController::class, 'indexPackagableServices']);
        });

        Route::get('/companies/{company}/services', [ServiceController::class, 'indexCompanyServices'])->middleware('locale');

        /////////// company api's  //////////
        Route::post('/companies/login', [CompanyController::class, 'login'])->middleware('locale');
        Route::post('/insertcompany', [CompanyController::class ,'insertcompany'] )->middleware('locale');
        Route::post('/companies/sendOTP', [CompanyController::class ,'sendOTP'] );
        Route::post('/companies/verAuthOTP', [CompanyController::class ,'verAuthOTP'] );
        Route::post('/companies/resetPass', [CompanyController::class ,'resetPass'] );
        Route::post('/companies/updateFCM', [CompanyController::class ,'updateFCM']);
        Route::middleware('auth:company')->group(function () {
            Route::controller(CompanyController::class)->group(function () {
                Route::get('/companies/logout', 'logout');
                Route::post('/companies/changeEmailOTP', 'changeEmailOTP');
                Route::post('/companies/verEmail', 'verEmail' );
                Route::post('/companies/changePass', 'changePass');
                Route::put('/companies/update', 'update')->middleware('locale');
            });
            Route::controller(StatisticsController::class)->group(function () {
                Route::post('/company/statistics/DailyStatistics','getDailyStatistics');
                Route::post('/company/statistics/MonthlyStatistics','getMonthlyStatistics');
                Route::post('/company/statistics/YearlyStatistics','getYearlyStatistics');
            });
        });

        Route::apiResource('/wallets', WalletController::class);
        Route::get('/userwallets/{user_id}',[WalletController::class, 'userWallet']);

        Route::middleware(['auth:sanctum'])->group(function(){
            Route::apiResource('/reviews', ReviewController::class);
            Route::delete('/reviews/{review}', [ReviewController::class, 'destroy']);
            Route::post('/reviews/{service}', [ReviewController::class, 'showServiceReviews']);
            Route::apiResource('/favorites', FavoriteController::class)->middleware('locale');
            Route::delete('/favorites/{service}', [FavoriteController::class, 'destroy']);

        });
        Route::middleware(['locale'])->group(function () {
            Route::apiResource('/services', ServiceController::class);
            Route::delete('/services/{service}/delete', [ServiceController::class, 'destroy']);
            Route::post('/services/{service}/update-activation', [ServiceController::class, 'updateActivation']);
            Route::post('/search/{category}', [ServiceController::class, 'search']);
            Route::post('/search_company',[ServiceController::class,'searchCompany'])->middleware(['auth:sanctum']);
        });

Route::middleware('locale')->group(function(){
Route::controller(OrderController::class)->group(function() {
    Route::get('/pending_orders/{user_id}','getpendingOrders');
    Route::get('/processed_orders/{user_id}','getprocessedOrder');
    Route::post('/insert_order' , 'createOrder');
    Route::get('/check_orders/{eventId}/',  'checkEventOrders');/////بيتأكد اذا فيه للايفنت اوردر او لا
    Route::post('/order_details','getOrderDetails');
    //Route::post('/update_order_status','updateOrderStatus');
    Route::post('/update_service_status' ,'updateServiceStatus');
    Route::get('/accepted_services/{orderId}','getAcceptedServices');//بجيب الخدمات المقبولة للاوردر
    Route::get('/accepted_service_event/{eventId}/', 'getAcceptedServicesForEvent');//بجيب كل الخدمات المقبولة للايفنت
    Route::post('/order_package','createOrderFromPackage');
    Route::get('/company/{companyId}/pending-services', 'getPendingCompany');
    Route::get('/company/{companyId}/processed-services', 'getProcessedCompany');
});
});
Route::middleware(['auth:sanctum'])->group(function() {
    Route::post('/customized-services', [CustomizedServiceController::class, 'store'])->middleware('locale');
    Route::get('/customized-services/{customizedService}', [CustomizedServiceController::class, 'show'])->middleware('locale');
});

Route::middleware('auth:company')->group(function () {
    Route::delete('/services/{service}/delete', [ServiceController::class, 'destroy']);
    Route::post('/services/{service}/update-activation', [ServiceController::class, 'updateActivation']);
    Route::get('/companies/companyWallet', [WalletController::class ,'companyWallet'] );
    Route::get('/companies/terms-and-condition/pdf', [CompanyController::class, 'pdf']);
});

Route::middleware('locale')->group(function (){
    Route::get('/companies/{company}/show-one', [CompanyController::class, 'show']);
    Route::get('/admin/applications', [AdminController::class ,'applications'] );
});


Route::post('/insertadmin',[AdminController::class ,'admin']);
Route::post('/admin/login',[AdminController::class ,'login']);
Route::get('/admin/sendOTP',[AdminController::class ,'sendOTP']);
Route::post('/admin/verAuthOTP',[AdminController::class ,'verAuthOTP']);
Route::post('/admin/resetPass',[AdminController::class ,'resetPass']);
Route::middleware('auth:admin')->group(function () {
    Route::controller(AdminController::class)->group(function () {
        Route::get('/admin/logout', 'logout');
        Route::post('/admin/acceptCompany', 'acceptCompany');
        Route::post('/admin/userSearch', 'userSearch');
        Route::post('/admin/companySearch', 'companySearch')->middleware('locale');
        Route::delete('/admin/deleteCompany/{id}', 'deleteCompany');
        Route::delete('/admin/deleteUser/{id}', 'deleteUser');
    });
    Route::get('/admin/totalStatistics',[StatisticsController::class ,'totalAdminStatistics']);
    Route::post('/admin/DailyStatistics',[StatisticsController::class ,'adminDailyStatistics']);
    Route::post('/admin/MonthlyStatistics',[StatisticsController::class ,'adminMonthlyStatistics']);
    Route::post('/admin/YearlyStatistics',[StatisticsController::class ,'adminYearlyStatistics']);
    Route::post('/admin/profitParagraph',[StatisticsController::class ,'profitParagraph']);
    Route::get('/admin/allCompanies', [CompanyController::class ,'allCompanies'] )->middleware('locale');
    Route::get('/admin/allUsers', [UserController::class ,'allUsers'] );
    Route::post('/admin/categories', [CategoryController::class , 'store'])->middleware('locale');
});
