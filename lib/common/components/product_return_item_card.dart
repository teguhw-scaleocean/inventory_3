import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_v3/data/model/return_product.dart';

import '../theme/text/base_text.dart';
import 'custom_divider.dart';
import 'reusable_widget.dart';

class ProductReturnItemCard extends StatelessWidget {
  final ReturnProduct item;

  const ProductReturnItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                item.code,
                style: BaseText.grey10Text14,
              ),
              InkWell(
                onTap: () {},
                child: SizedBox(
                  child: Text("Edit", style: BaseText.blue4Text11),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: CustomDivider(height: 0.5.h),
          ),
          buildProductDescPerRow(label: "Reason: ", value: item.reason),
          buildProductDescPerRow(
            label: "Location: ",
            value: item.location,
          )
        ],
      ),
    );
  }
}
