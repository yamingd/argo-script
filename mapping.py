#!/usr/bin/env python
# -*- coding: utf-8 -*-

java_types = {
    'int': 'Integer',
    'tinyint': 'Byte',
    'smallint': 'Short',
    'mediumint': 'Integer',
    'bigint': 'Long',
    'bit': 'Byte',

    'float': 'Float',
    'decimal': 'Double',
    'double': 'Double',

    'text': 'String',
    'varchar': 'String',
    'nvarchar': 'String',
    'char': 'String',
    'nchar': 'String',

    'datetime': 'Date',
    'date': 'Date',
    'timestamp': 'Date',
    'time': 'Date'
}

sql_setter = {
    'int': 'setInt',
    'tinyint': 'setByte',
    'smallint': 'setShort',
    'mediumint': 'setInt',
    'bigint': 'setLong',
    'bit': 'setByte',

    'float': 'setFloat',
    'decimal': 'setDouble',
    'double': 'setDouble',

    'text': 'setString',
    'varchar': 'setString',
    'nvarchar': 'setString',
    'char': 'setString',
    'nchar': 'setString',

    'datetime': 'setTimestamp',
    'date': 'setDate',
    'timestamp': 'setTimestamp',
    'time': 'setTime'
}

value_setter = {
    "datetime": 'new java.sql.Timestamp(%s.getTime())',
    'date': 'new java.sql.Date(%s.getTime())',
    'timestamp': 'new java.sql.Timestamp(%s.getTime())',
    'time': 'new java.sql.Time(%s.getTime())'
}

sql_getter = {
    'int': 'getInt',
    'tinyint': 'getByte',
    'smallint': 'getShort',
    'mediumint': 'getInt',
    'bigint': 'getLong',
    'bit': 'getByte',

    'float': 'getFloat',
    'decimal': 'getDouble',
    'double': 'getDouble',

    'text': 'getString',
    'varchar': 'getString',
    'nvarchar': 'getString',
    'char': 'getString',
    'nchar': 'getString',

    'datetime': 'getDate',
    'date': 'getDate',
    'timestamp': 'getTimestamp',
    'time': 'getTime'
}

protobuf_types = {
    'int': 'int32',
    'tinyint': 'int32',
    'smallint': 'int32',
    'mediumint': 'int32',
    'bigint': 'int64',
    'bit': 'int32',

    'float': 'float',
    'decimal': 'double',
    'double': 'double',

    'text': 'string',
    'varchar': 'string',
    'nvarchar': 'string',
    'char': 'string',
    'nchar': 'string',

    'datetime': 'int64',
    'date': 'int64',
    'timestamp': 'int64',
    'time': 'int64'
}

ios_types = {
    'int': 'int',
    'tinyint': 'int',
    'smallint': 'int',
    'mediumint': 'int',
    'bigint': 'long',
    'bit': 'int',

    'float': 'float',
    'decimal': 'float',
    'double': 'double',

    'text': 'NSString',
    'varchar': 'NSString',
    'nvarchar': 'NSString',
    'char': 'NSString',
    'nchar': 'NSString',

    'datetime': 'NSDate',
    'date': 'NSDate',
    'timestamp': 'NSDate',
    'time': 'NSDate'
}

sqlite_types = {
    'int': 'integer',
    'tinyint': 'integer',
    'smallint': 'integer',
    'mediumint': 'integer',
    'bigint': 'integer',
    'bit': 'integer',

    'float': 'real',
    'decimal': 'real',
    'double': 'real',

    'text': 'text',
    'varchar': 'text',
    'nvarchar': 'text',
    'char': 'text',
    'nchar': 'text',

    'datetime': 'integer',
    'date': 'integer',
    'timestamp': 'integer',
    'time': 'integer',
    'byte[]': 'blob'
}

sqlite_setter = {
    'int': 'bindLong',
    'tinyint': 'bindLong',
    'smallint': 'bindLong',
    'mediumint': 'bindLong',
    'bigint': 'bindLong',
    'bit': 'bindLong',

    'float': 'bindDouble',
    'decimal': 'bindDouble',
    'double': 'bindDouble',

    'text': 'bindString',
    'varchar': 'bindString',
    'nvarchar': 'bindString',
    'char': 'bindString',
    'nchar': 'bindString',

    'datetime': 'bindLong',
    'date': 'bindLong',
    'timestamp': 'bindLong',
    'time': 'bindLong',
    'byte[]': 'bindBlob'
}

sqlite_getter = {
    'int': 'getInt',
    'tinyint': 'getShort',
    'smallint': 'getInt',
    'mediumint': 'getInt',
    'bigint': 'getLong',
    'bit': 'getShort',

    'float': 'getFloat',
    'decimal': 'getDouble',
    'double': 'getDouble',

    'text': 'getString',
    'varchar': 'getString',
    'nvarchar': 'getString',
    'char': 'getString',
    'nchar': 'getString',

    'datetime': 'getLong',
    'date': 'getLong',
    'timestamp': 'getLong',
    'time': 'getLong',
    'byte[]': 'getBlob'
}

fmdb_getter = {
    'int': 'intForColumn',
    'tinyint': 'intForColumn',
    'smallint': 'intForColumn',
    'mediumint': 'intForColumn',
    'bigint': 'longForColumnIndex',
    'bit': 'intForColumn',

    'float': 'doubleForColumnIndex',
    'decimal': 'doubleForColumnIndex',
    'double': 'doubleForColumnIndex',

    'text': 'stringForColumnIndex',
    'varchar': 'stringForColumnIndex',
    'nvarchar': 'stringForColumnIndex',
    'char': 'stringForColumnIndex',
    'nchar': 'stringForColumnIndex',

    'datetime': 'dateForColumnIndex',
    'date': 'dateForColumnIndex',
    'timestamp': 'dateForColumnIndex',
    'time': 'dateForColumnIndex',
    'byte[]': 'dataForColumnIndex'
}

cpp_types = {
    'int': 'uint32_t',
    'tinyint': 'uint32_t',
    'smallint': 'uint32_t',
    'mediumint': 'uint32_t',
    'bigint': 'uint64_t',
    'bit': 'uint32_t',

    'float': 'float',
    'decimal': 'float',
    'double': 'double',

    'text': 'std::string',
    'varchar': 'std::string',
    'nvarchar': 'std::string',
    'char': 'std::string',
    'nchar': 'std::string',

    'datetime': 'uint64_t',
    'date': 'uint64_t',
    'timestamp': 'uint64_t',
    'time': 'uint64_t'
}

cpp_objcs = {
    'int': 'cppUInt32ToInt',
    'tinyint': 'cppUInt32ToInt',
    'smallint': 'cppUInt32ToInt',
    'mediumint': 'cppUInt32ToInt',
    'bigint': 'cppUInt64ToLong',

    'float': 'cppFloatToFloat',
    'decimal': 'cppFloatToFloat',
    'double': 'cppDoubleToDouble',

    'text': 'cppStringToObjc',
    'varchar': 'cppStringToObjc',
    'nvarchar': 'cppStringToObjc',
    'char': 'cppStringToObjc',
    'nchar': 'cppStringToObjc',
    
    'datetime': 'cppDateToObjc',
    'date': 'cppDateToObjc',
    'timestamp': 'cppDateToObjc',
    'time': 'cppDateToObjc'
}

objc_cpps = {
    'int': 'cppUInt32ToInt',
    'tinyint': 'cppUInt32ToInt',
    'smallint': 'cppUInt32ToInt',
    'mediumint': 'cppUInt32ToInt',
    'bigint': 'cppUInt64ToLong',
    'bit': 'cppUInt32ToInt',

    'float': 'cppFloatToFloat',
    'decimal': 'cppFloatToFloat',
    'double': 'cppDoubleToDouble',

    'text': 'objcStringToCpp',
    'varchar': 'objcStringToCpp',
    'nvarchar': 'objcStringToCpp',
    'char': 'objcStringToCpp',
    'nchar': 'objcStringToCpp',

    'datetime': 'objcDateToCpp',
    'date': 'objcDateToCpp',
    'timestamp': 'objcDateToCpp',
    'time': 'objcDateToCpp'
}