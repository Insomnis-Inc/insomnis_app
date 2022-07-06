// import 'dart:io';
// // import 'package:brokerstreet/auth/login.dart';
// // import 'package:brokerstreet/controllers/bidController.dart';
// // import 'package:brokerstreet/main.dart';
// // import 'package:brokerstreet/thousand_separator.dart';
// // import 'package:brokerstreet/views/client/bids/my_bids.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../toast.dart';
// // import 'package:animated_text_kit/animated_text_kit.dart';

// class ClientBidPlacement extends StatefulWidget {
//   const ClientBidPlacement({Key? key}) : super(key: key);
//   // final bool signedIn;
//   @override
//   _ClientBidPlacementState createState() => _ClientBidPlacementState();
// }

// class _ClientBidPlacementState extends State<ClientBidPlacement>
//     with AutomaticKeepAliveClientMixin {
//   late TextEditingController _textController;
//   late TextEditingController _priceController;
//   late String myId;
//   List<dynamic> images = [];
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     _priceController = TextEditingController();
//     _textController = TextEditingController();
//     // if (widget.signedIn) {
//     var _tokenBox = Hive.box(TokenBox);
//     myId = _tokenBox.get("id");
//     // }
//     setState(() {
//       images.add("Add Image");
//       images.add("Add Image");
//     });
//   }

//   onSent() {
//     String _text = _textController.text;
//     String _price = _priceController.text;
//     if (_text.length < 2) {
//       showToast("text too short", context);
//       return;
//     }

//     showToast("Uploading Bid", context);

//     if (_price.length < 2) {
//       _price = '_';
//     }

//     List<File>? _finalImages = [];
//     for (var row in images) {
//       if (row.runtimeType == ImageUploadModel) {
//         _finalImages.add(row.imageFile);
//       }
//     }

//     /// here
//     createBid(images: _finalImages, myId: myId, text: _text, price: _price)
//         .then((value) {
//       if (value) {
//         showSuccessToast("Bid placed Successfully", context);
//         setState(() {
//           _textController.clear();
//           _priceController.clear();
//           images.clear();
//           images.add("Add Image");
//           images.add("Add Image");
//         });
//         return;
//       } else {
//         showToast("Your connection is slowing down", context);
//         return;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     double v16 = width / 20;
//     return Scaffold(
//       body: Container(
//         width: width,
//         height: height,
//         child: ListView(
//           padding: EdgeInsets.only(top: v16, bottom: v16 * 3),
//           children: [
//             //
//             Container(
//               width: width,
//               height: v16 * 8,
//               child: Stack(
//                 children: [
//                   Positioned.fill(
//                       child: ClipRRect(
//                     child: Image.asset(
//                       "assets/images/intro/intro1.jpg",
//                       fit: BoxFit.cover,
//                     ),
//                   )),
//                   Positioned.fill(
//                       child: Container(
//                     color: REAL_BLACK.withOpacity(0.7),
//                   )),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: v16),
//                     child: Center(
//                       child: DefaultTextStyle(
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: TITLE_COLOR, fontSize: v16),
//                         child: AnimatedTextKit(
//                             repeatForever: true,
//                             animatedTexts: [
//                               RotateAnimatedText(
//                                   "Receive the best Offers from sellers, by placing a bid Now ",
//                                   textAlign: TextAlign.center,
//                                   duration: Duration(milliseconds: 5000)),
//                               RotateAnimatedText('Over 7000 registered sellers',
//                                   duration: Duration(milliseconds: 5000)),
//                               RotateAnimatedText(
//                                   "Uganda\'s biggest online market",
//                                   textAlign: TextAlign.center,
//                                   duration: Duration(milliseconds: 5000)),
//                               TypewriterAnimatedText('BROKER STREET',
//                                   textStyle: titleTextStyle.copyWith(
//                                     color: TITLE_COLOR,
//                                     fontSize: 28,
//                                   ),
//                                   speed: Duration(milliseconds: 120)),
//                             ]),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),

//             InkWell(
//               onTap: () {
//                 FocusScope.of(context).unfocus();
//                 navigatePage(context, className: ClientMyBids());
//               },
//               child: Container(
//                 margin: EdgeInsets.only(
//                     top: v16, bottom: v16, left: v16 * 2, right: v16 * 2),
//                 child: normalButton(
//                     v16: v16, bgColor: APP_ACCENT, title: "My Bids"),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: v16),
//               child: TextField(
//                 controller: _textController,
//                 maxLines: 3,
//                 autofocus: false,
//                 decoration: InputDecoration(
//                     focusColor: APP_PRIMARY,
//                     hintText: "Type what you are looking for ",
//                     border: OutlineInputBorder(
//                       gapPadding: 2,
//                       borderSide: BorderSide(color: Colors.black, width: 2),
//                     )),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.only(top: v16, left: v16, right: v16),
//               child: Text(
//                 "Budget (Optional)",
//                 style: normalTextStyle,
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: v16),
//               child: TextField(
//                 controller: _priceController,
//                 autofocus: false,
//                 keyboardType: TextInputType.number,
//                 inputFormatters: [ThousandsSeparatorInputFormatter()],
//                 decoration: InputDecoration(
//                     prefixText: 'UGX ',
//                     prefixStyle: normalTextStyle.copyWith(color: APP_ACCENT),
//                     focusColor: APP_PRIMARY,
//                     border: OutlineInputBorder(
//                       gapPadding: 2,
//                       borderSide: BorderSide(color: Colors.black, width: 2),
//                     )),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.only(top: v16, left: v16, right: v16),
//               child: Text(
//                 "Images (Optional)",
//                 style: normalTextStyle,
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: v16),
//               child: buildGridView(),
//             ),

//             InkWell(
//               onTap: () => onSent(),
//               child: Container(
//                 margin: EdgeInsets.only(
//                     top: v16 * 0.6, left: v16 * 2, right: v16 * 2),
//                 child: normalButton(
//                     v16: v16, bgColor: APP_ACCENT, title: "Place Bid"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;

//   Widget buildGridView() {
//     return GridView.count(
//       shrinkWrap: true,
//       crossAxisCount: 2,
//       childAspectRatio: 1,
//       children: List.generate(images.length, (index) {
//         if (images[index] is ImageUploadModel) {
//           ImageUploadModel uploadModel = images[index];
//           return Card(
//             clipBehavior: Clip.antiAlias,
//             child: Stack(
//               children: <Widget>[
//                 Image.file(
//                   uploadModel.imageFile!,
//                   width: 300,
//                   height: 300,
//                 ),
//                 Positioned(
//                   right: 5,
//                   top: 5,
//                   child: InkWell(
//                     child: Icon(
//                       Icons.remove_circle,
//                       size: 32,
//                       color: Colors.red,
//                     ),
//                     onTap: () {
//                       setState(() {
//                         images.replaceRange(index, index + 1, ['Add Image']);
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         } else {
//           return Card(
//             child: IconButton(
//               icon: Icon(Icons.add),
//               onPressed: () {
//                 _onAddImageClick(index);
//               },
//             ),
//           );
//         }
//       }),
//     );
//   }

//   Future _onAddImageClick(int index) async {
//     final XFile? imageX = await _picker.pickImage(source: ImageSource.gallery);
//     File? image = File(imageX!.path);

//     getFileImage(index, image);
//   }

//   void getFileImage(int index, File imageFile) async {
//     setState(() {
//       ImageUploadModel imageUpload = new ImageUploadModel();
//       imageUpload.isUploaded = false;
//       imageUpload.uploading = false;
//       imageUpload.imageFile = imageFile;
//       imageUpload.imageUrl = '';
//       images.replaceRange(index, index + 1, [imageUpload]);
//     });
//   }
// }

// class ImageUploadModel {
//   bool? isUploaded;
//   bool? uploading;
//   File? imageFile;
//   String? imageUrl;

//   ImageUploadModel({
//     this.isUploaded,
//     this.uploading,
//     this.imageFile,
//     this.imageUrl,
//   });
// }
