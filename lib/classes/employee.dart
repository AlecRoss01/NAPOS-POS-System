
class NAPOS_Employee {
    String _empName;
    int _empID;
    int _empPIN;
    int _accessLevel;

    NAPOS_Employee(this._empName, this._empID, this._empPIN, this._accessLevel);

    String get name { return _empName; }
    int get id { return _empID; }
    int get pin { return _empPIN; }
    int get access { return _accessLevel; }
}