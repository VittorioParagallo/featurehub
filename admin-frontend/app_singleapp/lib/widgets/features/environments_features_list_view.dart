import 'package:app_singleapp/widgets/features/feature_value_cell.dart';
import 'package:flutter/material.dart';

import 'feature_dashboard_constants.dart';
import 'hidden_environment_list.dart';
import 'tabs_bloc.dart';

class EnvironmentsAndFeatureValuesListView extends StatelessWidget {
  const EnvironmentsAndFeatureValuesListView({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  final TabsBloc bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Set<String>>(
        stream: bloc.hiddenEnvironments,
        builder: (context, snapshot) {
          return StreamBuilder<TabsState>(
              stream: bloc.currentTab,
              builder: (context, currentTabSnapshot) {
                return StreamBuilder<Set<String>>(
                    stream: bloc.featureCurrentlyEditingStream,
                    builder: (context, snapshot) {
                      return Container(
                        height: (bloc.unselectedFeatureCount *
                                unselectedRowHeight) +
                            (bloc.selectedFeatureCount * selectedRowHeight +
                                1.0) +
                            headerHeight +
                            2,
                        child: Scrollbar(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            physics: ClampingScrollPhysics(),
                            children: [
                              if (bloc.features.isNotEmpty)
                                ...bloc.sortedEnvironmentsThatAreShowing
                                    .map((efv) {
                                  return Container(
//                                  padding:
//                                      EdgeInsets.only(left: 1.0, right: 1.0),
                                    width: 170.0,
                                    child: Column(
                                      children: [
                                        Container(
//                                        color: Theme.of(context).highlightColor,
                                          height: headerHeight,
                                          child: Column(
                                            children: [
                                              HideEnvironmentContainer(
                                                name: efv.environmentName,
                                                envId: efv.environmentId,
                                              ),
                                            ],
                                          ),
                                        ),
                                        ...bloc.features.map((f) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                              top: BorderSide(
                                                  color: Colors.black45,
                                                  width: 0.5),
                                              right: BorderSide(
                                                  color: Colors.black45,
                                                  width: 0.5),
                                            )),
                                            child: FeatureValueCell(
                                                tabsBloc: bloc,
                                                feature: f,
                                                value: efv.features.firstWhere(
                                                    (fv) => fv.key == f.key,
                                                    orElse: () => null),
                                                efv: efv),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  );
                                })
                            ],
                          ),
                        ),
                      );
                    });
              });
        });
  }
}
