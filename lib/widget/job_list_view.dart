import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String sampleJobList = 'deneme\nfocus_run\npoint_and_shoot_example\n';

class JobListNotifier extends ChangeNotifier {
  List<String> jobList = [];

  void jobListParser(String jobListFromIPGScan) {
    jobList = jobListFromIPGScan.split("\n");
    jobList.removeLast();
    notifyListeners();
  }
}

final jobListProvider = ChangeNotifierProvider<JobListNotifier>(
  (ref) {
    return JobListNotifier();
  },
);

class ParseListButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () =>
          context.read(jobListProvider).jobListParser(sampleJobList),
      child: Text('Parse the job list'),
    );
  }
}

class JobListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final jobListWatcher = watch(jobListProvider);
    return ListView.builder(
      itemCount: jobListWatcher.jobList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.work_outline),
          title: Text(
            jobListWatcher.jobList[index],
          ),
          onTap: () {},
        );
      },
    );
  }
}


/*
import 'package:flutter/material.dart';

List<String> jobList = [];

String sampleJobList = 'deneme\nfocus_run\npoint_and_shoot_example\n';
List<String> jobListParser() {
  List<String> tempList;
  tempList = sampleJobList.split("\n");
  tempList.removeLast();
  return tempList;
}

class ParseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text('parse the job list'),
    );
  }
}

class JobListView extends StatefulWidget {
  @override
  _JobListViewState createState() => _JobListViewState();
}

class _JobListViewState extends State<JobListView> {
  @override
  void initState() {
    jobList = jobListParser();
    super.initState();
  }

  var _selectedIndex = 0;
  IconData _leadIcon = Icons.work_outline;
  var _selectedColor;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: jobList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: index == _selectedIndex
              ? Icon(_leadIcon, color: _selectedColor)
              : Icon(Icons.work_outline),
          title: Text(
            jobList[index],
            style: TextStyle(
              color: index == _selectedIndex ? _selectedColor : Colors.black,
            ),
          ),
          onTap: () {
            setState(() {
              _selectedIndex = index;
              _selectedColor = Colors.orange.shade600;
              _leadIcon = Icons.work;
            });
            print(
                'selected index: $_selectedIndex / selected job: ${jobList[index]}');
          },
        );
      },
    );
  }
}
*/