part of 'splash_bloc.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

 class SplashLoading extends SplashState{}

 class SplashLoded extends SplashState{}