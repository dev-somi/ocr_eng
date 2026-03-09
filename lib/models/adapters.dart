import 'package:hive/hive.dart';
import 'package:clickword/models/models.dart';

class WordBookAdapter extends TypeAdapter<WordBook> {
  @override
  final int typeId = 0;

  @override
  WordBook read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordBook(
      id: fields[0] as String,
      title: fields[1] as String,
      createdAt: fields[2] as DateTime,
      words: (fields[3] as List).cast<Word>(),
      iconName: fields[4] as String,
      colorValue: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WordBook obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.words)
      ..writeByte(4)
      ..write(obj.iconName)
      ..writeByte(5)
      ..write(obj.colorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WordBookAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}

class WordAdapter extends TypeAdapter<Word> {
  @override
  final int typeId = 1;

  @override
  Word read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Word(
      id: fields[0] as String,
      english: fields[1] as String,
      korean: fields[2] as String,
      correctCount: fields[3] as int,
      wrongCount: fields[4] as int,
      lastStudied: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Word obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.english)
      ..writeByte(2)
      ..write(obj.korean)
      ..writeByte(3)
      ..write(obj.correctCount)
      ..writeByte(4)
      ..write(obj.wrongCount)
      ..writeByte(5)
      ..write(obj.lastStudied);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WordAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}

class StudyLogAdapter extends TypeAdapter<StudyLog> {
  @override
  final int typeId = 2;

  @override
  StudyLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudyLog(
      id: fields[0] as String,
      wordId: fields[1] as String,
      isCorrect: fields[2] as bool,
      studyMode: fields[3] as String,
      timestamp: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StudyLog obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.wordId)
      ..writeByte(2)
      ..write(obj.isCorrect)
      ..writeByte(3)
      ..write(obj.studyMode)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is StudyLogAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
