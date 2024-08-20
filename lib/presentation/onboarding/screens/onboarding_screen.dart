import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_v3/common/constants/local_images.dart';
import 'package:inventory_v3/common/constants/text_constants.dart';
import 'package:inventory_v3/presentation/onboarding/widgets/dot_indicators.dart';

import '../../../common/theme/text/base_text.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  static const _kDuration = Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  List<Widget> _onBoardingPages = [];

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _onBoardingPages = [
      _buildContent(0),
      _buildContent(1),
      _buildContent(2),
    ];
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      debugPrint("_currentIndex: $_currentIndex.toString()");
    });
  }

  void _onNextPage() {
    _pageController.nextPage(duration: _kDuration, curve: _kCurve);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              onPageChanged: _onPageChanged,
              children: _onBoardingPages,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, bottom: 24),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Skip",
                        style: BaseText.mainText14
                            .copyWith(fontWeight: BaseText.medium),
                      ),
                    ),
                    GestureDetector(
                      onTap: _onNextPage,
                      child: Text(
                        "Next",
                        style: BaseText.mainText14
                            .copyWith(fontWeight: BaseText.medium),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Row _buildDotIndicators(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Indicator(currentIndex: index, positionIndex: 0),
        const SizedBox(width: 6),
        Indicator(currentIndex: index, positionIndex: 1),
        const SizedBox(width: 6),
        Indicator(currentIndex: index, positionIndex: 2),
      ],
    );
  }

  Column _buildContent(int currentIndex) {
    String images = "";
    String title = "";
    String subTitle = "";

    switch (currentIndex) {
      case 0:
        images = LocalImages.onBoarding1Image;
        title = TextConstants.onBoardingTitle1;
        subTitle = TextConstants.onBoardingSubTitle1;
        break;
      case 1:
        images = LocalImages.onBoarding2Image;
        title = TextConstants.onBoardingTitle2;
        subTitle = TextConstants.onBoardingSubTitle2;
        break;
      case 2:
        images = LocalImages.onBoarding3Image;
        title = TextConstants.onBoardingTitle3;
        subTitle = TextConstants.onBoardingSubTitle3;
      default:
        images = LocalImages.onBoarding1Image;
        title = TextConstants.onBoardingTitle1;
        subTitle = TextConstants.onBoardingSubTitle1;
    }

    return Column(
      children: [
        Flexible(
          child: SizedBox(
            height: 80,
            width: 90,
            // color: Colors.amber,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Powered by",
                      style: BaseText.grey2Text10,
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
                SvgPicture.asset(LocalImages.logoImage),
              ],
            ),
          ),
        ),
        const Spacer(),
        // Flexible(child: Container(height: 120)),
        SvgPicture.asset(images),
        const Spacer(),
        // Flexible(child: Container(height: 120)),
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: 328,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: BaseText.mainText20.copyWith(
                    fontWeight: BaseText.semiBold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: BaseText.subText14.copyWith(
                    fontWeight: BaseText.regular,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildDotIndicators(currentIndex),
        const Spacer(),
      ],
    );
  }
}
