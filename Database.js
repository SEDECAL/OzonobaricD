// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2024 Sedecal S.A.
// This file is part of OzonobaricD.
// See LICENSE file for details.

function dbConfig_Init() {
    var db = LocalStorage.openDatabaseSync("OzonobaricD_db", "1.0", "ConfigurationDatabase", 1000000)
    console.log("Starting configuration database...")

    try {
        db.transaction(function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS configuration ( \
                           id INTEGER PRIMARY KEY AUTOINCREMENT, \
                           protocol_name TEXT,          \
                           param_name TEXT,             \
                           param_order INT,             \
                           param_max_value_0 TEXT,      \
                           param_min_value_0 TEXT,      \
                           param_step_value_0 TEXT,     \
                           param_max_value_1 TEXT,      \
                           param_min_value_1 TEXT,      \
                           param_step_value_1 TEXT,     \
                           param_max_value_2 TEXT,      \
                           param_min_value_2 TEXT,      \
                           param_step_value_2 TEXT,     \
                           param_def_value TEXT,        \
                           param_fix_values TEXT,       \
                           param_units TEXT,            \
                           param_alt_units TEXT,        \
                           param_units_cov_factor REAL, \
                           param_color TEXT,            \
                           param_units_color TEXT,      \
                           param_icon TEXT )')
        })
    } catch (err) {
        console.log("Error creating table in database: " + err)
    }
}

function dbConfig_GetHandle() {
    try {
        var db = LocalStorage.openDatabaseSync("OzonobaricD_db", "1.0", "ConfigurationDatabase", 1000000)
    } catch (err) {
        console.log("Error opening database: " + err)
    }
    return db
}

function dbConfig_Exists() {
    var db = dbConfig_GetHandle()
    var result
    try {
        db.transaction(function(tx) {
            result = tx.executeSql('SELECT * FROM configuration ')
        })
    } catch (err) {
        console.log("Error checking if data base exists...")
    }

    if(result.rows.length){
        console.log("Data base already exists (", result.rows.length, "registers )")
    }else{
        console.log("Data base doesn't exist (", result.rows.length, "registers )")
    }
    return result.rows.length
}

function dbConfig_Insert(protocol, param, order, max_0, min_0, step_0, max_1, min_1, step_1, max_2, min_2, step_2, def, fix, units, alt_units, cov_factor, unit_color, color, icon) {
    var db = dbConfig_GetHandle()
    var result

    db.transaction(function (tx) {
        result = tx.executeSql('INSERT INTO configuration (  \
                                protocol_name,               \
                                param_name,                  \
                                param_order,                 \
                                param_max_value_0,           \
                                param_min_value_0,           \
                                param_step_value_0,          \
                                param_max_value_1,           \
                                param_min_value_1,           \
                                param_step_value_1,          \
                                param_max_value_2,           \
                                param_min_value_2,           \
                                param_step_value_2,          \
                                param_def_value,             \
                                param_fix_values,            \
                                param_units,                 \
                                param_alt_units,             \
                                param_units_cov_factor,      \
                                param_units_color,           \
                                param_color,                 \
                                param_icon )                 \
                                VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [protocol, param, order, max_0, min_0, step_0, max_1, min_1, step_1, max_2, min_2, step_2, def, fix, units, alt_units, cov_factor, unit_color, color, icon])

        if (result.rowsAffected !== 1) {
            console.log("Error inserting configuration db element...")
        }

        result = tx.executeSql('SELECT last_insert_rowid()')
    })
    return result.insertId
}

function dbConfig_Get(protocol) {
    var db = dbConfig_GetHandle()
    var result

    try {
        db.transaction(function(tx) {
            result = tx.executeSql('SELECT * FROM configuration WHERE protocol_name =? ORDER BY param_order', [protocol])

        })
    } catch (err) {
        console.log("Error getting default value from configuration database: " + err)
    }
    return result.rows
}

function dbConfig_Update(targetVal, value, protocol, param) {
   var db = dbConfig_GetHandle()
   var result

    try {
        db.transaction(function(tx) {
            result = tx.executeSql('UPDATE configuration SET ' + targetVal + '=? WHERE protocol_name =? AND param_name =?;', [value, protocol, param])
        })
    } catch (err) {
        console.log("Error updating default value on configuration database: " + err)
    }
}



function dbStorage_Init() {
    var db = LocalStorage.openDatabaseSync("OzDStorage_db", "1.0", "StorageDatabase", 1000)
    console.log("Starting storage database...")

    try {
        db.transaction(function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS storage (  \
                           id INTEGER PRIMARY KEY AUTOINCREMENT, \
                           db_version,                           \
                           linked_device TEXT,                   \
                           language TEXT,                        \
                           units TEXT,                           \
                           device_name TEXT,                     \
                           working_time INT,                     \
                           syringe_auto_flow INT,                \
                           dose_flow INT,                        \
                           continuous_clean_time INT,            \
                           vacuum_pressure_time INT )')
        })
    } catch (err) {
        console.log("Error creating table in storage database: " + err)
    }
}

function dbStorage_GetHandle() {
    try {
        var db = LocalStorage.openDatabaseSync("OzDStorage_db", "1.0", "StorageDatabase", 1000)
    } catch (err) {
        console.log("Error opening storage database: " + err)
    }
    return db
}

function dbStorage_Exists() {
    var db = dbStorage_GetHandle()
    var result
    try {
        db.transaction(function(tx) {
            result = tx.executeSql('SELECT * FROM storage ')
        })
    } catch (err) {
        console.log("Error checking if storage data base exists...")
    }

    if(result.rows.length){
        console.log("Storage data base already exists (", result.rows.length, "registers )")
    }else{
        console.log("Storage data base doesn't exist (", result.rows.length, "registers )")
    }
    return result.rows.length
}

function dbStorage_Insert(version, device, language, units, name, time, s_flow, d_flow, c_time, v_time) {
    var db = dbStorage_GetHandle()
    var result

    db.transaction(function (tx) {
        result = tx.executeSql('INSERT INTO storage  (  \
                                db_version,             \
                                linked_device,          \
                                language,               \
                                units,                  \
                                device_name,            \
                                working_time,           \
                                syringe_auto_flow,      \
                                dose_flow,              \
                                continuous_clean_time,  \
                                vacuum_pressure_time)
                                VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [version, device, language, units, name, time, s_flow, d_flow, c_time, v_time])

        if (result.rowsAffected !== 1) {
            console.log("Error inserting storage db element...")
        }

        result = tx.executeSql('SELECT last_insert_rowid()')
    })
    return result.insertId
}

function dbStorage_Get(data) {
    var db = dbStorage_GetHandle()
    var result

    try {
        db.transaction(function(tx) {
 //         result = tx.executeSql('SELECT * FROM storage')
            result = tx.executeSql('SELECT ' + data + ' FROM storage')
        })
    } catch (err) {
        console.log("Error getting value from storage database: " + err)
    }
    return result.rows.item(0)[data]
}

function dbStorage_Update(targetVal, value) {
    var db = dbStorage_GetHandle()
    var result

    try {
        db.transaction(function(tx) {
            result = tx.executeSql('UPDATE storage SET ' + targetVal + '=?;', [value])
        })
    } catch (err) {
        console.log("Error updating value on storage database: " + err)
    }
}

function dbStorage_UpdateUnits(value) {
    dbStorage_Update('units', value)
}

function dbStorage_UpdateLanguage(value) {
    dbStorage_Update('language', value)
}

function dbStorage_UpdateLinkedDevice(value) {
    dbStorage_Update('linked_device', value)
}

function dbStorage_UpdateWorkingTime(value) {
    dbStorage_Update('working_time', value)
}

function dbStorage_UpdateDeviceName(value) {
    dbStorage_Update('device_name', value)
}



function dbLang_Init() {
    var db = LocalStorage.openDatabaseSync("OzDLanguage_db", "1.0", "LanguageDatabase", 1000000)
    console.log("Starting language database...")

    try {
        db.transaction(function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS language ( \
                           id INTEGER PRIMARY KEY AUTOINCREMENT, \
                           language_id TEXT,          \
                           press_temp TEXT,           \
                           dev_info TEXT,             \
                           sw_versions TEXT,          \
                           interface TEXT,            \
                           control TEXT,              \
                           database TEXT,             \
                           gui TEXT,                  \
                           gen_time TEXT,             \
                           units_lang TEXT,           \
                           bt_connection TEXT,        \
                           load_param TEXT,           \
                           dev_name TEXT,             \
                           dev_parameters TEXT,       \
                           startup_results TEXT,      \
                           link_generator TEXT,       \
                           reset_gen_time TEXT,       \
                           save_param TEXT,           \
                           generation_mode TEXT,      \
                           pressure_cal TEXT,         \
                           flow_cal TEXT,             \
                           o3_cal TEXT,               \
                           period_cal TEXT,           \
                           step_desc TEXT,            \
                           press_cal_desc_1 TEXT,     \
                           press_cal_desc_2 TEXT,     \
                           flow_cal_desc_1 TEXT,      \
                           flow_cal_desc_2 TEXT,      \
                           o3_cal_desc_1 TEXT,        \
                           o3_cal_desc_2 TEXT,        \
                           o3_cal_desc_3 TEXT,        \
                           o3_cal_desc_4 TEXT )')
        })
    } catch (err) {
        console.log("Error creating table in language database: " + err)
    }
}

function dbLang_GetHandle() {
    try {
        var db = LocalStorage.openDatabaseSync("OzDLanguage_db", "1.0", "LanguageDatabase", 1000000)
    } catch (err) {
        console.log("Error opening language database: " + err)
    }
    return db
}

function dbLang_Exists() {
    var db = dbLang_GetHandle()
    var result
    try {
        db.transaction(function(tx) {
            result = tx.executeSql('SELECT * FROM language ')
        })
    } catch (err) {
        console.log("Error checking if language data base exists...")
    }

    if(result.rows.length){
        console.log("Language data base already exists (", result.rows.length, "registers )")
    }else{
        console.log("Language data base doesn't exist (", result.rows.length, "registers )")
    }
    return result.rows.length
}

function dbLang_Insert(language_id, press_temp, dev_info, sw_versions, interface, control, database, gui, gen_time, units_lang, bt_connection, load_param, dev_name, dev_parameters, startup_results, link_generator, reset_gen_time, save_param, generation_mode, pressure_cal, flow_cal, o3_cal, period_cal, step_desc, cal_desc_1, cal_desc_2, flow_desc_1, flow_desc_2, o3_desc_1, o3_desc_2, o3_desc_3, o3_desc_4) {
    var db = dbLang_GetHandle()
    var result

    db.transaction(function (tx) {
        result = tx.executeSql('INSERT INTO language (  \
                                language_id,            \
                                press_temp,             \
                                dev_info,               \
                                sw_versions,            \
                                interface,              \
                                control,                \
                                database,               \
                                gui,                    \
                                gen_time,               \
                                units_lang,             \
                                bt_connection,          \
                                load_param,             \
                                dev_name,               \
                                dev_parameters,         \
                                startup_results,        \
                                link_generator,         \
                                reset_gen_time,         \
                                save_param,             \
                                generation_mode,        \
                                pressure_cal,           \
                                flow_cal,               \
                                o3_cal,                 \
                                period_cal,             \
                                step_desc,              \
                                press_cal_desc_1,       \
                                press_cal_desc_2,       \
                                flow_cal_desc_1,        \
                                flow_cal_desc_2,        \
                                o3_cal_desc_1,          \
                                o3_cal_desc_2,          \
                                o3_cal_desc_3,          \
                                o3_cal_desc_4 )
                                VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [language_id, press_temp, dev_info, sw_versions, interface, control, database, gui, gen_time, units_lang, bt_connection, load_param, dev_name, dev_parameters, startup_results, link_generator, reset_gen_time, save_param, generation_mode, pressure_cal, flow_cal, o3_cal, period_cal, step_desc, cal_desc_1, cal_desc_2, flow_desc_1, flow_desc_2, o3_desc_1, o3_desc_2, o3_desc_3, o3_desc_4])

        if (result.rowsAffected !== 1) {
            console.log("Error inserting language db element...")
        }

        result = tx.executeSql('SELECT last_insert_rowid()')
    })
    return result.insertId
}

function dbLang_Get(languageId, textId) {
    var db = dbLang_GetHandle()
    var result

    if(arguments.length === 1){
        textId = languageId
        languageId = dbStorage_Get("language")
    }

    try {
        db.transaction(function(tx) {
//          result = tx.executeSql('SELECT * FROM language WHERE language_id =? AND param_name =?;', [languageId, textId])
            result = tx.executeSql('SELECT ' + textId +' FROM language WHERE language_id =?', [languageId])
        })
    } catch (err) {
        console.log("Error getting default value from language database: " + err)
        return "undefined text (0)"  // no textId found
    }

    if(result.rows.item(0) === undefined){
        return "undefined text (1)"  // no language found
    }

    return result.rows.item(0)[textId]
}


//////////////////////////////////////////////////////////////////////////////////////////////











function dbHelp_Init() {
    var db = LocalStorage.openDatabaseSync("OzDHelp_db", "1.0", "HelpDatabase", 1000000)
    console.log("Starting help resources database...")

    try {
        db.transaction(function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS help ( \
                           id INTEGER PRIMARY KEY AUTOINCREMENT, \
                           protocol_name TEXT,    \
                           manual TEXT,           \
                           tutorial_video TEXT,   \
                           diagram TEXT,          \
                           protocol_video TEXT )')
        })
    } catch (err) {
        console.log("Error creating table in help resources database: " + err)
    }
}

function dbHelp_GetHandle() {
    try {
        var db = LocalStorage.openDatabaseSync("OzDHelp_db", "1.0", "HelpDatabase", 1000000)
    } catch (err) {
        console.log("Error opening help resources database: " + err)
    }
    return db
}

function dbHelp_Exists() {
    var db = dbHelp_GetHandle()
    var result
    try {
        db.transaction(function(tx) {
            result = tx.executeSql('SELECT * FROM help ')
        })
    } catch (err) {
        console.log("Error checking if help resources data base exists...")
    }

    if(result.rows.length){
        console.log("Help resources data base already exists (", result.rows.length, "registers )")
    }else{
        console.log("Help resources data base doesn't exist (", result.rows.length, "registers )")
    }
    return result.rows.length
}

function dbHelp_Insert(prot_name, manual, tut_video, diagram, prot_video) {
    var db = dbHelp_GetHandle()
    var result

    db.transaction(function (tx) {
        result = tx.executeSql('INSERT INTO help (  \
                                protocol_name,      \
                                manual,             \
                                tutorial_video,     \
                                diagram,            \
                                protocol_video)
                                VALUES(?, ?, ?, ?, ?)', [prot_name, manual, tut_video, diagram, prot_video])

        if (result.rowsAffected !== 1) {
            console.log("Error inserting help resources db element...")
        }

        result = tx.executeSql('SELECT last_insert_rowid()')
    })
    return result.insertId
}

function dbHelp_Get(prot_name, help_type) {
    var db = dbHelp_GetHandle()
    var result

    try {
        db.transaction(function(tx) {
            result = tx.executeSql('SELECT ' + help_type +' FROM help WHERE protocol_name =?', [prot_name])
        })
    } catch (err) {
        console.log("Error getting default value from help resources database: " + err)
        return "undefined help resource (0)"  // no help_type found
    }

    if(result.rows.item(0) === undefined){
        return "undefined help resource (1)"  // no prot_name found
    }

    return result.rows.item(0)[help_type]
}
//////////////////////////////////////////////////////////////////////////







// DATA BASE MANAGEMENT EXAMPLAES

//function dbReadAll()//pending
//{
//    var db = dbConfig_GetHandle()
//    db.transaction(function (tx) {
//        var results = tx.executeSql(
////                    'SELECT rowid,date,trip_desc,distance FROM trip_log order by rowid desc')
//                      'SELECT * FROM configuration WHERE protocol_name =? AND param_name =?;', ["continuous", "time"])
//        for (var i = 0; i < results.rows.length; i++) {
//            inputModel.append({
//                                 units:"--",
//                                  max_val: results.rows.item(i).param_max_value,
//                                  min_val: results.rows.item(i).param_min_value,
//                                  value: results.rows.item(i).param_def_value,
//                                  unitsColor: "darkgoldenrod",
//                                  valueColor: "gold",
//                                  icon_: "Images/ic_schedule_white_48dp.png",
//                                  memoryButons: results.rows.item(i).param_fix_value
//                             })
//        }
//    })
//}


//function dbGetDefValue(protocol, param){

//    var db = dbGetHandle()
//    var result

//    try {
//        db.transaction(function(tx) {
//            result = tx.executeSql('SELECT param_def_value FROM configuration WHERE protocol_name =? AND param_name =?;', [protocol, param])
//        })
//    } catch (err) {
//        console.log("Error getting default value from configuration database: " + err)
//    }

//    return result.rows.item(0).param_def_value
//}

//function dbGetFixValues(protocol, param){

//    var db = dbGetHandle()
//    var result

//    try {
//        db.transaction(function(tx) {
//            result = tx.executeSql('SELECT param_fix_values FROM configuration WHERE protocol_name =? AND param_name =?;', [protocol, param])
//        })
//    } catch (err) {
//        console.log("Error getting fixed values from configuration database: " + err)
//    }

//    return result.rows.item(0).param_fix_values
//}


//function dbUpdateDefValue(protocol, param, defValue){

//   var db = dbGetHandle()
//   var result

//    try {
//        db.transaction(function(tx) {
//            result = tx.executeSql('UPDATE configuration SET param_def_value=? WHERE protocol_name =? AND param_name =?;', [defValue, protocol, param])
//        })
//    } catch (err) {
//        console.log("Error updating default value on configuration database: " + err)
//    }
//}

//function dbUpdateFixValues(protocol, param, fixValues){

//   var db = dbGetHandle()
//   var result

//    try {
//        db.transaction(function(tx) {
//            result = tx.executeSql('UPDATE configuration SET param_fix_values=? WHERE protocol_name =? AND param_name =?;', [fixValues, protocol, param])
//        })
//    } catch (err) {
//        console.log("Error updating fixed values on configuration database: " + err)
//    }
//}

//function dbReadAll()//pending
//{
//    var db = dbGetHandle()
//    db.transaction(function (tx) {
//        var results = tx.executeSql(
//                    'SELECT rowid,date,trip_desc,distance FROM trip_log order by rowid desc')
//        for (var i = 0; i < results.rows.length; i++) {
//            listModel.append({
//                                 id: results.rows.item(i).rowid,
//                                 checked: " ",
//                                 date: results.rows.item(i).date,
//                                 trip_desc: results.rows.item(i).trip_desc,
//                                 distance: results.rows.item(i).distance
//                             })
//        }
//    })
//}

//function dbUpdate(Pdate, Pdesc, Pdistance, Prowid) //pendign
//{
//    var db = dbGetHandle()
//    db.transaction(function (tx) {
//        tx.executeSql(
//                    'update trip_log set date=?, trip_desc=?, distance=? where rowid = ?', [Pdate, Pdesc, Pdistance, Prowid])
//    })
//}

//function dbDeleteRow(Prowid)//pending
//{
//    var db = dbGetHandle()
//    db.transaction(function (tx) {
//        tx.executeSql('delete from trip_log where rowid = ?', [Prowid])
//    })
//}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///*
//    Contains ALL the function used to manage the application database
//*/

//  /* See: http://doc.qt.io/archives/qt-5.5/qtquick-localstorage-qmlmodule.html for input arguments */
//  function getDatabase() {
//     return LocalStorage.openDatabaseSync("weatherRecorder_db", "1.0", "StorageDatabase", 1000000);
//  }


//  /* create the necessary tables.
//     Note: with a column of type REAL for the saved value, is always used the comma as decimal separator also when user uses the dot sign */
//  function createTables() {

//      var db = getDatabase();

//      db.transaction(
//          function(tx) {
//              tx.executeSql('CREATE TABLE IF NOT EXISTS configuration(id INTEGER PRIMARY KEY AUTOINCREMENT, param_name TEXT, param_value TEXT)');
//              tx.executeSql('CREATE TABLE IF NOT EXISTS temperature(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, temperature_value REAL)');
//      });
//   }


//  /* initialize the tables with some default values */
//  function insertDefaultConfigValues(){

//     insertConfigParamValue('city','Berlin');
//     insertConfigParamValue('temperatureUnit','Celsius');
//  }


//  /* load the configuration parameter with the provided name */
//  function getConfigParamValue(paramName){

//        var db = getDatabase();
//        var rs = "";
//        db.transaction(function(tx) {
//             rs = tx.executeSql('SELECT param_value FROM configuration WHERE param_name =?;',[paramName] );
//            }
//        );

//        return rs.rows.item(0).param_value;
//   }


//   /* INSERT a configuration parameter value. Return "OK" if the updated row is made successfully, "ERROR" otherwise */
//   function insertConfigParamValue(paramName,paramValue){

//       var db = getDatabase();
//       var res = "";

//       db.transaction(function(tx) {

//           var rs = tx.executeSql('INSERT INTO configuration (param_name, param_value) VALUES (?,?);', [paramName, paramValue]);
//           if (rs.rowsAffected === 1) {
//               res = "OK";
//           } else {
//               res = "Error";
//           }
//       }
//       );
//       return res;
//   }



//  /* UPDATE a configuration parameter value with the new provide one.
//     Return "OK" if the updated row is made successfully, "ERROR" otherwise
//  */
//  function updateConfigParamValue(paramName,paramValue){

//     var db = getDatabase();
//     var res = "";

//     db.transaction(function(tx) {
//         var rs = tx.executeSql('UPDATE configuration SET param_value=? WHERE param_name=?;', [paramValue,paramName]);
//         if (rs.rowsAffected === 1) {
//             res = "OK";
//         } else {
//             res = "Error";
//         }
//     }
//     );
//     return res;
//   }


//   /* Return a temperature value for the given date. If misisng retun 'N/A' (i.e. not available) */
//   function getTemperatureValueByDate(date){

//        var db = getDatabase();
//        var targetDate = new Date (date);

//        /* return a formatted date like: 2017-04-30 (yyyy-mm-dd) */
//        var fullTargetDate = DateUtils.formatDateToString(targetDate);
//        var rs = "";

//        db.transaction(function(tx) {
//              rs = tx.executeSql("SELECT temperature_value FROM temperature t where date(t.date) = date('"+fullTargetDate+"')");
//            }
//        );

//        /* check if value is missing or not */
//        if (rs.rows.length > 0) {
//            return rs.rows.item(0).temperature_value;
//        } else {
//            return "N/A";
//        }
//   }


//  /* delete a temperature value for the given date */
//  function deleteTemperatureByDate(date){

//       var db = getDatabase();
//       var targetDate = new Date (date);

//       var fullTargetDate = DateUtils.formatDateToString(targetDate);
//       var rs = "";

//       db.transaction(function(tx) {
//             rs = tx.executeSql("DELETE FROM temperature where date('"+fullTargetDate+"')");
//           }
//       );

//       return rs.rowsAffected;
//  }


//  /* Insert a new temperature value for the given date */
//  function insertTemperature(date,tempValue){

//       var db = getDatabase();
//       var fullDate = new Date (date);
//       var res = "";

//       /* return a formatted date like: 2017-09-30 (yyyy-mm-dd) */
//       var dateFormatted = DateUtils.formatDateToString(fullDate);

//       db.transaction(function(tx) {

//           var rs = tx.executeSql('INSERT INTO temperature (date, temperature_value) VALUES (?,?);', [dateFormatted, tempValue]);
//           if (rs.rowsAffected > 0) {
//               res = "OK";
//           } else {
//               res = "Error";
//           }
//       }
//       );
//       return res;
//  }


//  /* Update a temperature value for the given date. Return the amount of updated rows (0 in case of no updated row) */
//  function updateTemperature(date,tempValue){

//     var db = getDatabase();
//     var fullDate = new Date (date);
//     /* return a formatted date like: 2017-09-30 (yyyy-mm-dd) to be inserted in the database */
//     var dateFormatted = DateUtils.formatDateToString(fullDate);

//     var rs = "";

//     db.transaction(function(tx) {
//         rs = tx.executeSql('UPDATE temperature SET temperature_value=? WHERE date=?;', [tempValue,dateFormatted]);
//        }
//     );

//     return rs.rowsAffected;
//   }


//   /* Remove ALL the saved Temperature values NOT the table (i.e.: the table will be empty).
//      Return the number of rows deleted
//   */
//   function deleteAllTemperatureValues(){

//       var db = getDatabase();
//       var rs;

//       db.transaction(function(tx) {
//         rs = tx.executeSql('DELETE FROM temperature;');
//        }
//      );

//      return rs.rowsAffected;
//   }
