import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/common/components/custom_app_bar.dart';
import 'package:inventory_v3/common/components/custom_divider.dart';
import 'package:inventory_v3/common/components/primary_button.dart';
import 'package:inventory_v3/common/components/reusable_confirm_dialog.dart';
import 'package:inventory_v3/data/model/pallet.dart';
import 'package:inventory_v3/data/model/product.dart';
import 'package:inventory_v3/data/model/return_product.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/cubit/damage_cubit/damage_cubit.dart';
import 'package:inventory_v3/presentation/receipt/receipt_pallet/screens/pallet/return_pallet_product/return_add_product_screen.dart';

import '../../../../../common/components/reusable_dropdown_menu.dart';
import '../../../../../common/components/reusable_widget.dart';
import '../../../../../common/theme/color/color_name.dart';
import '../../../../../common/theme/text/base_text.dart';
import '../../../../../data/model/return_pallet.dart';
import '../../cubit/damage_cubit/damage_state.dart';

class ReturnPalletAndProductScreen extends StatefulWidget {
  final int idTracking;
  final bool? isBothLots;
  final bool? isDamage;

  const ReturnPalletAndProductScreen(
      {super.key, this.idTracking = 0, this.isBothLots, this.isDamage});

  @override
  State<ReturnPalletAndProductScreen> createState() =>
      _ReturnPalletAndProductScreenState();
}

class _ReturnPalletAndProductScreenState
    extends State<ReturnPalletAndProductScreen> {
  late DamageCubit damageCubit;

  int idTracking = 0;
  bool isShowResult = false; // Serial Number Result
  bool isShowLotsResult = false; // Lots Result
  bool isShowNoTrackingResult = false;

  bool isBothLots = false;
  bool isDamage = false; // Serial Number
  bool isDamagePalletIncLots = false;
  bool isDamagePalletIncNoTracking = false;

  Product? _damageProduct;

  String appBarTitle = "Return";

  @override
  void initState() {
    super.initState();

    idTracking = widget.idTracking;
    debugPrint("idTracking: $idTracking");
    isBothLots = widget.isBothLots ?? false;
    // isDamage = widget.isDamage ?? false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    damageCubit = BlocProvider.of<DamageCubit>(context);

    isDamage = damageCubit.state.isDamagePalletIncSn ?? false;
    isDamagePalletIncLots = damageCubit.state.isDamagePalletIncLots ?? false;
    isDamagePalletIncNoTracking =
        damageCubit.state.isDamagePalletIncNoTracking ?? false;

    if (isDamage || isDamagePalletIncLots || isDamagePalletIncNoTracking) {
      appBarTitle = "Damage";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          onTap: () => Navigator.pop(context),
          title: "$appBarTitle: Pallet and Product",
        ),
        body: BlocListener<DamageCubit, DamageState>(
          listener: (context, state) {
            _damageProduct = state.damageProduct;
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: ListView.separated(
                itemCount: 2,
                separatorBuilder: (context, index) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: const CustomDivider(
                        color: ColorName.grey9Color,
                      ),
                    ),
                itemBuilder: (context, index) {
                  if (isShowResult && index == 0 ||
                      isShowLotsResult && index == 0 ||
                      isShowNoTrackingResult && index == 0) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        listTileTheme: ListTileTheme.of(context).copyWith(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      child: ExpansionTile(
                        collapsedShape: const RoundedRectangleBorder(
                          side: BorderSide.none,
                        ),
                        shape: const RoundedRectangleBorder(
                          side: BorderSide.none,
                        ),
                        tilePadding: EdgeInsets.zero,
                        title: Text(
                          "Pallet A14$index",
                          style: BaseText.grey10Text14,
                        ),
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildProductItemCard(
                                name: (isShowResult)
                                    ? "Nebulizer Machine"
                                    : (isShowNoTrackingResult)
                                        ? "Surgical Instruments"
                                        : "Syringes",
                                code: (isShowResult)
                                    ? "NM928321"
                                    : (isShowNoTrackingResult)
                                        ? "SUR_12942"
                                        : (isBothLots == true)
                                            ? "SYR-LOTS-2842"
                                            : "SY_12937",
                                reason: _damageProduct?.reason,
                              ),
                              SizedBox(height: 8.h),
                              SizedBox(
                                height: 30.h,
                                child: Row(
                                  children: [
                                    _buildAddProductButton(
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8.h),
                            ],
                          )
                        ],
                      ),
                    );
                  }

                  return SizedBox(
                    height: 30.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pallet A14$index",
                          style: BaseText.grey10Text14,
                        ),
                        _buildAddProductButton(onTap: () {
                          final addProduct = Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReturnAddProductScreen(
                                idTracking: idTracking,
                              ),
                            ),
                          );

                          addProduct.then((value) {
                            if (idTracking == 0) {
                              setState(() {
                                isShowResult = true;
                              });
                            } else if (idTracking == 1) {
                              setState(() {
                                isShowLotsResult = true;
                              });
                            } else if (idTracking == 2) {
                              setState(() {
                                isShowNoTrackingResult = true;
                              });
                            }
                          });
                        })
                      ],
                    ),
                  );
                }),
          ),
        ),
        bottomNavigationBar: buildBottomNavbar(
          child: PrimaryButton(
            onPressed: () {
              String confirmTitle = "Confirm Return";
              String confirmMessage =
                  "Are you sure you want to return this\nPallet & Product?";

              ReturnPallet returnPallet;
              if (isShowLotsResult) {
                returnPallet = ReturnPallet(
                  id: 1,
                  palletCode: "A494",
                  reason: "Overstock",
                  location: "Warehouse A-342-3-4",
                );
              } else if (isShowNoTrackingResult) {
                returnPallet = ReturnPallet(
                  id: 1,
                  palletCode: "A490",
                  reason: "Overstock",
                  location: "Warehouse A-342-3-4",
                );
              } else {
                returnPallet = ReturnPallet(
                  id: 1,
                  palletCode: "A4910",
                  reason: "Overstock",
                  location: "Warehouse A-342-3-4",
                );
              }

              Future.delayed(const Duration(milliseconds: 500), () {
                if (isDamage ||
                    isDamagePalletIncLots ||
                    isDamagePalletIncNoTracking) {
                  // ReturnProduct returnProduct = ReturnProduct(
                  //   id: returnPallet.id,
                  //   code: returnPallet.palletCode,
                  //   reason: _damageProduct!.reason,
                  //   location: _damageProduct!.location,
                  //   lotsNumber: _damageProduct!.lotsNumber,
                  //   quantity: _damageProduct!.quantity?.toInt(),
                  // );

                  returnPallet = ReturnPallet(
                    id: returnPallet.id,
                    palletCode: returnPallet.palletCode,
                    reason: _damageProduct!.reason,
                    location: _damageProduct!.location,
                    damageProducts: _damageProduct,
                    damageQty: _damageProduct!.quantity,
                  );

                  debugPrint(
                      "ReturnPalletAndProductScreen=>Damage - Lots:  $returnPallet");

                  confirmTitle = "Confirm Damage";
                  confirmMessage =
                      "Are you sure you want to damage this\nPallet and Product?";
                }

                reusableConfirmDialog(
                  context,
                  title: confirmTitle,
                  message: confirmMessage,
                  maxLines: 2,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, returnPallet);
                    // Navigator.pop(context);
                  },
                );
              });
            },
            height: 40.h,
            title: "Submit",
          ),
        ),
      ),
    );
  }

  InkWell _buildAddProductButton({required void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 13.w,
        ),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: ColorName.blue4Color,
            ),
            borderRadius: BorderRadius.circular(5.r),
          ),
        ),
        alignment: Alignment.center,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Text(
          "Add Product",
          textAlign: TextAlign.center,
          style: BaseText.blue4Text11.copyWith(
            fontWeight: BaseText.medium,
          ),
        ),
      ),
    );
  }

  Widget buildProductItemCard(
      // ReturnPallet? item,
      {
    required String name,
    required String code,
    String? reason,
  }) {
    return Container(
        // width: 328,
        // height: 126,
        padding: EdgeInsets.all(12.w),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFEFEFEF)),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: BaseText.grey10Text14,
                ),
                InkWell(
                  onTap: () {
                    // if (idTracking == 0) {
                    if (isDamage ||
                        isDamagePalletIncLots ||
                        isDamagePalletIncNoTracking) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReturnAddProductScreen(
                            idTracking: idTracking,
                            isEditDamage: true,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReturnAddProductScreen(
                            idTracking: idTracking,
                            isEdit: true,
                          ),
                        ),
                      );
                    }
                    // }
                  },
                  child: SizedBox(
                    child: Text("Edit", style: BaseText.blue4Text11),
                  ),
                )
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              code,
              style: BaseText.grey2Text12.copyWith(
                fontWeight: BaseText.light,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: CustomDivider(thickness: 0.5.h),
            ),
            _buildProductDescPerRow(
              label: "Items: ",
              value: "1",
            ),
            SizedBox(height: 2.h),
            _buildProductDescPerRow(
              label: "Reason: ",
              value: reason ?? "Overstock",
            ),
            SizedBox(height: 2.h),
            _buildProductDescPerRow(
              label: "Location: ",
              value: "Warehouse A-342-3-4",
            ),
          ],
        ));
  }

  Row _buildProductDescPerRow({
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: BaseText.grey2Text12),
        Text(value,
            style:
                BaseText.grey2Text12.copyWith(color: const Color(0xFF797979))),
      ],
    );
  }
}
