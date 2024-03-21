import 'package:flutter/material.dart';

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField(
      {super.key,
      Widget? title,
      FormFieldSetter<bool>? onChanged,
      FormFieldSetter<bool>? onSaved,
      FormFieldValidator<bool>? validator,
      bool initialValue = false,
      bool autovalidate = false})
      : super(
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<bool> state) {
            return CheckboxListTile(
              activeColor: Colors.red,
              dense: state.hasError,
              title: title,
              value: state.value,
              onChanged: (value) {
                state.didChange(value);
                if(onChanged != null){
                  onChanged(value);
                }
              },
              subtitle: state.hasError
                  ? Builder(
                      builder: (BuildContext context) => Text(
                        state.errorText ?? "",
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    )
                  : null,
              controlAffinity: ListTileControlAffinity.leading,
            );
          },
        );
}
