import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seaaegis/providers/beach_data_provider.dart';

class CalendarWidget extends StatefulWidget {
  final BeachDataProvider provider;
  const CalendarWidget({super.key, required this.provider});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Scroll to the default selected index on first load
      scrollToSelectedIndex();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToSelectedIndex() {
    double offset = widget.provider.selectedIndex * 85.0;
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        // color: Color.fromARGB(255, 76, 162, 237),
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40), bottomLeft: Radius.circular(40)),
      ),
      height: 80,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          DateTime date = widget.provider.today.add(Duration(days: index - 1));
          String dayOfWeek = DateFormat('EEEE').format(date);
          String day = DateFormat('MM/dd').format(date);

          bool isSelected = widget.provider.selectedIndex == index;

          return GestureDetector(
            onTap: () {
              widget.provider.setSelectedIndex(index);
              scrollToSelectedIndex();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayOfWeek,
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.grey.shade100,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [
                                Color(0xFFD656EC),
                                Color(0xFF29B6F6),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(20),
                      color: isSelected ? null : Colors.grey.shade200,
                    ),
                    child: Text(
                      day,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
