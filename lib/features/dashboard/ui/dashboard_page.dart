import 'package:flutter/material.dart';
import 'package:exp_dapp/features/deposit/ui/deposit.dart';
import 'package:exp_dapp/features/withdraw/ui/withdraw.dart';
import 'package:exp_dapp/utils/app_assets.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DeFi Dashboard'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                    tag: 'ethLogo',
                    child: Image.network(AppAssets.ethLogo,
                        width: 50, height: 50)),
                const SizedBox(width: 16),
                const Text(
                  '100 ETH',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
                  const DepositPage(),
                  Colors.green..shade200,
                ),
                const SizedBox(width: 16),
                _buildGradientButton(
                  context,
                  'Withdraw',
                  const WithdrawPage(),
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
          Expanded(
            child: ListView(
              children: [
                _buildTransactionItem(
                  '50 ETH',
                  'NFT Purchase',
                  '0x1234567890',
                  'Withdraw',
                  '25th August 12:00 PM',
                ),
                // Add more transactions here
              ],
            ),
          ),
        ],
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

  Widget _buildTransactionItem(String amount, String description,
      String address, String type, String date) {
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
                Column(
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
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                type,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: type == 'Withdraw' ? Colors.red : Colors.green,
                ),
              ),
              Text(
                date,
                style: TextStyle(color: Colors.grey.shade300),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
