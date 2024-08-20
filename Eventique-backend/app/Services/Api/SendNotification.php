<?php

namespace App\Services\Api;

use App\Models\Notification;
use Illuminate\Support\Facades\Log;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;

class SendNotification
{

    public function index()
    {
        return auth()->user()->notifications;
    }

    public function sendToUser($user, $title, $message, $type = 'basic')
    {
        // Path to the service account key JSON file
        $serviceAccountPath = storage_path('eventiuqe.json');
        //$serviceAccountPath = 'C:/vscproject/potatoSandwitch/storage/eventiuqe.json';

        // Initialize the Firebase Factory with the service account
        $factory = (new Factory)->withServiceAccount($serviceAccountPath);

        // Create the Messaging instance
        $messaging = $factory->createMessaging();

        // Prepare the notification array
        $notification = [
            'title' => $title,
            'body' => $message,
            'sound' => 'default',
        ];

        // Additional data payload
        $data = [
            'type' => $type,
            'id' => $user['id'],
            'message' => $message,
        ];

        // Create the CloudMessage instance
        $cloudMessage = CloudMessage::withTarget('token', $user['fcm_token'])
            ->withNotification($notification)
            ->withData($data);

        try {
            // Send the notification
            $messaging->send($cloudMessage);

            // Save the notification to the database
             Notification::create([
                'type' => 'App\Notifications\User',
                'notifiable_type' => 'App\Models\User',
                'notifiable_id' => $user['id'],
                'data' => json_encode([
                    'user' => $user['name'],
                    'message' => $message,
                    'title' => $title,
                ]), // The data of the notification
            ]);
            return 1;
        } catch (\Kreait\Firebase\Exception\MessagingException $e) {
//            Log::error($e->getMessage());
//            return 0;
            return error($e->getMessage());
        } catch (\Kreait\Firebase\Exception\FirebaseException $e) {
//            Log::error($e->getMessage());
//            return 0;
            return error($e->getMessage());
        }
    }

    public function sendToCompany($company, $title, $message, $type = 'basic')
    {
        $serviceAccountPath = storage_path('eventiuqe.json');

        $factory = (new Factory)->withServiceAccount($serviceAccountPath);

        $messaging = $factory->createMessaging();

        $notification = [
            'title' => $title,
            'body' => $message,
            'sound' => 'default',
        ];

        $data = [
            'type' => $type,
            'id' => $company['id'],
            'message' => $message,
        ];

        $cloudMessage = CloudMessage::withTarget('token', $company['fcm_token'])
            ->withNotification($notification)
            ->withData($data);

        try {
            // Send the notification
            $messaging->send($cloudMessage);

            $not = Notification::create([
                'type' => 'App\Notifications\Company',
                'notifiable_type' => 'App\Models\Company',
                'notifiable_id' => $company['id'],
                'data' => json_encode([
                    'user' => $company['company_name'],
                    'message' => $message,
                    'title' => $title,
                ]),
            ]);
            return 1;
        } catch (\Kreait\Firebase\Exception\MessagingException $e) {
            return error($e->getMessage());
        } catch (\Kreait\Firebase\Exception\FirebaseException $e) {
            return error($e->getMessage());
        }
    }

    public function markAsRead($notificationId): bool
    {
        $notification = auth()->user()->notifications()->findOrFail($notificationId);

        if(isset($notification)) {
            $notification->markAsRead();
            return true;
        }else return false;
    }

    public function destroy($id): bool
    {
        $notification = auth()->user()->notifications()->findOrFail($id);

        if(isset($notification)) {
            $notification->delete();
            return true;
        }else return false;
    }

}
