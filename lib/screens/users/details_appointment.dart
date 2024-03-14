import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../provider/api/links.dart';
import '../../provider/users/users_provider.dart';
import '../helper/show_dialog.dart';
import '../helper/text_form_field.dart';

Color blueColor = const Color.fromARGB(255, 35, 107, 254);

Color whiteColor = Colors.white;
Color? greyColor = Colors.grey[500];
Color? greenColor = Colors.green;
Color? amberColor = Colors.amber;

class DetailsAppointment extends StatelessWidget {
  final Map<String, dynamic> appointmentIndex;
  const DetailsAppointment({super.key, required this.appointmentIndex});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          title: const Text("تعديل الحجز"),
        ),
        body: Container(
          padding: const EdgeInsets.all(15.0),
          color: Colors.grey[300],
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              DoctorDetailsHeader(appointmentIndex: appointmentIndex),
              AvailableDays(appointmentIndex: appointmentIndex),
              AvailableTimes(appointmentIndex: appointmentIndex),
              Description(appointmentIndex: appointmentIndex),
              Phone(appointmentIndex: appointmentIndex),
              BookingButton(appointmentIndex: appointmentIndex),
            ],
          ),
        ),
      ),
    );
  }
}

class DoctorDetailsHeader extends StatelessWidget {
  final Map<String, dynamic> appointmentIndex;
  const DoctorDetailsHeader({super.key, required this.appointmentIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              "$linkServerName/users_images/${appointmentIndex['url']}",
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width / 2,
              fit: BoxFit.fill,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Text("${appointmentIndex['name']}"),
        const SizedBox(height: 10.0),
      ],
    );
  }
}

class AvailableDays extends StatelessWidget {
  final Map<String, dynamic> appointmentIndex;
  const AvailableDays({super.key, required this.appointmentIndex});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<UsersProvider>(context, listen: true);

    var workTodays = appointmentIndex['workTodays'].split(",");
    //convert from string into date time
    DateTime selectedDay = DateTime.parse(appointmentIndex['selectedDay']);
    List<int> activeWorkdays = [];

    for (var i = 0; i < workTodays.length; i++) {
      switch (workTodays[i]) {
        case 'السبت':
          activeWorkdays.add(DateTime.saturday);
          break;
        case 'الاحد':
          activeWorkdays.add(DateTime.sunday);
          break;
        case 'الاثنين':
          activeWorkdays.add(DateTime.monday);
          break;
        case 'الثلاثاء':
          activeWorkdays.add(DateTime.tuesday);
          break;
        case 'الاربعاء':
          activeWorkdays.add(DateTime.wednesday);
          break;
        case 'الخميس':
          activeWorkdays.add(DateTime.thursday);
          break;

        default:
          activeWorkdays.add(DateTime.friday);
          break;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30.0),
        const Text(
          "ايام العمل",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30.0),
        Container(
          color: whiteColor,
          child: TableCalendar(
            calendarStyle: CalendarStyle(
              selectedDecoration:
                  BoxDecoration(color: greenColor, shape: BoxShape.circle),
            ),
            locale: 'ar_IQ',
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            focusedDay:
                model.isSelectedDay == false ? selectedDay : model.focusedDay,
            firstDay: DateTime(2023),
            lastDay: DateTime(2030),
            selectedDayPredicate: (day) {
              return isSameDay(
                  model.isSelectedDay == false
                      ? selectedDay
                      : model.selectedDay,
                  day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              model.selectDayFromCalender(selectedDay, focusedDay);
            },
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: greyColor),
              weekendStyle: TextStyle(color: greenColor),
            ),
            daysOfWeekHeight: 30.0,
            weekendDays: activeWorkdays,
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, _) {
                return Text(
                  '${date.day}',
                  style: TextStyle(color: greyColor),
                );
              },
              disabledBuilder: (context, date, _) {
                // Disable selection of inactive days And past days
                if (!activeWorkdays.contains(date.weekday) ||
                    date.isBefore(DateTime.now())) {
                  return Container();
                }

                return null;
              },
            ),
            enabledDayPredicate: (date) {
              // Enable interaction only with active days
              return activeWorkdays.contains(date.weekday) &&
                  !date.isBefore(DateTime.now());
            },
          ),
        ),
      ],
    );
  }
}

class AvailableTimes extends StatelessWidget {
  final Map<String, dynamic> appointmentIndex;

  const AvailableTimes({super.key, required this.appointmentIndex});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<UsersProvider>(context, listen: true);
    final startTime = appointmentIndex['startTime'];

    final endTime = appointmentIndex['endTime'];
    List availableTimes = [];
    for (var i = startTime; i <= endTime; i++) {
      availableTimes.add("$i:00");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30.0),
        const Text(
          "الاوقات المتاحة للحجز",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: availableTimes.length,
            itemBuilder: (BuildContext context, int index) {
              String time = availableTimes[index].toString();
              bool isSelected = model.selectedTime.isNotEmpty
                  ? model.selectedTime == time
                  : appointmentIndex['selectedTime'] == time;

              //Set Initial value for selectedTime Field
              model.selectedTime.isEmpty
                  ? model.selectedTime = appointmentIndex['selectedTime']
                  : appointmentIndex['selectedTime'] == time;

              return InkWell(
                onTap: () {
                  model.toggleSelectTime(time);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? greenColor : whiteColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    "${availableTimes[index]}",
                    style: TextStyle(
                      color: isSelected ? whiteColor : greyColor,
                    ),
                  ),
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 5.0,
              childAspectRatio: 2.0,
            ),
          ),
        ),
      ],
    );
  }
}

class Description extends StatelessWidget {
  final Map<String, dynamic> appointmentIndex;

  const Description({super.key, required this.appointmentIndex});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<UsersProvider>(context, listen: true);
    model.appointmentDescriptionUp.text = appointmentIndex['description'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30.0),
        const Text(
          "الوصف",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10.0),
        textFormField(model.appointmentDescriptionUp, 200, 5, whiteColor,
            TextInputType.text),
      ],
    );
  }
}

class Phone extends StatelessWidget {
  final Map<String, dynamic> appointmentIndex;

  const Phone({super.key, required this.appointmentIndex});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<UsersProvider>(context, listen: true);
    model.appointmentPhoneUp.text = appointmentIndex['phone'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "الهاتف",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10.0),
        textFormField(
            model.appointmentPhoneUp, 11, 1, whiteColor, TextInputType.phone),
        const SizedBox(height: 30.0),
      ],
    );
  }
}

class BookingButton extends StatelessWidget {
  final Map<String, dynamic> appointmentIndex;
  const BookingButton({super.key, required this.appointmentIndex});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<UsersProvider>(context, listen: true);

    void showDialog(String resultMessage) {
      DialogHelper.myDialog(context, resultMessage, 'pop');
    }

    void showLoading() {
      DialogHelper.showLoadingIndicator(context);
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: greenColor,
        foregroundColor: whiteColor,
      ),
      onPressed: () async {
        showLoading();
        await model.updateAppointment(
            appointmentIndex['id'], appointmentIndex['randomIdDoctor']);
        showDialog(model.resultMessage);
      },
      child: const Text(
        "تعديل الحجز",
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
