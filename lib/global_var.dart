import 'package:flutter/material.dart';

int paddingSize = 3;
int blockViewRow = 20;
int blockViewCol = 10;
int blockRow = blockViewRow+paddingSize*2;
int blockCol = blockViewCol+paddingSize*2;

bool gamePause = false;
bool gameOver = false;

int speed = 2;
bool isClockwise = false;
Color activeBlockColor = Colors.purple;
Color deadBlockColor = Colors.black;
Color emptyBlockColor = Colors.grey;
Color backgroundColor = Colors.white;

int score = 0;
int highestScore = 0;
int eliminatedLines = 0;

int levelThreshold = 9999;
int nextPattern = 0;
