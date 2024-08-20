<?php

namespace App\Http\Controllers;

use App\Models\AdminWallet;
use App\Models\Company;
use App\Models\CompanyWallet;
use App\Models\Event;
use App\Models\Order;
use App\Models\Review;
use App\Models\Service;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\DB;

class StatisticsController extends Controller
{
    public function getDailyStatistics(Request $request)
    {
        $request->validate([
            'date' => 'required|date',
        ]);

        $date = $request->input('date');
        //$companyId = $request->input('company_id');
        $companyId = auth()->user()->id;
        $userCount = Order::join('service_order_pivot', 'orders.id', '=', 'service_order_pivot.order_id')
            ->join('services', 'service_order_pivot.service_id', '=', 'services.id')
            ->whereDate('orders.created_at', $date)
            ->where('services.company_id', $companyId)
            ->distinct('orders.user_id')
            ->count('orders.user_id');

        $serviceCount = Service::where('company_id', $companyId)
            ->whereDate('created_at', $date)
            ->count();

        $totalProfit = CompanyWallet::where('company_id', $companyId)
            ->whereDate('created_at', $date)
            ->sum('amount');

        $averageRating = Review::join('services', 'reviews.service_id', '=', 'services.id')
            ->where('services.company_id', $companyId)
            ->whereDate('reviews.created_at', $date)
            ->avg('reviews.rate');

        return success(null, Response::HTTP_OK, [
            'date' => $date,
            'company_id' => $companyId,
            'user_count' => $userCount,
            'service_count' => $serviceCount,
            'total_profit' => $totalProfit,
            'avg_rating' => $averageRating
        ]);
    }

    public function getMonthlyStatistics(Request $request)
    {
        $request->validate([
            'date' => 'required|date_format:Y-m',
        ]);

        $date = $request->input('date');
        //$companyId = $request->input('company_id');
        $companyId = auth()->user()->id;

        $userCount = Order::join('service_order_pivot', 'orders.id', '=', 'service_order_pivot.order_id')
            ->join('services', 'service_order_pivot.service_id', '=', 'services.id')
            ->where('services.company_id', $companyId)
            ->whereMonth('orders.created_at', date('m', strtotime($date)))
            ->whereYear('orders.created_at', date('Y', strtotime($date)))
            ->distinct('orders.user_id')
            ->count('orders.user_id');

        $serviceCount = Service::where('company_id', $companyId)
            ->whereMonth('created_at', date('m', strtotime($date)))
            ->whereYear('created_at', date('Y', strtotime($date)))
            ->count();

        $totalProfit = CompanyWallet::where('company_id', $companyId)
            ->whereMonth('created_at', date('m', strtotime($date)))
            ->whereYear('created_at', date('Y', strtotime($date)))
            ->sum('amount');

        $averageRating = Review::join('services', 'reviews.service_id', '=', 'services.id')
            ->where('services.company_id', $companyId)
            ->whereMonth('reviews.created_at', date('m', strtotime($date)))
            ->whereYear('reviews.created_at', date('Y', strtotime($date)))
            ->avg('reviews.rate');

        return success(null, Response::HTTP_OK, [
            'date' => $date,
            'company_id' => $companyId,
            'user_count' => $userCount,
            'service_count' => $serviceCount,
            'total_profit' => $totalProfit,
            'avg_rating' => $averageRating
        ]);

    }

    public function getYearlyStatistics(Request $request)
    {
        $request->validate([
            'date' => 'required|date_format:Y',
        ]);

        $date = $request->input('date');
        //$companyId = $request->input('company_id');
        $companyId = auth()->user()->id;
        $userCount = Order::join('service_order_pivot', 'orders.id', '=', 'service_order_pivot.order_id')
            ->join('services', 'service_order_pivot.service_id', '=', 'services.id')
            ->where('services.company_id', $companyId)
            ->whereYear('orders.created_at', date('Y', strtotime($date)))
            ->distinct('orders.user_id')
            ->count('orders.user_id');

        $serviceCount = Service::where('company_id', $companyId)
            ->whereYear('created_at', date('Y', strtotime($date)))
            ->count();

        $totalProfit = CompanyWallet::where('company_id', $companyId)
            ->whereYear('created_at', date('Y', strtotime($date)))
            ->sum('amount');

        $averageRating = Review::join('services', 'reviews.service_id', '=', 'services.id')
            ->where('services.company_id', $companyId)
            ->whereYear('reviews.created_at', date('Y', strtotime($date)))
            ->avg('reviews.rate');

        return success(null, Response::HTTP_OK, [
            'date' => $date,
            'company_id' => $companyId,
            'user_count' => $userCount,
            'service_count' => $serviceCount,
            'total_profit' => $totalProfit,
            'avg_rating' => $averageRating
        ]);

    }

    public function totalAdminStatistics (Request $request){

        $userCount = User::count('id');
        $companyCount = Company::where('accessibility',1)->count('id');
        $events = Event::count('id');
        $profits = AdminWallet::sum('amount');

        return success(null, Response::HTTP_OK, [
            'user_count' => $userCount,
            'company_count' => $companyCount,
            'total_profit' => $profits,
            'events' => $events
        ]);
    }

    public function adminDailyStatistics(Request $request)
    {
        $request->validate([
            'date' => 'required|date',
        ]);

        $date = $request->input('date');

        $userCount =User::whereDate('created_at', $date)
            ->count('id');

        $companyCount = Company::whereDate('created_at', $date)
            ->count('id');

        $profit = AdminWallet::whereDate('created_at', $date)
            ->sum('amount');

        $events = Event::whereDate('created_at', $date)
            ->count('id');

        return success(null, Response::HTTP_OK, [
            'user_count' => $userCount,
            'company_count' => $companyCount,
            'total_profit' => $profit,
            'events' => $events
        ]);
    }

    public function adminMonthlyStatistics(Request $request)
    {
        $request->validate([
            'date' => 'required|date_format:Y-m',
        ]);

        $date = $request->input('date');

        $userCount = User::whereMonth('created_at', date('m', strtotime($date)))
            ->whereYear('created_at', date('Y', strtotime($date)))
            ->count('id');

        $companyCount = Company::whereMonth('created_at', date('m', strtotime($date)))
            ->whereYear('created_at', date('Y', strtotime($date)))
            ->count('id');

        $profit = AdminWallet::whereMonth('created_at', date('m', strtotime($date)))
            ->whereYear('created_at', date('Y', strtotime($date)))
            ->sum('amount');

        $events = Event::whereMonth('created_at', date('m', strtotime($date)))
            ->whereYear('created_at', date('Y', strtotime($date)))
            ->count('id');

        return success(null, Response::HTTP_OK, [
            'user_count' => $userCount,
            'company_count' => $companyCount,
            'total_profit' => $profit,
            'events' => $events
        ]);
    }

    public function adminYearlyStatistics(Request $request)
    {
        $request->validate([
            'date' => 'required|date_format:Y',
        ]);

        $date = $request->input('date');

        $userCount = User::whereYear('created_at', date('Y', strtotime($date)))
            ->count('id');

        $companyCount = Company::whereYear('created_at', date('Y', strtotime($date)))
            ->count('id');

        $profit = AdminWallet::whereYear('created_at', date('Y', strtotime($date)))
            ->sum('amount');

        $events = Event::whereYear('created_at', date('Y', strtotime($date)))
            ->count('id');

        return success(null, Response::HTTP_OK, [
            'user_count' => $userCount,
            'company_count' => $companyCount,
            'total_profit' => $profit,
            'events' => $events
        ]);
    }

    public function profitParagraph(Request $request)
    {
        $request->validate([
            'date' => 'required|date_format:Y',
        ]);
        $date = $request->input('date');

        $monthlyProfits = [];
        for ($month = 1; $month <= 12; $month++) {
            $startDate = date('Y-m-d', strtotime("$date-$month-01"));
            $endDate = date('Y-m-t', strtotime($startDate));

            $totalProfit = AdminWallet::whereBetween('created_at', [$startDate, $endDate])
                ->sum('amount');
            $monthlyProfits[$month] = $totalProfit;
        }
        return response()->json($monthlyProfits);
    }

    }
