
 
class Offer {
  int? id;
  String? productName;
  String? offerTitle;
  String? offerPrice;
  String? originalPrice;
  String? productImage;
  String? shopName;

  Offer(
      {this.id,
      this.productName,
      this.offerTitle,
      this.offerPrice,
      this.originalPrice,
      this.productImage,
      this.shopName});

  Offer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['productName'];
    offerTitle = json['offerTitle'];
    offerPrice = json['offerPrice'];
    originalPrice = json['originalPrice'];
    productImage = json['productImage'];
    shopName = json['shopName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productName'] = this.productName;
    data['offerTitle'] = this.offerTitle;
    data['offerPrice'] = this.offerPrice;
    data['originalPrice'] = this.originalPrice;
    data['productImage'] = this.productImage;
    data['shopName'] = this.shopName;
    return data;
  }
}