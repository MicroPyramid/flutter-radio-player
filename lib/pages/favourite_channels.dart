import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:radiostring/blocs/station_bloc.dart';
import 'package:radiostring/models/channel.dart';

class FavouriteChannels extends StatefulWidget {
  final AsyncSnapshot<StationsBloc> snapshot;
  FavouriteChannels(this.snapshot);

  @override
  State createState() => _FavouriteChannelsState();
}

class _FavouriteChannelsState extends State<FavouriteChannels> {

  List<Station> _favouriteStations = [];
  var screenSize;

  void initState() {
    super.initState();
  }

  @override
 Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    _favouriteStations = stationsBloc.favouriteStations;
    return _favouriteStations.length > 0 ? Container(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: _favouriteStations.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
            child: Card(
              margin: EdgeInsets.only(bottom: 5.0),
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        if(stationsBloc.isPlaying == false || (stationsBloc.currentPlayingStation != null && stationsBloc.currentPlayingStation.id != null && 
                        stationsBloc.currentPlayingStation != _favouriteStations[index])){
                          stationsBloc.currentPlayingStation = _favouriteStations[index];
                          stationsBloc.stopAudio();
                          stationsBloc.callAudio(_favouriteStations[index]);
                          stationsBloc.isPlaying = true;
                        } else {
                          stationsBloc.stopAudio();
                          stationsBloc.isPlaying = false;
                        }
                      },
                      child: Container(
                        width: screenSize.width * 0.1,
                        child: CircleAvatar(
                          radius: screenSize.width / 20,
                          backgroundColor: Theme.of(context).buttonColor,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: screenSize.width / 22,
                            child: stationsBloc.isPlaying && _favouriteStations[index].id == stationsBloc.currentPlayingStation.id ? 
                              Icon(Icons.pause, color: Theme.of(context).buttonColor, size: screenSize.width / 20): 
                              SvgPicture.asset('assets/images/play-button.svg'),
                          ),
                        )
                      ),
                    ),
                    Container(
                      width: screenSize.width * 0.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(_favouriteStations[index].name,
                              style: TextStyle(
                                fontSize: screenSize.width / 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Jost-Regular',
                                color: Color.fromRGBO(24, 35, 82, 1)
                              )
                            ),
                          ),
                          Container(
                            child: Text(_favouriteStations[index].country,
                            style: TextStyle(
                                fontFamily: 'Jost-Regular',
                                color: Color.fromRGBO(124, 138, 175, 1)
                              )
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: screenSize.width * 0.1,
                      child: GestureDetector(
                        onTap: (){
                          stationsBloc.updateFavourites(_favouriteStations[index]);
                        },
                        child: Image.asset('assets/images/favourite.png',
                          height: screenSize.width / 20,
                          color: Color.fromRGBO(137, 149, 183, 1)
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      ),
    ): Center(
      child: Text('No stations',
      style: TextStyle(
        color: Color.fromRGBO(137, 149, 183, 1),
        fontFamily: 'Jost-Regular'
      )),
    );
  }
}
