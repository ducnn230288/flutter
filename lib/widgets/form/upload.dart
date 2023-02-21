// import 'dart:io';
// import 'package:transparent_image/transparent_image.dart';
//
// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../full_screen_image.dart';
// import '../spin.dart';
// import '/services/core/index.dart';
// import '/utils.dart';
// import '../button.dart';
//
// class WidgetUpload extends StatefulWidget {
//   final String label;
//   final String keyPath;
//   final double space;
//   final Function onGetList;
//   final Function onGetTemplate;
//   final Function onUpload;
//   final Function onDelete;
//
//   WidgetUpload({
//     Key? key,
//     this.label = '',
//     this.space = 15.0,
//     this.keyPath = 'file',
//     required this.onGetList,
//     required this.onGetTemplate,
//     required this.onUpload,
//     required this.onDelete,
//   }) : super(key: key);
//
//   @override
//   WidgetUploadState createState() => WidgetUploadState();
// }
//
// class WidgetUploadState extends State<WidgetUpload> {
//   bool isVideo = false;
//   bool isLoading = true;
//   List<dynamic> _imageFileList = [];
//   dynamic infoUpload;
//
//   bool showDelete = false;
//
//   @override
//   initState() {
//     getTemplate();
//     getData();
//     super.initState();
//   }
//
//   getData() async {
//     _imageFileList = await widget.onGetList();
//     isLoading = false;
//     setState(() {});
//   }
//
//   getTemplate() async {
//     infoUpload = (await widget.onGetTemplate())[0];
//     setState(() {});
//   }
//
//   final ImagePicker _picker = ImagePicker();
//
//   void _onImageButtonPressed(ImageSource source, {BuildContext? context, bool isMultiImage = false}) async {
//     if (isVideo) {
//       final XFile? file = await _picker.pickVideo(
//           source: source,
//           maxDuration: const Duration(seconds: 10)
//       );
//       print('pickVideo');
//       print(file!.path);
//     } else if (isMultiImage) {
//       final List<XFile>? pickedFileList = await _picker.pickMultiImage();
//       print('pickMultiImage');
//       // _imageFileList = pickedFileList;
//       if (pickedFileList != null) {
//         await showConfirmImage(context!, pickedFileList);
//       }
//       pickedFileList!.forEach((XFile element) {
//         print(element.path);
//       });
//     } else {
//       final XFile? pickedFile = await _picker.pickImage(source: source,);
//       // _imageFileList = [pickedFile];
//       if (pickedFile != null) {
//         await showConfirmImage(context!, [pickedFile]);
//       }
//       print('pickImage');
//       print(pickedFile!.path);
//     }
//   }
//
//   Future<void> showConfirmImage(BuildContext context,List<XFile?>? _imageFileList) async {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Confirm Upload', style: TextStyle( fontWeight: FontWeight.w700),).tr(),
//           content: Container(
//             height: 300.0,
//             width: 300.0,
//             child:  GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 5,
//                 mainAxisSpacing: 5,
//                 childAspectRatio: 1.15,
//               ),
//               scrollDirection: Axis.vertical,
//               shrinkWrap: true,
//               itemCount: _imageFileList!.length,
//               itemBuilder: (context, index) {
//                 return Image.file(File(_imageFileList[index]!.path));
//               },
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Upload', style: TextStyle( fontWeight: FontWeight.w700),),
//               onPressed: () async {
//                 isLoading = true;
//                 setState(() {});
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop();
//                 List<dynamic> linkImages = [];
//                 for(var item in _imageFileList) {
//                   final data = await ServiceCore.postUploadPhysicalBlob(context, item, {'destinationPhysicalPath': infoUpload['prefix']});
//                   linkImages.add({...infoUpload, 'file': data['physicalPath']});
//                 }
//                 await widget.onUpload(linkImages);
//                 await getData();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showModal(context) {
//     Future<void> future = showModalBottomSheet<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: Icon(Icons.photo),
//                 title: Text('Pick Image from gallery'.tr(),),
//                 onTap: () {
//                   isVideo = false;
//                   _onImageButtonPressed(
//                       ImageSource.gallery,
//                       context: context
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.photo_library),
//                 title: Text('Pick Multiple Image from gallery'.tr(),),
//                 onTap: () {
//                   isVideo = false;
//                   _onImageButtonPressed(
//                     ImageSource.gallery,
//                     context: context,
//                     isMultiImage: true,
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.camera_alt),
//                 title: Text('Take a Photo'.tr(),),
//                 onTap: () {
//                   isVideo = false;
//                   _onImageButtonPressed(
//                       ImageSource.camera,
//                       context: context
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.video_library),
//                 title: Text('Pick Video from gallery'.tr(),),
//                 onTap: () {
//                   isVideo = true;
//                   _onImageButtonPressed(ImageSource.gallery);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.videocam),
//                 title: Text('Take a Video'.tr(),),
//                 onTap: () {
//                   isVideo = true;
//                   _onImageButtonPressed(ImageSource.camera);
//                 },
//               ),
//             ],
//           ),);
//       },
//     );
//     future.then((void value) => print('modal closed'));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return isLoading == true ? WidgetSpin() : Container(
//       padding: EdgeInsets.symmetric(horizontal: 5.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               widget.label != '' ? Text(widget.label, style: TextStyle(
//                 color: Utils.hintColor,
//                 fontSize: 16,
//               ),) : Container(),
//               Row(
//                 children: [
//                   WidgetButton(
//                       onClick: () {
//                         showDelete = !showDelete;
//                         setState(() {});
//                       },
//                       transparent: true,
//                       height: 30,
//                       icon: Icon(Icons.delete, color: showDelete == false ? Colors.black : Colors.red, size: 25,)
//                   ),
//                   WidgetButton(
//                       onClick: () => _showModal(context),
//                       transparent: true,
//                       height: 30,
//                       icon: Icon(Icons.upload_file, color: Colors.black, size: 25,)
//                   ),
//                 ],
//               ),
//             ],
//           ),
//
//           GridView.builder(
//             physics: ScrollPhysics(),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 5,
//               mainAxisSpacing: 5,
//               childAspectRatio: 1.15,
//             ),
//             scrollDirection: Axis.vertical,
//             shrinkWrap: true,
//             itemCount: _imageFileList.length,
//             itemBuilder: (context, index) {
//               return Container(
//                 color: Colors.black,
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   alignment: AlignmentDirectional.center,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 8.0),
//                       child: WidgetFullScreen(
//                         url: _imageFileList[index][widget.keyPath],
//                       ),
//                     ),
//                     showDelete == true ? Positioned(
//                       right: 5,
//                       top: 5,
//                       width: 25,
//                       height: 25,
//                       child: InkWell(
//                         onTap: () async {
//                           isLoading = true;
//                           setState(() {});
//                           await widget.onDelete(_imageFileList[index]);
//                           await getData();
//                         },
//                         child: Container(
//                           padding: EdgeInsets.all(2.0),
//                           decoration: BoxDecoration(
//                             color: Colors.red.withOpacity(0.8),
//                             borderRadius: BorderRadius.all(Radius.circular(18.0)),
//                           ),
//                           child: Wrap(
//                             alignment: WrapAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.close,
//                                 color: Colors.white,
//                                 size: 20.0,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ) : Container(),
//                   ],
//                 ),
//               );
//             },
//           ),
//           SizedBox(height: widget.space),
//         ],
//       ),
//     );
//   }
// }
