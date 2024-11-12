import 'package:flutter_easyloading/flutter_easyloading.dart';

class Loading {
  Future loading(Function block, {bool isShowLoading = true}) async {
    if (isShowLoading) {
      showLoading();
    }
    try {
      await block();
    } catch (e) {
      rethrow;
    } finally {
      dismissLoading();
    }
    return;
  }

  void showLoading() {
    EasyLoading.show(status: "加载中...");
  }

  void showErrorLoading(e) {
    EasyLoading.showError(e);
  }

  void dismissLoading() {
    EasyLoading.dismiss();
  }
}
