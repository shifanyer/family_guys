import 'dart:io';

import 'package:family_guys/buttons/menu_button.dart';
import 'package:family_guys/db_methods/db_main_methods.dart';
import 'package:family_guys/db_methods/fire_storages/fire_storage_service.dart';
import 'package:family_guys/info_objects/connection_types.dart';
import 'package:family_guys/info_objects/person_info.dart';
import 'package:family_guys/my_icons.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'select_list.dart';

class FullPersonCard extends StatefulWidget {
  final PersonInfo personInfo;
  final ImageProvider avatar;

  const FullPersonCard({Key? key, required this.personInfo, required this.avatar}) : super(key: key);

  @override
  _FullPersonCardState createState() => _FullPersonCardState();
}

class _FullPersonCardState extends State<FullPersonCard> {

  Future<Image> getImage(BuildContext context, List<String> imagePath) async {
    late Image m;
    await FireStorageService.loadFromStorage(context, imagePath).then((downloadUrl) {
      m = Image.network(
        downloadUrl.toString(),
        fit: BoxFit.scaleDown,
      );
    });

    return m;
  }

  Future<List<Image>> getImagesList({required BuildContext context, required String personId}) async {
    var imageIdList = await DbMainMethods.downloadPersonImagesIdList(personId);
    var imagesList = <Image>[];
    print('imageIdList: ${imageIdList}');
    for (var imageId in imageIdList) {
      var path = [personId, imageId];
      print('imagePath: ${path}');
      var img = await getImage(context, path);
      if (img!=null) {
        imagesList.add(img);
      }
    }
    return imagesList;
  }

  @override
  Widget build(BuildContext context) {
    var relativesButtonHeight = 170.0;
    // var image = '0917f0e1f3493166ff7ad5593898fee1c316846c-1609576653.webp';
    var image = 'sticker.png';
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.8,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image(
                image: widget.avatar,
                fit: BoxFit.cover,
              ),
              title: Text(widget.personInfo.nameDisplay()),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.black12,
              width: MediaQuery.of(context).size.width / 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 20.0, 0.0, 20.0),
                child: Text(
                  'Годы жизни: '
                          '${widget.personInfo.birthDate?.displayDate() ?? '??????'}' +
                      ' - ' +
                      '${widget.personInfo.deathDate?.displayDate() ?? '??????'}',
                  style: TextStyle(color: Colors.black87, fontSize: 16, decoration: TextDecoration.none),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<List<Image>>(
              future: getImagesList(context: context, personId: widget.personInfo.id ?? ''),
              builder: (context, snapshot) {
                var galleryItems = <Image>[];
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length == 0) return Container();
                    galleryItems.addAll((snapshot.data)!);
                    return Container(
                        color: Colors.white10,
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: PhotoViewGallery.builder(
                          scrollPhysics: const BouncingScrollPhysics(),
                          builder: (BuildContext context, int index) {
                            return PhotoViewGalleryPageOptions(
                              imageProvider: (galleryItems[index].image),
                              // AssetImage(galleryItems[index].image),
                              initialScale: PhotoViewComputedScale.contained * 1,
                              heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index].hashCode),
                            );
                          },
                          itemCount: galleryItems.length,
                          loadingBuilder: (context, event) => Center(
                            child: Container(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                value: event == null
                                    ? 0
                                    : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? event.cumulativeBytesLoaded * 1000),
                              ),
                            ),
                          ),
                          backgroundDecoration:
                              BoxDecoration(color: Colors.white, border: Border(top: BorderSide(width: 3), bottom: BorderSide(width: 3))),
                          /*
                        pageController: widget.pageController,
                        onPageChanged: onPageChanged,

                         */
                        ));
                  }
                }
                // return Padding(
                //   padding: const EdgeInsets.all(32.0),
                //   child: snapshot.data,
                // );

                if (snapshot.connectionState == ConnectionState.waiting) return Container(width: 10, child: LinearProgressIndicator());

                return Container();
              },
            ),
          ),
          SliverToBoxAdapter(
            child: CircleButton(
              icon: Icons.image,
              onClick: () async {
                await pickImageFromDevice(widget.personInfo.id!);
              Fluttertoast.showToast(
                  msg: 'Изображение добавлено',
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.green,
                  textColor: Colors.black87,
                  fontSize: 16.0
              );
                setState(() {

                });
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Row(
              children: [
                GestureDetector(
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width / 4,
                    // height: relativesButtonHeight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            child: GestureDetector(
                              onTap: () {
                                return bottomShowConnections(
                                    DbMainMethods.loadConnectionsByType(widget.personInfo.id!, 'parents'), 'У этого человека не найдено родителей');
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    child: Icon(
                                      CustomIcons.parents,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Родители', style: TextStyle(color: Colors.black87, fontSize: 16, decoration: TextDecoration.none)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 1, top: 10),
                            child: Card(
                              child: CircleButton(
                                  width: MediaQuery.of(context).size.width / 5,
                                  color: Colors.white,
                                  icon: Icons.add,
                                  onClick: () {
                                    Fluttertoast.showToast(
                                        msg: 'Дважды тапните на карточку, чтобы создать связь',
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 5,
                                        backgroundColor: Colors.black12,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                    return bottomAddConnection(widget.personInfo, ConnectionType.children_parents);
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width / 4,
                    // height: relativesButtonHeight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            child: GestureDetector(
                              onTap: () {
                                return bottomShowConnections(
                                    DbMainMethods.loadConnectionsByType(widget.personInfo.id!, 'children'), 'У этого человека не найдено детей');
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    child: Icon(
                                      Icons.child_care,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Дети', style: TextStyle(color: Colors.black87, fontSize: 16, decoration: TextDecoration.none)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 1, top: 10),
                            child: Card(
                              child: CircleButton(
                                  width: MediaQuery.of(context).size.width / 5,
                                  color: Colors.white,
                                  icon: Icons.add,
                                  onClick: () {
                                    Fluttertoast.showToast(
                                        msg: 'Дважды тапните на карточку, чтобы создать связь',
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 5,
                                        backgroundColor: Colors.black12,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                    return bottomAddConnection(widget.personInfo, ConnectionType.parents_children);
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width / 4,
                    // height: relativesButtonHeight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            child: GestureDetector(
                              onTap: () {
                                return bottomShowConnections(
                                    DbMainMethods.loadConnectionsByType(widget.personInfo.id!, 'spouses'), 'У этого человека не найдено супругов');
                              },
                              child: Column(
                                children: [
                                  Container(
                                      height: 30,
                                      child: Icon(
                                        CustomIcons.marriage,
                                        size: 30,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Супруги', style: TextStyle(color: Colors.black87, fontSize: 16, decoration: TextDecoration.none)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 1, top: 10),
                            child: Card(
                              child: CircleButton(
                                  width: MediaQuery.of(context).size.width / 5,
                                  color: Colors.white,
                                  icon: Icons.add,
                                  onClick: () {
                                    Fluttertoast.showToast(
                                        msg: 'Дважды тапните на карточку, чтобы создать связь',
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 5,
                                        backgroundColor: Colors.black12,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                    return bottomAddConnection(widget.personInfo, ConnectionType.spouses_spouses);
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width / 4,
                    // height: relativesButtonHeight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            child: GestureDetector(
                              onTap: () {
                                return bottomShowConnections(
                                    DbMainMethods.loadConnectionsByType(widget.personInfo.id!, 'friends'), 'У этого человека не найдено друзей');
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    child: Icon(
                                      Icons.clean_hands_rounded,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Друзья', style: TextStyle(color: Colors.black87, fontSize: 16, decoration: TextDecoration.none)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 1, top: 10),
                            child: Card(
                              child: CircleButton(
                                  width: MediaQuery.of(context).size.width / 5,
                                  color: Colors.white,
                                  icon: Icons.add,
                                  onClick: () {
                                    Fluttertoast.showToast(
                                        msg: 'Дважды тапните на карточку, чтобы создать связь',
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 5,
                                        backgroundColor: Colors.black12,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                    return bottomAddConnection(widget.personInfo, ConnectionType.friends_friends);
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.grey,
              width: 10,
              height: 60,
            ),
          ),
          /*
          SliverToBoxAdapter(
            child: Container(
              color: Colors.redAccent,
              width: 10,
              height: 60,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.yellowAccent,
              width: 10,
              height: 60,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.grey,
              width: 10,
              height: 60,
            ),
          ),

           */
        ],
      ),
    );
  }

  bottomAddConnection(PersonInfo firstPersonInfo, ConnectionType connectionType) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return FutureBuilder<List<PersonInfo>>(
            future: DbMainMethods.loadAllPersons(),
            builder: (context, childrenSnapshot) {
              if (childrenSnapshot.hasData) {
                return SelectPerson(
                  persons: childrenSnapshot.data ?? [],
                  isLoading: !childrenSnapshot.hasData,
                  noItemsMessage: 'У Вас нет других людей',
                  makeConnectionWithPerson: firstPersonInfo,
                  connectionType: connectionType,
                );
              } else {
                return LinearProgressIndicator();
              }
            });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      isScrollControlled: false,
      isDismissible: true,
    );
  }

  bottomShowConnections(Future<List<PersonInfo>> future, String noItemsMessage) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FutureBuilder<List<PersonInfo>>(
            future: future,
            builder: (context, childrenSnapshot) {
              if (childrenSnapshot.hasData) {
                return SelectPerson(
                  persons: childrenSnapshot.data ?? [],
                  isLoading: !childrenSnapshot.hasData,
                  noItemsMessage: noItemsMessage,
                );
              } else {
                return LinearProgressIndicator();
              }
            });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      isScrollControlled: false,
      isDismissible: true,
    );
  }

  Future<void> pickImageFromDevice(String personId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    File imageFile = File(pickedFile!.path);
    await uploadImageToFirebase(imageFile, personId);
  }

  uploadImageToFirebase(File image, String personId) async {
    String basename(String filePath) {
      var pathList = filePath.split('/');
      print('pathList: ${pathList}');
      var res = pathList.last;
      return res;
    }
    // var fileName = basename(image.path);
    var fileName= await DbMainMethods.addImageToPerson(personId);
    var firebaseStorageRef = FirebaseStorage.instance.ref().child(personId+'/'+fileName);
    await firebaseStorageRef.putFile(image);
    // var taskSnapshot = await uploadTask;
    
  }

}
