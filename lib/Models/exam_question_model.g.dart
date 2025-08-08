// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_question_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExamQuestionModelAdapter extends TypeAdapter<ExamQuestionModel> {
  @override
  final int typeId = 1;

  @override
  ExamQuestionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamQuestionModel(
      id: fields[0] as int,
      question: fields[1] as String,
      options: (fields[2] as List).cast<String>(),
      correctAnswer: fields[3] as int,
      previewVideo: fields[4] as String?,
      correctVideo: fields[5] as String?,
      wrongVideo: fields[6] as String?,
      isExpanded: fields[7] as bool?,
      selectedIndex: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ExamQuestionModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.question)
      ..writeByte(2)
      ..write(obj.options)
      ..writeByte(3)
      ..write(obj.correctAnswer)
      ..writeByte(4)
      ..write(obj.previewVideo)
      ..writeByte(5)
      ..write(obj.correctVideo)
      ..writeByte(6)
      ..write(obj.wrongVideo)
      ..writeByte(7)
      ..write(obj.isExpanded)
      ..writeByte(8)
      ..write(obj.selectedIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamQuestionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
