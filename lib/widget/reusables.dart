import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/job_command_providers.dart';
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
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.grey,
        border: Border.symmetric(
          horizontal: BorderSide(width: 1.0, color: Colors.black26),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SetVariableWidget extends ConsumerStatefulWidget {
  const SetVariableWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SetVariableWidgetState();
}

class _SetVariableWidgetState extends ConsumerState<SetVariableWidget> {
  @override
  Widget build(BuildContext context) {
    final setVariableValue = ref.watch(setVariableValueProvider.notifier);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InfoLabel('Set variable', ipgScanCommandList.systemSetVariable),
        const SetVariableList(),
        Container(
          height: 24,
          width: 90,
          padding: const EdgeInsets.all(2.0),
          child: TextField(
            onChanged: (value) {
              setVariableValue.state = value;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}

class SetVariableList extends ConsumerStatefulWidget {
  const SetVariableList({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SetVariableListState();
}

class _SetVariableListState extends ConsumerState<SetVariableList> {
  int dropdownValue = 1;

  @override
  Widget build(BuildContext context) {
    final variable = ref.watch(setVariableProvider.notifier);
    return DropdownButtonHideUnderline(
      child: DropdownButton<int>(
        value: dropdownValue,
        onChanged: (newValue) {
          setState(() {
            dropdownValue = newValue!;
            variable.state = dropdownValue;
          });
        },
        items: List.generate(24, (index) => index)
            .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
            .toList(),
      ),
    );
  }
}

class GetVariableWidget extends ConsumerStatefulWidget {
  const GetVariableWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GetVariableWidgetState();
}

class _GetVariableWidgetState extends ConsumerState<GetVariableWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InfoLabel('Get variable: ', ipgScanCommandList.systemGetVariable),
        const GetVariableList(),
        Container(
          height: 24,
          width: 90,
          padding: const EdgeInsets.all(2.0),
          child: const TextField(
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}

class GetVariableList extends ConsumerStatefulWidget {
  const GetVariableList({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GetVariableListState();
}

class _GetVariableListState extends ConsumerState<GetVariableList> {
  int dropdownValue = 1;

  @override
  Widget build(BuildContext context) {
    final variable = ref.watch(getVariableProvider.notifier);
    return DropdownButtonHideUnderline(
      child: DropdownButton<int>(
        value: dropdownValue,
        onChanged: (newValue) {
          setState(() {
            dropdownValue = newValue!;
            variable.state = dropdownValue;
          });
        },
        items: List.generate(24, (index) => index)
            .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
            .toList(),
      ),
    );
  }
}

class BeamPositionSet extends ConsumerStatefulWidget {
  const BeamPositionSet({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BeamPositionSetState();
}

class BeamPositionSetState extends ConsumerState<BeamPositionSet> {
  String xValue = '0', yValue = '0', zValue = '0';

  void updatePosition() {
    ref.read(beamPositionSetProvider.notifier).state =
        '$xValue $yValue $zValue';
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InfoLabel('Set beam position', ipgScanCommandList.scannerParkAt),
        Container(
          height: 24,
          width: 72,
          padding: const EdgeInsets.all(2.0),
          child: TextField(
            onChanged: (value) {
              xValue = value;
              if (xValue.isEmpty) {
                xValue = '0';
              }
              updatePosition();
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
              LengthLimitingTextInputFormatter(5),
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Container(
          height: 24,
          width: 72,
          padding: const EdgeInsets.all(2.0),
          child: TextField(
            onChanged: (value) {
              yValue = value;
              if (yValue.isEmpty) {
                yValue = '0';
              }
              updatePosition();
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
              LengthLimitingTextInputFormatter(5),
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Container(
          height: 24,
          width: 72,
          padding: const EdgeInsets.all(2.0),
          child: TextField(
            onChanged: (value) {
              zValue = value;
              if (zValue.isEmpty) {
                zValue = '0';
              }
              updatePosition();
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
              LengthLimitingTextInputFormatter(5),
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}

class BeamPositionGet extends ConsumerStatefulWidget {
  const BeamPositionGet({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BeamPositionGetState();
}

class BeamPositionGetState extends ConsumerState<BeamPositionGet> {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InfoLabel('Get beam position',
            ipgScanCommandList.scannerGetWorkspacePosition),
        Container(
          height: 24,
          width: 72,
          padding: const EdgeInsets.all(2.0),
          child: const TextField(
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Container(
          height: 24,
          width: 72,
          padding: const EdgeInsets.all(2.0),
          child: const TextField(
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Container(
          height: 24,
          width: 72,
          padding: const EdgeInsets.all(2.0),
          child: const TextField(
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
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

    if (widget.commandType == ipgScanCommandList.jobStart ||
        widget.commandType == ipgScanCommandList.systemSetVariable ||
        widget.commandType == ipgScanCommandList.systemGetVariable ||
        widget.commandType == ipgScanCommandList.scannerParkAt ||
        widget.commandType == ipgScanCommandList.scannerGetWorkspacePosition) {
      widget.receivedDataText = '';
    } else if (widget.commandType == lastCommand) {
      widget.receivedDataText = dataReceived;
      widget.receivedDataText.trim();
    }

    return Container(
      padding: const EdgeInsets.all(2.0),
      height: 24,
      alignment: Alignment.centerLeft,
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
    );
  }
}

class JobStartGuideCheckBox extends ConsumerStatefulWidget {
  const JobStartGuideCheckBox({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _JobStartGuideCheckBoxState();
}

class _JobStartGuideCheckBoxState extends ConsumerState<JobStartGuideCheckBox> {
  bool? checkVal = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: checkVal,
      onChanged: (val) {
        setState(() {
          checkVal = val;
          if (val != null && val == true) {
            ref.read(jobStartGuideOptionProvider.notifier).state = ' -guide';
          } else {
            ref.read(jobStartGuideOptionProvider.notifier).state = '';
          }
        });
      },
    );
  }
}

class JobStartSavefileCheckBox extends ConsumerStatefulWidget {
  const JobStartSavefileCheckBox({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _JobStartSavefileCheckBoxState();
}

class _JobStartSavefileCheckBoxState
    extends ConsumerState<JobStartSavefileCheckBox> {
  bool? checkVal = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: checkVal,
      onChanged: (val) {
        setState(() {
          checkVal = val;
          if (val != null && val == true) {
            ref.read(jobStartSavefileOptionProvider.notifier).state =
                ' -savefile';
          } else {
            ref.read(jobStartSavefileOptionProvider.notifier).state = '';
          }
        });
      },
    );
  }
}

class JobStartGroupName extends ConsumerStatefulWidget {
  const JobStartGroupName({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _JobStartGroupNameState();
}

class _JobStartGroupNameState extends ConsumerState<JobStartGroupName> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 60,
      padding: const EdgeInsets.all(2.0),
      child: TextField(
        onChanged: (val) {
          if (val.isNotEmpty) {
            ref.read(jobStartGroupOptionProvider.notifier).state =
                ' -groupG$val';
          } else {
            ref.read(jobStartGroupOptionProvider.notifier).state = '';
          }
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
        ],
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class CommandListWidget extends ConsumerStatefulWidget {
  const CommandListWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommandListWidgetState();
}

class _CommandListWidgetState extends ConsumerState<CommandListWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InfoLabel('Command List', ipgScanCommandList.noCommand),
        const CommandDropDownList(),
      ],
    );
  }
}

class CommandDropDownList extends ConsumerStatefulWidget {
  const CommandDropDownList({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommandDropDownList();
}

class _CommandDropDownList extends ConsumerState<CommandDropDownList> {
  int dropdownValue = 1;

  @override
  Widget build(BuildContext context) {
    final helpCommand = ref.watch(helpSpecialCommandProvider.notifier);

    return DropdownButtonHideUnderline(
      child: DropdownButton<int>(
        value: dropdownValue,
        onChanged: (newValue) {
          setState(() {
            dropdownValue = newValue!;
            helpCommand.state = ipgScanCommandMap[
                    ipgScanCommandList.values.elementAt(dropdownValue)]
                .toString();
          });
        },
        items: List.generate(
          ipgScanCommandMap.length,
          (index) => index,
        )
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  '${ipgScanCommandMap[ipgScanCommandList.values.elementAt(e)]}',
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
