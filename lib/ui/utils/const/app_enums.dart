enum ScreenName {
  login,
  dashboard,
  wallet,
  stores,
  ticket,
  ads,
  purchaseAds,
  faq
}

/// Page error
enum ErrorType { error403, error404, noInternet }

enum MediaTypeEnum {image,video}
enum AdsForEnum {yourself,client}

enum ContentLengthEnum {ten,fifteen,thirty}
final List imageExt =  ["jpeg", "jpg", 'png', 'raw', 'mp4'];


enum PopUpFor {
  none
}

enum AccountStatus{
  ACTIVE,
  NEW,
  REJECTED,
  PENDING,
  INACTIVE,
}

enum CmsType {
  aboutUs,
  privacyPolicy,
  termsAndCondition,
  // faq,
  // returnPolicy,
  // cancellationPolicy,
  // none,
}

enum LanguageSelectionEnum {
  en,
  ar
}

enum UserType{
  AGENCY,VENDOR,STORE
}

final userTypeValue = EnumValues({
  'AGENCY':UserType.AGENCY,
  'VENDOR':UserType.VENDOR,
});

enum SampleItem { itemOne }

enum OrderType { all, order, services, favourite}

enum TicketStatus {ALL,PENDING,ACKNOWLEDGED,RESOLVED}

///Order Statues
enum OrdersStatusEnum { RESOLVED, ACKNOWLEDGED, PENDING, ACCEPTED, PREPARED, DISPATCH, PARTIALLY_DELIVERED, DELIVERED, REJECTED, CANCELED, IN_TRAY, ROBOT_CANCELED }

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

enum ticketStatus{
  PENDING,
  ACKNOWLEDGED,
  RESOLVED
}

enum TransactionType{
  CREDIT,DEBIT,ALL
}