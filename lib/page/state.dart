class PageState {
  PageState init() {
    return PageState();
  }

  PageState clone() {
    return PageState();
  }
}


class BlCubitCounterState {
  late int count;

  BlCubitCounterState init() {
    return BlCubitCounterState()..count = 0;
  }

  BlCubitCounterState clone() {
    return BlCubitCounterState()..count = count;
  }
}
