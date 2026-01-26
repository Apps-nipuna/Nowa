import 'package:flutter/material.dart';
import 'package:orsa_3/models/event_model.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@NowaGenerated()
class Events extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const Events({super.key});

  @override
  State<Events> createState() {
    return _EventsState();
  }
}

@NowaGenerated()
class _EventsState extends State<Events> {
  DateTime _selectedDate = DateTime.now();

  late Future<List<EventModel>> eventsFuture;

  bool canCreateContent = false;

  Future<List<EventModel>> _fetchEvents() async {
    final response = await Supabase.instance.client.from('events').select();
    return (response as List)
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<EventModel> _getEventsForDate(List<EventModel> events) {
    return events.where((event) {
      final eventDate = DateTime.parse(event.eventDate).toLocal();
      return eventDate.year == _selectedDate.year &&
          eventDate.month == _selectedDate.month &&
          eventDate.day == _selectedDate.day;
    }).toList();
  }

  void _previousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
    });
  }

  Widget _buildCalendarGrid(List<EventModel> events) {
    final firstDay = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDay = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    final daysInMonth = lastDay.day;
    final startingWeekday = firstDay.weekday;
    final dayNames = ['SU.', 'M.', 'TU.', 'W.', 'TH.', 'F.', 'SA.'];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: dayNames.map((day) {
            final isWeekend =
                dayNames.indexOf(day) == 0 || dayNames.indexOf(day) == 6;
            return SizedBox(
              width: 50,
              child: Center(
                child: Text(
                  day,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isWeekend
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: 42,
          itemBuilder: (context, index) {
            final dayNumber = index - startingWeekday + 2;
            if (dayNumber < 1 || dayNumber > daysInMonth) {
              return const SizedBox();
            }
            final date = DateTime(
              _selectedDate.year,
              _selectedDate.month,
              dayNumber,
            );
            final isSelected = dayNumber == _selectedDate.day;
            final hasEvent = events.any((event) {
              final eventDate = DateTime.parse(event.eventDate).toLocal();
              return eventDate.year == date.year &&
                  eventDate.month == date.month &&
                  eventDate.day == date.day;
            });
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = date;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : hasEvent
                      ? Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withValues(alpha: 0.5)
                      : Colors.transparent,
                  border: isSelected
                      ? Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        )
                      : hasEvent
                      ? Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    dayNumber.toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : (dayNumber <= 1 || index % 7 == 6)
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showEventDetails(BuildContext context, EventModel event) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    event.eventName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow(
                    context,
                    Icons.calendar_today,
                    'Date & Time',
                    _formatEventDateTime(event.eventDate),
                  ),
                  const SizedBox(height: 16),
                  if (event.venue != null && event.venue!.isNotEmpty)
                    _buildDetailRow(
                      context,
                      Icons.location_on,
                      'Venue',
                      event.venue!,
                    ),
                  if (event.venue != null && event.venue!.isNotEmpty)
                    const SizedBox(height: 16),
                  if (event.description != null &&
                      event.description!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event.description!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Close',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = const [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER',
    ];
    return months[month - 1];
  }

  String _formatDateLabel(DateTime date) {
    const months = const [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  String _formatEventDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();
      const months = const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      final formattedDate =
          '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
      final formattedTime =
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      return '${formattedDate} at ${formattedTime}';
    } catch (e) {
      return dateTimeString;
    }
  }

  Future<void> _checkUserPermissions() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final response = await Supabase.instance.client
            .from('profiles')
            .select('user_role, position')
            .eq('id', user.id)
            .single();
        final userRole = response['user_role'] as String? ?? '';
        final position = response['position'] as String? ?? '';
        if (mounted) {
          setState(() {
            canCreateContent =
                userRole == 'admin' ||
                position == 'President' ||
                position == 'Secretary';
          });
        }
      }
    } catch (e) {
      print('Error checking permissions: ${e}');
    }
  }

  @override
  void initState() {
    super.initState();
    eventsFuture = _fetchEvents();
    _checkUserPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<EventModel>>(
          future: eventsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No events found',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }
            final events = snapshot.data;
            final selectedDateEvents = _getEventsForDate(events!);
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed: _previousMonth,
                            ),
                            Center(
                              child: Text(
                                '${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: _nextMonth,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onHorizontalDragEnd: (details) {
                            if (details.primaryVelocity! > 0) {
                              _previousMonth();
                            } else {
                              if (details.primaryVelocity! < 0) {
                                _nextMonth();
                              }
                            }
                          },
                          child: _buildCalendarGrid(events!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _formatDateLabel(_selectedDate),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (selectedDateEvents.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'No events on this date',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: selectedDateEvents.length,
                        itemBuilder: (context, index) {
                          final event = selectedDateEvents[index];
                          return _EventCard(
                            event: event,
                            onTap: () => _showEventDetails(context, event),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (canCreateContent)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText:
                                    'Add event on ${_formatDateLabel(_selectedDate)}',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          FloatingActionButton(
                            onPressed: () {},
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.secondary,
                            child: Icon(
                              Icons.add,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: canCreateContent
          ? FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('New event action'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : null,
    );
  }
}

@NowaGenerated()
class _EventCard extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const _EventCard({required this.event, required this.onTap, super.key});

  final EventModel event;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final eventDate = DateTime.parse(event.eventDate).toLocal();
    final isAllDay = eventDate.hour == 0 && eventDate.minute == 0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.eventName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isAllDay ? 'All day' : _formatTime(eventDate),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '3',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
