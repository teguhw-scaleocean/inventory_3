import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/common/components/primary_button.dart';
import 'package:inventory_v3/presentation/receipt/receipt_product/cubit/product_detail/product_menu_product_detail_cubit.dart';

import '../../../../../common/components/custom_app_bar.dart';
import '../../../../../common/helper/tracking_helper.dart';
import '../../../../../common/theme/color/color_name.dart';
import '../../../../../common/theme/text/base_text.dart';
import '../../../../../data/model/item_card.dart';
import '../../../../../data/model/product.dart';

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

  @override
  void initState() {
    super.initState();

    _getTrackingId();
    generateUpdateList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

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
                    BlocProvider.of<ProductMenuProductDetailCubit>(context)
                        .getLotsUpdateTotalDone(totalNotDone, qtyUpdate);

                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.of(context).pop(updateListItems.first.code);
                    });
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
}
