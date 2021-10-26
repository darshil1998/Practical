import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../add_product.dart';
import 'dashboard_controller.dart';

class DashboardPage extends StatelessWidget {
  final DashboardController pc = Get.put(DashboardController());
  List<String> _list = ['Product', 'Launch Date', 'Rating', 'launch Site'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Product List'),
              actions: [
                PopupMenuButton(
                  child: Center(child: Icon(Icons.notes)),
                  itemBuilder: (context) {
                    return List.generate(_list.length, (index) {
                      return PopupMenuItem(
                        child: Text(_list[index]),
                        onTap: () {
                          if (index == 0) {
                            pc.products
                                .sort((a, b) => a.name.compareTo(b.name));
                          } else if (index == 1) {
                            pc.products.sort((a, b) => DateFormat('dd-MM-yyyy')
                                .parse(a.launchedDate)
                                .compareTo(DateFormat('dd-MM-yyyy')
                                    .parse(b.launchedDate)));
                          } else if (index == 2) {
                            pc.products
                                .sort((a, b) => b.rating.compareTo(a.rating));
                          } else {
                            pc.products.sort(
                                (a, b) => a.launchSite.compareTo(b.launchSite));
                          }
                        },
                      );
                    });
                  },
                ),
                InkWell(
                  onTap: () {
                    Get.to(AddProduct());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.add,
                      size: 38,
                    ),
                  ),
                )
              ],
            ),
            body: Container(
              child:
                  Padding(padding: EdgeInsets.all(5), child: getProductList()),
            )));
  }

  Widget getProductList() {
    return Obx(
      () => pc.products.length == 0
          ? Center(
              child: Text('No Product Yet',
                  style: TextStyle(color: Colors.black, fontSize: 18)),
            )
          : ListView.builder(
              itemCount: pc.products.length,
              itemBuilder: (context, index) => Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text(
                            (index + 1).toString() + ".",
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(pc.products[index].name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(pc.products[index].launchedDate,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey)),
                                ),
                                SmoothStarRating(
                                  allowHalfRating: false,
                                  starCount: 5,
                                  rating: pc.products[index].rating,
                                  size: 20.0,
                                  color: Colors.green,
                                  borderColor: Colors.green,
                                  spacing: 0.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(pc.products[index].launchSite,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal)),
                                ),
                              ],
                            ),
                          ),
                          Wrap(children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.create),
                                onPressed: () =>
                                    Get.to(AddProduct(index: index))),
                            IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  Get.defaultDialog(
                                      title: 'Delete Product',
                                      middleText:
                                          'Do you really want to delete ${pc.products[index].name} product?',
                                      onCancel: () => Get.back(),
                                      confirmTextColor: Colors.white,
                                      onConfirm: () {
                                        pc.products.removeAt(index);
                                        Get.back();
                                      });
                                })
                          ])
                        ],
                      ),
                    ),
                  )),
    );
  }
}
