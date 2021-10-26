import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:practical/models/product.dart';

class DashboardController extends GetxController {
  var products=List<Product>().obs;
  void add(Product n) {
    products.add(n);
  }
  @override
  void onInit() {
    List storedProducts=GetStorage().read<List>('products');
    if(storedProducts!=null){
      products=storedProducts.map((e) => Product.fromJson(e)).toList().obs;
    }
    ever(products, (_){
      GetStorage().write('products',products.toList());
    });
    super.onInit();
  }
}
