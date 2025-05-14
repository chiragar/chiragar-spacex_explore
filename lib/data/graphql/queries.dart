import 'package:chiragar_spacex_explore/data/graphql/fragments.dart';

class SpaceXQueries {
  // --- LAUNCH QUERIES ---
  static const String getPastLaunches = '''
    ${SpaceXFragments.launchCore}
    ${SpaceXFragments.nestedRocketInfo} 
    query GetPastLaunches(\$limit: Int, \$offset: Int, \$find: LaunchFind, \$order: String, \$sort: String) {
      launchesPast(limit: \$limit, offset: \$offset, find: \$find, order: \$order, sort: \$sort) {
        ...LaunchCore
      }
    }
  ''';

  static const String getLaunchDetails = '''
    ${SpaceXFragments.launchCore}
    ${SpaceXFragments.nestedRocketInfo}
    # If you needed to fetch the ROCKET's full details including its images *alongside* the launch,
    # you would typically add a separate query field for the rocket by its ID, if the API supports it,
    # or make a second call.
    # For now, we rely on NestedRocketInfo for the embedded rocket data.
    query GetLaunchDetails(\$id: ID!) {
      launch(id: \$id) {
        ...LaunchCore
        ships {
          id
          name
          image
          type
          home_port
        }
      }
    }
  ''';

  // --- ROCKET QUERIES ---
  static const String getAllRockets = '''
    ${SpaceXFragments.rocketCoreForTopLevelQueries} 
    query GetAllRockets {
      rockets {
        ...RocketCoreForTopLevelQueries 
      }
    }
  ''';

  static const String getRocketDetails = '''
    ${SpaceXFragments.rocketCoreForTopLevelQueries}
    query GetRocketDetails(\$id: ID!) {
      rocket(id: \$id) {
        ...RocketCoreForTopLevelQueries
        # engines { type version layout number thrust_sea_level { kN } } # Example for more details
      }
    }
  ''';

  // --- COMPANY INFO ---
  static const String getCompanyInfo = r'''
    query GetCompanyInfo {
      company {
        name
        founder
        founded
        employees
        vehicles
        launch_sites
        test_sites
        ceo
        cto
        coo
        cto_propulsion
        valuation
        headquarters {
          address
          city
          state
        }
        summary
      }
    }
  ''';
}