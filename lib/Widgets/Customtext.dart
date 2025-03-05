import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget {
  final Function(String)? onChanged;
  final String? labelText;
  final bool obscureText;

  const CustomFormTextField({
    Key? key,
    this.onChanged,
    this.labelText,
    required this.obscureText, required String hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      validator: (data) {
        if (data == null || data.isEmpty) {
          return 'Field is required';
        }
        return null;
      },
      onChanged: onChanged,
      cursorColor: Colors.brown, // لون المؤشر بني
      style: TextStyle(color: Colors.black, fontSize: 16.0), // لون النص داخل الحقل أسود
      decoration: InputDecoration(
        labelText: labelText, // النص داخل الحقل
        labelStyle: TextStyle(color: Colors.grey, fontSize: 18.0), // لون النص داخل الـ Label رمادي
        filled: true,
        fillColor: Colors.white, // لون الخلفية أبيض
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // حواف مستديرة
          borderSide: BorderSide(color: Colors.brown, width: 2), // عند التحديد، الحواف باللون البني
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // الحواف مستديرة عند عدم التحديد أيضًا
          borderSide: BorderSide(color: Colors.grey, width: 1), // الحدود الافتراضية رمادية
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // الحواف الافتراضية أيضًا مستديرة
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
    );
  }
}
