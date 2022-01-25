import 'package:sysmac_events_generator/infrastructure/sysmac/sysmac.dart';
import '../test/infrastructure/test_resource.dart';

main() {
  var sysmacProjectFile=SysmacProjectFile(SysmacProjectTestResource().file.path);
  print(sysmacProjectFile.projectIndexXml.xmlDocument);
}