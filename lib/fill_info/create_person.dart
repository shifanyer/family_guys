import 'dart:io';
import 'dart:typed_data';

import 'package:family_guys/db_methods/db_main_methods.dart';
import 'package:family_guys/info_objects/date.dart';
import 'package:family_guys/info_objects/person_info.dart';
import 'package:family_guys/person_card/person_card.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../card_page.dart';
import 'date_choose.dart';

class Animal {
  final int id;
  final String name;

  Animal({
    required this.id,
    required this.name,
  });
}

class SelectPage extends StatefulWidget {
  SelectPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  static List<Animal> _animals = [
    Animal(id: 1, name: "Lion"),
    Animal(id: 2, name: "Flamingo"),
    Animal(id: 3, name: "Hippo"),
    Animal(id: 4, name: "Horse"),
    Animal(id: 5, name: "Tiger"),
    Animal(id: 6, name: "Penguin"),
    Animal(id: 7, name: "Spider"),
    Animal(id: 8, name: "Snake"),
    Animal(id: 9, name: "Bear"),
    Animal(id: 10, name: "Beaver"),
    Animal(id: 11, name: "Cat"),
    Animal(id: 12, name: "Fish"),
    Animal(id: 13, name: "Rabbit"),
    Animal(id: 14, name: "Mouse"),
    Animal(id: 15, name: "Dog"),
    Animal(id: 16, name: "Zebra"),
    Animal(id: 17, name: "Cow"),
    Animal(id: 18, name: "Frog"),
    Animal(id: 19, name: "Blue Jay"),
    Animal(id: 20, name: "Moose"),
    Animal(id: 21, name: "Gecko"),
    Animal(id: 22, name: "Kangaroo"),
    Animal(id: 23, name: "Shark"),
    Animal(id: 24, name: "Crocodile"),
    Animal(id: 25, name: "Owl"),
    Animal(id: 26, name: "Dragonfly"),
    Animal(id: 27, name: "Dolphin"),
  ];
  final _items = _animals.map((animal) => MultiSelectItem<Animal>(animal, animal.name)).toList();

  List _selectedAnimals = [];
  List _selectedAnimals2 = [];
  List _selectedAnimals3 = [];

  List _selectedAnimals4 = [];
  List _selectedAnimals5 = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController patronymicController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController deathDateController = TextEditingController();
  PickerDateRange datesRange = PickerDateRange(DateTime.now(), DateTime.now());
  bool isUpload = false;
  late List<Image> photosList;
  late List<File> photosFileList;
  Image? avatar;
  File? avatarFile;

  @override
  void initState() {
    photosList = [];
    photosFileList = [];
    // _selectedAnimals5 = _animals;
    // nameController =        TextEditingController();
    // patronymicController =  TextEditingController();
    // surnameController =     TextEditingController();
    // birthDateController =   TextEditingController();
    // deathDateController =   TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: surnameController,
                    decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Фамилия', hintText: 'Введите фамилию'),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Имя', hintText: 'Введите имя'),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: patronymicController,
                    decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Отчество', hintText: 'Введите Отчество'),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: birthDateController,
                    onTap: () async {
                      await Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => ChooseDate(
                                    datesRange: (newTime) {
                                      datesRange = newTime;
                                    },
                                  )));
                      setState(() {
                        birthDateController.text = humanReadable(datesRange);
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Годы жизни',
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Фото'),
                ),
              ),
              Container(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var img in photosList)
                      Container(
                        width: 80,
                        height: 80,
                        child: img,
                      ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () async {
                        var newImgFile = (await pickImageFromDevice());
                        photosList.add(Image.file(newImgFile));
                        photosFileList.add((newImgFile));
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Аватар'),
                ),
              ),
              Container(
                height: 100,
                child: Row(
                  children: [
                    if (avatar != null)
                      Container(
                        width: 80,
                        height: 80,
                        child: avatar,
                      ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () async {
                        var newImgFile = (await pickImageFromDevice());
                        avatar = (Image.file(newImgFile));
                        avatarFile = newImgFile;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              /*
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(.4),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    MultiSelectBottomSheetField(
                      initialChildSize: 0.4,
                      listType: MultiSelectListType.CHIP,
                      searchable: true,
                      buttonText: Text("Favorite Animals"),
                      title: Text("Animals"),
                      items: _items,
                      onConfirm: (values) {
                        _selectedAnimals2 = [];
                        for (var animal in values) {
                          print('animal.runtimeType.toString(): ${animal.runtimeType.toString()}');
                          if (animal.runtimeType.toString() == 'Animal') {
                            _selectedAnimals2.add(animal as Animal);
                          }
                        }
                        // _selectedAnimals2 = (values as List<Animal>);
                      },
                      chipDisplay: MultiSelectChipDisplay(
                        onTap: (value) {
                          setState(() {
                            _selectedAnimals2.remove(value);
                          });
                        },
                      ),
                    ),
                    _selectedAnimals2 == null || _selectedAnimals2.isEmpty
                        ? Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "None selected",
                              style: TextStyle(color: Colors.black54),
                            ))
                        : Container(),
                  ],
                ),
              ),
              */
              /*
              MultiSelectDialogField(
                onConfirm: (val) {
                  _selectedAnimals5 = [];
                  for (var animal in val) {
                    print('animal.runtimeType.toString(): ${animal.runtimeType.toString()}');
                    if (animal.runtimeType.toString() == 'Animal') {
                      _selectedAnimals5.add(animal as Animal);
                    }
                  }
                  // _selectedAnimals5 = (val as List<Animal>);
                },
                items: _items,
                initialValue: _selectedAnimals5, // setting the value of this in initState() to pre-select values.
              ),
              */
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            isUpload = true;
          });
          var personInfo = toPersonInfo();
          var personId = await DbMainMethods.uploadPerson(personInfo, avatarFile!, photosFileList);
          personInfo.id = personId;
          Navigator.pop(context);
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => CardPage(
                        personInfo: personInfo,
                      )));
        },
        child: isUpload
            ? CircularProgressIndicator(
                backgroundColor: Colors.white,
              )
            : Text('ADD'),
      ),
    );
  }

  humanReadable(PickerDateRange dates) {
    return "${dates.startDate?.day ?? '?'}.${dates.startDate?.month ?? '?'}.${dates.startDate?.year ?? '?'}" +
        " - " +
        "${dates.endDate?.day ?? '?'}.${dates.endDate?.month ?? '?'}.${dates.endDate?.year ?? '?'}";
  }

  DateInfo makeDateInfo(DateTime? date) {
    return DateInfo(day: date?.day ?? 666999, month: date?.month ?? 666999, year: date?.year ?? 666999);
  }

  PersonInfo toPersonInfo() {
    var personInfo = PersonInfo(
        name: nameController.text,
        surname: surnameController.text,
        patronymic: patronymicController.text,
        birthDate: makeDateInfo(datesRange.startDate),
        deathDate: makeDateInfo(datesRange.endDate));
    return personInfo;
  }

  Future<File> pickImageFromDevice() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    // print(pickedFile.runtimeType);
    File imageFile = File(pickedFile!.path);
    return imageFile;
    // await uploadImageToFirebase(imageFile, personId);
  }

}
