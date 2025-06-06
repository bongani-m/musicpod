import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../extensions/build_context_x.dart';
import '../../extensions/taget_platform_x.dart';
import '../../settings/settings_model.dart';

class Progress extends StatelessWidget with WatchItMixin {
  const Progress({
    super.key,
    this.value,
    this.backgroundColor,
    this.color,
    this.valueColor,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeCap,
    this.strokeWidth = 3.0,
    this.padding,
    this.adaptive = true,
  });

  final double? value;
  final Color? backgroundColor;
  final Color? color;
  final Animation<Color?>? valueColor;
  final double strokeWidth;
  final String? semanticsLabel;
  final String? semanticsValue;
  final StrokeCap? strokeCap;
  final EdgeInsetsGeometry? padding;
  final bool adaptive;

  @override
  Widget build(BuildContext context) {
    final useYaruTheme = watchPropertyValue(
      (SettingsModel m) => m.useYaruTheme,
    );
    return useYaruTheme && isLinux
        ? YaruCircularProgressIndicator(
            strokeWidth: strokeWidth,
            value: value,
            color: color,
            trackColor: backgroundColor,
          )
        : Padding(
            padding: padding ?? const EdgeInsets.all(4),
            child: adaptive
                ? CircularProgressIndicator.adaptive(
                    strokeWidth: strokeWidth,
                    value: value,
                    backgroundColor: value == null
                        ? null
                        : (backgroundColor ??
                              context.theme.colorScheme.primary.withValues(
                                alpha: 0.3,
                              )),
                  )
                : CircularProgressIndicator(
                    strokeWidth: strokeWidth,
                    value: value,
                    backgroundColor: value == null
                        ? null
                        : (backgroundColor ??
                              context.theme.colorScheme.primary.withValues(
                                alpha: 0.3,
                              )),
                  ),
          );
  }
}

class LinearProgress extends StatelessWidget with WatchItMixin {
  const LinearProgress({
    super.key,
    this.color,
    this.trackHeight,
    this.value,
    this.backgroundColor,
  });

  final double? value;
  final Color? color, backgroundColor;
  final double? trackHeight;

  @override
  Widget build(BuildContext context) {
    final useYaruTheme = watchPropertyValue(
      (SettingsModel m) => m.useYaruTheme,
    );
    return useYaruTheme
        ? YaruLinearProgressIndicator(
            value: value,
            strokeWidth: trackHeight,
            color: color,
          )
        : LinearProgressIndicator(
            value: value,
            minHeight: trackHeight,
            color: color,
            backgroundColor: backgroundColor,
            borderRadius: BorderRadius.circular(2),
          );
  }
}
