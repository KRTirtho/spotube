part of 'sliding_up_panel.dart';

class PanelController extends ChangeNotifier {
  SlidingUpPanelState? _panelState;

  void _addState(SlidingUpPanelState panelState) {
    _panelState = panelState;
    notifyListeners();
  }

  bool _forceScrollChange = false;

  /// use this function when scroll change in func
  /// Example:
  /// panelController.forseScrollChange(scrollController.animateTo(100, duration: Duration(milliseconds: 400), curve: Curves.ease))
  Future<void> forceScrollChange(Future func) async {
    _forceScrollChange = true;
    _panelState!._scrollingEnabled = true;
    await func;
    // if (_panelState!._sc.offset == 0) {
    //   _panelState!._scrollingEnabled = true;
    // }
    if (panelPosition < 1) {
      _panelState!._scMinOffset = _panelState!._scrollController.offset;
    }
    _forceScrollChange = false;
  }

  bool __nowTargetForceDraggable = false;

  bool get _nowTargetForceDraggable => __nowTargetForceDraggable;

  set _nowTargetForceDraggable(bool value) {
    __nowTargetForceDraggable = value;
    notifyListeners();
  }

  /// Determine if the panelController is attached to an instance
  /// of the SlidingUpPanel (this property must return true before any other
  /// functions can be used)
  bool get isAttached => _panelState != null;

  /// Closes the sliding panel to its collapsed state (i.e. to the  minHeight)
  Future<void> close() async {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    await _panelState!._close();
    notifyListeners();
  }

  /// Opens the sliding panel fully
  /// (i.e. to the maxHeight)
  Future<void> open() async {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    await _panelState!._open();
    notifyListeners();
  }

  /// Hides the sliding panel (i.e. is invisible)
  Future<void> hide() async {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    await _panelState!._hide();
    notifyListeners();
  }

  /// Shows the sliding panel in its collapsed state
  /// (i.e. "un-hide" the sliding panel)
  Future<void> show() async {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    await _panelState!._show();
    notifyListeners();
  }

  /// Animates the panel position to the value.
  /// The value must between 0.0 and 1.0
  /// where 0.0 is fully collapsed and 1.0 is completely open.
  /// (optional) duration specifies the time for the animation to complete
  /// (optional) curve specifies the easing behavior of the animation.
  Future<void> animatePanelToPosition(double value,
      {Duration? duration, Curve curve = Curves.linear}) {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    assert(0.0 <= value && value <= 1.0);
    return _panelState!
        ._animatePanelToPosition(value, duration: duration, curve: curve);
  }

  /// Animates the panel position to the snap point
  /// Requires that the SlidingUpPanel snapPoint property is not null
  /// (optional) duration specifies the time for the animation to complete
  /// (optional) curve specifies the easing behavior of the animation.
  Future<void> animatePanelToSnapPoint(
      {Duration? duration, Curve curve = Curves.linear}) {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    assert(_panelState!.widget.snapPoint != null,
        "SlidingUpPanel snapPoint property must not be null");
    return _panelState!
        ._animatePanelToSnapPoint(duration: duration, curve: curve);
  }

  /// Sets the panel position (without animation).
  /// The value must between 0.0 and 1.0
  /// where 0.0 is fully collapsed and 1.0 is completely open.
  set panelPosition(double value) {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    assert(0.0 <= value && value <= 1.0);
    _panelState!._panelPosition = value;
  }

  /// Gets the current panel position.
  /// Returns the % offset from collapsed state
  /// to the open state
  /// as a decimal between 0.0 and 1.0
  /// where 0.0 is fully collapsed and
  /// 1.0 is full open.
  double get panelPosition {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    return _panelState!._panelPosition;
  }

  /// Returns whether or not the panel is
  /// currently animating.
  bool get isPanelAnimating {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    return _panelState!._isPanelAnimating;
  }

  /// Returns whether or not the
  /// panel is open.
  bool get isPanelOpen {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    return _panelState!._isPanelOpen;
  }

  /// Returns whether or not the
  /// panel is closed.
  bool get isPanelClosed {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    return _panelState!._isPanelClosed;
  }

  /// Returns whether or not the
  /// panel is shown/hidden.
  bool get isPanelShown {
    assert(isAttached, "PanelController must be attached to a SlidingUpPanel");
    return _panelState!._isPanelShown;
  }
}
