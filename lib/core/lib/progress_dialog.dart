import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

enum ProgressDialogType { Normal, Download }

String _dialogMessage = "Loading...";
String _headerMessage = "Download a file...";
double _progress = 0.0, _maxProgress = 100.0;

Widget? _customBody;

TextAlign _textAlign = TextAlign.left;
Alignment _progressWidgetAlignment = Alignment.centerLeft;

bool _isShowing = false;
BuildContext? _context;
BuildContext? _dismissingContext;
ProgressDialogType? _progressDialogType;
bool _barrierDismissible = true, _showLogs = false;
Function()? dismissibleFunction;
TextStyle _progressTextStyle = TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w400),
    _messageStyle = TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600),
    _headerMessageStyle = TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w600);

double _dialogElevation = 8.0, _borderRadius = 8.0;
Color _backgroundColor = Colors.white;
Curve _insetAnimCurve = Curves.easeInOut;

Widget _progressWidget = Image.asset(
  'assets/images/double_ring_loading_io.gif',
);

class ProgressDialog {
  late _Body _dialog;

  _Body getBody() {
    return _dialog;
  }

  ProgressDialog(
    BuildContext context, {
    ProgressDialogType? type,
    bool? isDismissible,
    bool? showLogs,
    Widget? customBody,
    Function()? callback,
  }) {
    _context = context;
    dismissibleFunction = callback;
    _progressDialogType = type ?? ProgressDialogType.Normal;
    _barrierDismissible = isDismissible ?? true;
    _showLogs = showLogs ?? false;
    _customBody = customBody ?? null;
  }

  void style(
      {Widget? child,
      double? progress,
      double? maxProgress,
      String? message,
      String? headerMessage,
      TextStyle? headerMessageStyle,
      Widget? progressWidget,
      Color? backgroundColor,
      TextStyle? progressTextStyle,
      TextStyle? messageTextStyle,
      double? elevation,
      TextAlign? textAlign,
      double? borderRadius,
      Curve? insetAnimCurve,
      Alignment? progressWidgetAlignment}) {
    if (_isShowing) return;
    if (_progressDialogType == ProgressDialogType.Download) {
      _progress = progress ?? _progress;
    }
    _headerMessage = headerMessage ?? '';
    _headerMessageStyle = headerMessageStyle ?? _headerMessageStyle;
    _dialogMessage = message ?? _dialogMessage;
    _maxProgress = maxProgress ?? _maxProgress;
    _progressWidget = progressWidget ?? _progressWidget;
    _backgroundColor = backgroundColor ?? _backgroundColor;
    _messageStyle = messageTextStyle ?? _messageStyle;
    _progressTextStyle = progressTextStyle ?? _progressTextStyle;
    _dialogElevation = elevation ?? _dialogElevation;
    _borderRadius = borderRadius ?? _borderRadius;
    _insetAnimCurve = insetAnimCurve ?? _insetAnimCurve;
    _textAlign = textAlign ?? _textAlign;
    _progressWidget = child ?? _progressWidget;
    _progressWidgetAlignment = progressWidgetAlignment ?? _progressWidgetAlignment;
  }

  void update(
      {double? progress, double? maxProgress, String? message, Widget? progressWidget, TextStyle? progressTextStyle, TextStyle? messageTextStyle}) {
    if (_progressDialogType == ProgressDialogType.Download) {
      _progress = progress ?? _progress;
    }

    _dialogMessage = message ?? _dialogMessage;
    _maxProgress = maxProgress ?? _maxProgress;
    _progressWidget = progressWidget ?? _progressWidget;
    _messageStyle = messageTextStyle ?? _messageStyle;
    _progressTextStyle = progressTextStyle ?? _progressTextStyle;

    if (_isShowing) _dialog.update();
  }

  bool isShowing() {
    return _isShowing;
  }

  Future<bool> hide() async {
    try {
      if (_isShowing) {
        _isShowing = false;
        Get.back();
        if (_showLogs) debugPrint('ProgressDialog dismissed');
        return Future.value(true);
      } else {
        if (_showLogs) debugPrint('ProgressDialog already dismissed');
        return Future.value(false);
      }
    } catch (err) {
      debugPrint('Seems there is an issue hiding dialog');
      debugPrint('$err');
      return Future.value(false);
    }
  }

  Future<bool> show() async {
    try {
      _progress = 0.0;
      if (!_isShowing) {
        _dialog = new _Body();
        showDialog<dynamic>(
          context: Get.context!,
          barrierDismissible: _barrierDismissible,
          builder: (BuildContext context) {
            _dismissingContext = context;
            return WillPopScope(
              onWillPop: () async {
                if (dismissibleFunction != null) dismissibleFunction!();
                return _barrierDismissible;
              },
              child: Dialog(
                  backgroundColor: _backgroundColor,
                  insetAnimationCurve: _insetAnimCurve,
                  insetAnimationDuration: Duration(milliseconds: 100),
                  elevation: _dialogElevation,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(_borderRadius))),
                  child: _dialog),
            );
          },
        );
        // Delaying the Function() for 200 milliseconds
        // [Default transitionDuration of DialogRoute]
        await Future.delayed(Duration(milliseconds: 200));
        if (_showLogs) debugPrint('ProgressDialog shown');
        _isShowing = true;
        return true;
      } else {
        if (_showLogs) debugPrint("ProgressDialog already shown/showing");
        return false;
      }
    } catch (err) {
      _isShowing = false;
      debugPrint('Exception while showing the dialog');
      debugPrint('$err');
      return false;
    }
  }
}

// ignore: must_be_immutable
class _Body extends StatefulWidget {
  _BodyState _dialog = _BodyState();

  update() {
    _dialog.update();
  }

  @override
  State<StatefulWidget> createState() {
    return _dialog;
  }
}

class _BodyState extends State<_Body> with AutomaticKeepAliveClientMixin<_Body> {
  update() {
    setState(() {});
  }

  @override
  void dispose() {
    _isShowing = false;
    if (_showLogs) debugPrint('ProgressDialog dismissed by back button');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: ScreenUtil().setHeight(120),
      child: _customBody ??
          Row(
            children: <Widget>[
              const SizedBox(width: 8.0),
              Align(
                alignment: _progressWidgetAlignment,
                child: SizedBox(
                  width: 60.0,
                  height: 60.0,
                  child: _progressWidget,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _progressDialogType == ProgressDialogType.Normal
                    ? Text(
                        _dialogMessage,
                        textAlign: _textAlign,
                        style: _messageStyle,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(height: 2.0),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Expanded(child: Text(_headerMessage, style: _headerMessageStyle)),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Expanded(child: Text(_dialogMessage, style: _messageStyle)),
                                ],
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text("$_progress/$_maxProgress", style: _progressTextStyle),
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(width: 8.0)
            ],
          ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
