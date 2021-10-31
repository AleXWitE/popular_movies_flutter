// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_data_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveMovieDetailsAdapter extends TypeAdapter<HiveMovieDetails> {
  @override
  final int typeId = 0;

  @override
  HiveMovieDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveMovieDetails(
      id: fields[0] as int,
      movOrigTitle: fields[1] as String,
      movPosterPath: fields[2] as String,
      movGenres: (fields[12] as List)?.cast<dynamic>(),
      movVote: fields[11] as double,
      movLanguage: fields[3] as String,
      movRuntime: fields[8] as int,
      movOverview: fields[4] as String,
      movRelease: fields[6] as String,
      movBudget: fields[9] as int,
      movRevenue: fields[10] as int,
      movHomepage: fields[7] as String,
      movTagline: fields[5] as String,
      movBackpacks: (fields[16] as List)?.cast<String>(),
      movYoutube: (fields[15] as List)?.cast<HiveMovieYoutube>(),
      movReviews: (fields[14] as List)?.cast<HiveMovieReviews>(),
      movId: fields[13] as int,
      movIsFav: fields[17] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HiveMovieDetails obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.movOrigTitle)
      ..writeByte(2)
      ..write(obj.movPosterPath)
      ..writeByte(3)
      ..write(obj.movLanguage)
      ..writeByte(4)
      ..write(obj.movOverview)
      ..writeByte(5)
      ..write(obj.movTagline)
      ..writeByte(6)
      ..write(obj.movRelease)
      ..writeByte(7)
      ..write(obj.movHomepage)
      ..writeByte(8)
      ..write(obj.movRuntime)
      ..writeByte(9)
      ..write(obj.movBudget)
      ..writeByte(10)
      ..write(obj.movRevenue)
      ..writeByte(11)
      ..write(obj.movVote)
      ..writeByte(12)
      ..write(obj.movGenres)
      ..writeByte(13)
      ..write(obj.movId)
      ..writeByte(14)
      ..write(obj.movReviews)
      ..writeByte(15)
      ..write(obj.movYoutube)
      ..writeByte(16)
      ..write(obj.movBackpacks)
    ..writeByte(17)
    ..write(obj.movIsFav);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveMovieDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveMovieReviewsAdapter extends TypeAdapter<HiveMovieReviews> {
  @override
  final int typeId = 1;

  @override
  HiveMovieReviews read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveMovieReviews(
      id: fields[0] as int,
      author: fields[1] as String,
      fullContent: fields[2] as String,
      shortContent: fields[3] as String,
      isExpansed: fields[4] as bool,
      isExpState: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HiveMovieReviews obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.fullContent)
      ..writeByte(3)
      ..write(obj.shortContent)
      ..writeByte(4)
      ..write(obj.isExpansed)
      ..writeByte(5)
      ..write(obj.isExpState);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveMovieReviewsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveMovieYoutubeAdapter extends TypeAdapter<HiveMovieYoutube> {
  @override
  final int typeId = 2;

  @override
  HiveMovieYoutube read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveMovieYoutube(
      ytKey: fields[0] as String,
      ytName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveMovieYoutube obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.ytKey)
      ..writeByte(1)
      ..write(obj.ytName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveMovieYoutubeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveMovieImagesAdapter extends TypeAdapter<HiveMovieImages> {
  @override
  final int typeId = 3;

  @override
  HiveMovieImages read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveMovieImages(
      imgId: fields[0] as int,
      imgUrl: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveMovieImages obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.imgId)
      ..writeByte(1)
      ..write(obj.imgUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveMovieImagesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
