import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:here_maps_test/bloc/bloc/locations/location_search_bloc.dart';
import 'package:here_maps_test/bloc/states/location/location_search_state.dart';
import 'package:here_maps_test/data/model/LocationModel.dart';

import '../../../bloc/bloc/locations/locations_list_bloc.dart';
import '../../../bloc/events/location/location_list_vent.dart';
import '../../../bloc/events/location/location_search_event.dart';

class DraggableList extends StatefulWidget {
  final List<LocationModel> list;
  final Function onListOrderChanged;

  const DraggableList({Key? key, required this.list, required this.onListOrderChanged}) : super(key: key);

  @override
  State<DraggableList> createState() => _DraggableListState();
}

class _DraggableListState extends State<DraggableList> {
  late List<LocationModel> _list;

  @override
  void initState() {
    _list = widget.list;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: gtList,
    );
  }

  bool _searchInList(LocationModel item, String query) {
    return item.address.street.contains(query) ||
        item.address.city.contains(query) ||
        item.address.zip.contains(query) ||
        item.type.contains(query);
  }

  Widget get gtList => BlocBuilder<LocationSearchBloc, LocationSearchState>(
          builder: (context, state) {
            List<LocationModel>  mList = state.isQuery
            ? _list
                .where((item) =>
                    item.address.street.toLowerCase().contains(state.query) ||
                    item.address.city.toLowerCase().contains(state.query) ||
                    item.address.zip.contains(state.query) ||
                    item.type.toLowerCase().contains(state.query))
                .toList()
            : _list;

        return ReorderableListView(
          children: mList.map((item) => _listItem(item)).toList(),
          onReorder: (int start, int current) {
            // dragging from top to bottom
            if (start < current) {
              int end = current - 1;
              LocationModel startItem = mList[start];
              int i = 0;
              int local = start;
              do {
                _list[local] = mList[++local];
                i++;
              } while (i < end - start);
              mList[end] = startItem;
            }
            // dragging from bottom to top
            else if (start > current) {
              LocationModel startItem = mList[start];
              for (int i = start; i > current; i--) {
                mList[i] = mList[i - 1];
              }
              mList[current] = startItem;
            }
            _vibrate();
            setState(() {
              context.read<LocationListBloc>().add(OnListOrderChanged(mList));
            });
          },
        );
      });

  Widget _listItem(LocationModel locationModel) {
    var position = _list.indexOf(locationModel);
    var isFirstRowEmpty = locationModel.address.street.isNotEmpty;
    var isSecondRowEmpty =
        locationModel.address.city.isEmpty && locationModel.address.zip.isEmpty;
    var firstRow = isFirstRowEmpty
        ? Padding(
            padding: EdgeInsets.only(
                top: isSecondRowEmpty ? 20 : 8, bottom: 2, left: 4),
            child: Text(
              locationModel.address.street,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          )
        : Container();
    var secondRow = Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8, left: 4),
      child: isSecondRowEmpty
          ? Container()
          : Text("${locationModel.address.city}, ${locationModel.address.zip}",
              style: Theme.of(context).textTheme.labelSmall),
    );
    var prefix = locationModel.type == "home"
        ? Container(
            padding: const EdgeInsets.only(top: 8),
            margin: EdgeInsets.only(right: 12),
            child: Image.asset("assets/home.png"),
          )
        : locationModel.type == "current"
            ? Container(
                padding: const EdgeInsets.only(top: 8),
                margin: EdgeInsets.only(right: 12),
                child: Image.asset("assets/location.png"),
              )
            : Container(
                decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                padding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 11),
                margin: EdgeInsets.only(right: 22),
                child: Text(
                  "${position}",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      key: Key(locationModel.id),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          prefix,
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          firstRow,
                          secondRow,
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            top: isSecondRowEmpty ? 16 : 6,
                            bottom: isSecondRowEmpty ? 6 : 0),
                        child: Image.asset("assets/drag_lines.png"))
                  ],
                ),
                position != _list.length - 1
                    ? Container(
                        margin: const EdgeInsets.only(left: 5, top: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).dividerColor,
                              width: 1,
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }


  void _vibrate() {
    HapticFeedback.vibrate();
    SystemSound.play(SystemSoundType.click);
  }
}
