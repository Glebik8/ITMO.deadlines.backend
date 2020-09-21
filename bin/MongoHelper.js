"use strict";
exports.__esModule = true;
var Mongoose = require("mongoose");
var MongoHelper = /** @class */ (function () {
    function MongoHelper() {
    }
    MongoHelper.initMongo = function () {
        var _this = this;
        var uri = "mongodb+srv://glebik8:2QkO1Io11NilgSKz@cluster0.2olbh.mongodb.net/users?retryWrites=true&w=majority";
        Mongoose.connect(uri, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        }).then(function () {
            console.log('MongoHelper: inited');
            _this.connection = Mongoose.connection;
        });
    };
    MongoHelper.collection = function (addr) {
        return this.connection.collection(addr);
    };
    return MongoHelper;
}());
exports.MongoHelper = MongoHelper;
