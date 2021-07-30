
import 'package:flutter/material.dart';

class JobListView extends StatefulWidget {
  @override
  _JobListViewState createState() => _JobListViewState();
}

class _JobListViewState extends State<JobListView> {
  var jobList = List<String>.generate(
    100,
    (index) => 'Job $index',
  );

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
              ? Icon(_leadIcon, color: _selectedColor,)
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
            print('selected index: $_selectedIndex / selected job: ${jobList[index]}');
          },
        );
      },
    );
  }
}
