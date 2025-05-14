import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart'; // For number formatting
import 'package:chiragar_spacex_explore/domain/entities/company_info.dart';
import 'package:chiragar_spacex_explore/injection_container.dart';
import 'package:chiragar_spacex_explore/presentation/blocs_cubits/company_info/company_info_bloc.dart';

class CompanyInfoPage extends StatefulWidget {
  const CompanyInfoPage({super.key});

  @override
  State<CompanyInfoPage> createState() => _CompanyInfoPageState();
}

class _CompanyInfoPageState extends State<CompanyInfoPage> {
  late CompanyInfoBloc _companyInfoBloc;

  @override
  void initState() {
    super.initState();
    _companyInfoBloc = getIt<CompanyInfoBloc>()..add(FetchCompanyInfo());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpaceX Company Info'),
      ),
      body: BlocProvider.value(
        value: _companyInfoBloc,
        child: BlocBuilder<CompanyInfoBloc, CompanyInfoState>(
          builder: (context, state) {
            if (state is CompanyInfoInitial || state is CompanyInfoLoading) {
              return Center(child: SpinKitFadingCube(color: theme.colorScheme.primary));
            } else if (state is CompanyInfoLoaded) {
              final info = state.info;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        info.name,
                        style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      info.summary,
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 24),
                    _buildInfoCard(context, info),
                    const SizedBox(height: 16),
                    _buildLeadershipCard(context, info),
                  ],
                ),
              );
            } else if (state is CompanyInfoError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => _companyInfoBloc.add(FetchCompanyInfo()),
                      child: const Text('Retry'),
                    )
                  ],
                ),
              );
            }
            return const Center(child: Text('Something went wrong.'));
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, CompanyInfo info) {
    final numberFormat = NumberFormat.decimalPattern();
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 0);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overview', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            _infoRow('Founder:', info.founder),
            _infoRow('Founded:', info.foundedYear.toString()),
            _infoRow('Employees:', numberFormat.format(info.employees)),
            _infoRow('Vehicles:', info.vehicles.toString()),
            _infoRow('Launch Sites:', info.launchSites.toString()),
            _infoRow('Test Sites:', info.testSites.toString()),
            _infoRow('Valuation:', currencyFormat.format(info.valuation)),
            _infoRow('Headquarters:', info.headquarters.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadershipCard(BuildContext context, CompanyInfo info) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Leadership', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            _infoRow('CEO:', info.ceo),
            _infoRow('CTO:', info.cto),
            _infoRow('COO:', info.coo),
            _infoRow('CTO Propulsion:', info.ctoPropulsion),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}