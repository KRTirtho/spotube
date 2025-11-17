part of 'metadata.dart';

enum FormFieldVariant { text, password, number }

@Freezed(unionKey: 'objectType')
class MetadataFormFieldObject with _$MetadataFormFieldObject {
  @FreezedUnionValue("input")
  factory MetadataFormFieldObject.input({
    required String objectType,
    required String id,
    @Default(FormFieldVariant.text) FormFieldVariant variant,
    String? placeholder,
    String? defaultValue,
    bool? required,
    String? regex,
  }) = MetadataFormFieldInputObject;

  @FreezedUnionValue("text")
  factory MetadataFormFieldObject.text({
    required String objectType,
    required String text,
  }) = MetadataFormFieldTextObject;

  factory MetadataFormFieldObject.fromJson(Map<String, dynamic> json) =>
      _$MetadataFormFieldObjectFromJson(json);
}
