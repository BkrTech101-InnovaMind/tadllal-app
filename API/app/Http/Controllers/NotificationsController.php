<?php

namespace App\Http\Controllers;

use App\Http\Resources\NotificationResource;
use Illuminate\Http\Request;
use App\Traits\HttpResponses;

class NotificationsController extends Controller
{
    use HttpResponses;
    public function index()
    {
        $notifications = auth()->user()->unreadNotifications;
        return NotificationResource::collection($notifications);
    }

    public function markAsRead($id)
    {
        $notificationId = $id;

        if ($notificationId) {
            $notification = auth()->user()->notifications()->find($notificationId);

            if ($notification) {
                $notification->markAsRead();
                return $this->success([], 'Notification marked as read successfully.');
            } else {
                return $this->error('', 'Notification not found.', 404);
            }
        } else {
            return $this->error('', 'Notification ID is required.', 400);
        }
    }

    public function deleteNotification($id)
    {
        $notificationId = $id;

        if ($notificationId) {
            $notification = auth()->user()->notifications()->find($notificationId);

            if ($notification) {
                $notification->delete();
                return $this->success([], 'Notification deleted successfully.');
            } else {
                return $this->error('', 'Notification not found.', 404);
            }
        } else {
            return $this->error('', 'Notification ID is required.', 400);
        }
    }

    public function deleteAllNotifications()
    {
        auth()->user()->notifications()->delete();
        return $this->success([], 'All notifications deleted successfully.');
    }

    public function showAllNotifications()
    {
        $unreadNotifications = auth()->user()->unreadNotifications;
        $readNotifications = auth()->user()->readNotifications;


        $allNotifications = $readNotifications->concat($unreadNotifications);

        return NotificationResource::collection($allNotifications);

    }

    public function markAllNotificationsAsRead()
    {
        auth()->user()->unreadNotifications->markAsRead();

        return $this->success([], 'All notifications marked as read.');
    }




}