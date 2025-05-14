class SpaceXFragments {
  // This fragment is for when you query Rockets directly (list or by ID)
  static const String rocketCoreForTopLevelQueries = r'''
    fragment RocketCoreForTopLevelQueries on Rocket {
      id
      name
      type
      description
      success_rate_pct
      first_flight
      height { meters feet }
      diameter { meters feet }
      mass { kg lb }
      cost_per_launch
      country
      company
      stages
      active
    }
  ''';

  // This fragment is for basic rocket info when nested under a Launch
  static const String nestedRocketInfo = r'''
    fragment NestedRocketInfo on Rocket {
       id
      name
      type
      description 
      success_rate_pct 
      active 
    }
  ''';

  static const String launchCore = r'''
    fragment LaunchCore on Launch {
      id
      mission_name
      launch_date_utc
      launch_success
      details
      links {
        mission_patch
        mission_patch_small
        article_link
        video_link
        flickr_images # These are for the LAUNCH
      }
      rocket { # This is of type LaunchRocket
        rocket_name
        rocket_type
        rocket { # This is of type Rocket (nested)
          ...NestedRocketInfo # Use the specific fragment for nested rockets
        }
      }
      launch_site {
        site_id
        site_name_long
        site_name
      }
    }
  ''';

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