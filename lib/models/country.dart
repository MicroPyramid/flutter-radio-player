class Country {
  String name;
  int id;

  Country(
    {
      this.name,
      this.id
    }
  );

  Country.fromJson(Map country) {
    this.name = country['name'];
    this.id = country['id'];
  }

  toJson() {
    return {
      'name': name,
      'id': id
    };
  }
}