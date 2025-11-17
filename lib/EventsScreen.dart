import 'package:flutter/material.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07856),
        elevation: 0,
        title: const Text("الفعاليات", style: TextStyle(color: Colors.white)),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.search, color: Colors.white),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16, left: 16),
            child: Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "عرض حسب: القائمة",
                  style: TextStyle(fontSize: 20, color: Color(0xFF354152)),
                ),
                Icon(Icons.filter_list, color: Colors.black54),
              ],
            ),
          ),

          // TabBar
          TabBar(
            controller: tabController,
            labelColor: Colors.brown.shade400,
            unselectedLabelColor: const Color(0xFFA07856),
            indicatorColor: Colors.brown.shade400,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            tabs: const [
              Tab(text: "الفعاليات القادمة"),
              Tab(text: "فعالياتي"),
              Tab(text: "الفعاليات السابقة"),
            ],
          ),

          // Tabs content
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [_emptyState(), _emptyState(), _emptyState()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_month, size: 120, color: Color(0xFFA07856)),
          SizedBox(height: 20),

          Text(
            "لا يوجد لديك بطاقات حاليا",
            style: TextStyle(
              fontSize: 16,
              color: Colors.brown.shade400,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
