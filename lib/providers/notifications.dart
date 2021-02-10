import 'dart:convert';

import 'package:flutter/material.dart' hide Notification;
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/services/error_reporting.dart';
import 'package:lloud_mobile/util/ws_client.dart';
import 'package:lloud_mobile/models/notification.dart';
import 'package:lloud_mobile/util/network.dart';

class Notifications with ChangeNotifier {
  String authToken;
  int userId;
  WebSocketChannel _channel;
  WsClient _wsClient;
  List<Notification> _notifications = [];
  bool _hasUnread = false;

  Notifications(this.authToken, this.userId);

  bool get hasUnread => _hasUnread;
  List<Notification> get notifications => [..._notifications];

  Notifications update(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;

    authToken == null ? clear() : fetchAndSetNotifications();

    return this;
  }

  void clear() {
    _notifications = [];
    _hasUnread = false;
    notifyListeners();
  }

  Future<void> fetchAndSetNotifications({int page = 1}) async {
    final url = '${Network.host}/api/v2/user/$userId/notifications?page=$page';
    final res = await http.get(url, headers: Network.headers(token: authToken));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (decodedRes['status'] != 'success') {
      return [];
    }

    _notifications.addAll(Notification.fromJsonList(
        decodedRes['data']['notifications'] as List<dynamic>));
    notifyListeners();
  }

  Future<void> reset() async {
    _notifications = [];
    await fetchAndSetNotifications();
  }

  Future<void> markAsSeen(Notification notification) async {
    final url =
        '${Network.host}/api/v2/user/$userId/notifications/${notification.id}/seen';
    await http.post(url,
        headers: Network.headers(token: authToken), body: json.encode({}));
  }

  void listenForUnreadNotifications() {
    _wsClient =
        new WsClient(url: '${Network.wsHost}/adonis-ws/', authToken: authToken);
    _channel = _wsClient.connect();
    _wsClient.join('notifications:$userId');

    _channel.stream.listen((event) {
      _wsClient.handleEvent(event);
      _parseAndSetUnreadNotifications(event);
    }, onDone: () {
      listenForUnreadNotifications();
    }, onError: (err, stack) {
      ErrorReportingService.report(err, stackTrace: stack);
    });
  }

  @override
  void dispose() {
    _wsClient.die();
    _channel.sink.close();
    super.dispose();
  }

  void _parseAndSetUnreadNotifications(event) {
    Map<String, dynamic> decodedResponse = json.decode(event);

    if (decodedResponse['t'] == 7) {
      int unreadNotifications =
          decodedResponse['d']['data']['unread_notifications'];
      _hasUnread = (unreadNotifications > 0);
      notifyListeners();
    }
  }

  void clearUnread() {
    _hasUnread = false;
    notifyListeners();
  }
}
