import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';

import 'package:radiostring/blocs/station_bloc.dart';
import 'package:radiostring/models/country.dart';
import 'all_channels.dart';
import 'favourite_channels.dart';

class Home extends StatefulWidget {
  Home();

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = new TextEditingController();
  var screenSize;
  String channelType = 'all';
  bool _isSearching = false;

  List<Country> _countries= [] ;

  @override
  void initState() {
    checkInternet();
    super.initState();
  }

  checkInternet() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // await stationsBloc.getFavourites();
      stationsBloc.getCountries();
      // stationsBloc.getStations();
    } else {
      showNoInternet(context, 'No internet connection!');
    }
  }

  void showNoInternet(BuildContext context, String error_content) {
    Flushbar(
      messageText: Text(error_content,
        style: TextStyle(
          fontFamily: 'Jost-Regular',
          color: Colors.white
        )
      ),
      isDismissible: false,
      mainButton: FlatButton(
        child: Text(
          'TRY AGAIN',
          style: TextStyle(color: Theme.of(context).accentColor,
          fontFamily: 'Jost-Medium'),
        ),
        onPressed: () {
          Navigator.of(context).pop(true);
          checkInternet();
        },
      ),
      duration: Duration(minutes: 1),
    )..show(context);
  }

  @override
  void dispose() {
    stationsBloc.dispose();
    super.dispose();
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
  }

  Widget _builsAppBar() {
    return Container(
      padding: EdgeInsets.only(top: screenSize.height * 0.05, bottom: screenSize.height * 0.02),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        _scaffoldKey.currentState.openDrawer();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: screenSize.width / 20),
                        child: Image.asset('assets/images/sidebar.png',
                        width: screenSize.width / 22)
                      ),
                    ),
                    Container(
                      child: Text('Radio String',
                      style: TextStyle(
                        fontFamily: 'Jost-Medium',
                        fontSize: screenSize.width / 22
                      ),),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: !_isSearching ? SvgPicture.asset('assets/images/search.svg',
                  width: screenSize.width / 15):
                  Icon(Icons.close, color: Color.fromRGBO(203, 203, 203, 1))
                ),
              )
            ],
          ),
          _isSearching ? Container(
            margin: EdgeInsets.only(top: 5.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              color: Color.fromRGBO(243, 243, 244, 1),
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      height: screenSize.height * 0.06,
                      child: TextFormField(
                        autofocus: true,
                        cursorColor: Colors.black,
                        controller: _searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search by Name',
                          hintStyle: TextStyle(
                            fontFamily: 'Jost-Regular'
                          ),
                        ),
                        onChanged: (val){
                          
                        },
                      ),
                    )
                  ),
                  Container(
                    width: screenSize.width * 0.10,
                    height: screenSize.height * 0.06,
                    color: Theme.of(context).buttonColor,
                    child: SvgPicture.asset('assets/images/search.svg',
                    fit: BoxFit.none,
                    color: Colors.white),
                  )
                ],
              ),
            )
          ): Container()
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: screenSize.height * 0.06,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide( 
            color: Color.fromRGBO(203, 203, 203, 1)
          ),
          top: BorderSide(  
            color: Color.fromRGBO(203, 203, 203, 1)
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              setState(() {
                channelType = 'all';
              });
            },
            child: Container(
              height: screenSize.height * 0.06,
              color: channelType == 'all' ? Theme.of(context).highlightColor: Colors.white,
              width: screenSize.width * 0.43,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 5.0),
                    child: Image.asset('assets/images/squares.png',
                    width: screenSize.width / 35,
                    color: channelType == 'all' ? Colors.white: Colors.black)
                  ),
                  Text('All Channels',
                  style: TextStyle(
                    color: channelType == 'all' ? Colors.white: Colors.black,
                    fontFamily: 'Jost-Regular',
                    fontSize: screenSize.width / 25
                  ),)
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                channelType = 'favourites';
              });
            },
            child: Container(
              height: screenSize.height * 0.06,
              width: screenSize.width * 0.43,
              decoration: BoxDecoration(
                color: channelType == 'favourites' ? Theme.of(context).highlightColor: Colors.white,
                border: Border(
                  left: BorderSide( 
                    color: Color.fromRGBO(203, 203, 203, 1)
                  ),
                  right: BorderSide(  
                    color: Color.fromRGBO(203, 203, 203, 1)
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 5.0),
                    child: Image.asset('assets/images/favourite.png',
                    width: screenSize.width / 30,
                    color: channelType == 'favourites' ? Colors.white: Colors.black)
                  ),
                  Text('Favourite Stations',
                  style: TextStyle(
                    color: channelType == 'favourites' ? Colors.white: Colors.black,
                    fontFamily: 'Jost-Regular',
                    fontSize: screenSize.width / 25
                  ),)
                ],
              ),
            ),
          ),
          Container(
            width: screenSize.width * 0.14,
            child: GestureDetector(
              onTap: _openEndDrawer,
              child: SvgPicture.asset('assets/images/filters.svg',
                width: screenSize.width / 22,
                color: Colors.black
              ),
            )
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, AsyncSnapshot<StationsBloc> snapshot) {
    return Container(
      child: channelType == 'all' ?
        AllChannels(snapshot): FavouriteChannels(snapshot),
    );
  }

  Widget _buildSideMenu(context, AsyncSnapshot<StationsBloc> snapshot) {
    return Container(
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(top: screenSize.height * 0.05),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: screenSize.height * 0.06,
              child: ListTile(
                title: Text('Home',
                style: TextStyle(
                  fontFamily: 'Jost-Medium'
                )),
                onTap: () => {},
              ),
            ),
            Container(
              height: screenSize.height * 0.06,
              child: ListTile(
                title: Text('About Us',
                style: TextStyle(
                  fontFamily: 'Jost-Medium'
                )),
                onTap: () => {},
              ),
            ),
            Container(
              height: screenSize.height * 0.06,
              child: ListTile(
                title: Text('Privacy Policy',
                style: TextStyle(
                  fontFamily: 'Jost-Medium'
                )),
                onTap: () => {},
              ),
            ),
            Container(
              height: screenSize.height * 0.06,
              child: ListTile(
                title: Text('Terms & Conditions',
                style: TextStyle(
                  fontFamily: 'Jost-Medium'
                )),
                onTap: () => {},
              ),
            ),
            Container(
              height: screenSize.height * 0.06,
              margin: EdgeInsets.only(bottom: 10.0),
              child: ListTile(
                title: Text('Contact Us',
                style: TextStyle(
                  fontFamily: 'Jost-Medium'
                )),
                onTap: () => {},
              ),
            ),
            Container(
              height: screenSize.height * 0.07,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color.fromRGBO(59, 89, 152, 1),
                  radius: screenSize.height / 40,
                  child: Image.asset('assets/images/facebook.png',
                  color: Colors.white, height: screenSize.height / 45),
                ),
                title: Text('Facebook',
                style: TextStyle(
                  fontFamily: 'Jost-Medium',
                  color: Color.fromRGBO(59, 89, 152, 1)
                )),
                onTap: () => {},
              ),
            ),
            Container(
              height: screenSize.height * 0.07,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color.fromRGBO(29, 161, 242, 1),
                  radius: screenSize.height / 40,
                  child: Image.asset('assets/images/twitter.png',
                  color: Colors.white, height: screenSize.height / 45),
                ),
                title: Text('Twitter',
                style: TextStyle(
                  fontFamily: 'Jost-Medium',
                  color: Color.fromRGBO(29, 161, 242, 1)
                )),
                onTap: () => {},
              ),
            ),
            Container(
              height: screenSize.height * 0.07,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color.fromRGBO(244, 67, 54, 1),
                  radius: screenSize.height / 40,
                  child: Image.asset('assets/images/google.png',
                  color: Colors.white, height: screenSize.height / 45),
                ),
                title: Text('Google',
                style: TextStyle(
                  fontFamily: 'Jost-Medium',
                  color: Color.fromRGBO(244, 67, 54, 1)
                )),
                onTap: () => {},
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEndDrawer(context, AsyncSnapshot<StationsBloc> snapshot) {
      _countries = stationsBloc.countries;
      return Container(
        color: Colors.white,
        child: Container(
          child: Column(
            children: [
              Container(
                color: Color.fromRGBO(203, 203, 203, 1),
                height: screenSize.height * 0.04,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                color: Color.fromRGBO(203, 203, 203, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        'Filter By Country',
                        style: TextStyle(
                          fontFamily: 'Jost-Medium'
                        ),
                      ),
                    ),
                    Container(
                      child: FlatButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          stationsBloc.clearFilters();
                        }, 
                        child: Text('Clear All',
                        style: TextStyle(
                          fontFamily: 'Jost-Medium',
                          color: Colors.grey
                        ))
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: screenSize.height * 0.85,
                margin: EdgeInsets.only(top: 5.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(0.0),
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: _countries.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                            child: GestureDetector(
                              onTap: (){
                                stationsBloc.filteredCountryId = _countries[index].id;
                                Navigator.of(context).pop();
                                stationsBloc.getCountryStations(_countries[index].id);
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: screenSize.height / 24,
                                child: Text(_countries[index].name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: stationsBloc.filteredCountryId == _countries[index].id ? 
                                            Theme.of(context).buttonColor: Colors.black,
                                    fontFamily: 'Jost-Regular',
                                    fontSize: screenSize.width / 23
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      );
  }

  Widget _buildBottomBar(context, AsyncSnapshot<StationsBloc> snapshot){
    return stationsBloc.currentPlayingStation != null && 
    stationsBloc.currentPlayingStation.id != null ? BottomAppBar(
      color: Color.fromRGBO(72, 100, 170, 1),
      child: Container(
        height: screenSize.height * 0.09,
        child: Row(
          children: [
            Container(
              width: screenSize.width * 0.12,
              child: IconButton(
                icon: stationsBloc.isPlaying ? 
                Icon(Icons.pause, color: Colors.white, size: 30.0):
                Icon(Icons.play_arrow, color: Colors.white, size: 30.0), 
                onPressed: (){
                  if(!stationsBloc.isPlaying){
                    stationsBloc.startAudio();
                    stationsBloc.isPlaying = true;
                  } else {
                    stationsBloc.stopAudio();
                    stationsBloc.isPlaying = false;
                  }
                }
              ),
            ),
            Container(
              width: screenSize.width * 0.53,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(stationsBloc.currentPlayingStation.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Jost-Regular'
                    )),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(stationsBloc.currentPlayingStation.country,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontFamily: 'Jost-Regular'
                    )),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              width: screenSize.width * 0.35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: (){
                      stationsBloc.currentPlayingStation.isFavourite = !stationsBloc.currentPlayingStation.isFavourite;
                      stationsBloc.updateFavourites(stationsBloc.currentPlayingStation);
                    },
                    child: Container(
                      padding: EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 1.0
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0) 
                        ),
                      ),
                      child: Image.asset(!stationsBloc.currentPlayingStation.isFavourite ? 
                      'assets/images/unfavourite.png': 'assets/images/favourite.png',
                      height: screenSize.width / 27, color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1.0
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(5.0) 
                      ),
                    ),
                    child: Image.asset('assets/images/google.png',
                    height: screenSize.width / 27, color: Colors.white),
                  ),
                  Container(
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1.0
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(5.0) 
                      ),
                    ),
                    child: Image.asset('assets/images/facebook.png',
                    height: screenSize.width / 27, color: Colors.white),
                  ),
                  Container(
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1.0
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(5.0)  
                      ),
                    ),
                    child: Image.asset('assets/images/twitter.png',
                    height: screenSize.width / 27, color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ): BottomAppBar();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return StreamBuilder<StationsBloc>(
      stream: stationsBloc.station,
      builder: (context, AsyncSnapshot<StationsBloc> snapshot) {
        return Scaffold(
          drawer: Container(
            width: screenSize.width * 0.75,
            child: Drawer(
              child: _buildSideMenu(context, snapshot),
            ),
          ),
          key: _scaffoldKey,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Container(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      _builsAppBar(),
                      _buildTabBar(),
                    ],
                  )
                ),
                Expanded(child: _buildBody(context, snapshot))
              ],
            ),
          ),
          endDrawer: Drawer(
            child: Container(
              width: screenSize.width * 0.6,
              child: Drawer(
                child: _buildEndDrawer(context, snapshot),
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomBar(context, snapshot),
        );
      }
    );
  }
}
