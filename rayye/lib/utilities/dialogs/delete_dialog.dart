import 'package:flutter/material.dart';
import 'package:rayye/extensions/buildcontext/loc.dart';
import 'package:rayye/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: context.loc.delete,
    content: context.loc.delete_note_prompt,
    optionsBuilder: () => {
      context.loc.cancel: false,
      context.loc.delete: true,
    },
  ).then((value) => value ?? false);
}
