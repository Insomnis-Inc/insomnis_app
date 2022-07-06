class SVDrawerModel {
  String? title;
  String? image;

  SVDrawerModel({this.image, this.title});
}

List<SVDrawerModel> getDrawerOptions() {
  List<SVDrawerModel> list = [];

  // list.add(SVDrawerModel(
  //     image: 'images/socialv/icons/ic_Profile.png', title: 'Profile'));
  // list.add(SVDrawerModel(
  //     image: 'images/socialv/icons/ic_2User.png', title: 'Friends'));
  list.add(SVDrawerModel(
      image: 'images/socialv/icons/ic_3User.png', title: 'Events'));
  list.add(SVDrawerModel(
      image: 'images/socialv/icons/ic_Image.png', title: 'Groups'));
  list.add(SVDrawerModel(
      image: 'images/socialv/icons/ic_Image.png', title: 'Pizza corner'));
  list.add(SVDrawerModel(
      image: 'images/socialv/icons/ic_Image.png', title: 'Ice cream'));
  list.add(
      SVDrawerModel(image: 'images/socialv/icons/ic_Image.png', title: 'BBQ'));
  list.add(SVDrawerModel(
      image: 'images/socialv/icons/ic_Image.png', title: 'Wines & Spirits'));
  list.add(SVDrawerModel(
      image: 'images/socialv/icons/ic_Image.png', title: 'Lost & Found'));

  list.add(SVDrawerModel(
      image: 'images/socialv/icons/ic_Image.png', title: 'Bookmark'));
  // list.add(SVDrawerModel(image: 'images/socialv/icons/ic_Document.png', title: 'Forums'));
  // list.add(SVDrawerModel(
  //     image: 'images/socialv/icons/ic_Send.png', title: 'Lost & Found'));
  // list.add(SVDrawerModel(
  //     image: 'images/socialv/icons/ic_Star.png', title: 'Rate Us'));
  list.add(SVDrawerModel(
      image: 'images/socialv/icons/ic_Logout.png', title: 'Logout'));

  return list;
}
