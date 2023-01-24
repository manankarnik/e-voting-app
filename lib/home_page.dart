import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'auth.dart';
import 'firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage(this.phoneNumber, {super.key});
  final String phoneNumber;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String title = 'Home';

  Widget getWidget(data) {
    switch (selectedIndex) {
      case 0:
        return Column(
          children: [
            Card(
              elevation: 0,
              color: Colors.grey[200],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 70,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Welcome,\n${data["FullName"]}',
                      style: TextStyle(
                          fontSize: 30,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                () {
                  if (data["Voted"]) {
                    return 'You have already cast your vote!';
                  }
                  return 'You have not cast your vote!\nCast your vote by navigating to the Vote tab';
                }(),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              children: const [
                SizedBox(
                  height: 18,
                ),
                Chart(),
                SizedBox(
                  width: 28,
                ),
              ],
            ),
          ],
        );
      case 1:
        return Text(
          'Vote',
          style: TextStyle(
              fontSize: 30,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        );
      default:
        return Text(
          'Settings',
          style: TextStyle(
              fontSize: 30,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () => signOut(context),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: FutureBuilder(
        future: getUser(widget.phoneNumber),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: getWidget(
                    snapshot.data,
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_vote_rounded),
            label: 'Vote',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              setState(() => title = 'Home');
              break;
            case 1:
              setState(() => title = 'Vote');
              break;
            default:
              setState(() => title = 'Settings');
          }
          setState(() => selectedIndex = index);
        },
      ),
    );
  }
}

class Chart extends StatefulWidget {
  const Chart({
    Key? key,
  }) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              'Vote Chart',
              style: TextStyle(
                  fontSize: 30,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 80,
                  sections: showingSections(),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Indicator(
                  color: Color(0xff0293ee),
                  text: 'First',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xfff8b250),
                  text: 'Second',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xff845bef),
                  text: 'Third',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xff13d38e),
                  text: 'Fourth',
                  isSquare: true,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        default:
          throw Error();
      }
    });
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
