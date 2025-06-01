import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

class TermVariable extends StatelessWidget {
  final String? option;
  final String? label;
  final bool? isSelected;
  final bool canSelect;
  final Function? onSelectTerm;
  final Map? value;

  const TermVariable({
    Key? key,
    this.option,
    this.label,
    this.isSelected,
    this.onSelectTerm,
    required this.canSelect,
    this.value,
  }) : super(key: key);

  Container boxCircle({
    double? size,
    Color? color,
    Border? border,
  }) {
    return Container(
      width: size ?? 39,
      height: size ?? 39,
      decoration: BoxDecoration(
        color: color,
        border: border,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget buildColor({ThemeData? theme}) {
    Color? color = ConvertData.fromHex(value!['value'], Colors.transparent);

    Widget child = Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(6),
          child: boxCircle(color: color, size: 27),
        ),
        isSelected!
            ? boxCircle(
                border: Border.all(width: 2, color: theme!.primaryColor),
              )
            : boxCircle(
                border: Border.all(color: theme!.dividerColor),
              )
      ],
    );
    if (!canSelect) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: !canSelect ? null : onSelectTerm as void Function()?,
      child: Opacity(
        opacity: canSelect ? 1 : 0.6,
        child: child,
      ),
    );
  }

  Widget buildImage({ThemeData? theme}) {
    if (!canSelect) {
      return const SizedBox();
    }
    return InkWell(
      onTap: !canSelect ? null : onSelectTerm as void Function()?,
      child: Opacity(
        opacity: canSelect ? 1 : 0.6,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(value!['value']),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(8),
            border: isSelected! ? Border.all(width: 2, color: theme!.primaryColor) : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle? titleButton = theme.textTheme.bodyMedium;

    if (value != null && value!['type'] == 'color') return buildColor(theme: theme);
    if (value != null && value!['type'] == 'image') return buildImage(theme: theme);

    if (isSelected!) {
      return OutlinedButton(
        onPressed: onSelectTerm as void Function()?,
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.primaryColor,
          side: BorderSide(width: 2, color: theme.primaryColor),
          textStyle: titleButton,
          minimumSize: const Size(40, 0),
          padding: paddingHorizontal,
        ),
        child: Text(label!),
      );
    }
    if (!canSelect) {
      return const SizedBox();
    }
    return OutlinedButton(
      onPressed: !canSelect ? null : onSelectTerm as void Function()?,
      style: OutlinedButton.styleFrom(
        foregroundColor: titleButton!.color,
        side: BorderSide(width: 1, color: theme.dividerColor),
        textStyle: titleButton,
        minimumSize: const Size(40, 0),
        padding: paddingHorizontal,
      ),
      child: Text(label!),
    );
  }
}
