import 'package:app_singleapp/api/router.dart';
import 'package:app_singleapp/theme/theme_data.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'api/client_api.dart';
import 'config/routes.dart';
import 'routes/landing_route.dart';

void main() async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  mainApp();
}

void mainApp() async {
  runApp(BlocProvider(
      creator: (_context, _bag) {
        final bloc = ManagementRepositoryClientBloc();
        ManagementRepositoryClientBloc.router = Router();
        ManagementRepositoryClientBloc.router.mrBloc = bloc;
        Routes.configureRoutes(ManagementRepositoryClientBloc.router);
        return bloc;
      },
      child: FeatureHubApp()));
}

class FeatureHubApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FeatureHub',
      theme: myTheme,
      home: LandingRoute(title: 'FeatureHub'),
      onGenerateRoute: (RouteSettings settings) {
        final uri = Uri.parse(settings.name);

        final params = uri.queryParametersAll;
        ManagementRepositoryClientBloc.router
            .navigateTo(context, uri.path, params: params);
        BlocProvider.of<ManagementRepositoryClientBloc>(context)
            .resetInitialized();
        return null;
      },
    );
  }
}
