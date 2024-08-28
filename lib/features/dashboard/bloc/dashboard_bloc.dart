import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:exp_dapp/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardFetchInitialEvent>(dashboardFetchInitialEvent);
    on<DashboardDepositEvent>(dashboardDepositEvent);
    on<DashboardWithdrawEvent>(dashboardWithdrawEvent);
  }

  List<TransactionModel> mainTrans = [];
  Web3Client? _client;
  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  late EthPrivateKey _credentials;
  late DeployedContract _contract;
  int balance = 0;

  // Functions
  late ContractFunction _deposit;
  late ContractFunction _withdraw;
  late ContractFunction _getBalance;
  late ContractFunction _getAllTransactions;

  FutureOr<void> dashboardFetchInitialEvent(
      DashboardFetchInitialEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());

    try {
      const String rpcUrl = "http://127.0.0.1:7545";
      const String socketUrl = "ws://127.0.0.1:7545";
      const String privateKey =
          "0x033c518fdca5221427f9a2cd1feaea89041b20a10e208f2c340914a72257bf35";

      _client = Web3Client(
        rpcUrl,
        http.Client(),
        socketConnector: () {
          return IOWebSocketChannel.connect(socketUrl).cast<String>();
        },
      );

      log("Client Created");

      // GET ABI
      String abiFile = await rootBundle
          .loadString("build/contracts/ExpenseManagerContract.json");
      var jsonDecoded = jsonDecode(abiFile);
      _abiCode = ContractAbi.fromJson(
          jsonEncode(jsonDecoded["abi"]), 'ExpenseManagerContract');

      _contractAddress =
          EthereumAddress.fromHex("0x43c715000197d6c480920E309DB5BbF745098Db0");

      _credentials = EthPrivateKey.fromHex(privateKey);

      log("ABI and Address Fetched");

      // GET DEPLOYED CONTRACT
      _contract = DeployedContract(_abiCode, _contractAddress);

      log("Contract Deployed");

      // GET FUNCTIONS
      _deposit = _contract.function("deposit");
      _withdraw = _contract.function("withdraw");
      _getBalance = _contract.function("getBalance");
      _getAllTransactions = _contract.function("getAllTransactions");

      log("Functions Fetched");
      final transactionsData = await _client!.call(
        contract: _contract,
        function: _getAllTransactions,
        params: [],
      );

      final balanceData = await _client!.call(
        contract: _contract,
        function: _getBalance,
        params: [
          EthereumAddress.fromHex("0x2f628E25eDF1b6cc88283A77A92C966f57862f2e"),
        ],
      );
      log("Balance Data : ${balanceData.toString()}");
      log("Transactions Data : ${transactionsData.toString()}");

      List<TransactionModel> trans = [];
      for (int i = 0; i < transactionsData[0].length; i++) {
        TransactionModel transactionModel = TransactionModel(
            address: transactionsData[0][i].toString(),
            amount: transactionsData[1][i].toInt(),
            reason: transactionsData[2][i],
            date: DateTime.fromMicrosecondsSinceEpoch(
                transactionsData[3][i].toInt()));
        trans.add(transactionModel);
      }
      mainTrans = trans;
      int bal = balanceData[0].toInt();
      balance = bal;
      emit(DashboardSuccess(
        balance: balance,
        transactions: mainTrans,
      ));
    } catch (e) {
      log("UHMMM : ${e.toString()}");
      emit(DashboardError(
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> dashboardWithdrawEvent(
      DashboardWithdrawEvent event, Emitter<DashboardState> emit) async {
    final data = await _client!.call(
      contract: _contract,
      function: _deposit,
      params: [
        event.model.amount,
        event.model.reason,
      ],
    );
    log("Withdraw Event : ${data.toString()}");
  }

  FutureOr<void> dashboardDepositEvent(
      DashboardDepositEvent event, Emitter<DashboardState> emit) async {
    final data = await _client!.call(
      contract: _contract,
      function: _withdraw,
      params: [
        event.model.amount,
        event.model.reason,
      ],
    );
  }
}
