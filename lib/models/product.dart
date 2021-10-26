class Product {
  String name;
  String launchedDate;
  String launchSite;
  double rating;

  Product({this.name, this.launchedDate, this.launchSite, this.rating});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      name: json['name'],
      launchedDate: json['launchedDate'],
      launchSite: json['launchSite'],
      rating: json['rating']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'launchedDate': launchedDate,
        'launchSite': launchSite,
        'rating': rating
      };
}
