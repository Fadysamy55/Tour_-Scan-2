class PostsModel{
  String? id;
  String? name;
  String? imgPath;
  String? title;
  bool? isFav =false;
  String?  description;
  bool? isPlaces=true;
  PostsModel({
    this.id,
    this.name,
    this.imgPath,
    this.title,
    this.isFav,
    this.description,
    this.isPlaces
  });
}