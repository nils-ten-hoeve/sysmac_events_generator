import 'package:archive/archive.dart';
import 'package:sysmac_events_generator/infrastructure/sysmac/data_type.dart';
import 'package:sysmac_events_generator/infrastructure/sysmac/sysmac.dart';
import 'package:xml/xml.dart';

const String typeAttribute = 'type';
const String idAttribute = 'id';
const String nameSpaceAttribute = 'namespace';
const String entity = 'Entity';
const String dataType = 'DataType';

/// Represents the only [ArchiveFile] with an
/// .[oem](https://en.wikipedia.org/wiki/Original_equipment_manufacturer)
/// file extension inside a [SysmacProjectFile].
///
/// It contains a [XmlDocument] containing them main project index that contains
/// references to other xml files.
///
/// It can convert this [XmlDocument] to domain objects that represent
/// more meaningful information (e.g. references to other xml files)
class ProjectIndexXml extends ArchiveXml {
  final Archive archive;

  ProjectIndexXml(this.archive) : super.fromArchiveFile(_findOemFile(archive));

  static ArchiveFile _findOemFile(Archive archive) =>
      archive.firstWhere((ArchiveFile archiveFile) =>
          archiveFile.isFile && archiveFile.name.endsWith('.oem'));

  List<DataTypeArchiveXmlFile> dataTypeArchiveXmlFiles() {
    List<XmlNode> dataTypeEntities = _findDataTypeEntities();

    List<DataTypeArchiveXmlFile> dataTypeArchiveXmlFiles = [];
    for (var dataTypeEntity in dataTypeEntities) {
      try {
        String id = dataTypeEntity.getAttribute(idAttribute)!;
        String nameSpacePath = dataTypeEntity.getAttribute(nameSpaceAttribute)??'';
        var archiveFile = _findArchiveFile(id);
        var dataTypeXmlArchiveFile = DataTypeArchiveXmlFile.fromArchiveFile(
            nameSpacePath: nameSpacePath,
            archiveFile: archiveFile);
        dataTypeArchiveXmlFiles.add(dataTypeXmlArchiveFile);
      } on Error {
        // Not found: no problem, try next
      }
    }
    return dataTypeArchiveXmlFiles;
  }

  List<XmlNode> _findDataTypeEntities() {
    var dataTypeEntities = xmlDocument.descendants
        .where((node) => _isDataTypeEntity(node))
        .toList();
    return dataTypeEntities;
  }

  /// throws error when not found
  ArchiveFile _findArchiveFile(String id) {
    String xmlFileName = '$id.xml';
    return archive.firstWhere(
        (ArchiveFile archiveFile) => archiveFile.name.endsWith(xmlFileName));
  }

  bool _isDataTypeEntity(XmlNode node) =>
      node is XmlElement &&
      node.name.local == entity &&
      node.getAttribute(typeAttribute) == dataType;
}
