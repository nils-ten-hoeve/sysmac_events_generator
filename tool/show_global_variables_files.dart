import 'package:sysmac_events_generator/infrastructure/sysmac/sysmac.dart';
import 'package:sysmac_events_generator/infrastructure/sysmac/variable.dart';
import '../test/infrastructure/test_resource.dart';

main() {
  var sysmacProjectFile=SysmacProjectFile(SysmacProjectTestResource().file.path);
  for (var file in sysmacProjectFile.projectIndexXml.globalVariableArchiveXmlFiles()) {
    print (file.nameSpacePath);
    print(file.xmlDocument.toXmlString(pretty: true));
    print("");
  }
}