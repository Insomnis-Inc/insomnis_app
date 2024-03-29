import 'UserApi.dart';

class NotificationApi {
  final String id;
  final String type;
  final bool seen;
  final String text;
  final String timeAgo;
  final String timeText;
  final UserApi? notifier;

  NotificationApi(
      {required this.id,
      required this.type,
      required this.seen,
      required this.text,
      required this.timeAgo,
      required this.timeText,
      required this.notifier});

  factory NotificationApi.fromJson(Map<String, dynamic> json) {
    return NotificationApi(
        id: json['id'],
        type: json['type'],
        seen: json['seen'] == '1' ? true : false,
        text: json['type_text'],
        timeAgo: json['time_text_string'],
        timeText: json['time_text'],
        notifier: UserApi.fromJson(json['notifier']));
  }
}

// 
// "type_text": "followed you",
//             "icon": "user-plus",
//             "time_text_string": "2 m",
//             "time_text": "12:12"

//  "api_status": 200,
//     "notifications": [
//         {
//             "id": "6",
//             "notifier_id": "1",
//             "recipient_id": "3",
//             "post_id": "0",
//             "reply_id": "0",
//             "comment_id": "0",
//             "page_id": "0",
//             "group_id": "0",
//             "group_chat_id": "0",
//             "event_id": "0",
//             "thread_id": "0",
//             "blog_id": "0",
//             "story_id": "0",
//             "seen_pop": "0",
//             "type": "following",
//             "type2": "",
//             "text": "",
//             "url": "https://kordgram.com/Admin",
//             "full_link": "",
//             "seen": "0",
//             "sent_push": "0",
//             "admin": "0",
//             "time": "1652962362",
//             "notifier": {
//                 "user_id": "1",
//                 "username": "Admin",
//                 "email": "rwsenfuka@gmail.com",
//                 "first_name": "",
//                 "last_name": "",
//                 "avatar": "https://kordgram.com/upload/photos/d-avatar.jpg?cache=0",
//                 "cover": "https://kordgram.com/upload/photos/d-cover.jpg?cache=0",
//                 "background_image": "",
//                 "relationship_id": "0",
//                 "address": "",
//                 "working": "",
//                 "working_link": "",
//                 "about": null,
//                 "school": "",
//                 "gender": "male",
//                 "birthday": "0000-00-00",
//                 "country_id": "0",
//                 "website": "",
//                 "facebook": "",
//                 "google": "",
//                 "twitter": "",
//                 "linkedin": "",
//                 "youtube": "",
//                 "vk": "",
//                 "instagram": "",
//                 "qq": null,
//                 "wechat": null,
//                 "discord": null,
//                 "mailru": null,
//                 "language": "english",
//                 "ip_address": "102.82.39.184",
//                 "follow_privacy": "0",
//                 "friend_privacy": "0",
//                 "post_privacy": "ifollow",
//                 "message_privacy": "0",
//                 "confirm_followers": "0",
//                 "show_activities_privacy": "1",
//                 "birth_privacy": "0",
//                 "visit_privacy": "0",
//                 "verified": "1",
//                 "lastseen": "1652962460",
//                 "emailNotification": "1",
//                 "e_liked": "1",
//                 "e_wondered": "1",
//                 "e_shared": "1",
//                 "e_followed": "1",
//                 "e_commented": "1",
//                 "e_visited": "1",
//                 "e_liked_page": "1",
//                 "e_mentioned": "1",
//                 "e_joined_group": "1",
//                 "e_accepted": "1",
//                 "e_profile_wall_post": "1",
//                 "e_sentme_msg": "0",
//                 "e_last_notif": "0",
//                 "notification_settings": "{\"e_liked\":1,\"e_shared\":1,\"e_wondered\":0,\"e_commented\":1,\"e_followed\":1,\"e_accepted\":1,\"e_mentioned\":1,\"e_joined_group\":1,\"e_liked_page\":1,\"e_visited\":1,\"e_profile_wall_post\":1,\"e_memory\":1}",
//                 "status": "0",
//                 "active": "1",
//                 "admin": "1",
//                 "registered": "00/0000",
//                 "phone_number": "",
//                 "is_pro": "0",
//                 "pro_type": "0",
//                 "timezone": "",
//                 "referrer": "0",
//                 "ref_user_id": "0",
//                 "ref_level": null,
//                 "balance": "0",
//                 "paypal_email": "",
//                 "notifications_sound": "0",
//                 "order_posts_by": "1",
//                 "android_m_device_id": "",
//                 "ios_m_device_id": "",
//                 "android_n_device_id": "",
//                 "ios_n_device_id": "",
//                 "web_device_id": "",
//                 "wallet": "0.00",
//                 "lat": "0.3407872",
//                 "lng": "32.5910528",
//                 "last_location_update": "1653374749",
//                 "share_my_location": "1",
//                 "last_data_update": "1652959416",
//                 "details": {
//                     "post_count": "1",
//                     "album_count": "0",
//                     "following_count": "0",
//                     "followers_count": "1",
//                     "groups_count": "0",
//                     "likes_count": "0",
//                     "mutual_friends_count": 0
//                 },
//                 "last_avatar_mod": "0",
//                 "last_cover_mod": "0",
//                 "points": "0",
//                 "daily_points": "0",
//                 "point_day_expire": "",
//                 "last_follow_id": "0",
//                 "share_my_data": "1",
//                 "last_login_data": null,
//                 "two_factor": "0",
//                 "new_email": "",
//                 "two_factor_verified": "0",
//                 "new_phone": "",
//                 "info_file": "",
//                 "city": "",
//                 "state": "",
//                 "zip": "",
//                 "school_completed": "0",
//                 "weather_unit": "us",
//                 "paystack_ref": "",
//                 "code_sent": "0",
//                 "StripeSessionId": null,
//                 "time_code_sent": "0",
//                 "permission": null,
//                 "skills": null,
//                 "languages": null,
//                 "currently_working": "",
//                 "banned": "0",
//                 "banned_reason": "",
//                 "coinbase_hash": "",
//                 "coinbase_code": "",
//                 "avatar_post_id": 0,
//                 "cover_post_id": 0,
//                 "avatar_full": "upload/photos/d-avatar.jpg",
//                 "user_platform": "web",
//                 "url": "https://kordgram.com/Admin",
//                 "name": "Admin",
//                 "API_notification_settings": {
//                     "e_liked": 1,
//                     "e_shared": 1,
//                     "e_wondered": 0,
//                     "e_commented": 1,
//                     "e_followed": 1,
//                     "e_accepted": 1,
//                     "e_mentioned": 1,
//                     "e_joined_group": 1,
//                     "e_liked_page": 1,
//                     "e_visited": 1,
//                     "e_profile_wall_post": 1,
//                     "e_memory": 1
//                 },
//                 "is_notify_stopped": 0,
//                 "mutual_friends_data": "",
//                 "lastseen_unix_time": "1652962460",
//                 "lastseen_status": "on",
//                 "is_reported": false,
//                 "is_story_muted": false,
//                 "is_following_me": 1,
//                 "is_open_to_work": 0,
//                 "is_providing_service": 0,
//                 "providing_service": 0,
//                 "open_to_work_data": "",
//                 "formated_langs": []
//             },
//             "ajax_url": "?link1=timeline&u=Admin",
//             "type_text": "followed you",
//             "icon": "user-plus",
//             "time_text_string": "2 m",
//             "time_text": "12:12"
//         }
//     ],
//     "new_notifications_count": "1"
