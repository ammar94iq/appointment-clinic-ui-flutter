import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../provider/users/users_provider.dart';
import '../helper/show_dialog.dart';
import '../helper/text_form_field.dart';

Color blueColor = const Color.fromARGB(255, 35, 107, 254);

Color whiteColor = Colors.white;
Color? greyColor = Colors.grey[500];
Color? greenColor = Colors.green;

class AddAppointment extends StatelessWidget {
  final Map<String, dynamic> detailsDoctor;
  const AddAppointment({super.key, required this.detailsDoctor});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          title: const Text("حجز الموعد"),
        ),
        body: Container(
          padding: const EdgeInsets.all(15.0),
          color: Colors.grey[300],
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              AvailableDays(detailsDoctor: detailsDoctor),
              AvailableTimes(detailsDoctor: detailsDoctor),
              const Description(),
              const Phone(),
              BookingButton(detailsDoctor: detailsDoctor),
            ],
          ),
        ),
      ),
    );
  }
}

class AvailableDays extends StatelessWidget {
  final Map<String, dynamic> detailsDoctor;
  const AvailableDays({super.key, required this.detailsDoctor});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<UsersProvider>(context, listen: true);

    var workTodays = detailsDoctor['workTodays'].split(",");

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
            focusedDay: model.focusedDay,
            firstDay: DateTime(2023),
            lastDay: DateTime(2030),
            selectedDayPredicate: (day) {
              return isSameDay(model.selectedDay, day);
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
  final Map<String, dynamic> detailsDoctor;

  const AvailableTimes({super.key, required this.detailsDoctor});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<UsersProvider>(context, listen: true);
    final startTime = detailsDoctor['startTime'];
    final endTime = detailsDoctor['endTime'];

    // Function to get the AM/PM designation from a time string
    String getPeriod(String time) {
      final parts = time.split(' ');
      return parts[1]; // Extract AM/PM designation
    }

    final startPeriod = getPeriod(startTime);
    final endPeriod = getPeriod(endTime);

    // Parse the hours from the start and end times
    final startHour = int.parse(startTime.split(':')[0]);
    final endHour = int.parse(endTime.split(':')[0]);

    List<String> availableTimes = [];

    // Loop through each hour and add to availableTimes
    if (startPeriod == endPeriod) {
      // If both start and end times are in the same period (AM or PM)
      for (int i = startHour; i <= endHour; i++) {
        final hour = i % 12 == 0 ? 12 : i % 12;
        availableTimes.add('$hour:00 $startPeriod');
      }
    } else {
      // If start and end times are in different periods (AM to PM transition)
      for (int i = startHour; i <= 12; i++) {
        final hour = i % 12 == 0 ? 12 : i % 12;
        availableTimes.add('$hour:00 $startPeriod');
      }
      for (int i = 1; i <= endHour; i++) {
        final hour = i % 12 == 0 ? 12 : i % 12;
        availableTimes.add('$hour:00 $endPeriod');
      }
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
              bool isSelected = model.selectedTime == time;

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
                    availableTimes[index],
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
  const Description({super.key});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<UsersProvider>(context, listen: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30.0),
        const Text(
          "الوصف",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10.0),
        textFormField(model.appointmentDescription, 200, 5, whiteColor,
            TextInputType.text),
      ],
    );
  }
}

class Phone extends StatelessWidget {
  const Phone({super.key});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<UsersProvider>(context, listen: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "الهاتف",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10.0),
        textFormField(
            model.appointmentPhone, 11, 1, whiteColor, TextInputType.phone),
        const SizedBox(height: 30.0),
      ],
    );
  }
}

class BookingButton extends StatelessWidget {
  final Map<String, dynamic> detailsDoctor;
  const BookingButton({super.key, required this.detailsDoctor});

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
        await model.addAppointment(detailsDoctor['randomId'].toString());
        showDialog(model.resultMessage);
      },
      child: const Text(
        "حجز الموعد",
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
