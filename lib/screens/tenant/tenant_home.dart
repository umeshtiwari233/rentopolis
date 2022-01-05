import 'package:cached_network_image/cached_network_image.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:rentopolis/config/configuration.dart';
import 'package:rentopolis/controllers/auth_controller.dart';
import 'package:rentopolis/controllers/data_controller.dart';
import 'package:rentopolis/controllers/internet_controller.dart';
import 'package:rentopolis/screens/no_internet/no_internet.dart';
import 'package:rentopolis/screens/tenant/tenant_drawer.dart';
import 'package:rentopolis/screens/tenant/tenant_home_details.dart';
import 'package:rentopolis/widgets/custom_chipper.dart';
import 'package:rentopolis/widgets/house_row_rent.dart';
import 'package:svg_icon/svg_icon.dart';

class TenantHome extends StatelessWidget {
  const TenantHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InternetController _internetController =
        Get.put(InternetController());
    return Scaffold(
      // body: Obx(()=>_internetController.current==_internetController.noInternet?NoInternet():LoginScreen()),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Press back again to Exit'),
        ),
        child: GetBuilder<InternetController>(
          builder: (builder) => (_internetController.connectionType == 0.obs)
              ? const NoInternet()
              : ZoomDrawer(
                  style: DrawerStyle.Style2,
                  mainScreen: TenantHomeScreen(),
                  menuScreen: TenantDrawerScreen(),
                  showShadow: true,
                ),
        ),
      ),
    );
  }
}

class TenantHomeScreen extends StatelessWidget {
  TenantHomeScreen({Key? key}) : super(key: key);
  AuthController authController = Get.put(AuthController());

  final DataController dataController = Get.put(DataController());
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      dataController.getUplodedHouses();
    });
    var _size = MediaQuery.of(context).size;
    return Container(
      height: _size.height,
      width: _size.width,
      color: primaryWhite,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: _size.height * .01,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed: () {
                ZoomDrawer.of(context)!.toggle();
              },
              icon: const SvgIcon('assets/icons/menu.svg')),
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Text('Hello ${authController.userData['name']}',
                  style: mainFont(fontSize: 20, color: primaryBlack)),
            )),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
            child: Text(
              'Find your sweet home',
              style: mainFont(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        GetBuilder<DataController>(
          builder: (controller) => controller.totalData.isEmpty
              ? const Center(
                  child: const Text('😔 NO DATA FOUND 😔'),
                )
              : Expanded(
                  child: ListView.builder(
                      itemCount: dataController.totalData.length,
                      itemBuilder: (context, index) {
                        return Column(children: [
                          HouseContainer(
                            size: _size,
                            images: dataController.totalData[index].images,
                            name: dataController.totalData[index].name,
                            rent:
                                dataController.totalData[index].rent.toString(),
                            bedroom: dataController.totalData[index].bedroom
                                .toString(),
                            bathroom: dataController.totalData[index].bathroom
                                .toString(),
                            sqft:
                                dataController.totalData[index].area.toString(),
                            about: dataController.totalData[index].about,
                            address: dataController.totalData[index].address,
                            houseid: dataController.totalData[index].houseid
                                .toString(),
                            uid: dataController.totalData[index].uid,
                            latilong: dataController.totalData[index].latilong,
                          ),
                          // HouseContainer(
                          //     size: _size,
                          //     images: dataController.totalData[index].images,
                          //     name: dataController.totalData[index].name,
                          //     rent:
                          //         dataController.totalData[index].rent.toString(),
                          //     bedroom: dataController.totalData[index].bedroom
                          //         .toString(),
                          //     bathroom: dataController.totalData[index].bathroom
                          //         .toString(),
                          //     sqft:
                          //         dataController.totalData[index].area.toString(),
                          //     about: dataController.totalData[index].about,
                          //     address: dataController.totalData[index].address,
                          //     houseid: dataController.totalData[index].houseid,
                          //     uid: dataController.totalData[index].uid),
                        ]);
                      }),
                ),
        ),
      ]),
    );
  }
}

class HouseContainer extends StatelessWidget {
  HouseContainer(
      {Key? key,
      required Size size,
      required var images,
      required var name,
      required var rent,
      required var bedroom,
      required var bathroom,
      required var sqft,
      required var about,
      required var address,
      required var houseid,
      required var uid,
      required var latilong})
      : _size = size,
        _images = images,
        _name = name,
        _rent = rent,
        _bedroom = bedroom,
        _bathroom = bathroom,
        _sqft = sqft,
        _about = about,
        _address = address,
        _houseid = houseid,
        _uid = uid,
        _latilong = latilong,
        super(key: key);

  final Size _size;
  final List<dynamic> _images, _latilong;
  final _houseid;
  final _name, _rent, _bedroom, _bathroom, _sqft, _about, _address, _uid;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: primaryWhite,
            borderRadius: BorderRadius.circular(20.0),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              const BoxShadow(
                  color: grey, blurRadius: 2.0, offset: const Offset(2.0, 2.0))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              child: CachedNetworkImage(
                imageUrl: _images[0],
                height: _size.height * .4,
                width: double.infinity,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            HouseRowRent(
              name: _name,
              rent: _rent,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomChipper(
                  size: _size,
                  icon: const Icon(
                    Icons.bed,
                    size: 20,
                    color: teal,
                  ),
                  text: _bedroom,
                ),
                CustomChipper(
                  size: _size,
                  icon: const Icon(
                    Icons.bathtub,
                    size: 20,
                    color: teal,
                  ),
                  text: _bathroom,
                ),
                CustomChipper(
                  size: _size,
                  icon: const Icon(
                    Icons.height,
                    size: 20,
                    color: teal,
                  ),
                  text: _sqft,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Get.to(const TenantHomeDetails(), arguments: [
                    _about, //0
                    _address, //1
                    _sqft, //2
                    _bathroom, //3
                    _bedroom, //4
                    _houseid, //5
                    _images, //6
                    _name, //7
                    _rent, //8
                    _uid, //9
                    _latilong //10
                  ]);
                },
                // child: Text('${_houseid}'),
                child: const Text('View the house'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
