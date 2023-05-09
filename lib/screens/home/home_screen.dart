import 'package:fit_raho/providers/firebase_auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

const List<HealthDataType> dataTypesAndroid = [
  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.BLOOD_OXYGEN,
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  HealthDataType.BODY_TEMPERATURE,
  HealthDataType.HEART_RATE,
  // HealthDataType.STEPS,

  // HealthDataType.MOVE_MINUTES, // TODO: Find alternative for Health Connect
  // HealthDataType.SLEEP_AWAKE,
  // HealthDataType.SLEEP_ASLEEP,
  // HealthDataType.SLEEP_IN_BED,

  HealthDataType.WATER,
];

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTHORIZED,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_DELETED,
  DATA_NOT_ADDED,
  DATA_NOT_DELETED,
  STEPS_READY,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  int _nofSteps = 0;
  static final types = dataTypesAndroid;
  final permissions = types.map((e) => HealthDataAccess.READ).toList();
  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  Future authorize() async {
    // If we are trying to read Step Count, Workout, Sleep or other data that requires
    // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
    // This requires a special request authorization call.
    //
    // The location permission is requested for Workouts using the Distance information.
    await Permission.activityRecognition.request();
    await Permission.location.request();

    // Check if we have permission
    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions);

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    hasPermissions = false;

    bool authorized = false;
    if (!hasPermissions) {
      // requesting access to the data types before reading them
      try {
        authorized =
            await health.requestAuthorization(types, permissions: permissions);
      } catch (error) {
        print("Exception in authorize: $error");
      }
    }

    setState(() => _state =
        (authorized) ? AppState.AUTHORIZED : AppState.AUTH_NOT_GRANTED);
  }

  // Fetch data points from the health plugin and show them in the app.
  Future fetchData() async {
    setState(() => _state = AppState.FETCHING_DATA);

    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(hours: 24));

    // Clear old data points
    _healthDataList.clear();

    try {
      // fetch health data
      List<HealthDataPoint> healthData =
          await health.getHealthDataFromTypes(yesterday, now, types);
      // save all the new data points (only the first 100)
      _healthDataList.addAll(
          (healthData.length < 100) ? healthData : healthData.sublist(0, 100));
    } catch (error) {
      print("Exception in getHealthDataFromTypes: $error");
    }

    // filter out duplicates
    _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

    List<dynamic> _heartRateList = [];
    List<dynamic> _bloodOxygenList = [];
    List<dynamic> _bloodPressureDiastolicList = [];
    List<dynamic> _bloodPressureSystolicList = [];
    List<dynamic> _bodyTemperatureList = [];
    // List<dynamic> _hydrationList = [];
    double waterDrank = 0;

    _healthDataList.forEach((element) {
      if (element.unit == HealthDataUnit.BEATS_PER_MINUTE) {
        _heartRateList.add(element);
      }
    });
    _healthDataList.forEach((element) {
      if (element.unit == HealthDataUnit.PERCENT) {
        _bloodOxygenList.add(element);
      }
    });

    _healthDataList.forEach((element) {
      if (element.type == HealthDataType.BLOOD_PRESSURE_DIASTOLIC) {
        _bloodPressureDiastolicList.add(element);
      }
    });
    _healthDataList.forEach((element) {
      if (element.type == HealthDataType.BLOOD_PRESSURE_SYSTOLIC) {
        _bloodPressureSystolicList.add(element);
      }
    });
    _healthDataList.forEach((element) {
      if (element.type == HealthDataType.BODY_TEMPERATURE) {
        _bodyTemperatureList.add(element);
      }
    });

    _healthDataList.forEach((element) {
      // print(element);
      if (element.type == HealthDataType.WATER) {
        // waterDrank += element.value as double;
        waterDrank += double.parse(element.value.toString());
        // print(element.value.toString());
      }
    });

    var heartDataPointLatest = _heartRateList.last;
    var bloodOxygenDataPointLatest = _bloodOxygenList.last;
    var bloodPressureDiastolicDataPointLatest =
        _bloodPressureDiastolicList.last;
    var bloodPressureSystolicDataPointLatest = _bloodPressureSystolicList.last;
    var bodyTemperatureDataPointLatest = _bodyTemperatureList.last;


    print(heartDataPointLatest);
    print(bloodOxygenDataPointLatest);
    print(bloodPressureDiastolicDataPointLatest);
    print(bloodPressureSystolicDataPointLatest);
    print(bodyTemperatureDataPointLatest);
    print('water drank: $waterDrank LITRES');

    // update the UI to display the results
    setState(() {
      _state = _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
    });
  }

  // Fetch steps from the health plugin and show them in the app.
  Future fetchStepData() async {
    int? steps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        steps = await health.getTotalStepsInInterval(midnight, now);
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      print('Total number of steps: $steps');

      setState(() {
        _nofSteps = (steps == null) ? 0 : steps;
        _state = (steps == null) ? AppState.NO_DATA : AppState.STEPS_READY;
      });
    } else {
      print("Authorization not granted - error in authorization");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20),
            child: SpinKitFadingCube(
              color: Color(0xFFBA68C8),
              size: 60.0,
            )),
        Text('Fetching data...')
      ],
    );
  }

  Widget _contentDataReady() {
    return ListView.builder(
        itemCount: _healthDataList.length,
        itemBuilder: (_, index) {
          HealthDataPoint p = _healthDataList[index];
          if (p.value is AudiogramHealthValue) {
            return ListTile(
              title: Text("${p.typeString}: ${p.value}"),
              trailing: Text('${p.unitString}'),
              subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
            );
          }
          if (p.value is WorkoutHealthValue) {
            return ListTile(
              title: Text(
                  "${p.typeString}: ${(p.value as WorkoutHealthValue).totalEnergyBurned} ${(p.value as WorkoutHealthValue).totalEnergyBurnedUnit?.name}"),
              trailing: Text(
                  '${(p.value as WorkoutHealthValue).workoutActivityType.name}'),
              subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
            );
          }
          return ListTile(
            title: Text("${p.typeString}: ${p.value}"),
            trailing: Text('${p.unitString}'),
            subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
          );
        });
  }

  Widget _contentNoData() {
    return Text('No Data to show');
  }

  Widget _contentNotFetched() {
    return Column(
      children: [
        Text('Press the download button to fetch data.'),
        Text('Press the plus button to insert some random data.'),
        Text('Press the walking button to get total step count.'),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget _authorized() {
    return Text('Authorization granted!');
  }

  Widget _authorizationNotGranted() {
    return Text('Authorization not given. '
        'For Android please check your OAUTH2 client ID is correct in Google Developer Console. '
        'For iOS check your permissions in Apple Health.');
  }

  Widget _dataAdded() {
    return Text('Data points inserted successfully!');
  }

  Widget _dataDeleted() {
    return Text('Data points deleted successfully!');
  }

  Widget _stepsFetched() {
    return Text('Total number of steps: $_nofSteps');
  }

  Widget _dataNotAdded() {
    return Text('Failed to add data');
  }

  Widget _dataNotDeleted() {
    return Text('Failed to delete data');
  }

  Widget _content() {
    if (_state == AppState.DATA_READY)
      return _contentDataReady();
    else if (_state == AppState.NO_DATA)
      return _contentNoData();
    else if (_state == AppState.FETCHING_DATA)
      return _contentFetchingData();
    else if (_state == AppState.AUTHORIZED)
      return _authorized();
    else if (_state == AppState.AUTH_NOT_GRANTED)
      return _authorizationNotGranted();
    else if (_state == AppState.DATA_ADDED)
      return _dataAdded();
    else if (_state == AppState.DATA_DELETED)
      return _dataDeleted();
    else if (_state == AppState.STEPS_READY)
      return _stepsFetched();
    else if (_state == AppState.DATA_NOT_ADDED)
      return _dataNotAdded();
    else if (_state == AppState.DATA_NOT_DELETED)
      return _dataNotDeleted();
    else
      return _contentNotFetched();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Screen'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // when user signs anonymously or with phone, there is no email
            if (!user.isAnonymous && user.phoneNumber == null)
              Text(user.email!),
            if (!user.isAnonymous && user.phoneNumber == null)
              Text(user.providerData[0].providerId),
            // display phone number only when user's phone number is not null
            if (user.phoneNumber != null) Text(user.phoneNumber!),
            // uid is always available for every sign in method
            Text(user.uid),
            // display the button only when the user email is not verified
            // or isnt an anonymous user

            ElevatedButton(
              onPressed: () {
                context.read<FirebaseAuthMethods>().signOut(context);
              },
              child: Text('Sign Out'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<FirebaseAuthMethods>().deleteAccount(context);
              },
              child: Text('Delete Account'),
            ),
            Wrap(
              spacing: 10,
              children: [
                TextButton(
                    onPressed: authorize,
                    child: Text("Auth", style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.blue))),
                TextButton(
                    onPressed: fetchData,
                    child: Text("Fetch Data",
                        style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.blue))),
                TextButton(
                    onPressed: fetchStepData,
                    child: Text("Fetch Step Data",
                        style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.blue))),
                SizedBox(
                  height: 12,
                ),
              ],
            ),
            Expanded(child: Center(child: _content()))
          ],
        ));
  }
}
