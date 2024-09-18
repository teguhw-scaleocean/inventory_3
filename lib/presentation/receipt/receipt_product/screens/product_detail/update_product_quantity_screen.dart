import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../common/components/custom_app_bar.dart';
import '../../../../../common/components/primary_button.dart';
import '../../../../../common/constants/local_images.dart';
import '../../../../../common/helper/tracking_helper.dart';
import '../../../../../common/theme/color/color_name.dart';
import '../../../../../common/theme/text/base_text.dart';
import '../../../../../data/model/item_card.dart';
import '../../../../../data/model/product.dart';
import '../../cubit/product_detail/product_menu_product_detail_cubit.dart';

class UpdateProductQuantityScreen extends StatefulWidget {
  final String tracking;

  const UpdateProductQuantityScreen({
    super.key,
    required this.tracking,
  });

  @override
  State<UpdateProductQuantityScreen> createState() =>
      _UpdateProductQuantityScreenState();
}

class _UpdateProductQuantityScreenState
    extends State<UpdateProductQuantityScreen> {
  int idTracking = 0;
  String tracking = "";

  List<ItemCard> updateListItems = [];
  // List<bool> updateListIsSelected = [];

  bool isAllSelected = false;

  String titleUpdateButton = "Update";
  int qtyUpdate = 0;

  late Product? _product;
  int totalNotDone = 0;

  // SN
  bool isItemInputDate = false;

  @override
  void initState() {
    super.initState();

    _getTrackingId();
    if (idTracking == 1) {
      generateUpdateList();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (idTracking == 0) {
      generateUpdateListSerialNumber();
      _product = context.read<ProductMenuProductDetailCubit>().state.product;
      totalNotDone = _product!.productQty.toInt();
    }
    if (idTracking == 1) {
      _product = context.read<ProductMenuProductDetailCubit>().state.product;
      totalNotDone = _product!.productQty.toInt();
    }
  }

  void _getTrackingId() {
    tracking = widget.tracking;
    idTracking = TrackingHelper().getTrackingId(tracking);
    debugPrint("idTracking: $idTracking");
  }

  void generateUpdateList() {
    updateListItems = List.generate(
      11,
      (index) => ItemCard(
        id: index + 1,
        code: "SYR-LOTS-2842",
        dateTime: "Exp. Date: 12/07/2024",
        quantity: 1,
        isSelected: false,
      ),
    ).toList(growable: false);
  }

  void generateUpdateListSerialNumber() {
    List<SerialNumber> snList =
        context.read<ProductMenuProductDetailCubit>().getListOfSerialNumber();
    snList.map((e) {
      var item = ItemCard(
        id: e.id,
        code: e.label,
        dateTime: (e.isInputDate == true) ? "Exp. Date: -" : e.expiredDateTime,
        quantity: 1,
      );

      updateListItems.add(item);

      if (e.isInputDate == true) {
        isItemInputDate = true;
      }
    }).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
            title: "Update Qty", onTap: () => Navigator.pop(context)),
        body: Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tracking,
                style:
                    BaseText.black2Text14.copyWith(fontWeight: BaseText.medium),
              ),
              Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: updateListItems.length,
                      itemBuilder: (context, index) {
                        var item = updateListItems[index];

                        return ListTileTheme(
                          horizontalTitleGap: 8,
                          child: CheckboxListTile(
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: item.isSelected,
                            title:
                                Text(item.code, style: BaseText.grey10Text14),
                            subtitle: Text(
                              item.dateTime,
                              style: BaseText.mainText12.copyWith(
                                color: ColorName.dateTimeColor,
                                fontWeight: BaseText.light,
                              ),
                            ),
                            side: const BorderSide(
                              color: ColorName.grey4Color,
                            ),
                            shape: const Border(
                                bottom: BorderSide(
                              color: ColorName.grey8Color,
                            )),
                            onChanged: (newSelectedValue) {},
                          ),
                        );
                      }))
            ],
          ),
        ),
        bottomNavigationBar: Builder(builder: (context) {
          return Container(
            height: 72,
            padding: const EdgeInsets.all(16),
            decoration: _buildBottomDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        side: const BorderSide(
                          color: ColorName.grey4Color,
                        ),
                        value: isAllSelected,
                        onChanged: (val) {
                          setState(() {
                            isAllSelected = !isAllSelected;

                            updateListItems.map((e) {
                              e.isSelected = val!;

                              // Add & Remove from list
                              if (isAllSelected) {
                                e.isSelected = true;
                              } else {
                                e.isSelected = false;
                              }
                            }).toList();

                            qtyUpdate =
                                (isAllSelected) ? updateListItems.length : 0;
                            titleUpdateButton = "Update ($qtyUpdate)";
                          });
                        },
                      ),
                      Text("All", style: BaseText.grey1Text12),
                    ],
                  ),
                ),
                PrimaryButton(
                  onPressed: () {
                    if (qtyUpdate == 0) {
                      return;
                    }

                    if (idTracking == 0) {
                      if (isItemInputDate) {
                        Future.delayed(const Duration(seconds: 2), () {
                          _onShowUpdateFailed(context);
                        });
                      } else {
                        BlocProvider.of<ProductMenuProductDetailCubit>(context)
                            .getLotsUpdateTotalDone(totalNotDone, qtyUpdate);

                        Future.delayed(const Duration(seconds: 1), () {
                          Navigator.of(context).pop("serial-number");
                        });
                      }
                    }
                    if (idTracking == 1) {
                      BlocProvider.of<ProductMenuProductDetailCubit>(context)
                          .getLotsUpdateTotalDone(totalNotDone, qtyUpdate);

                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.of(context).pop(updateListItems.first.code);
                      });
                    }
                  },
                  height: 40.h,
                  width: 160.w,
                  title: titleUpdateButton,
                  textStyle: BaseText.whiteText14.copyWith(
                    fontWeight: BaseText.medium,
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  _onShowUpdateFailed(BuildContext context) {
    onShowErrorDialog(
      context,
      isInputDate: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 10.h),
          Text(
            'Update Failed!',
            style: BaseText.black2TextStyle.copyWith(
              fontSize: 16.sp,
              fontWeight: BaseText.semiBold,
            ),
          ),
          Container(height: 4.h),
          Text(
            "Cannot update quantity.\nPlease input expiration date.",
            textAlign: TextAlign.center,
            style: BaseText.grey2Text14.copyWith(
              fontWeight: BaseText.light,
            ),
          )
        ],
      ),
    );
  }

  BoxDecoration _buildBottomDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      border: Border(
        left: BorderSide(color: Color(0xFFF5F5F5)),
        top: BorderSide(width: 0.50, color: Color(0xFFF5F5F5)),
        right: BorderSide(color: Color(0xFFF5F5F5)),
        bottom: BorderSide(color: Color(0xFFF5F5F5)),
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0x33333A51),
          blurRadius: 20,
          offset: Offset(0, 8),
          spreadRadius: 0,
        )
      ],
    );
  }

  onShowErrorDialog(BuildContext context,
      {required Widget body, required bool isInputDate}) {
    return AwesomeDialog(
      context: context,
      animType: AnimType.bottomSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.error,
      showCloseIcon: true,
      width: double.infinity,
      // padding: EdgeInsets.symmetric(horizontal: 16.w),
      body: body,
      btnOkOnPress: () {
        debugPrint('OnClcik');
      },
      // btnOkIcon: Icons.check_circle,
      btnOk: PrimaryButton(
        onPressed: () async {
          Navigator.of(context).pop();
        },
        height: 40.h,
        title: "OK",
      ),
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();
  }
}
