import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_audio_stream/url_audio_stream.dart';

import 'package:radiostring/models/channel.dart';
import 'package:radiostring/models/country.dart';
import 'package:radiostring/services/radiostring_services.dart';

class StationsBloc {
  List<Station> _allStations = [];
  List<Country> _countries = [];
  bool _isLoading = false;
  List<Station> _favouriteStations = [];
  int _filteredCountryId;
  Station _currentPlayingStation;
  static AudioStream stream = new AudioStream("");
  bool _isPlaying = false;
  bool _isShowBottomBar = false;
  String _nextService;
  List _favouriteStationIds = [];
  List _allStationIds = [];

  final _stationsFetcher = PublishSubject<StationsBloc>();
  Stream<StationsBloc> get station => _stationsFetcher.stream;

  dispose() {
    _stationsFetcher.close();
  }

  List<Station> get allStations {
    return _allStations;
  }

  List<Station> get favouriteStations {
    return _favouriteStations;
  }

  List<Country> get countries {
    return _countries;
  }

  bool get isLoading {
    return _isLoading;
  }

  int get filteredCountryId {
    return _filteredCountryId;
  }

  set filteredCountryId(int filteredCountryId) {
    _filteredCountryId = filteredCountryId;
    _stationsFetcher.sink.add(stationsBloc);
  }

  Station get currentPlayingStation {
    return _currentPlayingStation;
  }

  set currentPlayingStation(Station currentPlayingStation) {
    _currentPlayingStation = currentPlayingStation;
    _stationsFetcher.sink.add(stationsBloc);
  }

  bool get isPlaying {
    return _isPlaying;
  }

  set isPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    _stationsFetcher.sink.add(stationsBloc);
  }

  bool get isShowBottomBar {
    return _isShowBottomBar;
  }

  set isShowBottomBar(bool isShowBottomBar) {
    _isShowBottomBar = isShowBottomBar;
    _stationsFetcher.sink.add(stationsBloc);
  }

  getCountries() async{
    await RadioStringService().getCountries().then((response) {
      var _allCountries = (json.decode(response.body))['data'];
      for(var country in _allCountries){
        _countries.add(Country.fromJson(country));
      }
      _stationsFetcher.sink.add(stationsBloc);
    }).catchError((onError){

    });
  }

  getStations() async{
    _allStations.clear();
    _allStationIds.clear();
    _isLoading = true;
    await RadioStringService().getStations().then((response) {
      var _stations = (json.decode(response.body))['data'];
      _nextService = (json.decode(response.body))['next'];
      for(var station in _stations){
        Station _station = Station.fromJson(station);
        if(_favouriteStationIds.length > 0 && _favouriteStationIds.contains(_station.id)){
          _station.isFavourite = true;
        }
        if(!_allStationIds.contains(_station.id)){
          _allStations.add(_station);
          _allStationIds.add(_station.id);
        }
        
      }
      _isLoading = false;
      _stationsFetcher.sink.add(stationsBloc);
    }).catchError((onError){

    });
  }

  getNextStations() async{
    await RadioStringService().getNextStations(_nextService).then((response) {
      var _stations = (json.decode(response.body))['data'];
      _nextService = (json.decode(response.body))['next'];
      for(var station in _stations){
        Station _station = Station.fromJson(station);
        if(_favouriteStationIds.length > 0 && _favouriteStationIds.contains(_station.id)){
          _station.isFavourite = true;
        }
        if(!_allStationIds.contains(_station.id)){
          _allStations.add(_station);
          _allStationIds.add(_station.id);
        }
      }
      _stationsFetcher.sink.add(stationsBloc);
    }).catchError((onError){

    });
  }

  getFavourites() async{
    _favouriteStations.clear();
    List _favourites = [];
    _favouriteStationIds.clear();
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    _favourites = preferences.getString('favourites') != null ? 
                  json.decode(preferences.getString('favourites')): [];
    for(var _station in _favourites) {
      _favouriteStationIds.add(_station['id']);
      _favouriteStations.add(Station.fromJson(_station));
    }
    _stationsFetcher.sink.add(stationsBloc);
  }

  updateFavourites(Station station) async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    if(!_favouriteStationIds.contains(station.id)){
      for(Station _station in _allStations){
        if(_station.id == station.id){
          _station.isFavourite = true;
          _favouriteStations.add(_station);
          _favouriteStationIds.add(_station.id);
        }
      }
    } else {
       _favouriteStations.removeAt(_favouriteStationIds.indexOf(station.id));
       _favouriteStationIds.remove(station.id);
       for(Station _station in _allStations){
        if(_station.id == station.id){
          _station.isFavourite = false;
          _favouriteStations.remove(_station);
        }
      }
    }
    preferences.setString('favourites', json.encode(_favouriteStations));
    _stationsFetcher.sink.add(stationsBloc);
  }

  getCountryStations(id) async{
    _allStations.clear();
    _allStationIds.clear();
    _isLoading = true;
    await RadioStringService().getCountryStations(id).then((response) {
      var _stations = (json.decode(response.body))['results'];
      _nextService = (json.decode(response.body))['next'];
      for(var station in _stations){
        Station _station = Station.fromJson(station);
        if(_favouriteStationIds.length > 0 && _favouriteStationIds.contains(_station.id)){
          _station.isFavourite = true;
        }
        if(!_allStationIds.contains(_station.id)){
          _allStations.add(_station);
          _allStationIds.add(_station.id);
        }
      }
      _isLoading = false;
      _stationsFetcher.sink.add(stationsBloc);
    }).catchError((onError){

    });
  }

  clearFilters() {
    _filteredCountryId = null;
    getStations();
  }

  callAudio(Station station) {
    currentPlayingStation = station;
    _isPlaying = true;
    stream.stop();
    stream = new AudioStream(station.stream);
    stream.start();
    _stationsFetcher.sink.add(stationsBloc);
  }

  startAudio() {
    stream.start();
  }

  stopAudio() {
    stream.stop();
  }
}

final stationsBloc = StationsBloc();
