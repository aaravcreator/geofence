class Product {
  String? name;
  double? markedPrice;
  double? salePrice;
  String? shopName;

  Product({this.name, this.markedPrice, this.salePrice, this.shopName});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    markedPrice = json['markedPrice'];
    salePrice = json['salePrice'];
    shopName = json['shopName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['markedPrice'] = this.markedPrice;
    data['salePrice'] = this.salePrice;
    data['shopName'] = this.shopName;
    return data;
  }
}