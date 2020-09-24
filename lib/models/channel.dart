class Station {
  int id;
  String name;
  String country;
  String stream;
  String slug;
  bool isFavourite;

  Station(
    {
      this.id,
      this.country,
      this.name,
      this.stream,
      this.slug,
      this.isFavourite,
    }
  );

  Station.fromJson(Map station) {
    this.id = station['id'];
    this.country = station['country'];
    this.name = station['title'];
    this.stream = station['stream'];
    this.slug = station['slug'];
    this.isFavourite = station['isFavourite'] != null ? station['isFavourite']: false;
  }

  toJson() {
    return {
      "id": id,
      "country": country,
      "title": name,
      "stream": stream,
      "slug": slug,
      "isFavourite": isFavourite
    };
  }
}