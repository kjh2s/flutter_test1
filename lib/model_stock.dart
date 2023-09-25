class Stock{
  final String ticker;
  final double price;

  Stock(this.ticker, this.price);

  Map<String, Object> toMap(){
    Map<String, Object> map = {};
    map['stock_ticker'] = this.ticker;
    map['stock_price'] = this.price.toString();
    return map;
  }
}