// features/auth/presentation/pages/forgetpassword_page.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetpasswordPage extends StatelessWidget {
  const ForgetpasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.auth_forgot_password_title.tr()),
      ),

      // Body
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          children: [
            Center(
              child: Text(
                LocaleKeys.auth_forgot_password_heading.tr(),
                style: getMediumStyle(
                  color: AppColors.black,
                  fontSize: 18.sp,
                ),
              ),
            ),
            Text(
              LocaleKeys.auth_forgot_password_instruction.tr(),
              style: getLightStyle(color: AppColors.grey, fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 32.h),

            // Email field
            TextFormField(
              validator: Validator.emailValidate,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: LocaleKeys.auth_forgot_password_email_label.tr(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: LocaleKeys.auth_forgot_password_email_hint.tr(),
              ),
            ),

            SizedBox(height: 48.h),

            // Confirm button
            ElevatedButton(
              onPressed: () {},
              child: Text(LocaleKeys.auth_forgot_password_confirm_button.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
