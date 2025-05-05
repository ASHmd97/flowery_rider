// features/auth/presentation/widget/remember_me.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';
import 'package:flowery_rider/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RememberMe extends StatefulWidget {
  const RememberMe({super.key});

  @override
  State<RememberMe> createState() => _RememberMeState();
}

class _RememberMeState extends State<RememberMe> {
  // Initialize with a default value instead of using late
  bool value = false;

  @override
  void initState() {
    super.initState();
    // Get the initial value from the AuthCubit
    try {
      if (context.read<AuthCubit>() != null) {
        value = context.read<AuthCubit>().rememberMe;
      }
    } catch (e) {
      // Handle the case when AuthCubit is not available
      value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 150),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Checkbox(
              value: value,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    value = newValue;
                    try {
                      // Try to update the AuthCubit if available
                      context.read<AuthCubit>().setRememberMe(newValue);
                    } catch (e) {
                      // Silently handle the case when AuthCubit is not yet available
                    }
                  });
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Text(
            LocaleKeys.auth_login_remember_me.tr(),
            style: getRegularStyle(color: AppColors.black),
          ),
        ],
      ),
    );
  }
}
