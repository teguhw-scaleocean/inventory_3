import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../theme/color/color_name.dart';
import '../theme/text/base_text.dart';

class ReusableDropdownSearch extends StatefulWidget {
  final List<dynamic> listOfItemsValue;
  final dynamic selectedValue;
  final Function(dynamic) onChange;

  const ReusableDropdownSearch(
      {required this.listOfItemsValue,
      required this.selectedValue,
      required this.onChange,
      super.key});

  @override
  State<ReusableDropdownSearch> createState() => _ReusableDropdownSearchState();
}

class _ReusableDropdownSearchState extends State<ReusableDropdownSearch> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      // padding: const EdgeInsets.all(8),
      child: DropdownSearch<dynamic>(
        itemAsString: (valueOfName) => valueOfName,
        items: widget.listOfItemsValue,
        selectedItem: widget.selectedValue,
        onChanged: widget.onChange
        // (value) {
        //   setState(() {
        //     widget.selectedValue = value;

        //     log(widget.selectedValue.id.toString());
        //     log(widget.selectedValue.name);
        //   });
        // }
        ,
        popupProps: PopupProps.menu(
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                focusColor: ColorName.mainColor,
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: ColorName.borderColor,
                constraints: const BoxConstraints(
                  maxHeight: 40,
                ),
                contentPadding: const EdgeInsets.all(8),
                hintText: '',
                // hintStyle: BaseText.greyText12,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorName.borderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: ColorName.mainColor, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            showSearchBox: true,
            itemBuilder: (context, items, isSelected) {
              return ListTile(
                selectedColor: ColorName.mainColor.withOpacity(0.5),
                selected: isSelected,
                selectedTileColor: Colors.amber,
                leading: Text(items, style: BaseText.blackText12),
              );
            }),
        dropdownButtonProps: const DropdownButtonProps(
          color: Colors.red,
        ),
        dropdownDecoratorProps: DropDownDecoratorProps(
          baseStyle: BaseText.blackText12,
          textAlignVertical: TextAlignVertical.center,
          dropdownSearchDecoration: InputDecoration(
            contentPadding: const EdgeInsets.all(8),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorName.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorName.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: ColorName.mainColor, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
