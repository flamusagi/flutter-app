

import 'package:flutter/material.dart';

int currentIndex = 0;
BottomNavigationBar buildBottomNavigationBar(BuildContext context) {
  return BottomNavigationBar(

    currentIndex: currentIndex,
    onTap: (int index){
      print(index);
      currentIndex=index;
      if(index==0){
        Navigator.of(context, rootNavigator: true).pushNamed("/Home");
      }else if(index==1){

      }else if(index==2){

      }else if(index==3){
        Navigator.of(context, rootNavigator: true).pushNamed("/News");

      }
    },
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.message),
        label: '消息',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.video_call),
        label: '小世界',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.contacts),
        label: '联系人',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.dynamic_feed),
        label: '动态',
      ),
    ],
    type: BottomNavigationBarType.fixed, // 使用fixed类型
  );
}
