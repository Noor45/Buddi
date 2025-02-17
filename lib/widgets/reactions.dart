import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter/material.dart';
import 'package:buddi/utils/strings.dart';

Widget _buildReactionsPreviewIcon(String path) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Image.asset(path, height: 25),
    );

Widget _buildReactionsIcon(String path) => Container(
      color: Colors.transparent,
      child: Image.asset(path, height: 20),
    );

final reactions = [
  Reaction(
    value: '0',
    previewIcon: _buildReactionsPreviewIcon(StringRefer.kLikeReaction),
    icon: _buildReactionsIcon(StringRefer.kLikeReaction),
  ),
  Reaction(
    value: '1',
    previewIcon: _buildReactionsPreviewIcon(StringRefer.kDisLikeReaction),
    icon: _buildReactionsIcon(StringRefer.kDisLikeReaction),
  ),
  Reaction(
    value: '2',
    previewIcon: _buildReactionsPreviewIcon(StringRefer.kOpenMouthReaction),
    icon: _buildReactionsIcon(
      StringRefer.kOpenMouthReaction,
    ),
  ),
  Reaction(
    value: '3',
    previewIcon: _buildReactionsPreviewIcon(StringRefer.kTearOfJoyReaction),
    icon: _buildReactionsIcon(
      StringRefer.kTearOfJoyReaction,
    ),
  ),
  Reaction(
    value: '4',
    previewIcon: _buildReactionsPreviewIcon(StringRefer.kHeartEyesReaction),
    icon: _buildReactionsIcon(
      StringRefer.kHeartEyesReaction,
    ),
  ),
  Reaction(
    value: '5',
    previewIcon: _buildReactionsPreviewIcon(StringRefer.kSadReaction),
    icon: _buildReactionsIcon(
      StringRefer.kSadReaction,
    ),
  ),
  Reaction(
    value: '6',
    previewIcon: _buildReactionsPreviewIcon(StringRefer.kClapReaction),
    icon: _buildReactionsIcon(
      StringRefer.kClapReaction,
    ),
  ),
];
