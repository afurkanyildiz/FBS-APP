final List<String> imageList = [
  'assets/images/slider/slider_1.jpeg',
  'assets/images/slider/slider_2.jpg',
  'assets/images/slider/slider_3.png'
];

enum ImageConstants {
  appLogo('logo3'),
  ;

  final String value;
  const ImageConstants(this.value);
  String get toPng => 'assets/images/$value.png';
}
