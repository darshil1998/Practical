import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:practical/models/product.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'dashboard/dashboard_controller.dart';

class AddProduct extends StatelessWidget {
  int index;

  AddProduct({this.index});

  final formKey = GlobalKey<FormState>();
  FocusNode nameFocus = FocusNode();
  FocusNode launchedAtFocus = FocusNode();
  FocusNode launchSiteFocus = FocusNode();
  var rating = 0.0.obs;
  var ratingError = false.obs;

  @override
  Widget build(BuildContext context) {
    final DashboardController nc = Get.find();
    rating.value = index == null ? 0.0 : nc.products[index].rating;
    TextEditingController nameController = new TextEditingController(
        text: index == null ? null : nc.products[index].name);
    TextEditingController dateController = new TextEditingController(
        text: index == null ? null : nc.products[index].launchedDate);
    TextEditingController launchSiteController = new TextEditingController(
        text: index == null ? null : nc.products[index].launchSite);
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title:
                  index == null ? Text('Add Product') : Text('Edit Product '),
            ),
            body: Padding(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        validator: (value) {
                          var contain = nc.products.value.where((element) =>
                              element.name.toLowerCase() == nameController.text.toLowerCase());
                          if (value.isEmpty) {
                            return 'product name is required!';
                          } else if (index != null
                              ? (nc.products[index].name.toLowerCase() != value.toLowerCase()
                                  ? contain.isNotEmpty
                                  : false)
                              : (contain.isNotEmpty)) {
                            return 'please enter unique product name!';
                          }
                          return null;
                        },
                        focusNode: nameFocus,
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter a product name',
                          labelText: 'product name',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        style: TextStyle(fontSize: 18),
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (v) {
                          nameFocus.unfocus();
                          // launchedAtFocus.requestFocus();
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final DateTime pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2015),
                              lastDate: DateTime(2050));
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                            dateController.text = formattedDate;
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'launched date is required!';
                              }
                              return null;
                            },
                            autofocus: false,
                            focusNode: launchedAtFocus,
                            controller: dateController,
                            decoration: InputDecoration(
                              hintText: 'Enter a launched date',
                              labelText: 'launched date',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            style: TextStyle(fontSize: 18),
                            keyboardType: TextInputType.text,
                            onFieldSubmitted: (v) {
                              launchedAtFocus.unfocus();
                              launchSiteFocus.requestFocus();
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'launch site is required!';
                          }
                          return null;
                        },
                        focusNode: launchSiteFocus,
                        controller: launchSiteController,
                        decoration: InputDecoration(
                          hintText: 'Enter a launchSite',
                          labelText: 'launch site',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        style: TextStyle(fontSize: 18),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Popularity :',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Obx(() => SmoothStarRating(
                            allowHalfRating: false,
                            onRatingChanged: (value) {
                              rating.value = value;
                              ratingError.value = false;
                              print('Value${value.toString()}');
                              if (value != 0.0) {
                                ratingError.value = false;
                              }
                            },
                            starCount: 5,
                            rating: rating.value,
                            size: 40.0,
                            color: Colors.green,
                            borderColor: Colors.green,
                            spacing: 0.0,
                          )),
                      Obx(() => Visibility(
                          visible: ratingError.value,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              'Rating is required',
                              style: TextStyle(
                                  color: Color(0xffcc0000), fontSize: 12),
                            ),
                          ))),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text('Cancel'),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.red),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState.validate() &
                                        validateRating()) {
                                      if (index == null) {
                                        nc.products.add(Product(
                                            name: nameController.text.trim(),
                                            launchedDate: dateController.text,
                                            launchSite:
                                                launchSiteController.text.trim(),
                                            rating: rating.value));
                                      } else {
                                        var product = nc.products[index];
                                        product.name = nameController.text;
                                        product.launchedDate =
                                            dateController.text;
                                        product.launchSite =
                                            launchSiteController.text;
                                        product.rating = rating.value;
                                        nc.products[index] = product;
                                      }
                                      Get.back();
                                    }
                                  },
                                  child: index == null
                                      ? Text('Add')
                                      : Text('Update'),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.green)),
                            )
                          ])
                    ],
                  ),
                ),
              ),
            )));
  }

  bool validateRating() {
    if (rating.value == 0.0) {
      ratingError.value = true;
      return false;
    } else {
      ratingError.value = false;
      return true;
    }
  }
}
