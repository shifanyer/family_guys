import 'package:family_guys/db_methods/fire_storages/fire_storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullPersonCard extends StatefulWidget {
  @override
  _FullPersonCardState createState() => _FullPersonCardState();
}

class _FullPersonCardState extends State<FullPersonCard> {
  Future<Widget> getImage(BuildContext context, String image) async {
    late Image m;
    await FireStorageService.loadFromStorage(context, image).then((downloadUrl) {
      m = Image.network(
        downloadUrl.toString(),
        fit: BoxFit.scaleDown,
      );
    });

    return m;
  }

  @override
  Widget build(BuildContext context) {
    var image = '0917f0e1f3493166ff7ad5593898fee1c316846c-1609576653.webp';
    return Card(
      child: FutureBuilder<Widget>(
        future: getImage(context, image),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: snapshot.data,
            );

          if (snapshot.connectionState == ConnectionState.waiting)
            return Container(
                child: CircularProgressIndicator());

          return Container();
        },
      ),
    );
  }
}
