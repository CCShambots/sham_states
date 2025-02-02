
import 'package:sham_states/services/nt4_client.dart';
import 'package:sham_states/services/nt_connection.dart';

class NetworkTableTreeRow {
  final String topic;
  final String rowName;

  final NT4Topic? ntTopic;

  List<NetworkTableTreeRow> children = [];

  NetworkTableTreeRow({
    required this.topic,
    required this.rowName,
    this.ntTopic,
  });

  bool hasRow(String name) {
    for (NetworkTableTreeRow child in children) {
      if (child.rowName == name) {
        return true;
      }
    }
    return false;
  }

  bool hasRows(List<String> names) {
    for (String row in names) {
      if (!hasRow(row)) {
        return false;
      }
    }

    return true;
  }

  bool containsOnlyMetadata() {
    if (children.isEmpty) {
      return false;
    }

    return !children.any((row) => !row.rowName.startsWith('.'));
  }

  void addRow(NetworkTableTreeRow row) {
    if (hasRow(row.rowName)) {
      return;
    }

    children.add(row);
  }

  NetworkTableTreeRow getRow(String name) {
    for (NetworkTableTreeRow row in children) {
      if (row.rowName == name) {
        return row;
      }
    }

    throw Exception("Trying to retrieve a row that doesn't exist");
  }

  NetworkTableTreeRow createNewRow(
      {required String topic, required String name, NT4Topic? ntTopic}) {
    NetworkTableTreeRow newRow =
        NetworkTableTreeRow(topic: topic, rowName: name, ntTopic: ntTopic);
    addRow(newRow);

    return newRow;
  }

  void sort() {
    children.sort((a, b) {
      if (a.children.isNotEmpty && b.children.isEmpty) {
        return -1;
      } else if (a.children.isEmpty && b.children.isNotEmpty) {
        return 1;
      }

      return a.rowName.compareTo(b.rowName);
    });

    for (NetworkTableTreeRow child in children) {
      child.sort();
    }
  }

  void clearRows() {
    children.clear();
  }

  // static NTWidgetModel? getNTWidgetFromTopic(NT4Topic ntTopic) {
  //   switch (ntTopic.type) {
  //     case NT4TypeStr.kFloat64:
  //     case NT4TypeStr.kInt:
  //     case NT4TypeStr.kFloat32:
  //     case NT4TypeStr.kBoolArr:
  //     case NT4TypeStr.kFloat64Arr:
  //     case NT4TypeStr.kFloat32Arr:
  //     case NT4TypeStr.kIntArr:
  //     case NT4TypeStr.kString:
  //     case NT4TypeStr.kStringArr:
  //       return TextDisplayModel(
  //         topic: ntTopic.name,
  //         dataType: ntTopic.type,
  //       );
  //     case NT4TypeStr.kBool:
  //       return BooleanBoxModel(
  //         topic: ntTopic.name,
  //         dataType: ntTopic.type,
  //       );
  //   }
  //   return null;
  // }

  // Future<NTWidgetModel?>? getPrimaryWidget() async {
  //   if (ntTopic == null) {
  //     if (hasRow('.type')) {
  //       return await getTypedWidget('$topic/.type');
  //     }

  //     return null;
  //   }

  //   return getNTWidgetFromTopic(ntTopic!);
  // }

  Future<String?> getTypeString(String typeTopic) async {
    return ntConnection.subscribeAndRetrieveData(typeTopic);
  }

  // Future<NTWidgetModel?>? getTypedWidget(String typeTopic) async {
  //   String? type = await getTypeString(typeTopic);

  //   if (type == null) {
  //     return null;
  //   }

  //   return NTWidgetBuilder.buildNTModelFromType(type, topic);
  // }

  // Future<List<NTWidgetContainerModel>?> getListLayoutChildren() async {
  //   List<NTWidgetContainerModel> listChildren = [];
  //   for (NetworkTableTreeRow child in children) {
  //     if (child.rowName.startsWith('.')) {
  //       continue;
  //     }
  //     WidgetContainerModel? childModel =
  //         await child.toWidgetContainerModel(resortToListLayout: false);

  //     if (childModel is NTWidgetContainerModel) {
  //       listChildren.add(childModel);
  //     }
  //   }

  //   if (listChildren.isEmpty) {
  //     return null;
  //   }

  //   return listChildren;
  // }

  // Future<WidgetContainerModel?> toWidgetContainerModel({
  //   bool resortToListLayout = true,
  //   ListLayoutBuilder? listLayoutBuilder,
  // }) async {
  //   NTWidgetModel? primary = await getPrimaryWidget();

  //   if (primary == null) {
  //     if (resortToListLayout) {
  //       List<NTWidgetContainerModel>? listLayoutChildren =
  //           await getListLayoutChildren();

  //       if (listLayoutChildren != null) {
  //         return listLayoutBuilder?.call(
  //           title: rowName,
  //           children: listLayoutChildren,
  //         );
  //       }
  //     }
  //     return null;
  //   }

  //   NTWidget? widget = NTWidgetBuilder.buildNTWidgetFromModel(primary);

  //   if (widget == null) {
  //     return null;
  //   }

  //   double width = NTWidgetBuilder.getDefaultWidth(primary);
  //   double height = NTWidgetBuilder.getDefaultHeight(primary);

  //   return NTWidgetContainerModel(
  //     initialPosition: Rect.fromLTWH(0.0, 0.0, width, height),
  //     title: rowName,
  //     childModel: primary,
  //   );
  // }

  // Future<WidgetContainer?> toWidgetContainer() async {
  //   NTWidgetModel? primary = await getPrimaryWidget();
  //   if (primary == null) {
  //     return null;
  //   }
  //   NTWidget? widget = NTWidgetBuilder.buildNTWidgetFromModel(primary);

  //   if (widget == null) {
  //     primary.unSubscribe();
  //     primary.disposeWidget(deleting: true);
  //     primary.forceDispose();

  //     return null;
  //   }

  //   double width = NTWidgetBuilder.getDefaultWidth(primary);
  //   double height = NTWidgetBuilder.getDefaultHeight(primary);

  //   return WidgetContainer(
  //     title: rowName,
  //     width: width,
  //     height: height,
  //     child: widget,
  //   );
  // }
}
