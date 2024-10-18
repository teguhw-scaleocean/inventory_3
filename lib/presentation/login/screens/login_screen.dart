import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_v3/common/components/custom_form.dart';
import 'package:inventory_v3/common/components/custom_snackbar.dart';
import 'package:inventory_v3/common/components/primary_button.dart';
import 'package:inventory_v3/common/components/top_logo_section.dart';
import 'package:inventory_v3/common/constants/local_images.dart';
import 'package:inventory_v3/common/constants/text_constants.dart';
import 'package:inventory_v3/common/extensions/empty_space_extension.dart';
import 'package:inventory_v3/presentation/home/screens/home_screen.dart';
import 'package:inventory_v3/presentation/quality-control/quality_control_screen.dart';
import 'package:inventory_v3/presentation/receipt/receipt_screen.dart';

import '../../../common/theme/text/base_text.dart';
import '../../receipt/receipt_pallet/screens/receipt_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildTopLogoSection(),
                ],
              ),
              24.height,
              Container(
                height: 235,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                // alignment: Alignment.center,
                child: SvgPicture.asset(
                  LocalImages.loginImage,
                  fit: BoxFit.fitWidth,
                  height: 230,
                  width: 280,
                ),
              ),
              24.height,
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      TextConstants.loginTitle,
                      textAlign: TextAlign.center,
                      style: BaseText.mainText20
                          .copyWith(fontWeight: BaseText.semiBold),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      TextConstants.loginSubTitle,
                      style: BaseText.subText14,
                    ),
                  ],
                ),
              ),
              40.height,
              CustomFormField(
                title: "Email",
                hintText: "Enter your email",
                controller: _emailController,
                isShowTitle: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              16.height,
              CustomFormPassword(
                title: "Password",
                hintText: "Enter your password",
                controller: _passwordController,
                isShowTitle: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              40.height,
              PrimaryButton(
                onPressed: () {
                  var yourEmail = "theresia@gmail.com";
                  if (_emailController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    return;
                  }

                  if (_emailController.text.toLowerCase().contains(yourEmail)) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      CustomSnackbar().showSuccessToastMessage(context,
                          message: TextConstants.loginError);
                    });
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
                height: 40,
                title: "Login",
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
