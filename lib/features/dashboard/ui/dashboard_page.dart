import 'package:exp_dapp/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:exp_dapp/features/deposit/ui/deposit.dart';
import 'package:exp_dapp/features/withdraw/ui/withdraw.dart';
import 'package:exp_dapp/utils/app_assets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardBloc _dashboardBloc = DashboardBloc();
  @override
  void initState() {
    _dashboardBloc.add(DashboardFetchInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DeFi Dashboard'),
      ),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        bloc: _dashboardBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case const (DashboardLoading):
              return const Center(child: CircularProgressIndicator());
            case const (DashboardError):
              return Center(child: Text((state as DashboardError).message));
            case const (DashboardSuccess):
              final dashboardState = (state as DashboardSuccess);
              {}
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                            tag: 'ethLogo',
                            child: Image.network(AppAssets.ethLogo,
                                width: 50, height: 50)),
                        const SizedBox(width: 16),
                        Text(
                          '${dashboardState.balance} ETH',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildGradientButton(
                          context,
                          'Deposit',
                          DepositPage(
                            dashboardBloc: _dashboardBloc,
                          ),
                          Colors.green..shade200,
                        ),
                        const SizedBox(width: 16),
                        _buildGradientButton(
                          context,
                          'Withdraw',
                          WithdrawPage(
                            dashboardBloc: _dashboardBloc,
                          ),
                          Colors.redAccent..shade200,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Transactions",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (dashboardState.transactions.isEmpty)
                    const Center(
                      child: Text('No transactions found'),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dashboardState.transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = dashboardState.transactions[index];
                        return _buildTransactionItem(
                            '${transaction.amount} ETH',
                            transaction.reason,
                            transaction.address,
                            transaction.date);
                      },
                    ),
                  ),
                ],
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildGradientButton(
      BuildContext context, String text, Widget page, Color bgColor) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        height: 60,
        width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bgColor.withOpacity(0.2), bgColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
      String amount, String description, String address, DateTime date) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Image.network(AppAssets.ethLogo, width: 30, height: 30),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        amount,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(color: Colors.grey.shade300),
                      ),
                      Text(
                        address,
                        style: TextStyle(color: Colors.orange.shade500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                date.toString(),
                style: TextStyle(color: Colors.grey.shade300),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
