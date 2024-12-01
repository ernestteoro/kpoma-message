import 'package:flutter/material.dart';
import 'package:kpoma_messaging/provider/authentication_provider.dart';
import 'package:kpoma_messaging/provider/user_page_provider.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:kpoma_messaging/widget/top_bar.dart';
import 'package:kpoma_messaging/widget/custom_input_field.dart';
import 'package:kpoma_messaging/widget/custom_list_view_tiles.dart';
import 'package:kpoma_messaging/widget/rounded_button.dart';

import 'package:kpoma_messaging/models/user.dart';
import 'package:kpoma_messaging/provider/user_page_provider.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage> {
  double _deviceHeight;
  double _deviceWidth;
  final _registerFormKey = GlobalKey<FormState>();
  AuthenticationProvider _authenticationProvider;
  UsersPageProvider _usersPageProvider;
  TextEditingController _searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
            create: (_) => UsersPageProvider(_authenticationProvider))
      ],
      child: buildUI(),
    );
  }

  // function to build
  buildUI() {
    return Builder(builder: (BuildContext _context) {
      _usersPageProvider = _context.watch<UsersPageProvider>();
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.02),
        width: _deviceWidth * 0.97,
        height: _deviceHeight * 0.98,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            TopBar(
              "Users",
              primaryAction: IconButton(
                icon: Icon(Icons.logout),
                color: Color.fromRGBO(0, 82, 218, 1.0),
                onPressed: () {
                  _authenticationProvider.logOut();
                },
              ),
            ),
            CustomTextField(
              editingController: _searchFieldController,
              obscureText: false,
              hintText: "Search user ...",
              icon: Icons.search,
            ),
            _userList(),
            createChatButton(),
          ],
        ),
      );
    });
  }

  // function to display user list
  Widget _userList() {
    List<Users> _users = _usersPageProvider.users;
    return Expanded(child: () {
      if (_users != null) {
        if (_users.isNotEmpty) {
          return ListView.builder(
              itemCount: _users.length,
              itemBuilder: (BuildContext _context, int index) {
                Users user = _users[index];
                return CustomListViewTile(
                  height: _deviceHeight * 0.10,
                  title: user.name,
                  subTitle: "Last Active ${user.lastActive}",
                  imagePath: user.imageUrl,
                  isActive: user.wasRecentlyActive(),
                  isSelected:
                      _usersPageProvider.getSelectedUsers().contains(user),
                  onTap: () {
                    _usersPageProvider.updateSelectedUsers(user);
                  },
                );
              });
        } else {
          return Center(
            child: Text(
              "No users",
              style: TextStyle(color: Colors.white),
            ),
          );
        }
      } else {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      }
    }());
  }

  Widget createChatButton() {
    List<Users> selectedUsers = _usersPageProvider.getSelectedUsers();
    return Visibility(
        visible: selectedUsers.isNotEmpty,
        child: RoundedButton(
          name: selectedUsers.length == 1 ?
              "Chat with ${selectedUsers.first.name}"
              : "Create Group chat",
          height: _deviceHeight * 0.08,
          width: _deviceWidth * 0.80,
          onPressed: () {
            _usersPageProvider.createChat();
          },
        )
    );

  }
}
