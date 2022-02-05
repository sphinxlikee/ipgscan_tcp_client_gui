import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/tcp_provider.dart';
import '../ipg/ipgscan_api.dart';

class IPGScanJobCommandButton extends ConsumerWidget {
  final ipgScanCommandList commandType;
  final String parameter;
  final String? labelName;

  IPGScanJobCommandButton({
    Key? key,
    required this.commandType,
    required this.parameter,
  })  : labelName = ipgScanCommandMap[commandType],
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(tcpClientProvider).isConnected;

    return ElevatedButton(
      style: const ButtonStyle(
        alignment: Alignment.centerLeft,
      ),
      onPressed: !isConnected
          ? null
          : () {
              ref
                  .read(tcpClientProvider.notifier)
                  .writeToServer(setCommand(commandType, parameter));

              ref.read(lastCommandProvider.notifier).state = commandType;
            },
      child: Text(
        labelName ?? 'label problem',
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      height: 24,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.grey,
        border: Border.symmetric(
          horizontal: BorderSide(width: 1.0, color: Colors.black26),
        ),
      ),
    );
  }
}

class VariableList extends StatefulWidget {
  const VariableList({Key? key}) : super(key: key);

  @override
  _VariableListState createState() => _VariableListState();
}

class _VariableListState extends State<VariableList> {
  int dropdownValue = 1;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<int>(
        value: dropdownValue,
        onChanged: (newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
          print(dropdownValue);
        },
        items: const [
          DropdownMenuItem(
            value: 1,
            child: Text('1'),
          ),
          DropdownMenuItem(
            value: 2,
            child: Text('2'),
          ),
          DropdownMenuItem(
            value: 3,
            child: Text('3'),
          ),
          DropdownMenuItem(
            value: 4,
            child: Text('4'),
          ),
          DropdownMenuItem(
            value: 5,
            child: Text('5'),
          ),
          DropdownMenuItem(
            value: 6,
            child: Text('6'),
          ),
          DropdownMenuItem(
            value: 7,
            child: Text('7'),
          ),
          DropdownMenuItem(
            value: 8,
            child: Text('8'),
          ),
          DropdownMenuItem(
            value: 9,
            child: Text('9'),
          ),
          DropdownMenuItem(
            value: 10,
            child: Text('10'),
          ),
          DropdownMenuItem(
            value: 11,
            child: Text('11'),
          ),
          DropdownMenuItem(
            value: 12,
            child: Text('12'),
          ),
          DropdownMenuItem(
            value: 13,
            child: Text('13'),
          ),
          DropdownMenuItem(
            value: 14,
            child: Text('14'),
          ),
          DropdownMenuItem(
            value: 15,
            child: Text('15'),
          ),
          DropdownMenuItem(
            value: 16,
            child: Text('16'),
          ),
          DropdownMenuItem(
            value: 17,
            child: Text('17'),
          ),
          DropdownMenuItem(
            value: 18,
            child: Text('18'),
          ),
          DropdownMenuItem(
            value: 19,
            child: Text('19'),
          ),
          DropdownMenuItem(
            value: 20,
            child: Text('20'),
          ),
          DropdownMenuItem(
            value: 21,
            child: Text('21'),
          ),
          DropdownMenuItem(
            value: 22,
            child: Text('22'),
          ),
          DropdownMenuItem(
            value: 23,
            child: Text('23'),
          ),
          DropdownMenuItem(
            value: 24,
            child: Text('24'),
          ),
        ],
      ),
    );
  }
}

class GalvoPosition extends StatefulWidget {
  const GalvoPosition({Key? key, required this.enableState}) : super(key: key);
  final bool enableState;

  @override
  _GalvoPositionState createState() => _GalvoPositionState();
}

class _GalvoPositionState extends State<GalvoPosition> {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget.enableState
            ? InfoLabel('Set galvo position', ipgScanCommandList.scannerParkAt)
            : InfoLabel('Get galvo position',
                ipgScanCommandList.scannerGetWorkspacePosition),
        Container(
          height: 24,
          width: 60,
          child: TextField(
            enabled: widget.enableState,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          padding: const EdgeInsets.all(4.0),
        ),
        Container(
          height: 24,
          width: 60,
          child: TextField(
            enabled: widget.enableState,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          padding: const EdgeInsets.all(4.0),
        ),
        Container(
          height: 24,
          width: 60,
          child: TextField(
            enabled: widget.enableState,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          padding: const EdgeInsets.all(4.0),
        ),
      ],
    );
  }
}

class InfoLabel extends ConsumerStatefulWidget {
  final String label;
  final ipgScanCommandList commandType;
  String receivedDataText = '';
  InfoLabel(this.label, this.commandType, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InfoLabelState();
}

class _InfoLabelState extends ConsumerState<InfoLabel> {
  @override
  Widget build(BuildContext context) {
    final lastCommand = ref.watch(lastCommandProvider);
    final dataReceived = ref.watch(tcpClientProvider).dataReceived;

    if (widget.commandType == ipgScanCommandList.systemSetVariable ||
        widget.commandType == ipgScanCommandList.systemGetVariable ||
        widget.commandType == ipgScanCommandList.scannerParkAt ||
        widget.commandType == ipgScanCommandList.scannerGetWorkspacePosition) {
      widget.receivedDataText = '';
    } else if (widget.commandType == lastCommand) {
      widget.receivedDataText = dataReceived;
      widget.receivedDataText.trim();
      // widget.receivedDataText.split('\n');
    }

    return Container(
      padding: const EdgeInsets.all(2.0),
      height: 24,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: widget.label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: ': '),
            TextSpan(text: widget.receivedDataText),
          ],
        ),
      ),
      alignment: Alignment.centerLeft,
    );
  }
}
