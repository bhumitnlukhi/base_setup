abstract class NotificationRepository{

  /// API for the notification list
  Future notificationListAPI(String request,int pageNumber,int pageSize);

  /// API for the notification unread count
  Future notificationUnreadCountAPI(String request);

  ///  API for Delete the notification list
  Future deleteNotificationList();

  ///  API for Delete a notification
  Future deleteNotification(String notificationId);

  /// Api for reading all notification
  Future readAllNotification();
}