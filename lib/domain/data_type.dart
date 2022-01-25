import 'package:collection/collection.dart';
import 'package:sysmac_events_generator/infrastructure/sysmac/base_type.dart';

class NameSpace {
  final String name;
  final List<NameSpace> children = [];

  NameSpace(this.name);

  List<NameSpace> get descendants {
    List<NameSpace> all = [];
    for (var child in children) {
      all.add(child);
      all.addAll(child.descendants);
    }
    return all;
  }

  @override
  String toString() {
    String string = 'NameSpace {name: $name}';
    for (var child in children) {
      var lines = child.toString().split('\n');
      for (var line in lines) {
        string += "\n  $line";
      }
    }
    return string;
  }

  /// Tries to find a child using a list of [namesToFind]
  /// Returns this when [namesToFind] is empty.
  /// Returns null when a name can't be found.
  NameSpace? findNamePath(List<String> namesToFind) {
    if (namesToFind.isEmpty) {
      return this;
    }
    var childNameToFind = namesToFind.first;
    NameSpace? foundChild =
        children.firstWhereOrNull((child) => child.name == childNameToFind);
    if (foundChild == null) {
      return null;
    }
    if (namesToFind.length == 1) {
      return foundChild;
    } else {
      //try to find rest of the names
      namesToFind.removeAt(0);
      return foundChild.findNamePath(namesToFind);
    }
  }

  NameSpace? findNamePathString(String pathToFind) =>
      findNamePath(pathToFind.split('\\'));
}

class DataType extends NameSpace {
  final String comment;
  BaseType baseType;

  DataType({
    required String name,
    required this.baseType,
    required this.comment,
  }) : super(name);

  @override
  List<NameSpace> get children {
    if (baseType is DataTypeReference) {
      return [(baseType as DataTypeReference).dataType];
    } else {
      return super.children;
    }
  }

  @override
  String toString() {
    String string =
        '$DataType{name: $name, comment: $comment, baseType: $baseType}';
    for (var child in children) {
      var lines = child.toString().split('\n');
      for (var line in lines) {
        string += "\n  $line";
      }
    }
    return string;
  }
}
