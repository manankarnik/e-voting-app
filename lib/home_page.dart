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

  void votedCallback() {
    setState(() => {selectedIndex = 0, title = 'Home'});
  }

  Widget getWidget(data) {
    switch (selectedIndex) {
      case 0:
        return Column(
          children: [
            Card(
              elevation: 0,
              color: Colors.blue[100],
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
              child: () {
                if (data["Voted"]) {
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.green[100],
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green[600],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'You have successfully cast your vote!',
                            style: TextStyle(
                                color: Colors.green[600], fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.yellow[50],
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.warning,
                            color: Colors.yellow[700],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'You have not cast your vote!\nCast your vote by navigating to the Vote tab',
                            style: TextStyle(
                                color: Colors.yellow[700], fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }(),
            ),
            Column(
              children: const [
                SizedBox(
                  height: 10,
                ),
                Chart(),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
        );
      default:
        return Column(
          children: [
            Text(
              'Vote for Your Desired Party',
              style: TextStyle(
                  fontSize: 28,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: getParties(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data
                        .map<Widget>(
                          (party) => Party(
                            partyName: party["Name"],
                            voted: data['Voted'],
                            phoneNumber: widget.phoneNumber,
                            callback: incrementVotes,
                            votedCallback: votedCallback,
                          ),
                        )
                        .toList(),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
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
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.blue[50],
        unselectedItemColor: Colors.black38,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_vote_rounded),
            label: 'Vote',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              setState(() => title = 'Home');
              break;
            default:
              setState(() => title = 'Vote');
              break;
          }
          setState(() => selectedIndex = index);
        },
      ),
    );
  }
}

class Party extends StatelessWidget {
  const Party({
    required this.partyName,
    required this.phoneNumber,
    required this.voted,
    required this.callback,
    required this.votedCallback,
    Key? key,
  }) : super(key: key);

  final String partyName;
  final String phoneNumber;
  final bool voted;
  final Function(String partyName, String phoneNumber, Function callback)
      callback;
  final Function votedCallback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.blue[100],
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(12),
                child: Image(
                  image: AssetImage('lib/images/voting.png'),
                  height: 40,
                ),
              ),
              Text(
                partyName,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              ElevatedButton(
                  onPressed: voted
                      ? null
                      : () async {
                          callback(partyName, phoneNumber, votedCallback);
                        },
                  child: Text(voted ? 'Already voted' : 'Vote'))
            ],
          ),
        ),
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
    return FutureBuilder(
      future: getParties(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List votes = [];
          for (final map_ in snapshot.data) {
            votes.add(map_['Votes']);
          }
          List votesPercent = votes
              .map((e) => (e / votes.reduce((a, b) => a + b) * 100))
              .toList();
          print(votesPercent);

          return Card(
            elevation: 0,
            color: Colors.blue[100],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    'Votes',
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
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
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
                          sections: showingSections(votes, votesPercent)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Indicator(
                          color: const Color(0xff0293ee),
                          text: snapshot.data[0]['Name'],
                          isSquare: true,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Indicator(
                          color: const Color(0xfff8b250),
                          text: snapshot.data[1]['Name'],
                          isSquare: true,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Indicator(
                          color: const Color(0xff845bef),
                          text: snapshot.data[2]['Name'],
                          isSquare: true,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Indicator(
                          color: const Color(0xff13d38e),
                          text: snapshot.data[3]['Name'],
                          isSquare: true,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Indicator(
                          color: const Color(0xfff5387a),
                          text: snapshot.data[4]['Name'],
                          isSquare: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  List<PieChartSectionData> showingSections(votes, votesPercent) {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 10.0;
      final radius = isTouched ? 90.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: votesPercent[i],
            title:
                '${votesPercent[i].toStringAsFixed(2)}%\n${votes[i]} vote(s)',
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
            value: votesPercent[i],
            title:
                '${votesPercent[i].toStringAsFixed(2)}%\n${votes[i]} vote(s)',
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
            value: votesPercent[i],
            title:
                '${votesPercent[i].toStringAsFixed(2)}%\n${votes[i]} vote(s)',
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
            value: votesPercent[i],
            title:
                '${votesPercent[i].toStringAsFixed(2)}%\n${votes[i]} vote(s)',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 4:
          return PieChartSectionData(
            color: const Color(0xfff5387a),
            value: votesPercent[i],
            title:
                '${votesPercent[i].toStringAsFixed(2)}%\n${votes[i]} vote(s)',
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
