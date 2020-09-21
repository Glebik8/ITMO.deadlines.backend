"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var Mongoose = require("mongoose");
var mongoose_1 = require("mongoose");
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
    MongoHelper.deleteAll = function () {
        var _this = this;
        var promises = [];
        var maxId;
        this.collection('id').find().toArray()
            .then(function (value) { return value[0].id; })
            .then((function (value) {
            maxId = value;
            for (var i = 1; i <= value; i++) {
                promises.push(_this.connection.collection("" + i).drop().catch(function (error) { }));
            }
        })).finally(function () {
            mongoose_1.Promise.all(promises).finally(function () {
                _this.collection('id').findOneAndUpdate({ id: maxId }, { $set: { id: 1 } })
                    .finally(function () { return console.log('MongoHelper: delete finished'); });
            });
        });
    };
    return MongoHelper;
}());
exports.MongoHelper = MongoHelper;
module.exports = { MongoHelper: MongoHelper };
//# sourceMappingURL=MongoHelper.js.map