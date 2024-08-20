<?php

namespace App\Http\Controllers;

use App\Constants\Constants;
use App\Http\Resources\CompanyResource;
use App\Http\Resources\CustomizedServiceResource;
use App\Models\Company;
use App\Services\Api\SendNotification;
use Illuminate\Database\Eloquent\Builder;
use App\Http\Resources\ImageResource;
use App\Http\Resources\ServiceResource;
use App\Models\AdminWallet;
use App\Models\CompanyWallet;
use App\Models\CustomizedService;
use App\Models\Order;
use App\Models\Package;
use App\Models\Service;
use App\Models\Event;
use App\Models\User;
use App\Models\UserWallet;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Stichoza\GoogleTranslate\GoogleTranslate;



use Illuminate\Http\Request;

class OrderController extends Controller
{
    //////////////////////////////////////////////get all orders for user
    public function allOrdersForUser($id)
    {
        $all = DB::table('orders')->where('user_id', $id)->get();
        return $all;
    }

    ///////////////////////////////////////////////get user order based on order status(شغال)
    public function getpendingOrders($user_id)
    {
        $user = User::where('id', $user_id)->get();
        $penorders = Order::where('user_id', $user_id)
            ->where('status', 'pending')
            ->with('event')
            ->get();
        $response = $penorders->map(function ($order) {
            return [
                'id' => $order->id,
                'status' => $order->status,
                'total_price' => $order->total_price,
                'order_date' => $order->order_date,
                'user_id' => $order->user_id,
                'event_id' => $order->event_id,
                'event_name' => $order->event->name,
                'created_at' => $order->created_at,
                'updated_at' => $order->updated_at,
            ];
        });

        return response()->json([
            'pending_order' => $response,
        ]);
    }

    public function getprocessedOrder($user_id)
    {
        $processedOrder = Order::where('user_id', $user_id)
            ->where('status', 'processed')
            ->with('event')
            ->get();
        $response = $processedOrder->map(function ($order) {
            return [
                'id' => $order->id,
                'status' => $order->status,
                'total_price' => $order->total_price,
                'order_date' => $order->order_date,
                'user_id' => $order->user_id,
                'event_id' => $order->event_id,
                'event_name' => $order->event->name,
                'created_at' => $order->created_at,
                'updated_at' => $order->updated_at,
            ];
        });

        return response()->json([
            'pending_order' => $response,
        ]);
    }

    ///////////////////////////////////////////////////get all order details
    public function getOrderDetails(Request $request)
    {
        $validated = $request->validate([
            'order_id' => 'required|integer|exists:orders,id',
        ]);

        $orderId = $validated['order_id'];
        $order = Order::with(['services', 'customizedServices.service.images', 'event'])->findOrFail($orderId);
        // $locale = app()->getLocale();
        // $acceptedStatus = Constants::SERVICE_ORDER_STATUSES['ACCEPTED'][$locale];
        $acceptedStatus = Constants::SERVICE_ORDER_STATUSES['ACCEPTED']['en'];
        $totalAcceptedServicesPrice = 0;
        foreach ($order->services as $service) {
            // $status = json_decode($service->pivot->status, true);
            $status = json_decode($service->pivot->status, true);
            // if (isset($status[$locale]) && $status[$locale] === $acceptedStatus) {
            if (isset($status) && $status['en'] === $acceptedStatus) {
                $totalAcceptedServicesPrice += $service->pivot->price;
            }
        }

        foreach ($order->customizedServices as $customizedService) {
            // $status = json_decode($customizedService->status, true);
            $status = json_decode($customizedService->status, true);
            if (isset($status) && $status['en'] === $acceptedStatus) {
                $totalAcceptedServicesPrice += $customizedService->price;
            }
        }

        return response()->json([
            'services' => ServiceResource::collection($order->services),
            'customized_services' => CustomizedServiceResource::collection($order->customizedServices),
            'accepted_services_price' => $totalAcceptedServicesPrice,
            'event_name' => $order->event ? $order->event->name : null,
        ]);
    }


    //////////////////////////////////////////////////update status for order(pending,processed)
//    public function updateOrderStatus(Request $request){
//
//        $orderId = $request->input('order_id');
//        $order = Order::with('services')->find($orderId);
//
//        if (!$order) {
//            return response()->json(['error' => 'Order not found'], 404);
//        }
//        $services = $order->services;
//        $allServicesProcessed = true;
//        foreach ($services as $service) {
//            if ($service->pivot->status == json_encode(Constants::SERVICE_ORDER_STATUSES['PENDING'])) {
//                $allServicesProcessed = false;
//                break;
//            }
//        }
//
//        // Update order status based on services' statuses
//        if ($allServicesProcessed) {
//            $order->status = 'processed';
//        } else {
//            $order->status = 'pending';
//        }
//        $order->save();
//        return response()->json([
//            'order_id' => $order->id,
//            'status' => $order->status
//        ]);
//    }
    /////////////////////////////////////////update service status
    public function updateServiceStatus(Request $request)
    {
        $validated = $request->validate([
            'order_id' => 'required|exists:orders,id',
            'service_id' => 'integer|nullable',
            'customized_service_id' => 'integer|nullable',
            'status' => 'required|in:PENDING,ACCEPTED,REJECTED',
        ]);

        $orderId = $validated['order_id'];
        $serviceId = $validated['service_id'] ?? null;
        $customizedServiceId = $validated['customized_service_id'] ?? null;
        $status = $validated['status'];
        //$price = 0;
        $adminUserId = 1; // Change to your actual admin user ID

        if ($serviceId) {
            // Handle normal services
            $pivot = DB::table('service_order_pivot')
                ->where('order_id', $orderId)
                ->where('service_id', $serviceId)
                ->first();

            if (!$pivot) {
                return response()->json(['message' => 'Service not found in the order'], 404);
            }

            // Update the status
            DB::table('service_order_pivot')
                ->where('id', $pivot->id)
                ->update(['status' => json_encode(Constants::SERVICE_ORDER_STATUSES[$status])]);
            // ->update(['status' => Constants::SERVICE_ORDER_STATUSES[$status]]);

            if ($status == 'REJECTED') {
                /////////notification
                $notification = new SendNotification();
                $service = Service::findorfail($serviceId);
                $massage = $service->name . ' Has Been Rejected';
                $orderid = Order::where('id',$orderId)->first();
                $user = User::findorfail($orderid->user_id);
                $notification->sendToUser($user,$massage,'We regret to inform you that your order has been rejected. Please contact us for further details.');
            }
            if ($status == 'ACCEPTED') {

                /////////notification
                $notification = new SendNotification();
                $service = Service::findorfail($serviceId);
                $title = $service->name . ' Has Been Accepted!';
                $orderid = Order::where('id',$orderId)->first();
                $user = User::findorfail($orderid->user_id);
                $notification->sendToUser($user, $title, 'We will start processing it shortly');
                /////////////////////
                $price = $pivot->price;

                $order = Order::find($orderId);
                $userWallet = UserWallet::where('user_id', $order->user_id)->first();
                $userWallet->decrement('amount', $price);

                // Find the company associated with the service
                $service = Service::find($serviceId);
                $companyWallet = CompanyWallet::where('company_id', $service->company_id)->first();

                // Subtract 5% commission
                $commission = $price * 0.05;
               // $companyWallet->decrement('amount', $commission);
                $companyWallet->increment('amount', $price);

                $companyWallet->decrement('amount', $commission);


                // Add commission to admin's wallet
                $adminWallet = AdminWallet::where('admin_id', $adminUserId)->first();
                $adminWallet->increment('amount', $commission);

                // Add remaining price to the company's wallet
//                $companyWallet->increment('amount', $price - $commission);
            }
        } elseif ($customizedServiceId) {
            // Handle customized services
            $customizedService = CustomizedService::where('id', $customizedServiceId)
                ->where('order_id', $orderId)
                ->first();

            if (!$customizedService) {
                return response()->json(['message' => 'Customized service not found in the order'], 404);
            }

            // Update the status
            $customizedService->status = json_encode(Constants::SERVICE_ORDER_STATUSES[$status]);
            // $customizedService->status = Constants::SERVICE_ORDER_STATUSES[$status];
            $customizedService->save();

            if ($status == 'REJECTED') {
                /////////notification
                $notification = new SendNotification();
                $service = Service::findorfail($customizedService->service_id);
                $massage = $service->name . 'Has Been Rejected';
                $user = User::findorfail($customizedService->user_id);
                $not =$notification->sendToUser($user,$massage,'We regret to inform you that your order has been rejected. Please contact us for further details.');
                //return $not;
            }

            if ($status == 'ACCEPTED') {
                /////////notification
                $notification = new SendNotification();
                $service = Service::findorfail($customizedService->service_id);
                $title = $service->name . 'Has Been Accepted!';
                $user = User::findorfail($customizedService->user_id);
                $not =$notification->sendToUser($user, $title, 'We will start processing it shortly');
                //return $not;
                /////////////////////
                $price = $customizedService->price;

                $order = Order::find($orderId);
                $userWallet = UserWallet::where('user_id', $order->user_id)->first();
                $userWallet->decrement('amount', $price);

                // Find the company associated with the service
                $service = Service::find($customizedService->service_id);
                $companyWallet = CompanyWallet::where('company_id', $service->company_id)->first();

                // Subtract 2.5% commission
                $commission = $price * 0.05;
                $companyWallet->increment('amount', $price);

                 $companyWallet->decrement('amount', $commission);

                // Add commission to admin's wallet
                $adminWallet = AdminWallet::where('admin_id', $adminUserId)->first();
                $adminWallet->increment('amount', $commission);

                // Add remaining price to the company's wallet
//                $companyWallet->increment('amount', $price - $commission);
            }
        } else {
            return response()->json(['message' => 'Service or Customized Service ID required'], 400);
        }

        // Update order status
        $order = Order::with('services', 'customizedServices')->find($orderId);

        if (!$order) {
            return response()->json(['error' => 'Order not found'], 404);
        }

        $services = $order->services;
        $customizedServices = $order->customizedServices;
        $allServicesProcessed = true;

        foreach ($services as $service) {
            // if ($service->pivot->status == json_encode(Constants::SERVICE_ORDER_STATUSES['PENDING'])) {
            $status = json_decode($service->pivot->status,true);
            if ($status['en'] == Constants::SERVICE_ORDER_STATUSES['PENDING']['en']) {
                // if ($service->pivot->status->getTranslation('status', 'en') == Constants::SERVICE_ORDER_STATUSES['PENDING']['en']) {
                $allServicesProcessed = false;
                break;
            }
        }

        foreach ($customizedServices as $customizedService) {
            // if ($customizedService->status == json_encode(Constants::SERVICE_ORDER_STATUSES['PENDING'])) {
            $status = json_decode($customizedService->status,true);
            if ($status['en'] == Constants::SERVICE_ORDER_STATUSES['PENDING']['en']) {
                // if ($customizedService->status->getTranslation('status', 'en') == Constants::SERVICE_ORDER_STATUSES['PENDING']['en']) {
                $allServicesProcessed = false;
                break;
            }
        }

        // Update order status based on services' statuses
        if ($allServicesProcessed) {
            $order->status = 'processed';
        } else {
            $order->status = 'pending';
        }
        $order->save();

        return response()->json(['message' => 'Service status and order status updated successfully'], 200);
    }


    ///////////////////////////Insert order
    public function createOrder(Request $request)
    {
        $currentLocale = app()->getLocale();
        $targetLocale = ($currentLocale === 'en') ? 'ar' : 'en';
        $lang = new GoogleTranslate($currentLocale);
        $lang->setSource($currentLocale)->setTarget($targetLocale);

        $validated = $request->validate([
            'event_id' => 'required|exists:events,id',
            'user_id' => 'required',
            'services' => 'required|array',
            'services.*.id' => 'required|exists:services,id',
            'services.*.quantity' => 'required|integer|min:1',
            'customized_services' => 'sometimes|array',
            'customized_services.*.price' => 'required_with:customized_services|numeric|min:0',
            'customized_services.*.description' => 'required_with:customized_services|string',
            'customized_services.*.service_id' => 'required_with:customized_services|exists:services,id',
        ]);

        $event_id = $validated['event_id'];
        $user_id = $validated['user_id'];
        $normalServices = $validated['services'];
        $customizedServices = $validated['customized_services'] ?? [];

        // Calculate total price first
        $totalPrice = 0;

        foreach ($normalServices as $normalService) {
            $service = Service::find($normalService['id']);
            $quantity = $normalService['quantity'];
            $price = $service->price * $quantity;
            $totalPrice += $price;
        }

        foreach ($customizedServices as $customizedService) {
            $totalPrice += $customizedService['price'];
        }

        $userWallet = UserWallet::where('user_id', $user_id)->first();
        if ($userWallet->amount < $totalPrice) {
            return response()->json(['message' => 'You do not have enough money'], 400);
        }

        // Create the order
        $order = new Order();
        $order->event_id = $event_id;
        $order->user_id = $user_id;
        $order->status = 'pending';
        $order->total_price = $totalPrice;
        $order->order_date = now();
        $order->save();

        foreach ($normalServices as $normalService) {
            $service = Service::find($normalService['id']);
            $quantity = $normalService['quantity'];
            $price = $service->price * $quantity;

            $company = Company::findorfail($service->company_id);
            $notification = new SendNotification();
            $massage = 'A new order has been placed for ' . $service->name . ' service';
            $notification->sendToCompany($company, 'New Order Received!', $massage);

            $order->services()->attach($service->id, [
                'status' => json_encode(Constants::SERVICE_ORDER_STATUSES['PENDING']),
                // 'status' => Constants::SERVICE_ORDER_STATUSES['PENDING'],
                'price' => $price,
                'quantity' => $quantity,
            ]);
        }

        foreach ($customizedServices as $customizedService) {
            $description = [
                $currentLocale => $customizedService['description'],
                $targetLocale => $lang->translate($customizedService['description'])
            ];

            $customized = new CustomizedService();
            $customized->price = $customizedService['price'];
            $customized->description = json_encode($description);
            $customized->status = json_encode(Constants::SERVICE_ORDER_STATUSES['PENDING']);
            // $customized->status = Constants::SERVICE_ORDER_STATUSES['PENDING'];
            $customized->user_id = $user_id;
            $customized->order_id = $order->id;
            $customized->service_id = $customizedService['service_id'];
            $customized->save();

            $serviceCustom= Service::findorfail($customized->service_id);
            $companyCustom = Company::findorfail($serviceCustom->company_id);
            $notification = new SendNotification();
            $massage = 'A new order has been placed for' . $serviceCustom->name . 'service';
            $notification->sendToCompany($companyCustom, 'New Order Received!', $massage);
        }

        return response()->json(['message' => 'Order created successfully', 'order_id' => $order->id], 201);
    }
    //////////////////////////////////////////
    public function deleteOrder(Request $request)
    {
        $order = Order::where($request->input('order_id'))->first();
        $order->delete();
    }

/////////////////////////////////////////////////////////////////////
    public function getAcceptedServices($orderId)
    {
        // $locale = app()->getLocale();
        // $acceptedStatus = Constants::SERVICE_ORDER_STATUSES['ACCEPTED'][$locale];
        $acceptedStatus = Constants::SERVICE_ORDER_STATUSES['ACCEPTED']['en'];

        $order = Order::with('services', 'customizedServices')->find($orderId);

        if (!$order) {
            return response()->json(['message' => 'Order not found'], 404);
        }

        $acceptedServices = $order->services->filter(function ($service) use ($acceptedStatus) {
            // $status = json_decode($service->pivot->status, true);
            $status = json_decode($service->pivot->status);
            // return isset($status[app()->getLocale()]) && $status[app()->getLocale()] === $acceptedStatus;
            return isset($status) && $status['en'] === $acceptedStatus;
        });
        $acceptedcustomizedServices = $order->customizedServices->filter(function ($customizedService) use ($acceptedStatus) {
            $status = json_decode($customizedService->status, true);
            // return isset($status[app()->getLocale()]) && $status[app()->getLocale()] === $acceptedStatus;
            return isset($status) && $status['en'] === $acceptedStatus;

        });

        return response([
            'services' => ServiceResource::collection($acceptedServices),
            'customized_services' => CustomizedServiceResource::collection($acceptedcustomizedServices)
        ]);

    }

    ////////////////////////////////////////
    public function checkEventOrders($eventId)
    {
        $event = Event::with('orders')->find($eventId);

        if (!$event) {
            return response()->json(['message' => 'Event not found'], 404);
        }

        $hasOrders = $event->orders->isNotEmpty();

        return response()->json([
            'event_id' => $eventId,
            'has_orders' => $hasOrders,
        ]);
    }

    ///////////////////////////////////
    public function getAcceptedServicesForEvent($eventId)
    {
        $locale = app()->getLocale();
        // $acceptedStatus = Constants::SERVICE_ORDER_STATUSES['ACCEPTED'][$locale];
        $acceptedStatus = Constants::SERVICE_ORDER_STATUSES['ACCEPTED']['en'];
        $event = Event::with(['orders.services', 'orders.customizedServices'])->find($eventId);
        if (!$event) {
            return response()->json(['message' => 'Event not found'], 404);
        }
        $services = collect();
        $customizedServices = collect();
        $totalAcceptedServicesPrice = 0;

        foreach ($event->orders as $order) {
            // Normal services
            foreach ($order->services as $service) {
                $status = json_decode($service->pivot->status, true);
                // $status = $service->pivot->status->getTranslation('status', 'en');
                // if (isset($status[$locale]) && $status[$locale] === $acceptedStatus) {
                if (isset($status) && $status['en'] === $acceptedStatus) {
                    $images = $service->images->map(function ($image) {
                        return [
                            'id' => $image->id,
                            'url' => $image->url,
                        ];
                    });

                    $services->push([
                        'name' => $service->name,
                        'quantity' => $service->pivot->quantity,
                        'price' => $service->pivot->price,
                        'images' => $images,
                    ]);
                    $totalAcceptedServicesPrice += $service->pivot->price;
                }
            }

            // Customized services
            foreach ($order->customizedServices as $customizedService) {
                $status = json_decode($customizedService->status, true);
                // $status = $customizedService->status->getTranslation('status', 'en');
                // if (isset($status[$locale]) && $status[$locale] === $acceptedStatus) {
                if (isset($status) && $status['en'] === $acceptedStatus) {
                    $images = $service->images->map(function ($image) {
                        return [
                            'id' => $image->id,
                            'url' => $image->url,
                        ];
                    });
                    $description = json_decode($customizedService->description, true);
                    $localizedDescription = $description[$locale] ?? '';
                    $customizedServices->push([
                        'description' => $localizedDescription,
                        'price' => $customizedService->price,
                        'images' => $images,
                        'name'=>$service->name,

                    ]);
                    $totalAcceptedServicesPrice += $customizedService->price;
                }
            }
        }

        return response()->json([
            'services' => $services,
            'customized_services' => $customizedServices,
            'total_accepted_services_price' => $totalAcceptedServicesPrice,
        ]);
    }

    //////////////////////////////////////////////////////
    public function createOrderFromPackage(Request $request)
    {
        $validated = $request->validate([
            'package_id' => 'required|exists:packages,id',
            'user_id' => 'required|exists:users,id',
            'event_id' => 'required|exists:events,id'
        ]);

        $package_id = $validated['package_id'];
        $user_id = $validated['user_id'];

        $package = Package::with('services')->findOrFail($package_id);
        $services = $package->services;

        // Create the order
        $order = new Order();
        $order->event_id = $validated['event_id'];
        $order->user_id = $user_id;
        $order->status = 'pending';
        $order->total_price = 0;
        $order->order_date = now();
        $order->save();

        $totalPrice = 0;

        // Attach discounted services to the order
        foreach ($services as $service) {
            $quantity = 1; // Assuming quantity is 1, you can modify as needed
            $originalPrice = $service->price;
            $discountedPrice = $originalPrice * 0.05;
            $price = $discountedPrice * $quantity;
            $totalPrice += $price;

            $order->services()->attach($service->id, [
                'status' => json_encode(Constants::SERVICE_ORDER_STATUSES['PENDING']),
                // 'status' => Constants::SERVICE_ORDER_STATUSES['PENDING']['en'],
                'price' => $price,
                'quantity' => $quantity,
            ]);
        }

        $order->total_price = $totalPrice;
        $order->save();

        return ('Order created successfully from package');
    }
//////////////////////////////////////////////////////////
    public function getPendingCompany($companyId) {
        $locale = app()->getLocale();
        $pendingStatus = Constants::SERVICE_ORDER_STATUSES['PENDING'][$locale];

        // Retrieve services with pending status for the specified company
        $services = Service::where('company_id', $companyId)
            ->whereHas('orders', function ($query) use ($pendingStatus, $locale) {
                $query->where(DB::raw("JSON_UNQUOTE(JSON_EXTRACT(service_order_pivot.status, '$.\"$locale\"'))"), '=', $pendingStatus);
            })
            ->with(['orders' => function ($query) use ($locale, $pendingStatus) {
                $query->where(DB::raw("JSON_UNQUOTE(JSON_EXTRACT(service_order_pivot.status, '$.\"$locale\"'))"), '=', $pendingStatus)
                    ->with('user', 'event');
            }, 'images'])
            ->get();

        // Retrieve customized services with pending status for the specified company
        $customizedServices = CustomizedService::whereHas('service', function ($query) use ($companyId) {
            $query->where('company_id', $companyId);
        })
            ->where(DB::raw("JSON_UNQUOTE(JSON_EXTRACT(JSON_UNQUOTE(JSON_EXTRACT(status, '$.\"$locale\"')), '$.\"$locale\"'))"), '=', $pendingStatus)
            ->with(['orders.user', 'orders.event', 'service.images'])
            ->get();

//        if ($customizedServices->isEmpty()) {
//            return response()->json(['message' => 'No customized services found with pending status for this company.'], 404);
//        }

        // Format the response for services
        $serviceResults = [];

        foreach ($services as $service) {
            foreach ($service->orders as $order) {
                $serviceResults[] = [
                    'service_name' => $service->name,
                    'service_id'=>$service->id,
                    'service_images' => $service->images->map(function ($image) {
                        return [
                            'id' => $image->id,
                            'url' => $image->url,
                        ];
                    }),
                    'user_name' => $order->user->name,
                    'order_date' => $order->order_date,
                    'event_date' => $order->event->date,
                    'quantity' => $order->pivot->quantity,
                'price' => $order->pivot->price,
                    'description' => $service->getTranslation('description', $locale),
                    'order_id' => $order->id,
                ];
            }
        }

        // Format the response for customized services
        $customizedServiceResults = $customizedServices->map(function ($customizedService) use ($locale) {
            $description = json_decode($customizedService->description, true);
            $localizedDescription = $description[$locale] ?? '';
            return [
                'service_name' => $customizedService->service->name,
                'customized_service_id'=>$customizedService->id,
                'service_images' => $customizedService->service->images->map(function ($image) {
                    return [
                        'id' => $image->id,
                        'url' => $image->url,
                    ];
                }),
                'user_name' => $customizedService->orders->first()->user->name,
                'order_date' => $customizedService->orders->first()->order_date,
                'event_date' => $customizedService->orders->first()->event->date,
                'description' => $localizedDescription,
                'price' => $customizedService->price,
                'order_id' => $customizedService->order_id,
            ];
        });

        return response()->json([
            'services' => $serviceResults,
            'customized_services' => $customizedServiceResults,
        ]);
    }


//////////////////////////////////////////////
    public function getProcessedCompany($companyId) {
        $locale = app()->getLocale();
        $acceptedStatus = Constants::SERVICE_ORDER_STATUSES['ACCEPTED'][$locale];
        $rejectedStatus = Constants::SERVICE_ORDER_STATUSES['REJECTED'][$locale];

        // Retrieve services with accepted or rejected status for the specified company
        $services = Service::where('company_id', $companyId)
            ->whereHas('orders', function ($query) use ($acceptedStatus, $rejectedStatus, $locale) {
                $query->where(function ($query) use ($acceptedStatus, $rejectedStatus, $locale) {
                    $query->where(DB::raw("JSON_UNQUOTE(JSON_EXTRACT(service_order_pivot.status, '$.\"$locale\"'))"), '=', $acceptedStatus)
                        ->orWhere(DB::raw("JSON_UNQUOTE(JSON_EXTRACT(service_order_pivot.status, '$.\"$locale\"'))"), '=', $rejectedStatus);
                });
            })
            ->with(['orders' => function ($query) use ($locale, $acceptedStatus, $rejectedStatus) {
                $query->where(function ($query) use ($acceptedStatus, $rejectedStatus, $locale) {
                    $query->where(DB::raw("JSON_UNQUOTE(JSON_EXTRACT(service_order_pivot.status, '$.\"$locale\"'))"), '=', $acceptedStatus)
                        ->orWhere(DB::raw("JSON_UNQUOTE(JSON_EXTRACT(service_order_pivot.status, '$.\"$locale\"'))"), '=', $rejectedStatus);
                })
                    ->with('user', 'event');
            }, 'images'])
            ->get();

        // Retrieve customized services with accepted or rejected status for the specified company
        $customizedServices = CustomizedService::whereHas('service', function ($query) use ($companyId) {
            $query->where('company_id', $companyId);
        })
            ->where(function ($query) use ($acceptedStatus, $rejectedStatus, $locale) {
                $query->where(DB::raw("JSON_UNQUOTE(JSON_EXTRACT(JSON_UNQUOTE(JSON_EXTRACT(status, '$.\"$locale\"')), '$.\"$locale\"'))"), '=', $acceptedStatus)
                    ->orWhere(DB::raw("JSON_UNQUOTE(JSON_EXTRACT(JSON_UNQUOTE(JSON_EXTRACT(status, '$.\"$locale\"')), '$.\"$locale\"'))"), '=', $rejectedStatus);
            })
            ->with(['orders.user', 'orders.event', 'service.images'])
            ->get();
        $customizedServices = CustomizedService::whereHas('service', function ($query) use ($companyId) {
            $query->where('company_id', $companyId);
        })
            ->where(DB::raw("JSON_UNQUOTE(JSON_EXTRACT(JSON_UNQUOTE(JSON_EXTRACT(status, '$.\"$locale\"')), '$.\"$locale\"'))"), '=', $acceptedStatus)
            ->orWhere(DB::raw("JSON_UNQUOTE(JSON_EXTRACT(JSON_UNQUOTE(JSON_EXTRACT(status, '$.\"$locale\"')), '$.\"$locale\"'))"), '=', $rejectedStatus)
            ->with(['orders.user', 'orders.event', 'service.images'])
            ->get();

        if ($customizedServices->isEmpty() && $services->isEmpty()) {
            return response()->json(['message' => 'No services found with accepted or rejected status for this company.'], 404);
        }

        // Format the response for services
        $serviceResults = [];

        foreach ($services as $service) {
            foreach ($service->orders as $order) {
                $serviceResults[] = [
                    'service_name' => $service->name,
                    'service_id'=>$service->id,
                        'service_images' => $service->images->map(function ($image) {
                        return [
                            'id' => $image->id,
                            'url' => $image->url,
                        ];
                    }),
                    'user_name' => $order->user->name,
                    'order_date' => $order->order_date,
                    'event_date' => $order->event->date,
                    'quantity' => $order->pivot->quantity,
                    'price' => $order->pivot->price,
                    'description' => $service->getTranslation('description', $locale),
                    'order_id' => $order->id,
                ];
            }
        }

        // Format the response for customized services
        $customizedServiceResults = $customizedServices->map(function ($customizedService) use ($locale) {
            $description = json_decode($customizedService->description, true);
            $localizedDescription = $description[$locale] ?? '';
            return [
                'service_name' => $customizedService->service->name,
                'customized_service_id'=>$customizedService->id,
                'service_images' => $customizedService->service->images->map(function ($image) {
                    return [
                        'id' => $image->id,
                        'url' => $image->url,
                    ];
                }),
                'user_name' => $customizedService->orders->first()->user->name,
                'order_date' => $customizedService->orders->first()->order_date,
                'event_date' => $customizedService->orders->first()->event->date,
                'description' => $localizedDescription,
                'price' => $customizedService->price,
                'order_id' => $customizedService->order_id,
            ];
        });

        return response()->json([
            'services' => $serviceResults,
            'customized_services' => $customizedServiceResults,
        ]);
    }

}
