import 'package:archive/archive.dart';
import 'package:sysmac_events_generator/infrastructure/sysmac/sysmac.dart';
import 'package:sysmac_events_generator/infrastructure/test_resource.dart';

main() {
  var sysmacProjectFile=SysmacProjectFile(SysmacProjectTestResource().file.path);
  var archiveFileNames=sysmacProjectFile.archive.map((ArchiveFile archiveFile) => archiveFile.name).toList();
  print(archiveFileNames);
}