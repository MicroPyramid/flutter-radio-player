import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:radiostring/blocs/station_bloc.dart';
import 'package:radiostring/models/channel.dart';

class AllChannels extends StatefulWidget {
  final AsyncSnapshot<StationsBloc> snapshot;
  AllChannels(this.snapshot);

  @override
  State createState() => _AllChannelsState();
}

class _AllChannelsState extends State<AllChannels> {

  List<Station> _stations = [];
  var screenSize;
  ScrollController _controller;
  bool _bottomLoader = false;

  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  _scrollListener() async {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
          setState(() {
            _bottomLoader = true;
          });
          await stationsBloc.getNextStations();
          setState(() {
            _bottomLoader = false;
          });
    }
    // if (_controller.offset <= _controller.position.minScrollExtent &&
    //     !_controller.position.outOfRange) {
    //   setState(() {
    //     print("reach the top");
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    if(widget.snapshot.hasData && !widget.snapshot.data.isLoading){
      _stations = widget.snapshot.data.allStations;
      return _stations.length > 0 ? Column(
        children: [
          Expanded(
            child: Container(
              child: ListView.builder(
                controller: _controller,
                padding: EdgeInsets.symmetric(vertical: 10.0),
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: _stations.length,
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
                                stationsBloc.currentPlayingStation != _stations[index])){
                                  stationsBloc.currentPlayingStation = _stations[index];
                                  stationsBloc.stopAudio();
                                  stationsBloc.callAudio(_stations[index]);
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
                                    child: stationsBloc.isPlaying && _stations[index].id == stationsBloc.currentPlayingStation.id ? 
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
                                    child: Text(_stations[index].name,
                                      style: TextStyle(
                                        fontSize: screenSize.width / 25,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Jost-Regular',
                                        color: Color.fromRGBO(24, 35, 82, 1)
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(_stations[index].country,
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
                                  setState(() {
                                    _stations[index].isFavourite = !_stations[index].isFavourite;
                                  });
                                  stationsBloc.updateFavourites(_stations[index]);
                                },
                                child: Image.asset(_stations[index].isFavourite ? 'assets/images/favourite.png': 'assets/images/unfavourite.png',
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
            ),
          ),
          _bottomLoader ? Container(
            color: Colors.transparent,
            width: 50.0,
            height: 50.0,
            child: new Padding(
              padding: const EdgeInsets.all(5.0),
              child: new Center(
                child: new CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(72, 100, 170, 1))
                )
              )
            ),
          ): Container()
        ],
      ): Center(
        child: Text('No stations',
        style: TextStyle(
          color: Color.fromRGBO(137, 149, 183, 1),
          fontFamily: 'Jost-Regular'
        )),
      );
    } else if(widget.snapshot.hasError){
      return Text(widget.snapshot.error.toString());
    } 
    return Container(
      width: 300.0,
      height: 300.0,
      child: new Padding(
        padding: const EdgeInsets.all(5.0),
        child: new Center(
          child: new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(72, 100, 170, 1))
          )
        )
      ),
    );
  }
}
