import 'package:get/get.dart';

class GetxCommentController extends GetxController {
  var isReplyToComment = false;
  var commentId = '';

  static GetxCommentController get to => Get.find();

  void resetCommentReply() {
    isReplyToComment = false;
    commentId = '';
    update();
  }

  void commentReply(bool reply, String id) {
    isReplyToComment = reply;
    commentId = id;
    update();
  }
}
