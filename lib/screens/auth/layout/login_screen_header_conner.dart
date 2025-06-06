import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:ui/paths/curve_convex.dart';

import '../widgets/term_text.dart';

class LoginScreenImageHeaderConner extends StatelessWidget {
  final Widget? header;
  final Widget? loginForm;
  final Widget? socialLogin;
  final Widget? registerText;
  final Widget? termText;
  final Widget? title;
  final Color? background;
  final EdgeInsetsDirectional? padding;
  final EdgeInsetsDirectional? paddingFooter;

  const LoginScreenImageHeaderConner({
    Key? key,
    this.header,
    this.loginForm,
    this.socialLogin,
    this.registerText,
    this.termText,
    this.title,
    this.padding,
    this.paddingFooter,
    this.background,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double heightHeader = height * 0.3;

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: heightHeader,
          automaticallyImplyLeading: false,
          primary: false,
          backgroundColor: background,
          flexibleSpace: Stack(
            children: [
              SizedBox(
                height: heightHeader,
                width: width,
                child: header,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Transform.rotate(
                  angle: -math.pi,
                  child: ClipPath(
                    clipper: CurveInConvex(),
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      color: background,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SliverPadding(
          padding: padding!,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  children: [
                    title!,
                    const SizedBox(height: 24),
                    loginForm!,
                    if (registerText != null) ...[
                      const SizedBox(height: 32),
                      registerText!,
                    ],
                  ],
                );
              },
              childCount: 1,
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          fillOverscroll: true,
          child: Container(
            padding: paddingFooter,
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                socialLogin!,
                const SizedBox(height: 16),
                ContainerTermText(child: termText),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
