abstract class TicketRepository {
    /// create ticket
    Future createTicket({required String request});

    /// get ticket reason list
    Future getTicketReasonList({required String request});

    /// ticket List api
    Future ticketList({required String request, required  int pageNumber});

    /// ticket detail api
    Future ticketDetail({required String ticketId});

    /// create ticket
    Future faqListAPI({required String request,required int pageNo});

}

