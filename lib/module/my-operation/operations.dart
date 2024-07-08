import 'package:elektra_fit/global/global-models.dart';
import 'package:elektra_fit/global/index.dart';
import 'package:flutter/material.dart';

import '../../widget/index.dart';

class MyOperations extends StatefulWidget {
  const MyOperations({super.key});

  @override
  State<MyOperations> createState() => _MyOperationsState();
}

class _MyOperationsState extends State<MyOperations> {
  final service = GetIt.I<MyOperationsService>();
  late double screenHeight;
  late double screenWidth;

  @override
  void initState() {
    super.initState();
    service.spaInfo();
  }

  @override
  void dispose() {
    service.selectDateAvailability$.add(null);
    service.spaService$.add(null);
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              background: Colors.white,
              primary: config.primaryColor,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      service.selectDateAvailability$.add(picked);
      service.availability(picked);
    }
  }

  Future<dynamic> selectedHours(BuildContext context, double W, SpaService? item, double H) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(5),
          height: screenHeight * 0.7,
          width: screenWidth,
          child: StreamBuilder(
            stream: service.availabilityHours$.stream,
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Select Your Reservation Time".tr(), style: kMontserrat18),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.cancel, color: Colors.red, size: screenWidth / 12),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: Rx.combineLatest2(service.availabilityHours$, service.selectedHours$, (a, b) => null),
                      builder: (context, snapshot) {
                        if (service.availabilityHours$.value == null) {
                          return Center(child: CircularProgressIndicator(color: config.primaryColor));
                        } else if (service.availabilityHours$.value!.isEmpty) {
                          return const Center(child: Text("no found"));
                        }
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                          itemCount: service.availabilityHours$.value!.length,
                          itemBuilder: (context, index) {
                            var e = service.availabilityHours$.value![index];
                            bool selected = service.selectedHours$.value == e?.workHours;
                            return InkWell(
                              onTap: () {
                                service.selectedHours$.add(e!.workHours);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: selected ? config.primaryColor : Colors.black, width: selected ? 3 : 1),
                                  borderRadius: BorderRadius.circular(10),
                                  color: selected ? config.primaryColor.withOpacity(0.3) : Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    "${e?.workHours}",
                                    style: kProxima18,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom, left: 10, right: 10),
                    child: CButton(
                      title: "Continue".tr(),
                      func: () {
                        if (service.selectedHours$.value != "") {
                          Navigator.push(
                            context,
                            RouteAnimation.createRoute(
                              ReservationCreate(
                                spaService: item!,
                                resStart: service.selectDateAvailability$.value!,
                                selectedHours: service.selectedHours$.value,
                              ),
                              1,
                              0,
                            ),
                          );
                        } else {
                          kShowBanner(BannerType.ERROR, "Please select the seans time".tr(), context);
                        }
                      },
                      width: screenWidth,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: service.selectDateAvailability$.stream,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(title: Text("My Operations".tr()), actions: [
            Padding(
                padding: EdgeInsets.all(10),
                child: InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOperationDetail())),
                  child: Icon(Icons.menu, color: Colors.white, size: screenWidth / 14),
                ))
          ]),
          body: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: config.primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.date_range_outlined, size: screenWidth / 15, color: config.primaryColor),
                        service.selectDateAvailability$.value == null ? SizedBox(width: screenWidth / 7) : SizedBox(width: screenWidth / 4),
                        Text(
                          service.selectDateAvailability$.value == null
                              ? "Please choose the date".tr()
                              : DateFormat("dd MMMM yyyy").format(service.selectDateAvailability$.value!),
                          style: kAxiforma18.copyWith(color: config.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: service.spaService$,
                  builder: (context, snapshot) {
                    if (service.spaService$.value == null) {
                      return Center(child: CircularProgressIndicator(color: config.primaryColor));
                    } else if (service.spaService$.value!.isEmpty) {
                      return Center(child: Text("no found", style: kProxima17));
                    }
                    return SizedBox(
                      height: screenHeight * 0.78,
                      child: ListView.builder(
                        itemCount: service.spaService$.value?.length,
                        itemBuilder: (context, index) {
                          var item = service.spaService$.value?[index];
                          return Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${item?.product}", style: kAxiforma17),
                                    Text("${item?.price.toStringAsFixed(2)} ${item?.currency}", style: kProxima18),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    if (service.selectDateAvailability$.value != null) {
                                      selectedHours(context, screenWidth, item, screenHeight);
                                    } else {
                                      kShowBanner(BannerType.ERROR, "Please select the date".tr(), context);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: config.primaryColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text("Choose".tr(), style: kProxima18.copyWith(color: config.primaryColor)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}