
class NAPOS_Employee {
    String _empName;
    int _empID;
    int _empPIN;
    int _accessLevel;

    NAPOS_Employee(this._empName, this._empID, this._empPIN, this._accessLevel);

    String get name { return _empName; }
    String get id { return _empID; }
    String get pin { return _empPIN; }
    String get access { return _accessLevel; }
}