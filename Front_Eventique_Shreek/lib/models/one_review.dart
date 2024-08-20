class OneReview {
  final double? rating;
  final String personName, theComment, imgurl;
  final int personId;

  OneReview({
    required this.theComment,
    this.rating,
    required this.personName,
    required this.personId,
    required this.imgurl,
  });
}
