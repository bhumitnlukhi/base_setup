import 'package:flutter/material.dart';

abstract class MasterRepository {
    ///business category  Api
    Future businessCategoryApi(BuildContext context, int pageNumber,String request);

    ///Country api
    Future countryListApi(BuildContext context, int pageNumber,String request);
    ///State api
    Future stateListApi(BuildContext context, int pageNumber,String request);
    ///city api
    Future cityListApi(BuildContext context, int pageNumber,String request);

}

