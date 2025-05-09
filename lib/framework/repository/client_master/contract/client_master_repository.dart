abstract class ClientMasterRepository {
    ///add client Api
    Future addClientApi(String request,bool isEdit);

    Future clientDetailsApi(String clientId);

}

