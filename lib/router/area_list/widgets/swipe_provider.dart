import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 保存是否处于编辑模式
final editModeProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

/// 保存是否处于删除模式的位置
final waitRemoveProvider = StateNotifierProvider.autoDispose<WaitRemoveNotifier, int>((ref) {
  return WaitRemoveNotifier(-1);
});

class WaitRemoveNotifier extends StateNotifier<int> {
  WaitRemoveNotifier(int index) : super(index);

  void update(int index) {
    state = index;
  }

  bool isWaitRemove() {
    return -1 != state;
  }

  void reset() {
    state = -1;
  }
}
