import 'package:family_guys/db_methods/db_main_methods.dart';
import 'package:family_guys/db_methods/fire_storages/fire_storage_service.dart';
import 'package:family_guys/info_objects/person_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullPersonCard extends StatefulWidget {
  final PersonInfo personInfo;

  const FullPersonCard({Key? key, required this.personInfo}) : super(key: key);

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
    for (var imageId in imageIdList) {
      var path = [personId, imageId];
      var img = await getImage(context, path);
      imagesList.add(img);
    }
    return imagesList;
  }

  @override
  Widget build(BuildContext context) {
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
                    if (snapshot.data!.length == 0)
                      return Container();
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
        ],
      ),
    );
  }
}
