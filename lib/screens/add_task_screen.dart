import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final formKey = GlobalKey<FormState>();
  String _title = '';
  String _priority;
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFOrmatter = DateFormat('yMMMEd');
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  @override
  void initState(){
    super.initState();
    _dateController.text = _dateFOrmatter.format(_date);
  }

  @override
  void dispose(){
    _dateController.dispose();
    super.dispose();
  }

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
    );
    if (date != null && date != _date){
      setState(() {
       _date = date;
      });
      _dateController.text = _dateFOrmatter.format(_date);
    }
  }

  _submit(){
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      print('${_title}, ${_date}, ${_priority}');

      //Insert the task to our user's database

      // update the task
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 70.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios, size: 30, color: Theme.of(context).primaryColor,),),
                SizedBox(height: 20.0,),
                Text('Add Task',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10,),
                Form(key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 18.0
                          ),
                          decoration: InputDecoration(labelText: 'Title', labelStyle: TextStyle(
                            fontSize: 18.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (input) => input.trim().isEmpty ? 'Please enter a task title' : null,
                          onSaved: (input) => _title = input,
                          cursorColor: Theme.of(context).primaryColor,
                          initialValue: _title,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: _dateController,
                          style: TextStyle(
                              fontSize: 18.0
                          ),
                          onTap: _handleDatePicker,
                          decoration: InputDecoration(labelText: 'Date', labelStyle: TextStyle(
                              fontSize: 18.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          cursorColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: DropdownButtonFormField(
                          isDense: true,
                          icon: Icon(Icons.arrow_drop_down_circle),
                          iconSize: 22.0,
                          iconEnabledColor: Theme.of(context).primaryColor,
                          iconDisabledColor: Theme.of(context).primaryColorLight,
                          items: _priorities.map((String priority)  {
                            return DropdownMenuItem(
                              value: priority,
                                child: Text(priority, style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18.0,
                                ),)
                            );
                          }).toList(),
                          style: TextStyle(
                              fontSize: 18.0
                          ),
                          decoration: InputDecoration(labelText: 'Priority', labelStyle: TextStyle(
                              fontSize: 18.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (input) => _priority == null ? 'Please Select a Prioirity level' : null,
                          onSaved: (input) => _priority = input,
                          onChanged: (value){
                            setState(() {
                              _priority = value;
                            });
                          },
                          value: _priority,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.0)
                        ),
                        child: FlatButton(child: Text('Add', style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),),
                        onPressed: _submit,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
