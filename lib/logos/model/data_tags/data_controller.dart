import 'dart:convert';
import 'package:logos_maru/logos/model/data_tags/data_vo.dart';
import 'package:logos_maru/logos/model/eol.dart';
import 'package:logos_maru/logos/model/eol_colors.dart';
import 'package:logos_maru/logos/model/logos_controller.dart';
import 'package:logos_maru/logos/model/logos_service.dart';

class DataController {
  /** ===============================================
   *  Data List
   *  ===============================================*/
  List<DataVO> _dataList = [];

  List<DataVO> get dataList => _dataList;

  /// Set the list of data.
  void setDataList({required List<DataVO> dataList}) {
    _dataList = dataList;
  }

  DataVO _selectedData = DataVO.empty();

  DataVO get selectedData => _selectedData;

  void setSelectedData({required DataVO dataVO}) {
    _selectedData = dataVO;
  }

  /** ===============================================
   *  Update Data
   *  ===============================================*/
  Future<String> updateData( {
    required DataVO dataVO,
    required String table }) async {

    Map<String, dynamic> map = dataVO.toMap();
    map['table'] = '_' + table;

    _log(msg: 'updateData: map: $map');
    String result = await NetworkHelper.sendPostRequest( url: NetworkHelper.API_LOCATION + '/data_update.php', map: map);

    _log(msg: 'Result \n\n' + result.toString());

    /// todo: is there a better, more reliable way to check for success?
    if (result.contains('name')) {
      _log(msg: 'updateData: SUCCESS');

      /// todo: the result should be converted to dataVO and that vo is added to the list.
      _updateDataInList(dataVO: dataVO);
      return NetworkHelper.SUCCESS;
    } else {
      _log(msg: 'updateData: FAILURE');
      return NetworkHelper.NETWORK_ERROR;
    }
  }

  void _updateDataInList({required DataVO dataVO}) {
    /// First, if everything is in order then the dataID should be equal to the _dataList index -1.
    if (dataVO.id > 0 && dataVO.id <= _dataList.length && _dataList[dataVO.id - 1].id == dataVO.id) {
      _dataList[dataVO.id - 1] = dataVO;
      return;
    }

    /// If the dataID is not in order, then we need to find it.
    for (int i = 0; i < _dataList.length; i++) {
      if (_dataList[i].id == dataVO.id) {
        _dataList[i] = dataVO;
        break;
      }
    }
  }

  DataVO getDataByID({required int dataID}) {
    /// First, if everything is in order then the dataID should be equal to the _dataList index -1.
    DataVO dataVO = _dataList[dataID - 1];
    if (dataID > 0 && dataID == dataVO.id) {
      return dataVO;
    }

    /// If the dataID is not in order, then we need to find it.
    for (int i = 0; i < _dataList.length; i++) {
      if (_dataList[i].id == dataID) {
        return _dataList[i];
      }
    }

    return DataVO.empty();
  }

  List<DataVO> getDataListFromName({required String name}) {
    List<DataVO> dataList = [];

    if (name.isNotEmpty) {
      List<String> dataArray = name.split(',');
      int _len = dataArray.length;
      for (int i = 0; i < _len; i++) {
        dataList.add(getDataByID(dataID: int.parse(dataArray[i])));
      }
    }

    return dataList;
  }

  /** ===============================================
   *  When a Logos is selected update the data list to
   *  reflect which data in this Logos are selected.
   *  Start be setting all data to unselected.
   *
   *  The dataList passed in is from the selected Logos.
   *  ===============================================*/
  void updateDataListForLogos({required List<DataVO> dataList}) {
    _log(msg: 'updateDataListForLogos: dataList: $dataList');

    /// First, set all data to unselected.
    for (int i = 0; i < _dataList.length; i++) {
      _dataList[i].isSelected = false;
    }

    /// Now, loop through the dataList passed in and
    /// find the matching data in the _dataList to set to isSelected.
    int _len = dataList.length;
    for (int i = 0; i < _len; i++) {
      DataVO dataVO = getDataByID(dataID: dataList[i].id);
      dataVO.isSelected = true;
      _updateDataInList(dataVO: dataVO);
    }
  }

  /** ===============================================
   *  Convert the dataVOs to a string of dataIDs.
   *  ===============================================*/
  String getDataStringFromList({required List<DataVO> dataList}) {
    String dataString = '';
    int _len = dataList.length;
    for (int i = 0; i < _len; i++) {
      dataString += dataList[i].id.toString();
      if (i < _len - 1) {
        dataString += ',';
      }
    }
    return dataString;
  }

  /// Create a new data.
  Future<String> createDataOnServer( {
    required DataVO dataVO,
    required String table } ) async {

    Map<String, dynamic> map = dataVO.toMap();
    map['table'] = '_' + table;


    _log(msg: 'createData: map: $map');
    String result = await NetworkHelper.sendPostRequest(
        url: NetworkHelper.API_LOCATION + '/data_create.php',
        map: map
    );

    _log(msg: 'Result \n\n' + result.toString());
    var dataDecoded = jsonDecode(result)['data'] as List;

    if (dataDecoded.isNotEmpty) {
      _log(msg: 'updateData: SUCCESS');
      dataVO = dataDecoded.map((e) => DataVO.fromJson(e)).toList()[0];
      _dataList.add( dataVO );
      return NetworkHelper.SUCCESS;
    } else {
      _log(msg: 'updateData: FAILURE');
      return NetworkHelper.NETWORK_ERROR;
    }
  }

  /** ===============================================
   *  EOL
   *  ===============================================*/
  static void _log({required String msg, String title = '', Map<String, dynamic>? map, String json = '', bool shout = false, bool fail = false}) {
    if( LogosController().showConsoleOutput == true )
      EOL.log(msg: msg, map: map, title: title, json: json, shout: shout, fail: fail,
          color: EOLcolors.dataController_magenta_White
      );
  }
}