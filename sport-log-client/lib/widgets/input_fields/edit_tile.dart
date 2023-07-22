import 'package:flutter/material.dart';
import 'package:sport_log/widgets/app_icons.dart';

class CaptionTile extends StatelessWidget {
  const CaptionTile({required this.caption, super.key});

  final String caption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: Text(
        caption,
        style: const TextStyle(color: EditTile.iconCaptionColor),
      ),
    );
  }
}

class DefaultSwitch extends StatelessWidget {
  const DefaultSwitch({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25, // make it fit into EditTile
      child: FittedBox(
        child: Switch(
          value: value,
          onChanged: (isSet) {
            FocusManager.instance.primaryFocus?.unfocus();
            onChanged(isSet);
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}

/// Either a TextFormField or EditTile.optionalButton like placeholder.
class OptionalTextFormField extends StatelessWidget {
  const OptionalTextFormField({
    required this.textFormField,
    required this.showTextFormField,
    required this.leading,
    required this.buttonText,
    required this.onButtonPressed,
    super.key,
  });

  final TextFormField textFormField;
  final bool showTextFormField;
  final IconData? leading;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return showTextFormField
        ? textFormField
        : GestureDetector(
            onTap: onButtonPressed != null
                ? () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    onButtonPressed!();
                  }
                : null,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              height: EditTile.textFormFieldHeight,
              child: Row(
                children: [
                  if (leading != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Icon(leading, color: EditTile.iconCaptionColor),
                    ),
                  ElevatedButton.icon(
                    icon: const Icon(AppIcons.add),
                    label: Text(buttonText),
                    onPressed: onButtonPressed,
                  ),
                ],
              ),
            ),
          );
  }
}

/// A container with a style similar to TextFormField.
class EditTile extends StatelessWidget {
  const EditTile({
    required this.child,
    required this.leading,
    this.caption,
    this.onTap,
    this.onCancel,
    this.unboundedHeight = false,
    this.shrinkWidth = false,
    super.key,
  });

  // ignore: non_constant_identifier_names
  EditTile.Switch({
    required IconData? leading,
    String? caption,
    required bool value,
    required void Function(bool) onChanged,
    void Function()? onCancel,
    bool shrinkWidth = false,
    Key? key,
  }) : this(
          child: DefaultSwitch(value: value, onChanged: onChanged),
          leading: leading,
          caption: caption,
          onCancel: onCancel,
          shrinkWidth: shrinkWidth,
          key: key,
        );

  EditTile.optionalButton({
    required Widget Function() builder,
    required IconData leading,
    required String caption,
    required bool showButton,
    required void Function() onButtonPressed,
    void Function()? onTap,
    void Function()? onCancel,
    bool unboundedHeight = false,
    bool shrinkWidth = false,
    Key? key,
  }) : this(
          leading: leading,
          caption: showButton ? null : caption,
          onTap: showButton ? null : onTap,
          onCancel: showButton ? null : onCancel,
          unboundedHeight: showButton ? false : unboundedHeight,
          shrinkWidth: shrinkWidth,
          key: key,
          child: showButton
              ? ElevatedButton.icon(
                  icon: const Icon(AppIcons.add),
                  label: Text(caption),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    onButtonPressed();
                  },
                )
              : builder(),
        );

  final String? caption;
  final Widget child;
  final IconData? leading;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;

  /// if enabled [child] must have a bounded height
  final bool unboundedHeight;

  /// if enabled [child] must have a bounded width
  final bool shrinkWidth;

  static const Color iconCaptionColor = Colors.white70;
  static const double textFormFieldHeight = 49;

  Widget _captionChildColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (caption != null) CaptionTile(caption: caption!),
        DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyLarge!,
          child: child,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null
          ? () {
              FocusManager.instance.primaryFocus?.unfocus();
              onTap!();
            }
          : null,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: unboundedHeight ? null : textFormFieldHeight,
        child: Row(
          mainAxisSize: shrinkWidth ? MainAxisSize.min : MainAxisSize.max,
          children: [
            if (leading != null)
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Icon(leading, color: iconCaptionColor),
              ),
            shrinkWidth
                ? _captionChildColumn(context)
                : Expanded(child: _captionChildColumn(context)),
            if (onCancel != null)
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onCancel != null
                    ? () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        onCancel!();
                      }
                    : null,
                icon: const Icon(AppIcons.close),
              ),
          ],
        ),
      ),
    );
  }
}
