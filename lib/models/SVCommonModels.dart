// class SVDrawerModel {
//   String? name;
//   String? image;

//   SVDrawerModel({this.image, this.name});
// }

import 'package:brokerstreet/http/models/Extra.dart';

List<Extra> getDrawerOptions() {
  List<Extra> list = [];

  // list.add(Extra(
  //     image: 'images/socialv/icons/ic_Profile.png', name: 'Profile'));
  // list.add(Extra(
  //     image: 'images/socialv/icons/ic_2User.png', name: 'Friends'));
  list.add(Extra(image: 'assets/images/extras/party.png', name: 'Events'));
  list.add(Extra(image: 'assets/images/people.png', name: 'Groups'));
  list.add(Extra(
      image: 'assets/images/extras/pizza.png',
      id: '954eb3a8-93cb-4269-9c2b-2a6888b28e72',
      name: 'Pizza corner'));
  list.add(Extra(
      image: 'assets/images/extras/ice-cream.png',
      id: '1f298183-30c0-40e9-b8d8-5df9a9f8874f',
      name: 'Ice cream'));
  list.add(Extra(
      image: 'assets/images/extras/skewer.png',
      id: '855a7fdb-16d6-4a16-a2ba-e67cb09cf22d',
      name: 'BBQ'));
  list.add(Extra(
      image: 'assets/images/extras/wine.png',
      id: "db9fc096-e85f-4bef-81f0-c06cbd3092a9",
      name: 'Wines & Spirits'));
  list.add(Extra(
      image: 'assets/images/apartment.png',
      // id: '81a9e5c1-1a8c-45c8-9b97-c141e17b8397',
      name: 'Apartments & Hotels'));
  list.add(Extra(
      image: 'assets/images/extras/found.png',
      id: '81a9e5c1-1a8c-45c8-9b97-c141e17b8397',
      canAdd: true,
      name: 'Lost & Found'));

  list.add(Extra(image: 'assets/images/ribbon.png', name: 'Bookmarks'));
  // list.add(Extra(image: 'images/socialv/icons/ic_Document.png', name: 'Forums'));
  // list.add(Extra(
  //     image: 'images/socialv/icons/ic_Send.png', name: 'Lost & Found'));
  // list.add(Extra(
  //     image: 'images/socialv/icons/ic_Star.png', name: 'Rate Us'));
  list.add(Extra(image: 'images/socialv/icons/ic_Logout.png', name: 'Logout'));

  return list;
}
