var Math2 = function (exports) {
    exports.add = function (a, b) {
        var ret = a + b;
        return ret;
    };
    exports.square = function (a) {
        var ret = a * a;
        return ret;
    };
    return exports;
}(Math2 || {});
