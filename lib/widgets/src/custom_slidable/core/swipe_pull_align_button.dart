import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/constants/index.dart';
import 'cell.dart';
import 'events.dart';
import 'store.dart';
import 'swipe_data.dart';

class SwipePullAlignButton extends StatefulWidget {
  final int actionIndex;
  final bool trailing;

  const SwipePullAlignButton({Key? key, required this.actionIndex, required this.trailing}) : super(key: key);

  @override
  _SwipePullAlignButtonState createState() => _SwipePullAlignButtonState();
}

class _SwipePullAlignButtonState extends State<SwipePullAlignButton> with TickerProviderStateMixin {
  bool get trailing => widget.trailing;

  late double offsetX;
  late Alignment alignment;
  late CompletionHandler handler;

  StreamSubscription? pullLastButtonSubscription;
  StreamSubscription? pullLastButtonToCoverCellEventSubscription;
  StreamSubscription? closeNestedActionEventSubscription;

  bool whenNestedActionShowing = false;
  bool whenFirstAction = false;
  bool whenDeleting = false;

  late SwipeData data;
  late SwipeAction action;

  AnimationController? offsetController;
  AnimationController? widthFillActionContentController;
  AnimationController? alignController;
  late Animation<double> alignCurve;
  late Animation<double> offsetCurve;
  late Animation<double> widthFillActionContentCurve;

  late Animation animation;

  bool lockAnim = false;

  @override
  void initState() {
    super.initState();
    whenFirstAction = widget.actionIndex == 0;
    alignment = trailing ? Alignment.centerRight : Alignment.centerLeft;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _initAnim();
      _initCompletionHandler();
    });

    _listenEvent();
  }

  void _pullActionButton(bool isPullingOut) {
    _resetAnimationController(alignController);
    if (isPullingOut) {
      var tween = AlignmentTween(begin: alignment, end: trailing ? Alignment.centerLeft : Alignment.centerRight)
          .animate(alignCurve);
      tween.addListener(() {
        if (lockAnim) return;
        alignment = tween.value;
        setState(() {});
      });

      alignController?.forward();
    } else {
      var tween = AlignmentTween(begin: alignment, end: trailing ? Alignment.centerRight : Alignment.centerLeft)
          .animate(alignCurve);
      tween.addListener(() {
        if (lockAnim) return;
        alignment = tween.value;
        setState(() {});
      });
      alignController?.forward();
    }
  }

  void _listenEvent() {
    ///Cell layer has judged the value of performsFirstActionWithFullSwipe
    pullLastButtonSubscription = SwipeActionStore.getInstance().bus.on<PullLastButtonEvent>().listen((event) async {
      if (event.key == data.parentKey && whenFirstAction) {
        _pullActionButton(event.isPullingOut);
      }
    });

    pullLastButtonToCoverCellEventSubscription =
        SwipeActionStore.getInstance().bus.on<PullLastButtonToCoverCellEvent>().listen((event) {
      if (event.key == data.parentKey) {
        _animToCoverCell();
      }
    });

    closeNestedActionEventSubscription =
        SwipeActionStore.getInstance().bus.on<CloseNestedActionEvent>().listen((event) {
      if (event.key == data.parentKey && action.nestedAction != null && whenNestedActionShowing) {
        _resetNestedAction();
      }
      if (event.key != data.parentKey && whenNestedActionShowing) {
        _resetNestedAction();
      }
    });
  }

  void _resetNestedAction() {
    whenNestedActionShowing = false;
    alignment = trailing ? Alignment.centerRight : Alignment.centerLeft;
    setState(() {});
  }

  void _initCompletionHandler() {
    handler = (delete) async {
      if (delete) {
        SwipeActionStore.getInstance().bus.fire(const IgnorePointerEvent(ignore: true));

        if (data.firstActionWillCoverAllSpaceOnDeleting) {
          await _animToCoverCell();
        }
        await data.parentState.deleteWithAnim();
      } else {
        if (action.closeOnTap) {
          data.parentState.closeWithAnim();
        }
      }
    };
  }

  Future<void> _animToCoverCell() async {
    whenDeleting = true;
    _resetAnimationController(offsetController);
    animation =
        Tween<double>(begin: offsetX, end: trailing ? -data.contentWidth : data.contentWidth).animate(offsetCurve)
          ..addListener(() {
            if (lockAnim) return;
            offsetX = animation.value;
            setState(() {});
          });
    await offsetController?.forward();
  }

  void _animToCoverPullActionContent() async {
    if (action.nestedAction?.nestedWidth != null) {
      try {
        assert(
            (action.nestedAction?.nestedWidth ?? 0) >= data.totalActionWidth,
            "Your nested width must be larger than the width of all action buttons"
            "\n 你的nestedWidth必须要大于或者等于所有按钮的总长度，否则下面的按钮会显现出来");
      } catch (e) {
        print(e.toString());
      }
    }

    _resetAnimationController(widthFillActionContentController);
    whenNestedActionShowing = true;
    alignment = Alignment.center;

    if (action.nestedAction?.nestedWidth != null && action.nestedAction!.nestedWidth! > data.totalActionWidth) {
      data.parentState.adjustOffset(
          offsetX: action.nestedAction!.nestedWidth!, curve: action.nestedAction!.curve, trailing: trailing);
    }

    double endOffset;
    if (action.nestedAction?.nestedWidth != null) {
      endOffset = trailing ? -action.nestedAction!.nestedWidth! : action.nestedAction!.nestedWidth!;
    } else {
      endOffset = trailing ? -data.totalActionWidth : data.totalActionWidth;
    }

    animation = Tween<double>(begin: offsetX, end: endOffset).animate(widthFillActionContentCurve)
      ..addListener(() {
        if (lockAnim) return;
        offsetX = animation.value;
        alignment = Alignment.lerp(alignment, Alignment.center, widthFillActionContentController!.value)!;
        setState(() {});
      });
    widthFillActionContentController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    data = SwipeData.of(context);
    action = data.actions[widget.actionIndex];

    final bool shouldShowNestedActionInfo =
        widget.actionIndex == 0 && action.nestedAction != null && whenNestedActionShowing;

    if (!whenNestedActionShowing && !whenDeleting) {
      offsetX = data.currentOffset;
    }

    return InkWell(
      splashColor: CColor.primary.shade100,
      onTap: () {
        if (whenFirstAction && action.nestedAction != null && !whenNestedActionShowing) {
          if (action.nestedAction!.impactWhenShowing) {
            HapticFeedback.mediumImpact();
          }
          _animToCoverPullActionContent();
          return;
        }
        action.onTap?.call(handler);
      },
      child: Transform.translate(
        offset: Offset((trailing ? 1 : -1) * data.contentWidth + offsetX, 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(action.backgroundRadius),
            color: action.color,
          ),
          child: Align(
            alignment: trailing ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              alignment: alignment,
              width: offsetX.abs(),
              child: _buildButtonContent(shouldShowNestedActionInfo),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent(bool shouldShowNestedActionInfo) {
    if (whenDeleting) return const SizedBox();
    if (shouldShowNestedActionInfo && action.nestedAction?.content != null) {
      return action.nestedAction!.content!;
    }

    return action.title != null || action.icon != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildIcon(action, shouldShowNestedActionInfo),
              _buildTitle(action, shouldShowNestedActionInfo),
            ],
          )
        : action.content ?? const SizedBox();
  }

  Widget _buildIcon(SwipeAction action, bool shouldShowNestedActionInfo) {
    return shouldShowNestedActionInfo ? action.nestedAction?.icon ?? const SizedBox() : action.icon ?? const SizedBox();
  }

  Widget _buildTitle(SwipeAction action, bool shouldShowNestedActionInfo) {
    if (shouldShowNestedActionInfo) {
      if (action.nestedAction?.title == null) return const SizedBox();
      return Text(
        action.nestedAction!.title!,
        overflow: TextOverflow.clip,
        maxLines: 1,
        style: action.style,
      );
    } else {
      if (action.title == null) return const SizedBox();
      return Text(
        action.title!,
        overflow: TextOverflow.clip,
        maxLines: 1,
        style: action.style,
      );
    }
  }

  @override
  void dispose() {
    offsetController?.dispose();
    alignController?.dispose();
    widthFillActionContentController?.dispose();
    pullLastButtonSubscription?.cancel();
    pullLastButtonToCoverCellEventSubscription?.cancel();
    closeNestedActionEventSubscription?.cancel();
    super.dispose();
  }

  void _initAnim() {
    offsetController = AnimationController(vsync: this, duration: const Duration(milliseconds: 60));
    alignController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

    alignCurve = CurvedAnimation(parent: alignController!, curve: Curves.easeOutCirc);

    offsetCurve = CurvedAnimation(parent: offsetController!, curve: Curves.easeInToLinear);

    if (widget.actionIndex == 0 && action.nestedAction != null) {
      widthFillActionContentController = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
      widthFillActionContentCurve =
          CurvedAnimation(parent: widthFillActionContentController!, curve: action.nestedAction!.curve);
    }
  }

  void _resetAnimationController(AnimationController? controller) {
    lockAnim = true;
    controller?.value = 0;
    lockAnim = false;
  }
}
