import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallcraft/data/data.dart';
import 'package:wallcraft/model/wallpaper_model.dart';
import 'package:wallcraft/views/Favorites.dart';
import 'package:wallcraft/views/category.dart';
import 'package:wallcraft/views/search.dart';
import 'package:wallcraft/widgets/widget.dart';

import '../model/categories_model.dart';
import 'package:http/http.dart' as http;
import 'Search_splash.dart';
import 'image_view.dart';
import 'my_drawer_header.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var currentPage = DrawerSections.Home;

  List<CategoriesModel> categories = [];
  List<WallpaperModel> wallpapers = [];

  // ScrollController _scrollController = new ScrollController();

  TextEditingController searchController = new TextEditingController();

  getTrendingWallpapers() async {
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/curated?per_page=50&page=4"),
        headers: {"Authorization": apiKey});

    // print(response.body.toString());

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      // print(element);
      SrcModel srcModel = new SrcModel();
      WallpaperModel wallpaperModel = new WallpaperModel(src: srcModel);
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpaperModel.avg_color = element["avg_color"];
      wallpapers.add(wallpaperModel);
    });

    setState(() {});
  }

  @override
  void initState() {
    getTrendingWallpapers();
    categories = getCategories();
    super.initState();

    // _scrollController.addListener(() {
    //   print(_scrollController.position.pixels);
    //   if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
    //     getTrendingWallpapers();
    //     print("max scroll");
    //   }
    // });
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {

    //new added:


    // var container;
    // if (currentPage == DrawerSections.Home) {
    //   container = DashboardPage();
    // } else if (currentPage == DrawerSections.Favourites) {
    //   container = ContactsPage();
    // } else if (currentPage == DrawerSections.MyWallpapers) {
    //   container = EventsPage();
    // } else if (currentPage == DrawerSections.Contacts) {
    //   container = NotesPage();
    // }
    // else if (currentPage == DrawerSections.settings) {
    //   container = SettingsPage();
    // } else if (currentPage == DrawerSections.notifications) {
    //   container = NotificationsPage();
    // } else if (currentPage == DrawerSections.privacy_policy) {
    //   container = PrivacyPolicyPage();
    // } else if (currentPage == DrawerSections.send_feedback) {
    //   container = SendFeedbackPage();
    // }


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: brandName(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.blue,),
      ),


      //drawer :

      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),




      body: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xfff5f8fd),
                borderRadius: BorderRadius.circular(20),
                border: Border(),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24),
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        // focusedBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(color: Colors.black),
                        //   borderRadius: BorderRadius.circular(24),
                        // ),s

                        hintText: "search wallpaper",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              // builder: (contextr) => Search(
                              //       searchQuery: searchController.text,
                              //     )));
                              builder: (contextr) => SearchSplash(
                                    text: searchController.text,
                                  )));
                    },
                    child: Container(child: Icon(Icons.search)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 80,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24),
                itemCount: categories.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CategoriesTile(
                    title: categories[index].categoriesName,
                    imgUrl: categories[index].imgUrl,
                  );
                },
              ),
            ),
            SizedBox(
              height: 16,
            ),
            // Container(
            //   height: MediaQuery.of(context).size.height,
            //   child: ListView.builder(
            //     // padding: EdgeInsets.symmetric(horizontal: 24),
            //     controller: _scrollController,
            //     itemCount: wallpapers.length,
            //     shrinkWrap: true,
            //     scrollDirection: Axis.vertical,
            //     itemBuilder: (context, index) {
            //       return WallpapersList(wallpapers: wallpapers, context: context);
            //     },
            //   ),
            // ),
            WallpapersList(wallpapers: wallpapers, context: context),
            SizedBox(
              height: 16,
            ),
          ]),
        ),
      ),

      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed, // Fixed
      //   backgroundColor: Colors.blue, // <-- This works for fixed
      //   selectedItemColor: Colors.greenAccent,
      //   unselectedItemColor: Colors.white,
      //   onTap: (value) {
      //     // Respond to item press.
      //     setState(() => _currentIndex = value);
      //
      //   },
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.menu),
      //       label: 'menu',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.favorite),
      //       label: 'favourite',
      //
      //     ),
      //
      //   ],
      // ),
      // floatingActionButton:
      // FloatingActionButton(child: Icon(Icons.add,), onPressed: () {}),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  //new data added::


  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, "Home", Icons.home,
              currentPage == DrawerSections.Home ? true : false),
          menuItem(2, "Favorites", Icons.favorite,
              currentPage == DrawerSections.Favourites ? true : false),
          menuItem(3, "My Wallpapers", Icons.image,
              currentPage == DrawerSections.MyWallpapers ? true : false),
          Divider(),
          menuItem(4, "Contacts", Icons.people_alt_outlined,
              currentPage == DrawerSections.Contacts ? true : false),
          menuItem(5, "About Us", Icons.info,
              currentPage == DrawerSections.aboutUs ? true : false),
          Divider(),
          menuItem(6, "Privacy policy", Icons.privacy_tip_outlined,
              currentPage == DrawerSections.privacy_policy ? true : false),
          menuItem(7, "Send feedback", Icons.feedback_outlined,
              currentPage == DrawerSections.send_feedback ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.Home;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Home()),
              );
            } else if (id == 2) {
              currentPage = DrawerSections.Favourites;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Favorites()),
              );
            } else if (id == 3) {
              currentPage = DrawerSections.MyWallpapers;
            } else if (id == 4) {
              currentPage = DrawerSections.Contacts;
            } else if (id == 5) {
              currentPage = DrawerSections.aboutUs;
            } else if (id == 6) {
              currentPage = DrawerSections.privacy_policy;
            } else if (id == 7) {
              currentPage = DrawerSections.send_feedback;
            }
          });

        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.blue,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
enum DrawerSections {
  Home,
  Favourites,
  MyWallpapers,
  Contacts,
  aboutUs,
  privacy_policy,
  send_feedback,
}

class CategoriesTile extends StatelessWidget {
  late String imgUrl, title;
  CategoriesTile({this.title = "", this.imgUrl = ""});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Categorie(
                      categorieName: title.toLowerCase(),
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 4),
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imgUrl,
                  height: 50,
                  width: 100,
                  fit: BoxFit.cover,
                )),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              height: 50,
              width: 100,
//we reached at 47 minutes
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//drawerlist code:























