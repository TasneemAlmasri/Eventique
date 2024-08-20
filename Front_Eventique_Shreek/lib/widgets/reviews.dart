// import '/models/one_review.dart';
// import 'package:flutter/material.dart';

// class Reviews with ChangeNotifier {
//   final Map<int, List<OneReview>> _reviewsForServiceMap = {
//     1: [
//       OneReview(
//         theComment:
//             'the cream cheese frosting was the perfect balance of sweet and tangy',
//         rating: 3,
//         personName: 'Mira Hasan',
//         imgurl:
//             'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
//       ),
//       OneReview(
//         theComment:
//             'those handcrafted truffles were divine. It was the perfect ending to a perfect dinner',
//         rating: 4,
//         personName: 'Tasneem Masri',
//         imgurl:
//             'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
//       ),
//       OneReview(
//         theComment:
//             'the cream cheese frosting was the perfect balance of sweet and tangy',
//         rating: 2.5,
//         personName: 'Batoul haffar',
//         imgurl:
//             'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
//       ),
//       OneReview(
//         theComment:
//             'The Velvet Symphony cake was a showstopper at our anniversary party! The red velvet layers were so moist, and the cream cheese frosting was the perfect balance of sweet and tangy',
//         rating: 4,
//         personName: 'Raneem Masri',
//         imgurl:
//             'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
//       ),
//     ],
//     2: [
//       OneReview(
//         theComment: 'Truly the best roses Ive ever received',
//         rating: 4,
//         personName: 'Batoul haffar',
//         imgurl:
//             'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
//       ),
//       OneReview(
//         theComment:
//             'those handcrafted truffles were divine. It was the perfect ending to a perfect dinner',
//         rating: 4.5,
//         personName: 'Mira Hasan',
//         imgurl:
//             'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
//       ),
//     ],
//     3: [
//       OneReview(
//         theComment:
//             ' the veranda offered breathtaking views. Our guests havent stopped talking about it. Thank you for making our special day truly unforgettable',
//         rating: 2.5,
//         personName: 'Tasneem Masri',
//         imgurl:
//             'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
//       ),
//       OneReview(
//         theComment:
//             ' it was the epitome of elegance. The ambiance, the service, the attention to detail',
//         rating: 4,
//         personName: 'Mira Hasan',
//         imgurl:
//             'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
//       ),
//     ],
//     4: [],
//     5: [
//       OneReview(
//         theComment:
//             'The Velvet Symphony cake was a showstopper at our anniversary party! The red velvet layers were so moist, and the cream cheese frosting was the perfect balance of sweet and tangy',
//         rating: 4,
//         personName: 'Tasneem Masri',
//         imgurl:
//             'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
//       ),
//       OneReview(
//         theComment:
//             'those handcrafted truffles were divine. It was the perfect ending to a perfect dinner',
//         rating: 5,
//         personName: 'Mira Hasan',
//         imgurl:
//             'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
//       ),
//       OneReview(
//         theComment:
//             'the cream cheese frosting was the perfect balance of sweet and tangy',
//         rating: 1.5,
//         personName: 'Batoul haffar',
//         imgurl:
//             'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
//       ),
//       OneReview(
//         theComment:
//             'The Velvet Symphony cake was a showstopper at our anniversary party! The red velvet layers were so moist, and the cream cheese frosting was the perfect balance of sweet and tangy',
//         rating: 4,
//         personName: 'Raneem Masri',
//         imgurl:
//             'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
//       ),
//     ]
//   };

//   double getServiceRating(int serviceId) {
//     return 4;
//   }

//   List<OneReview> getReviewsForService(int serviceId) {
//     return _reviewsForServiceMap[serviceId]!;
//   }
// }
