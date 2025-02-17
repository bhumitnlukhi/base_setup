
import 'package:flutter/material.dart';

abstract class AuthenticationRepository {

  Future loginApi(BuildContext context, Map<String, dynamic> request);

}