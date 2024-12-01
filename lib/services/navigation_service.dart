import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey= GlobalKey<NavigatorState>();

  // function to remove the current page and push a page on top
  void removeAndNavigateToRoute(String _route){
    navigatorKey.currentState?.popAndPushNamed(_route);
  }

  // function to push a page on top of another
  void navigateToRoute(String _route){
    navigatorKey.currentState?.pushNamed(_route);
  }

  // function to navigate to page
  void navigateToPage(Widget _page){
    navigatorKey.currentState?.push(MaterialPageRoute(builder: (BuildContext _context){
      return _page;
    }));
  }

  // function to navigate back to where we are from
  void goBack(){
      navigatorKey.currentState?.pop();
  }

}