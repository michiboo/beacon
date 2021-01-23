import "package:flutter/material.dart";

import 'avatar.dart';
import 'messages.dart';
import 'store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await Store.createStore();

  // for (int i = 0; i < 5; i++) {
  //   await store.handleMessage(Message(
  //     id: "message_${i}_2",
  //     timestamp: DateTime.now().add(Duration(seconds: i)),
  //     fromId: "User$i",
  //     toId: "UserMe",
  //     data: "Second Message from $i",
  //   ));
  //   await store.handleMessage(Message(
  //     id: "broadcast_message_${i}_2",
  //     timestamp: DateTime.now().add(Duration(seconds: i)),
  //     fromId: "User$i",
  //     toId: "",
  //     data: "Second Broadcast Message from $i"
  //   ));
  // }

  runApp(ChatApp(store: store));
}

class ChatApp extends StatelessWidget {
  final Store store;

  const ChatApp({Key key, this.store}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: "Beacon",
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepOrange,
          // primarySwatch: Colors.pink,
          // accentColor: Colors.pink,
        ),
        // theme: ThemeData.light(),
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        // ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Beacon"),
      ),
      body: ListView.builder(
        itemBuilder: (context, i) {
          return ListTile(
            leading: Avatar(user: "$i", size: 40.0),
            title: Text("User $i"),
            subtitle: Text("Last message"),
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(builder: (context) {
                return new ChatPage(userId: "$i");
              }));
            },
          );
        },
        itemCount: 5,
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final String userId;

  const ChatPage({Key key, this.userId}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      Message(
        id: "id1",
        data:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a "
            "felis vitae purus sodales varius. Etiam nunc urna, dignissim et"
            " quam in, imperdiet accumsan magna. Etiam sodales tempor eros eu cursus.",
        timestamp: DateTime.now(),
        fromId: widget.userId,
        toId: "",
      )
    ];
  }

  void _send(Message newMessage) {
    setState(() => _messages.insert(0, newMessage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Beacon"),
      ),
      body: SafeArea(
        child: MessageList(
          currentUserId: "1",
          messages: _messages,
          onMessageSend: _send,
        ),
      ),
    );
  }
}
