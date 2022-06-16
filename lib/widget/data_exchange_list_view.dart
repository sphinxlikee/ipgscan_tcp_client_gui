import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/tcp_provider.dart';

class DataLine extends StatelessWidget {
  const DataLine({
    Key? key,
    required this.data,
  }) : super(key: key);
  final String data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
      margin: const EdgeInsets.only(left: 4.0),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
          border: Border.symmetric(vertical: BorderSide.none)),
      child: Text(data),
    );
  }
}

class DataExchangeScrollView extends ConsumerStatefulWidget {
  const DataExchangeScrollView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DataExchangeScrollViewState();
}

class _DataExchangeScrollViewState
    extends ConsumerState<DataExchangeScrollView> {
  final ScrollController _scrollController = ScrollController();

  void animateScrollbarToBottom(Duration duration) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: duration,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tcpClient = ref.watch(tcpClientProvider);
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) => animateScrollbarToBottom(const Duration(milliseconds: 250)),
    );
    return Expanded(
      child: Container(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
        alignment: Alignment.bottomLeft,
        child: Scrollbar(
          controller: _scrollController,
          interactive: true,
          thumbVisibility: true,
          trackVisibility: true,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
                children: tcpClient.dataReceivedSentList
                    .map((e) => DataLine(data: e))
                    .toList()),
          ),
        ),
      ),
    );
  }
}
