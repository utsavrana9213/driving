// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unanswered_questions_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnansweredQuestionsModelAdapter
    extends TypeAdapter<UnansweredQuestionsModel> {
  @override
  final int typeId = 0;

  @override
  UnansweredQuestionsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnansweredQuestionsModel(
      unansweredQuestions: fields[0] as ExamQuestionModel?,
    );
  }

  @override
  void write(BinaryWriter writer, UnansweredQuestionsModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.unansweredQuestions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnansweredQuestionsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
